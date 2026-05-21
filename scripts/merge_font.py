#!/usr/bin/env python3
"""Font merging script that combines English and CJK fonts with configurable
scaling factors, symbol font overlays, and metadata customization."""
import copy
from dataclasses import dataclass
from enum import Enum
import os
from typing import Any

from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._c_m_a_p import cmap_format_12
from fontTools.ttLib.tables._g_l_y_f import (
    Glyph as TTGlyphObj,
    GlyphCoordinates,
    table__g_l_y_f,
)
from fontTools.ttLib.tables._l_o_c_a import table__l_o_c_a
from fontTools.ttLib.tables.ttProgram import Program as TTProgram


# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

CJK_UNICODE_RANGES = [
    (0x2000, 0x206F),  # General Punctuation
    (0x2E80, 0x2EFF),  # CJK Radicals Supplement
    (0x3000, 0x303F),  # CJK Symbols and Punctuation
    (0x3200, 0x32FF),  # Enclosed CJK Letters and Months
    (0x3400, 0x4DBF),  # CJK Unified Ideographs Extension A
    (0x4E00, 0x9FFF),  # CJK Unified Ideographs
    (0xFE30, 0xFE4F),  # CJK Compatibility Forms
    (0xFF00, 0xFFEF),  # Halfwidth and Fullwidth Forms
]

# Pre-built collections for O(1) membership tests throughout the pipeline.
CJK_CODEPOINT_SET: set[int] = set()
CJK_CODEPOINT_LIST: list[int] = []
for start, end in CJK_UNICODE_RANGES:
    block = range(start, end + 1)
    CJK_CODEPOINT_SET.update(block)
    CJK_CODEPOINT_LIST.extend(block)


# ---------------------------------------------------------------------------
# OTF → TTF conversion
# ---------------------------------------------------------------------------


def convert_otf_to_ttf(font: TTFont, max_err: float = 1.0) -> None:
    """Convert a CFF-based font to TrueType outlines in place.

    Cubic Bézier curves are approximated as quadratic splines using
    ``Cu2QuPen`` so that the rest of the pipeline can work exclusively
    with the ``glyf`` table.
    """
    glyph_set = font.getGlyphSet()
    glyph_order = font.getGlyphOrder()
    tt_glyphs: dict[str, TTGlyphObj] = {}

    for glyph_name in glyph_order:
        try:
            tt_pen = TTGlyphPen(glyph_set)
            cu2qu_pen = Cu2QuPen(tt_pen, max_err=max_err, reverse_direction=True)
            glyph_set[glyph_name].draw(cu2qu_pen)
            tt_glyphs[glyph_name] = tt_pen.glyph()
        except Exception:  # noqa: BLE001 – empty / degenerate outlines
            tt_glyphs[glyph_name] = TTGlyphObj()

    # Install a glyf table with the converted glyphs.
    glyf = table__g_l_y_f()
    glyf.glyphs = tt_glyphs
    glyf.glyphOrder = glyph_order
    font["glyf"] = glyf

    # glyf requires a loca table.
    font["loca"] = table__l_o_c_a()

    # Flag the font as containing TrueType outlines.
    font["head"].glyphDataFormat = 0
    font.sfntVersion = "\x00\x01\x00\x00"

    # Upgrade maxp from CFF version (0x5000) to TrueType version (0x10000)
    # and initialise the TrueType-specific fields.  recalc() will later
    # compute the glyf-dependent values (maxPoints, maxContours, etc.).
    maxp = font["maxp"]
    maxp.tableVersion = 0x00010000
    for attr in (
        "maxZones",
        "maxTwilightPoints",
        "maxStorage",
        "maxFunctionDefs",
        "maxInstructionDefs",
        "maxStackElements",
        "maxSizeOfInstructions",
        "maxPoints",
        "maxContours",
        "maxCompositePoints",
        "maxCompositeContours",
        "maxComponentElements",
        "maxComponentDepth",
    ):
        if not hasattr(maxp, attr):
            setattr(maxp, attr, 0)
    if maxp.maxZones == 0:
        maxp.maxZones = 1

    # Remove the now-redundant CFF data.
    for tag in ("CFF ", "CFF2"):
        if tag in font:
            del font[tag]

    # post format 3 stores no glyph names (CFF fonts derive them from
    # CharStrings).  After dropping CFF we must switch to format 2 so
    # that glyph names referenced by GSUB (ligatures, alternates, etc.)
    # survive a save/reload cycle.
    if font["post"].formatType == 3.0:
        font["post"].formatType = 2.0
        font["post"].extraNames = []
        font["post"].mapping = {}


def load_font(path: str) -> TTFont:
    """Load a font file, converting CFF outlines to TrueType if necessary."""
    font = TTFont(path)
    if "glyf" not in font:
        convert_otf_to_ttf(font)
    return font


# ---------------------------------------------------------------------------
# Enums & Configuration
# ---------------------------------------------------------------------------


class Alignment(Enum):
    """Horizontal alignment when padding glyphs with whitespace."""

    LEFT = "left"
    CENTER = "center"
    RIGHT = "right"

    def compute_shift(self, available_space: int) -> int:
        """Return the horizontal shift for the given alignment and space."""
        if self is Alignment.LEFT:
            return 0
        if self is Alignment.CENTER:
            return available_space // 2
        if self is Alignment.RIGHT:
            return available_space


@dataclass
class PadConfig:
    """Configuration for padding specific characters with whitespace.

    Attributes
    ----------
    chars : list[str | int | tuple[int, int]]
        Characters, codepoints, or (start, end) ranges to pad.
    alignment : Alignment
        How to align the original glyph within the padded width.
    """

    chars: list[str | int | tuple[int, int]]
    alignment: Alignment


@dataclass
class FontMergeConfig:
    """Full configuration for a single font merging task.

    Attributes
    ----------
    stretch_chars : list[str | int | tuple[int, int]]
        Characters to stretch horizontally to double width.
    pad_configs : list[PadConfig]
        Per-character padding rules.
    adjust_baseline : bool
        Whether to auto-align CJK baseline to English baseline.
    new_font_family : str
        Font family name for the output.
    new_font_subfamily : str
        Font subfamily name for the output.
    new_author : str
        Author name written into metadata.
    new_description : str
        Description written into metadata.
    mark_as_monospace : bool
        Whether to flag the output font as monospaced.
    cjk_scale : float
        Uniform scale applied to CJK glyphs after UPM normalisation.
    western_scale_x : float
        Additional X-axis scale applied to western glyphs after the uniform
        'A'-advance normalisation.  May be larger or smaller than 1.0.
    western_scale_y : float
        Additional Y-axis scale applied to western glyphs after the uniform
        'A'-advance normalisation.  May be larger or smaller than 1.0.
    remove_hints : bool
        Whether to strip all hinting data from the output font.
    """

    stretch_chars: list[str | int | tuple[int, int]]
    pad_configs: list[PadConfig]
    adjust_baseline: bool
    new_font_family: str
    new_font_subfamily: str
    new_author: str
    new_description: str
    mark_as_monospace: bool
    cjk_scale: float
    western_scale_x: float
    western_scale_y: float
    remove_hints: bool


# ---------------------------------------------------------------------------
# Scaling parameters (shared across subfamilies)
# ---------------------------------------------------------------------------


@dataclass
class ScalingParams:
    """Pre-computed scaling parameters shared across every subfamily.

    Computed from the union of **all** subfamily font files so that cell
    geometry is consistent across weights and styles.

    Attributes
    ----------
    upm : int
        Unified UPM — maximum found across every western and CJK font in
        the family.
    target_adv_c : int
        Full-width (CJK) cell advance in unified UPM units.
        Always ``2 * target_adv_w``.
    target_adv_w : int
        Half-width (western / symbol) cell advance — the maximum
        UPM-normalised advance of ``'A'`` across all western subfamilies.
    """

    upm: int
    target_adv_c: int
    target_adv_w: int


# ---------------------------------------------------------------------------
# Font family config (subfamilies map)
# ---------------------------------------------------------------------------


@dataclass
class SubfamilySpec:
    """Font file paths and per-subfamily settings.

    Attributes
    ----------
    name : str
        Subfamily name (e.g. ``"Regular"``, ``"Bold Italic"``) used directly
        as ``new_font_subfamily`` in the output metadata and to derive the
        output filename.
    western_font_path : str
        Path to the western (Latin) font for this subfamily.
    cjk_font_path : str
        Path to the CJK font for this subfamily.  Italic subfamilies may
        point to a different typeface than the upright ones.
    cjk_scale : float
        Uniform scale applied to CJK glyphs after UPM normalisation.
    western_scale_x : float
        Additional X-axis scale applied to western glyphs after the uniform
        'A'-advance normalisation.  May be larger or smaller than 1.0.
        Defaults to 1.0 (no extra horizontal scaling).
    western_scale_y : float
        Additional Y-axis scale applied to western glyphs after the uniform
        'A'-advance normalisation.  May be larger or smaller than 1.0.
        Defaults to 1.0 (no extra vertical scaling).
    """

    name: str
    western_font_path: str
    cjk_font_path: str
    cjk_scale: float = 1.0
    western_scale_x: float = 1.0
    western_scale_y: float = 1.0


@dataclass
class FontFamilySpec:
    """Configuration for an entire font family.

    Common settings (metadata, glyph adjustments, symbol overlays) are
    declared once and shared across all subfamilies.  Scaling is computed
    from all pre-loaded subfamily fonts so that cell geometry is consistent
    across weights and styles, even when italic subfamilies use a different
    CJK font.

    Attributes
    ----------
    new_font_family : str
        Font family name written into the output metadata.
    new_author : str
        Author name written into metadata.
    new_description : str
        Description written into metadata.
    mark_as_monospace : bool
        Whether to flag the output fonts as monospaced.
    adjust_baseline : bool
        Auto-align CJK baseline to the western baseline.
    stretch_chars : list[str | int | tuple[int, int]]
        Characters to stretch horizontally to double width.
    pad_configs : list[PadConfig]
        Per-character padding rules.
    symbol_font_paths : list[str]
        Paths to symbol fonts to overlay.
    remove_hints : bool
        Strip all hinting data (``fpgm``, ``prep``, ``cvt ``, per-glyph
        programs, and hint-dependent metric tables) from the output fonts.
    subfamilies : list[SubfamilySpec]
        Ordered list of per-subfamily font paths and settings.  Each entry's
        ``name`` field is used as ``new_font_subfamily`` in the output
        metadata and to derive the output filename.
    """

    new_font_family: str
    new_author: str
    new_description: str
    mark_as_monospace: bool
    adjust_baseline: bool
    stretch_chars: list[str | int | tuple[int, int]]
    pad_configs: list[PadConfig]
    symbol_font_paths: list[str]
    remove_hints: bool
    subfamilies: list[SubfamilySpec]


# ---------------------------------------------------------------------------
# Low-level glyph geometry helpers
# ---------------------------------------------------------------------------


class GlyphTransformer:
    """Centralised helpers for the repetitive glyph coordinate manipulation
    patterns used throughout the merging pipeline.

    Every method operates on a single glyph **in place**.
    """

    @staticmethod
    def scale(glyph: Any, scale_x: float, scale_y: float) -> None:
        """Scale all coordinates by (*scale_x*, *scale_y*)."""
        if glyph.isComposite():
            for comp in glyph.components:
                if hasattr(comp, "x") and comp.x is not None:
                    comp.x = int(round(comp.x * scale_x))
                if hasattr(comp, "y") and comp.y is not None:
                    comp.y = int(round(comp.y * scale_y))
                if hasattr(comp, "transform"):
                    try:
                        (xx, xy), (yx, yy) = comp.transform
                        comp.transform = (
                            (xx * scale_x, xy * scale_x),
                            (yx * scale_y, yy * scale_y),
                        )
                    except ValueError:
                        pass
        elif hasattr(glyph, "coordinates"):
            glyph.coordinates = GlyphCoordinates([
                (int(round(x * scale_x)), int(round(y * scale_y)))
                for x, y in glyph.coordinates
            ])

    @staticmethod
    def shift_horizontal(glyph: Any, shift_x: int) -> None:
        """Translate all coordinates by *shift_x* on the X axis."""
        if shift_x == 0:
            return
        if glyph.isComposite():
            for comp in glyph.components:
                if hasattr(comp, "x") and comp.x is not None:
                    comp.x += shift_x
        elif hasattr(glyph, "coordinates"):
            glyph.coordinates = GlyphCoordinates([
                (x + shift_x, y) for x, y in glyph.coordinates
            ])

    @staticmethod
    def shift_vertical(glyph: Any, shift_y: int) -> None:
        """Translate all coordinates by *shift_y* on the Y axis."""
        if shift_y == 0:
            return
        if glyph.isComposite():
            for comp in glyph.components:
                if hasattr(comp, "y") and comp.y is not None:
                    comp.y += shift_y
        elif hasattr(glyph, "coordinates"):
            glyph.coordinates = GlyphCoordinates([
                (x, y + shift_y) for x, y in glyph.coordinates
            ])


# ---------------------------------------------------------------------------
# Per-glyph metric helpers
# ---------------------------------------------------------------------------


@dataclass
class FontTables:
    """Thin container that bundles the mutable tables edited during merging.

    Avoids threading ``glyf``, ``hmtx``, and the optional ``vmtx`` through
    every helper signature individually.
    """

    glyf: Any
    hmtx: Any
    vmtx: Any  # None when the font has no vmtx table

    @classmethod
    def from_font(cls, font: TTFont) -> "FontTables":
        return cls(
            glyf=font["glyf"],
            hmtx=font["hmtx"],
            vmtx=font["vmtx"] if "vmtx" in font else None,
        )


def scale_glyph_metrics(
    tables: FontTables,
    glyph_name: str,
    scale_x: float,
    scale_y: float,
) -> None:
    """Scale the hmtx and vmtx metric entries for *glyph_name* in place."""
    if glyph_name in tables.hmtx.metrics:
        adv, lsb = tables.hmtx.metrics[glyph_name]
        tables.hmtx.metrics[glyph_name] = (
            int(round(adv * scale_x)),
            int(round(lsb * scale_x)),
        )
    if tables.vmtx and glyph_name in tables.vmtx.metrics:
        v_adv, tsb = tables.vmtx.metrics[glyph_name]
        tables.vmtx.metrics[glyph_name] = (
            int(round(v_adv * scale_y)),
            int(round(tsb * scale_y)),
        )


def stretch_glyph(
    tables: FontTables,
    glyph_name: str,
    target_advance: int,
) -> None:
    """Stretch *glyph_name* horizontally so its advance becomes *target_advance*.

    Both the glyph outline and the hmtx entry are updated atomically.
    """
    if glyph_name not in tables.hmtx.metrics:
        return
    adv, lsb = tables.hmtx.metrics[glyph_name]
    if adv == 0:
        return
    scale_x = target_advance / float(adv)
    GlyphTransformer.scale(tables.glyf[glyph_name], scale_x, 1.0)
    tables.hmtx.metrics[glyph_name] = (target_advance, int(round(lsb * scale_x)))


def shift_glyph(
    tables: FontTables,
    glyph_name: str,
    shift_x: int,
    target_advance: int,
) -> None:
    """Shift *glyph_name* by *shift_x* and set its advance to *target_advance*.

    Both the glyph outline and the hmtx LSB are updated atomically.
    """
    GlyphTransformer.shift_horizontal(tables.glyf[glyph_name], shift_x)
    _, lsb = tables.hmtx.metrics[glyph_name]
    tables.hmtx.metrics[glyph_name] = (target_advance, lsb + shift_x)


def copy_glyph_into(
    src_tables: FontTables,
    dst_tables: FontTables,
    src_name: str,
    dst_name: str,
    dst_font: TTFont,
    scale_x: float,
    scale_y: float,
    y_offset: int = 0,
    apply_y_offset: bool = False,
) -> None:
    """Deep-copy one glyph (outline + metrics) from *src* into *dst*.

    The outline is scaled by (*scale_x*, *scale_y*) and, when
    *apply_y_offset* is ``True``, shifted vertically by *y_offset*.
    The glyph is registered in ``dst_font.glyphOrder`` if not already present.
    """
    if src_name in src_tables.glyf:
        copied = copy.deepcopy(src_tables.glyf[src_name])
        # Drop instructions: they reference the source font's fpgm/prep/cvt
        # tables, which are not present in the destination font.  Leaving
        # them in would produce invalid bytecode at render time.
        if hasattr(copied, "program"):
            copied.program = TTProgram()
        GlyphTransformer.scale(copied, scale_x, scale_y)
        if apply_y_offset:
            GlyphTransformer.shift_vertical(copied, y_offset)
        dst_tables.glyf[dst_name] = copied
        if dst_name not in dst_font.glyphOrder:
            dst_font.glyphOrder.append(dst_name)

    if src_name in src_tables.hmtx.metrics:
        adv, lsb = src_tables.hmtx.metrics[src_name]
        dst_tables.hmtx.metrics[dst_name] = (
            int(round(adv * scale_x)),
            int(round(lsb * scale_x)),
        )

    if dst_tables.vmtx and src_tables.vmtx and src_name in src_tables.vmtx.metrics:
        v_adv, tsb = src_tables.vmtx.metrics[src_name]
        scaled_tsb = int(round(tsb * scale_y))
        if apply_y_offset:
            scaled_tsb -= y_offset
        dst_tables.vmtx.metrics[dst_name] = (
            int(round(v_adv * scale_y)),
            scaled_tsb,
        )


# ---------------------------------------------------------------------------
# Codepoint utilities
# ---------------------------------------------------------------------------


def parse_codepoints(chars: list[str | int | tuple[int, int]]) -> set[int]:
    """Convert a mixed list of characters, integers, and (start, end)
    tuples into a flat set of integer codepoints."""
    codepoints: set[int] = set()
    for item in chars:
        if isinstance(item, str) and len(item) == 1:
            codepoints.add(ord(item))
        elif isinstance(item, int):
            codepoints.add(item)
        elif isinstance(item, tuple) and len(item) == 2:
            codepoints.update(range(item[0], item[1] + 1))
    return codepoints


# ---------------------------------------------------------------------------
# Font table helpers
# ---------------------------------------------------------------------------


def get_glyph_dependencies(glyph_name: str, glyf_table: dict) -> set[str]:
    """Recursively collect all component glyph names for a composite glyph."""
    deps = {glyph_name}
    if glyph_name not in glyf_table:
        return deps
    glyph = glyf_table[glyph_name]
    if glyph.isComposite():
        for component in glyph.components:
            deps.update(get_glyph_dependencies(component.glyphName, glyf_table))
    return deps


def get_typical_advance(font: TTFont, char_code: int) -> int:
    """Return the advance width for *char_code*, falling back to half UPM."""
    cmap = font.getBestCmap()
    if char_code in cmap:
        return font["hmtx"].metrics[cmap[char_code]][0]
    return font["head"].unitsPerEm // 2


def ensure_cmap_format_12(font: TTFont, cmap_mapping: dict[int, str]) -> None:
    """Ensure a Format 12 cmap subtable exists and is up to date.

    Format 12 (platform 3, encoding 10) is required for non-BMP codepoints
    (U+10000 and above) and is also the most capable Unicode subtable in
    general.  This function always creates it when absent, then syncs every
    Unicode subtable with *cmap_mapping*, respecting each table's range.
    """
    if not any(t.format == 12 for t in font["cmap"].tables):
        new_table = cmap_format_12(12)
        new_table.platformID = 3
        new_table.platEncID = 10
        new_table.language = 0
        new_table.cmap = {}
        font["cmap"].tables.append(new_table)

    for table in font["cmap"].tables:
        if table.isUnicode():
            if table.format == 4:
                for codepoint, name in cmap_mapping.items():
                    if codepoint <= 0xFFFF:
                        table.cmap[codepoint] = name
            else:
                table.cmap.update(cmap_mapping)


# ---------------------------------------------------------------------------
# Whole-font glyph scaling
# ---------------------------------------------------------------------------


def scale_gpos_values(table: Any, sx, sy) -> None:
    """Recursively scale every ``ValueRecord``-style positioning value in a
    GPOS subtable tree.  Anchors and ValueRecords are the only places
    GPOS stores font-unit coordinates, so we only need to touch those.
    """
    x_attrs = ("XPlacement", "XAdvance", "XCoordinate")
    y_attrs = ("YPlacement", "YAdvance", "YCoordinate")
    seen: set[int] = set()

    def walk(obj: Any, depth: int = 0) -> None:
        if depth > 20 or id(obj) in seen:
            return
        seen.add(id(obj))
        for attr in x_attrs:
            if hasattr(obj, attr):
                v = getattr(obj, attr)
                if isinstance(v, int) and v:
                    setattr(obj, attr, sx(v))
        for attr in y_attrs:
            if hasattr(obj, attr):
                v = getattr(obj, attr)
                if isinstance(v, int) and v:
                    setattr(obj, attr, sy(v))
        if isinstance(obj, (list, tuple)):
            for item in obj:
                walk(item, depth + 1)
        elif hasattr(obj, "__dict__"):
            for item in obj.__dict__.values():
                walk(item, depth + 1)

    walk(table)


def scale_font(font: TTFont, scale_x: float, scale_y: float) -> None:
    """Scale every glyph and its metrics by (*scale_x*, *scale_y*).

    Glyph outlines are scaled non-uniformly when the two factors differ.
    Horizontal metrics (advance width, LSB) follow *scale_x*; vertical
    metrics (vertical advance, TSB) and all global OS/2 / hhea / vhea
    fields follow *scale_y*.
    """
    tables = FontTables.from_font(font)

    for glyph_name in tables.glyf.keys():
        GlyphTransformer.scale(tables.glyf[glyph_name], scale_x, scale_y)
        scale_glyph_metrics(tables, glyph_name, scale_x, scale_y)

    if scale_x == 1.0 and scale_y == 1.0:
        return

    def sx(value: int) -> int:
        return int(round(value * scale_x))

    def sy(value: int) -> int:
        return int(round(value * scale_y))

    os2 = font["OS/2"]
    for attr in (
        "sTypoAscender", "sTypoDescender", "sTypoLineGap",
        "usWinAscent", "usWinDescent",
        "sxHeight", "sCapHeight",
        "ySubscriptYSize",
        "ySubscriptYOffset",
        "ySuperscriptYSize",
        "ySuperscriptYOffset",
        "yStrikeoutSize", "yStrikeoutPosition",
    ):
        setattr(os2, attr, sy(getattr(os2, attr)))
    for attr in (
        "xAvgCharWidth",
        "ySubscriptXSize",
        "ySubscriptXOffset",
        "ySuperscriptXSize",
        "ySuperscriptXOffset",
    ):
        setattr(os2, attr, sx(getattr(os2, attr)))

    hhea = font["hhea"]
    for attr in ("ascent", "descent", "lineGap", "caretSlopeRise"):
        setattr(hhea, attr, sy(getattr(hhea, attr)))
    for attr in ("caretSlopeRun", "caretOffset"):
        setattr(hhea, attr, sx(getattr(hhea, attr)))

    # post: underline metrics are expressed in font units, so they must
    # follow the vertical scale.  Without this, after a non-trivial UPM
    # change the underline ends up at the wrong depth and the wrong
    # thickness, making the font look subtly "lighter" / off-balance.
    post = font["post"]
    for attr in ("underlinePosition", "underlineThickness"):
        if hasattr(post, attr) and getattr(post, attr) is not None:
            setattr(post, attr, sy(getattr(post, attr)))

    # GPOS: scale every numeric placement / advance adjustment.  Most
    # monospace fonts have an empty GPOS, but kerning-aware fonts
    # (and ligature-anchor fonts) will look misaligned after a UPM
    # change if we leave these untouched.
    if "GPOS" in font:
        scale_gpos_values(font["GPOS"].table, sx, sy)

    # Keep the head bbox in sync; fontTools recomputes it on save when
    # glyphs change but updating it here keeps the in-memory font
    # self-consistent for any intermediate inspection / further scaling.
    head = font["head"]
    head.xMin = sx(head.xMin)
    head.xMax = sx(head.xMax)
    head.yMin = sy(head.yMin)
    head.yMax = sy(head.yMax)

    if "vhea" in font:
        vhea = font["vhea"]
        for attr in ("ascent", "descent", "lineGap", "caretSlopeRise"):
            setattr(vhea, attr, sy(getattr(vhea, attr)))
        for attr in ("caretSlopeRun", "caretOffset"):
            setattr(vhea, attr, sx(getattr(vhea, attr)))

    # Scale the Control Value Table (cvt) so TrueType hint instructions
    # continue to round to the correct positions after the coordinate
    # rescaling.  Most CVT entries are vertical measurements (stem widths,
    # reference Y positions), so we scale by scale_y.  When scale_x ==
    # scale_y (uniform) this is unambiguous; otherwise an averaged scale
    # is the best generic approximation.
    if "cvt " in font:
        cvt_scale = scale_y if scale_x == scale_y else (scale_x + scale_y) / 2.0
        cvt = font["cvt "]
        cvt.values = type(cvt.values)(
            cvt.values.typecode,
            (int(round(v * cvt_scale)) for v in cvt.values),
        )


# ---------------------------------------------------------------------------
# Hint removal
# ---------------------------------------------------------------------------


def remove_hinting(font: TTFont) -> None:
    """Strip all TrueType hinting data from *font* in place.

    Removes the three global hint tables (``fpgm``, ``prep``, ``cvt ``),
    clears per-glyph bytecode programs, drops the hint-dependent metric
    tables (``hdmx``, ``LTSH``, ``VDMX``), zeroes the hint-capacity fields
    in ``maxp``, and clears the hint-related bits in ``head.flags``.
    """
    # Global hint tables.
    for tag in ("fpgm", "prep", "cvt "):
        if tag in font:
            del font[tag]

    # Per-glyph bytecode programs.
    if "glyf" in font:
        for glyph in font["glyf"].glyphs.values():
            if hasattr(glyph, "program"):
                glyph.program = TTProgram()

    # Hint-dependent metric tables (values change with hinting on/off).
    for tag in ("hdmx", "LTSH", "VDMX"):
        if tag in font:
            del font[tag]

    # Zero all hint-capacity fields in maxp so the font declares no
    # interpreter resources are needed.
    maxp = font["maxp"]
    for attr in (
        "maxZones",
        "maxTwilightPoints",
        "maxStorage",
        "maxFunctionDefs",
        "maxInstructionDefs",
        "maxStackElements",
        "maxSizeOfInstructions",
    ):
        if hasattr(maxp, attr):
            setattr(maxp, attr, 0)
    # maxZones must be at least 1 (zone 0 always exists).
    if hasattr(maxp, "maxZones"):
        maxp.maxZones = 1

    # Clear head flag bits that only apply when hints are present:
    #   bit 3 — force ppem to integer values
    #   bit 4 — instructions may change advance widths
    font["head"].flags &= ~((1 << 3) | (1 << 4))


# ---------------------------------------------------------------------------
# Single-glyph width adjustments (pad / stretch)
# ---------------------------------------------------------------------------


def resolve_glyph(
    font: TTFont,
    codepoint: int,
) -> tuple[str, FontTables] | None:
    """Look up *codepoint* in *font* and return ``(glyph_name, tables)``.

    Returns ``None`` when the codepoint is absent from the cmap, the glyph
    has no outline, or its hmtx entry is missing.
    """
    cmap = font.getBestCmap()
    if codepoint not in cmap:
        return None
    glyph_name = cmap[codepoint]
    tables = FontTables.from_font(font)
    if glyph_name not in tables.glyf or glyph_name not in tables.hmtx.metrics:
        return None
    return glyph_name, tables


def pad_glyph_width(
    font: TTFont,
    codepoint: int,
    target_advance: int,
    alignment: Alignment,
) -> None:
    """Widen a glyph's advance width by adding whitespace on one or both sides."""
    resolved = resolve_glyph(font, codepoint)
    if resolved is None:
        return
    glyph_name, tables = resolved
    adv, _ = tables.hmtx.metrics[glyph_name]
    if adv >= target_advance:
        return
    shift_glyph(tables, glyph_name, alignment.compute_shift(target_advance - adv), target_advance)


def stretch_glyph_width(
    font: TTFont,
    codepoint: int,
    target_advance: int,
) -> None:
    """Horizontally stretch a glyph's geometry to fit *target_advance*."""
    resolved = resolve_glyph(font, codepoint)
    if resolved is None:
        return
    glyph_name, tables = resolved
    stretch_glyph(tables, glyph_name, target_advance)


# ---------------------------------------------------------------------------
# CJK glyph merging (two-phase)
# ---------------------------------------------------------------------------


def copy_cjk_glyphs_to_base(
    base_font: TTFont,
    cjk_font: TTFont,
    cjk_upm_scale: float,
    y_offset: int,
) -> None:
    """Phase 1 — Deep-copy every CJK glyph (and its dependencies) from the CJK
    font into the base font, applying UPM scaling and vertical offset.

    Copied glyphs are prefixed with ``cjk_`` to avoid name collisions.
    """
    base_cmap = base_font.getBestCmap()
    cjk_cmap = cjk_font.getBestCmap()
    base_tables = FontTables.from_font(base_font)
    cjk_tables = FontTables.from_font(cjk_font)

    for codepoint in CJK_CODEPOINT_LIST:
        if codepoint not in cjk_cmap:
            continue

        cjk_glyph_name = cjk_cmap[codepoint]
        dependencies = get_glyph_dependencies(cjk_glyph_name, cjk_tables.glyf)

        for dep_name in dependencies:
            new_dep_name = f"cjk_{dep_name}"
            if new_dep_name in base_tables.glyf:
                continue

            is_top_level = dep_name == cjk_glyph_name
            copy_glyph_into(
                cjk_tables, base_tables, dep_name, new_dep_name, base_font,
                scale_x=cjk_upm_scale, scale_y=cjk_upm_scale,
                y_offset=y_offset, apply_y_offset=is_top_level,
            )

            # Rename component references to use the cjk_ prefix.
            if new_dep_name in base_tables.glyf:
                glyph = base_tables.glyf[new_dep_name]
                if glyph.isComposite():
                    for comp in glyph.components:
                        comp.glyphName = f"cjk_{comp.glyphName}"

        base_cmap[codepoint] = f"cjk_{cjk_glyph_name}"


def adjust_cjk_glyph_widths(
    base_font: TTFont,
    cjk_font: TTFont,
    target_adv_w: int,
    target_adv_c: int,
    cjk_upm_scale: float,
    cjk_scale: float,
) -> None:
    """Phase 2 — Walk the CJK cmap and centre each copied glyph within its
    target advance width (fullwidth or halfwidth).

    When *cjk_scale* differs from 1.0 the glyph outline is scaled uniformly by
    that factor and then centred horizontally within the target advance cell.
    CJK codepoints must not appear in the stretch or pad configuration;
    any such adjustments must be applied to the merged font separately.
    """
    cjk_cmap = cjk_font.getBestCmap()
    base_tables = FontTables.from_font(base_font)
    cjk_hmtx = cjk_font["hmtx"]
    processed: set[str] = set()

    for codepoint, cjk_glyph_name in cjk_cmap.items():
        if codepoint not in CJK_CODEPOINT_SET:
            continue

        new_glyph_name = f"cjk_{cjk_glyph_name}"
        if new_glyph_name not in base_tables.glyf or new_glyph_name in processed:
            continue
        processed.add(new_glyph_name)

        # Determine target advance width
        original_adv = cjk_hmtx.metrics[cjk_glyph_name][0]
        scaled_adv = int(round(original_adv * cjk_upm_scale))

        if scaled_adv > target_adv_c * 0.75:
            target_adv = target_adv_c
        else:
            target_adv = target_adv_w

        # Centre the glyph within its target cell, optionally pre-scaling by
        # cjk_scale.  When the UPM-normalised advance is larger than target_adv
        # the glyph is centred with blanks added on both sides; when smaller it
        # is simply centred.
        if cjk_scale != 1.0:
            GlyphTransformer.scale(base_tables.glyf[new_glyph_name], cjk_scale, cjk_scale)
        effective_adv = scaled_adv * cjk_scale
        shift_x = int(round((target_adv - effective_adv) / 2.0))
        _, lsb = base_tables.hmtx.metrics[new_glyph_name]
        GlyphTransformer.shift_horizontal(base_tables.glyf[new_glyph_name], shift_x)
        base_tables.hmtx.metrics[new_glyph_name] = (
            target_adv,
            int(round(lsb * cjk_scale)) + shift_x,
        )


def merge_cjk_glyphs(
    base_font: TTFont,
    cjk_font: TTFont,
    target_adv_w: int,
    target_adv_c: int,
    cjk_upm_scale: float,
    y_offset: int,
    cjk_scale: float = 1.0,
) -> None:
    """Copy CJK glyphs into the base font and adjust their advance widths.

    Orchestrates the two phases: ``copy_cjk_glyphs_to_base`` followed by
    ``adjust_cjk_glyph_widths``.
    """
    copy_cjk_glyphs_to_base(base_font, cjk_font, cjk_upm_scale, y_offset)
    adjust_cjk_glyph_widths(
        base_font, cjk_font, target_adv_w, target_adv_c,
        cjk_upm_scale,
        cjk_scale=cjk_scale,
    )


# ---------------------------------------------------------------------------
# Symbol font merging
# ---------------------------------------------------------------------------


def merge_symbols_into_font(
    base_font: TTFont,
    symbol_font: TTFont,
    target_adv_w: int,
) -> None:
    """Overlay a symbol font onto the base font, scaling by UPM ratio.

    Existing glyphs are overwritten when names collide.  Every top-level
    symbol glyph's advance width is forced to *target_adv_w* after copying,
    ensuring a consistent halfwidth advance for all non-CJK glyphs.
    """
    base_cmap = base_font.getBestCmap()
    symbol_cmap = symbol_font.getBestCmap()
    base_tables = FontTables.from_font(base_font)
    sym_tables = FontTables(
        glyf=symbol_font["glyf"],
        hmtx=symbol_font["hmtx"],
        vmtx=symbol_font["vmtx"] if "vmtx" in base_font and "vmtx" in symbol_font else None,
    )
    scale = base_font["head"].unitsPerEm / symbol_font["head"].unitsPerEm

    for codepoint, sym_glyph_name in symbol_cmap.items():
        for dep_name in get_glyph_dependencies(sym_glyph_name, sym_tables.glyf):
            copy_glyph_into(
                sym_tables, base_tables, dep_name, dep_name, base_font,
                scale_x=scale, scale_y=scale,
            )
        base_cmap[codepoint] = sym_glyph_name

        # Force the top-level glyph's advance to the target halfwidth value.
        if target_adv_w > 0 and sym_glyph_name in base_tables.hmtx.metrics:
            adv, lsb = base_tables.hmtx.metrics[sym_glyph_name]
            if adv != target_adv_w:
                base_tables.hmtx.metrics[sym_glyph_name] = (target_adv_w, lsb)


# ---------------------------------------------------------------------------
# Metadata & monospace helpers
# ---------------------------------------------------------------------------


def update_font_metadata(font: TTFont, config: FontMergeConfig) -> None:
    """Rewrite the ``name`` table entries to reflect the merged font identity."""
    full_name = f"{config.new_font_family} {config.new_font_subfamily}"
    ps_name = (
        f"{config.new_font_family.replace(' ', '')}"
        f"-{config.new_font_subfamily.replace(' ', '')}"
    )

    replacements: dict[int, str] = {
        1:  config.new_font_family,
        2:  config.new_font_subfamily,
        3:  f"Merged:{full_name}",
        4:  full_name,
        6:  ps_name,
        8:  config.new_author,
        9:  config.new_author,
        10: config.new_description,
        16: config.new_font_family,
        17: config.new_font_subfamily,
    }

    for record in font["name"].names:
        new_text = replacements.get(record.nameID)
        if new_text is not None and new_text != record.toStr():
            record.string = new_text.encode(record.getEncoding())


def mark_font_as_monospace(font: TTFont, target_adv_w: int):
    """Hint the font as monospaced.

    For CJK-merged fonts the glyph set contains both halfwidth and
    fullwidth characters, so ``post.isFixedPitch`` is left at 0 and
    panose ``bProportion`` is not forced to the monospaced value.
    Setting these would cause renderers to allocate a single cell width
    for every glyph, breaking fullwidth CJK display.

    Only ``xAvgCharWidth`` is updated so that editors that inspect it
    can derive the intended halfwidth advance.
    """
    font["OS/2"].xAvgCharWidth = target_adv_w


# ---------------------------------------------------------------------------
# Baseline alignment
# ---------------------------------------------------------------------------


def compute_baseline_y_offset(
    western_font: TTFont,
    western_y_scale: float,
    cjk_font: TTFont,
    cjk_upm_scale: float,
    cjk_scale: float,
) -> int:
    """Calculate the vertical shift needed to align the CJK baseline
    with the (already-scaled) western baseline.

    *y_offset* is applied to CJK glyphs in phase 1 (copy), **before**
    *cjk_scale* is applied in phase 2 (centre).  Because phase 2 scales
    around the origin, the offset is magnified by *cjk_scale*, so we must
    pre-divide the western target by *cjk_scale* to arrive at the correct
    pre-phase-2 position.
    """
    western_os2 = western_font["OS/2"]
    cjk_os2 = cjk_font["OS/2"]
    western_center = (western_os2.sTypoAscender + western_os2.sTypoDescender) / 2.0
    cjk_center = (cjk_os2.sTypoAscender + cjk_os2.sTypoDescender) / 2.0
    return int(round(western_center * western_y_scale / cjk_scale - cjk_center * cjk_upm_scale))


# ---------------------------------------------------------------------------
# Main pipeline
# ---------------------------------------------------------------------------


def make_output_filename(family: str, subfamily: str) -> str:
    """Derive the output .ttf filename from family and subfamily names."""
    return f"{family.replace(' ', '')}-{subfamily.replace(' ', '')}.ttf"


def compute_scaling_params(
    loaded_subfamilies: dict[str, tuple[TTFont, TTFont]],
    symbol_fonts: list[TTFont] = [],
) -> ScalingParams:
    """Derive ``ScalingParams`` from **all** pre-loaded subfamily font pairs.

    The unified UPM is the maximum found across every western, CJK, and
    symbol font in the family, so that all source coordinates can be
    expressed losslessly in the output font.

    ``target_adv_w`` (the halfwidth cell advance) is derived **only from
    the western fonts** — the western font determines the typographic
    rhythm of the merged result.  CJK and symbol fonts must adapt to
    that cell, not the other way around: letting a wider CJK 'A' or a
    Nerd Font's geometry inflate the cell would force the western
    glyphs to be scaled up and would change the perceived size of the
    western text compared to the original.

    ``target_adv_c = 2 * target_adv_w``.
    """
    upm = 1
    # Collect (adv_for_A, source_upm) pairs from the WESTERN fonts only;
    # normalisation is deferred until the global UPM is known.
    western_adv_samples: list[tuple[int, int]] = []

    for w_font, c_font in loaded_subfamilies.values():
        upm = max(upm, w_font["head"].unitsPerEm, c_font["head"].unitsPerEm)
        western_adv_samples.append((
            get_typical_advance(w_font, ord("A")),
            w_font["head"].unitsPerEm,
        ))

    # Symbol fonts still contribute to UPM (so their outlines can be
    # represented at full fidelity) but NOT to target_adv_w.
    for s_font in symbol_fonts:
        upm = max(upm, s_font["head"].unitsPerEm)

    # target_adv_w = max UPM-normalised advance of 'A' across western fonts.
    target_adv_w = 0
    for adv, src_upm in western_adv_samples:
        normalised = int(round(adv * upm / float(src_upm)))
        target_adv_w = max(target_adv_w, normalised)

    target_adv_c = 2 * target_adv_w

    return ScalingParams(
        upm=upm,
        target_adv_c=target_adv_c,
        target_adv_w=target_adv_w,
    )


def process_font(
    config: FontMergeConfig,
    scaling: ScalingParams,
    western_font: TTFont,
    cjk_font: TTFont,
    symbol_fonts: list[TTFont],
) -> None:
    """Execute the complete font merging pipeline:

    1. Scale the western font to the unified UPM, normalise its 'A' advance
       to ``target_adv_w``, and apply the per-axis ``western_scale_x`` /
       ``western_scale_y`` adjustments — all in a single ``scale_font`` pass.
    2. Copy CJK glyphs and centre each one within its target cell
       (fullwidth or halfwidth).
    3. Stretch / pad designated western-side glyphs to ``target_adv_c``.
    4. Overlay symbol fonts.
    5. Write metadata and save.

    Parameters
    ----------
    config :
        Per-font settings (paths, metadata, glyph adjustments).
    scaling :
        Pre-computed cell geometry shared across all subfamilies in a
        family (from ``compute_scaling_params``).
    western_font :
        Pre-loaded western (Latin) font.  Mutated and saved in place.
    cjk_font :
        Pre-loaded CJK font.  Read-only during this call.
    symbol_fonts :
        Pre-loaded symbol fonts.  Read-only during this call.
    """

    upm = scaling.upm
    cjk_upm = cjk_font["head"].unitsPerEm
    cjk_upm_scale = upm / float(cjk_upm)

    target_adv_w = scaling.target_adv_w
    target_adv_c = scaling.target_adv_c

    # Compute the uniform scale that normalises the western 'A' advance to
    # target_adv_w, then derive the total per-axis scales by folding in the
    # per-subfamily adjustments.  Both are computed before any mutation so
    # that compute_baseline_y_offset sees the original font metrics.
    western_scale = target_adv_w / float(get_typical_advance(western_font, ord("A")))
    total_western_scale_x = western_scale * config.western_scale_x
    total_western_scale_y = western_scale * config.western_scale_y

    # Baseline alignment — must be computed before the western font is mutated.
    y_offset = 0
    if config.adjust_baseline:
        y_offset = compute_baseline_y_offset(
            western_font, total_western_scale_y, cjk_font, cjk_upm_scale,
            config.cjk_scale,
        )

    # Scale the western font: uniform 'A'-advance normalisation combined with
    # the per-axis adjustments in a single pass to avoid double-rounding.
    if total_western_scale_x != 1.0 or total_western_scale_y != 1.0:
        scale_font(western_font, total_western_scale_x, total_western_scale_y)
    western_font["head"].unitsPerEm = upm

    stretch_set = parse_codepoints(config.stretch_chars)

    # Merge CJK glyphs: phase 1 copies them at UPM-normalised size;
    # phase 2 centres each glyph within its target fullwidth or halfwidth cell.
    merge_cjk_glyphs(
        base_font=western_font,
        cjk_font=cjk_font,
        target_adv_w=target_adv_w,
        target_adv_c=target_adv_c,
        cjk_upm_scale=cjk_upm_scale,
        y_offset=y_offset,
        cjk_scale=config.cjk_scale,
    )

    # Stretch / pad western-side glyphs that fall outside CJK ranges.
    # Use target_adv_c (the expanded fullwidth) as the double-width target.
    for codepoint in stretch_set:
        stretch_glyph_width(western_font, codepoint, target_adv_c)

    for pad_cfg in config.pad_configs:
        for codepoint in parse_codepoints(pad_cfg.chars):
            pad_glyph_width(western_font, codepoint, target_adv_c, pad_cfg.alignment)

    # Force the advance of every stretched / padded glyph to target_adv_c so
    # that ink repositioning never leaves a residual halfwidth advance.
    fullwidth_cmap = western_font.getBestCmap()
    fullwidth_tables = FontTables.from_font(western_font)
    fullwidth_codepoints = stretch_set | {
        cp for cfg in config.pad_configs for cp in parse_codepoints(cfg.chars)
    }
    for codepoint in fullwidth_codepoints:
        glyph_name = fullwidth_cmap.get(codepoint)
        if glyph_name and glyph_name in fullwidth_tables.hmtx.metrics:
            adv, lsb = fullwidth_tables.hmtx.metrics[glyph_name]
            if adv != target_adv_c:
                fullwidth_tables.hmtx.metrics[glyph_name] = (target_adv_c, lsb)

    # Merge symbol fonts, normalising each symbol glyph's advance to
    # target_adv_w so that all non-CJK glyphs end up with the same
    # halfwidth cell.
    for symbol_font in symbol_fonts:
        merge_symbols_into_font(western_font, symbol_font, target_adv_w=target_adv_w)

    # Metadata & monospace flag
    update_font_metadata(western_font, config)
    if config.mark_as_monospace:
        mark_font_as_monospace(western_font, target_adv_w)

    # Ensure Format 12 cmap subtable exists for any non-BMP codepoints
    # accumulated across all merging stages.
    ensure_cmap_format_12(western_font, western_font.getBestCmap())

    # Remove hinting data if requested.  Done last so that any hint tables
    # copied in from source fonts (e.g. via symbol merging) are also covered.
    if config.remove_hints:
        remove_hinting(western_font)

    # Save — filename derived from family and subfamily names.
    western_font.save(make_output_filename(config.new_font_family, config.new_font_subfamily))


def process_family(family: FontFamilySpec) -> None:
    """Process all subfamilies of a font family.

    Each font file is opened exactly once.  Scaling is computed from all
    pre-loaded subfamily fonts, then every subfamily is processed in turn
    using the same open font objects.  All fonts are closed at the end.
    """
    # Load symbol fonts once; they are read-only across all subfamily runs.
    symbol_fonts: list[TTFont] = []
    for sym_path in family.symbol_font_paths:
        try:
            symbol_fonts.append(load_font(sym_path))
        except (FileNotFoundError, OSError) as err:
            print(f"  Warning: could not load symbol font {sym_path!r}: {err}")

    # Load western and CJK fonts for every subfamily.
    loaded: dict[str, tuple[TTFont, TTFont]] = {}
    for spec in family.subfamilies:
        try:
            loaded[spec.name] = (
                load_font(spec.western_font_path),
                load_font(spec.cjk_font_path),
            )
        except FileNotFoundError as err:
            print(f"  Error loading fonts for {spec.name!r}: {err}")

    print(
        f"[{family.new_font_family}] "
        f"Computing scaling from all {len(loaded)} subfamilies ..."
    )
    scaling = compute_scaling_params(loaded, symbol_fonts)

    try:
        for spec in family.subfamilies:
            if spec.name not in loaded:
                continue
            western_font, cjk_font = loaded[spec.name]
            output_filename = make_output_filename(family.new_font_family, spec.name)
            config = FontMergeConfig(
                stretch_chars=family.stretch_chars,
                pad_configs=family.pad_configs,
                adjust_baseline=family.adjust_baseline,
                new_font_family=family.new_font_family,
                new_font_subfamily=spec.name,
                new_author=family.new_author,
                new_description=family.new_description,
                mark_as_monospace=family.mark_as_monospace,
                cjk_scale=spec.cjk_scale,
                western_scale_x=spec.western_scale_x,
                western_scale_y=spec.western_scale_y,
                remove_hints=family.remove_hints,
            )
            print(f"  Processing: {output_filename} ...")
            try:
                process_font(config, scaling=scaling,
                             western_font=western_font, cjk_font=cjk_font,
                             symbol_fonts=symbol_fonts)
                print(f"  Saved: {output_filename}")
            except FileNotFoundError as err:
                print(f"  Error: {err}")
    finally:
        for w_font, c_font in loaded.values():
            w_font.close()
            c_font.close()
        for s_font in symbol_fonts:
            s_font.close()


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------


def main():
    """Configure and run font merging tasks."""
    fonts_dir = os.path.expanduser("~/Library/Fonts")

    COMMON = dict(
        new_author="Zhaosheng Pan",
        new_description="",
        mark_as_monospace=True,
        remove_hints=True,
        adjust_baseline=True,
        stretch_chars=["\u2026", "\u2014"],
        pad_configs=[
            PadConfig(chars=["\u2018", "\u201c"], alignment=Alignment.RIGHT),
            PadConfig(chars=["\u2019", "\u201d"], alignment=Alignment.LEFT),
        ],
        symbol_font_paths=[
            f"{fonts_dir}/SymbolsNerdFont-Regular.ttf",
            "FlogSymbols.ttf",
        ],
    )

    families = [
        FontFamilySpec(
            new_font_family="Monaspace Argon LXGW Bright TC NF",
            **COMMON,
            subfamilies=[
                SubfamilySpec(
                    name="Light",
                    western_font_path=f"{fonts_dir}/MonaspaceArgon-Light.otf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Light.ttf",
                    western_scale_x=0.9,
                    cjk_scale=1.18,
                ),
                SubfamilySpec(
                    name="Light Italic",
                    western_font_path=f"{fonts_dir}/MonaspaceArgon-LightItalic.otf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Light.ttf",
                    western_scale_x=0.9,
                    cjk_scale=1.18,
                ),
                SubfamilySpec(
                    name="Regular",
                    western_font_path=f"{fonts_dir}/MonaspaceArgon-Regular.otf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Regular.ttf",
                    western_scale_x=0.9,
                    cjk_scale=1.18,
                ),
                SubfamilySpec(
                    name="Italic",
                    western_font_path=f"{fonts_dir}/MonaspaceArgon-Italic.otf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Regular.ttf",
                    western_scale_x=0.9,
                    cjk_scale=1.18,
                ),
                SubfamilySpec(
                    name="Medium",
                    western_font_path=f"{fonts_dir}/MonaspaceArgon-Medium.otf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Medium.ttf",
                    western_scale_x=0.9,
                    cjk_scale=1.18,
                ),
                SubfamilySpec(
                    name="Medium Italic",
                    western_font_path=f"{fonts_dir}/MonaspaceArgon-MediumItalic.otf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Medium.ttf",
                    western_scale_x=0.9,
                    cjk_scale=1.18,
                ),
            ],
        ),
        FontFamilySpec(
            new_font_family="Monaspace Xenon Noto Serif LXGW CJK TC NF",
            **COMMON,
            subfamilies=[
                SubfamilySpec(
                    name="Light",
                    western_font_path=f"{fonts_dir}/MonaspaceXenon-Light.otf",
                    cjk_font_path=f"{fonts_dir}/NotoSerifCJKtc-Light.otf",
                    western_scale_x=0.9,
                    cjk_scale=1.13,
                ),
                SubfamilySpec(
                    name="Light Italic",
                    western_font_path=f"{fonts_dir}/MonaspaceXenon-LightItalic.otf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Light.ttf",
                    western_scale_x=0.9,
                    cjk_scale=1.18,
                ),
                SubfamilySpec(
                    name="Regular",
                    western_font_path=f"{fonts_dir}/MonaspaceXenon-Regular.otf",
                    cjk_font_path=f"{fonts_dir}/NotoSerifCJKtc-Regular.otf",
                    western_scale_x=0.9,
                    cjk_scale=1.13,
                ),
                SubfamilySpec(
                    name="Italic",
                    western_font_path=f"{fonts_dir}/MonaspaceXenon-Italic.otf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Regular.ttf",
                    western_scale_x=0.9,
                    cjk_scale=1.18,
                ),
                SubfamilySpec(
                    name="Medium",
                    western_font_path=f"{fonts_dir}/MonaspaceXenon-Medium.otf",
                    cjk_font_path=f"{fonts_dir}/NotoSerifCJKtc-Medium.otf",
                    western_scale_x=0.9,
                    cjk_scale=1.13,
                ),
                SubfamilySpec(
                    name="Medium Italic",
                    western_font_path=f"{fonts_dir}/MonaspaceXenon-MediumItalic.otf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Medium.ttf",
                    western_scale_x=0.9,
                    cjk_scale=1.18,
                ),
            ],
        ),
        FontFamilySpec(
            new_font_family="JetBrains Mono Noto Sans LXGW CJK TC NF",
            **COMMON,
            subfamilies=[
                SubfamilySpec(
                    name="Light",
                    western_font_path=f"{fonts_dir}/JetBrainsMono-Light.ttf",
                    cjk_font_path=f"{fonts_dir}/NotoSansCJKtc-Light.otf",
                    cjk_scale=1.15,
                ),
                SubfamilySpec(
                    name="Light Italic",
                    western_font_path=f"{fonts_dir}/JetBrainsMono-LightItalic.ttf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Light.ttf",
                    cjk_scale=1.2,
                ),
                SubfamilySpec(
                    name="Regular",
                    western_font_path=f"{fonts_dir}/JetBrainsMono-Regular.ttf",
                    cjk_font_path=f"{fonts_dir}/NotoSansCJKtc-Regular.otf",
                    cjk_scale=1.15,
                ),
                SubfamilySpec(
                    name="Italic",
                    western_font_path=f"{fonts_dir}/JetBrainsMono-Italic.ttf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Regular.ttf",
                    cjk_scale=1.2,
                ),
                SubfamilySpec(
                    name="Medium",
                    western_font_path=f"{fonts_dir}/JetBrainsMono-Medium.ttf",
                    cjk_font_path=f"{fonts_dir}/NotoSansCJKtc-Medium.otf",
                    cjk_scale=1.15,
                ),
                SubfamilySpec(
                    name="Medium Italic",
                    western_font_path=f"{fonts_dir}/JetBrainsMono-MediumItalic.ttf",
                    cjk_font_path=f"{fonts_dir}/LXGWBrightTC-Medium.ttf",
                    cjk_scale=1.2,
                ),
            ],
        ),
    ]

    for family in families:
        process_family(family)


if __name__ == "__main__":
    main()
