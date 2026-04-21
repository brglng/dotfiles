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
for _start, _end in CJK_UNICODE_RANGES:
    _block = range(_start, _end + 1)
    CJK_CODEPOINT_SET.update(_block)
    CJK_CODEPOINT_LIST.extend(_block)


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
        return 0


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

    Scaling is computed **automatically** — no user-supplied scale factors are
    needed:

    * Let ``C`` = natural CJK advance after UPM normalisation,
      ``H_c`` = CJK typographic height (scaled), ``W`` = western reference
      advance (capital 'A'), ``H_w`` = western typographic height.
    * ``A = H_c · 2W / H_w`` is the ``target_adv_c`` that would give the
      western glyph a perfectly uniform scale (scale_y / scale_x = 1).
    * The optimal cell width balances two objectives — western
      aspect-ratio distortion ``(A/T − 1)²`` and relative CJK blank space
      ``((T−C)/T)²`` — and is given by the closed-form minimiser
      ``T* = (A² + C²) / (A + C)``, clamped to ``≥ C`` so CJK ink always
      fits in the cell.
    * ``target_adv_w = T* // 2``.
    * Western ``scale_x = target_adv_w / W`` (fills halfwidth cell);  
      ``scale_y = H_c / H_w`` (forces western height to equal CJK height,
      making the non-uniformity as small as the two fonts allow).
    * CJK glyphs are scaled only by the UPM-normalisation ratio, then
      centred inside ``target_adv_c`` with minimal blank padding.

    Attributes
    ----------
    output_filename : str
        Output font file path.
    western_font_path : str
        Path to the base western font.
    cjk_font_path : str
        Path to the CJK font.
    stretch_chars : list[str | int | tuple[int, int]]
        Characters to stretch horizontally to double width.
    pad_configs : list[PadConfig]
        Per-character padding rules.
    symbol_font_paths : list[str]
        Paths to symbol fonts to overlay.
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
    remove_hints : bool
        When ``True``, all hinting data is stripped from the merged font before
        it is saved.  This removes the font-level programs (``fpgm``, ``prep``,
        ``cvt ``), display-optimisation tables (``hdmx``, ``LTSH``, ``VDMX``),
        and every per-glyph instruction sequence stored in the ``glyf`` table.
    """

    output_filename: str
    western_font_path: str
    cjk_font_path: str
    stretch_chars: list[str | int | tuple[int, int]]
    pad_configs: list[PadConfig]
    symbol_font_paths: list[str]
    adjust_baseline: bool
    new_font_family: str
    new_font_subfamily: str
    new_author: str
    new_description: str
    mark_as_monospace: bool
    remove_hints: bool


# ---------------------------------------------------------------------------
# Scaling parameters (shared across subfamilies)
# ---------------------------------------------------------------------------


@dataclass
class _ScalingParams:
    """Pre-computed scaling parameters derived from a reference subfamily.

    Sharing one ``_ScalingParams`` instance across every subfamily in a
    font family guarantees that all weights and styles have identical cell
    sizes and western proportions, even when different CJK fonts are used
    for upright vs italic variants.

    Attributes
    ----------
    upm : int
        The unified UPM (= max of western and CJK UPMs) used as the
        common coordinate space for the whole family.
    target_adv_c : int
        Full-width (CJK) cell advance in unified UPM units.
    target_adv_w : int
        Half-width (western / symbol) cell advance; always ``target_adv_c // 2``.
    western_scale_x : float
        X scale applied to every western glyph.
    western_scale_y : float
        Y scale applied to every western glyph (matches CJK height).
    scaled_cjk_adv : int
        Natural CJK advance after UPM normalisation; used to distinguish
        full-width from half-width CJK glyphs during merging.
    """

    upm: int
    target_adv_c: int
    target_adv_w: int
    western_scale_x: float
    western_scale_y: float
    scaled_cjk_adv: int


# ---------------------------------------------------------------------------
# Font family config (subfamilies map)
# ---------------------------------------------------------------------------


@dataclass
class SubfamilySpec:
    """Font file paths for a single subfamily.

    Attributes
    ----------
    western_font_path : str
        Path to the western (Latin) font for this subfamily.
    cjk_font_path : str
        Path to the CJK font for this subfamily.  Italic subfamilies may
        point to a different typeface than the upright ones.
    output_filename : str
        Destination path for the merged output font.
    """

    western_font_path: str
    cjk_font_path: str
    output_filename: str


@dataclass
class FontFamilySpec:
    """Configuration for an entire font family.

    Common settings (metadata, glyph adjustments, symbol overlays) are
    declared once and shared across all subfamilies.  Scaling is computed
    from the ``scaling_reference`` subfamily (default ``"Regular"``) and
    then reused verbatim for every other subfamily, ensuring consistent
    cell geometry even when italic subfamilies use a different CJK font.

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
    remove_hints : bool
        Strip hinting data from the merged fonts.
    adjust_baseline : bool
        Auto-align CJK baseline to the western baseline.
    stretch_chars : list[str | int | tuple[int, int]]
        Characters to stretch horizontally to double width.
    pad_configs : list[PadConfig]
        Per-character padding rules.
    symbol_font_paths : list[str]
        Paths to symbol fonts to overlay.
    subfamilies : dict[str, SubfamilySpec]
        Ordered map of subfamily name → font paths.  The key is used
        directly as ``new_font_subfamily`` in the output metadata.
    scaling_reference : str
        Which subfamily key to use when computing the shared
        ``_ScalingParams``.  Defaults to ``"Regular"``.
    """

    new_font_family: str
    new_author: str
    new_description: str
    mark_as_monospace: bool
    remove_hints: bool
    adjust_baseline: bool
    stretch_chars: list[str | int | tuple[int, int]]
    pad_configs: list[PadConfig]
    symbol_font_paths: list[str]
    subfamilies: dict[str, SubfamilySpec]
    scaling_reference: str = "Regular"


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


# ---------------------------------------------------------------------------
# Per-glyph metric helpers
# ---------------------------------------------------------------------------


@dataclass
class _FontTables:
    """Thin container that bundles the mutable tables edited during merging.

    Avoids threading ``glyf``, ``hmtx``, and the optional ``vmtx`` through
    every helper signature individually.
    """

    glyf: Any
    hmtx: Any
    vmtx: Any  # None when the font has no vmtx table

    @classmethod
    def from_font(cls, font: TTFont) -> "_FontTables":
        return cls(
            glyf=font["glyf"],
            hmtx=font["hmtx"],
            vmtx=font["vmtx"] if "vmtx" in font else None,
        )


def _scale_glyph_metrics(
    tables: _FontTables,
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


def _stretch_glyph(
    tables: _FontTables,
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


def _shift_glyph(
    tables: _FontTables,
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


def _copy_glyph_into(
    src_tables: _FontTables,
    dst_tables: _FontTables,
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
        GlyphTransformer.scale(copied, scale_x, scale_y)
        if apply_y_offset and y_offset != 0:
            if copied.isComposite():
                for comp in copied.components:
                    if hasattr(comp, "y") and comp.y is not None:
                        comp.y += y_offset
            elif hasattr(copied, "coordinates"):
                copied.coordinates = GlyphCoordinates([
                    (x, y + y_offset) for x, y in copied.coordinates
                ])
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


def build_alignment_map(pad_configs: list[PadConfig]) -> dict[int, Alignment]:
    """Build a codepoint \u2192 Alignment lookup from a list of PadConfigs."""
    mapping: dict[int, Alignment] = {}
    for cfg in pad_configs:
        for cp in parse_codepoints(cfg.chars):
            mapping[cp] = cfg.alignment
    return mapping


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


def scale_font(font: TTFont, scale_x: float, scale_y: float) -> None:
    """Scale every glyph and its metrics by (*scale_x*, *scale_y*).

    Glyph outlines are scaled non-uniformly when the two factors differ.
    Horizontal metrics (advance width, LSB) follow *scale_x*; vertical
    metrics (vertical advance, TSB) and all global OS/2 / hhea / vhea
    fields follow *scale_y*.
    """
    tables = _FontTables.from_font(font)

    for glyph_name in tables.glyf.keys():
        GlyphTransformer.scale(tables.glyf[glyph_name], scale_x, scale_y)
        _scale_glyph_metrics(tables, glyph_name, scale_x, scale_y)

    if scale_x == 1.0 and scale_y == 1.0:
        return

    def _sx(value: int) -> int:
        return int(round(value * scale_x))

    def _sy(value: int) -> int:
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
        setattr(os2, attr, _sy(getattr(os2, attr)))
    for attr in (
        "xAvgCharWidth",
        "ySubscriptXSize",
        "ySubscriptXOffset",
        "ySuperscriptXSize",
        "ySuperscriptXOffset",
    ):
        setattr(os2, attr, _sx(getattr(os2, attr)))

    hhea = font["hhea"]
    for attr in ("ascent", "descent", "lineGap"):
        setattr(hhea, attr, _sy(getattr(hhea, attr)))
    for attr in ("caretSlopeRise",):
        setattr(hhea, attr, _sy(getattr(hhea, attr)))
    for attr in ("caretSlopeRun", "caretOffset"):
        setattr(hhea, attr, _sx(getattr(hhea, attr)))

    if "vhea" in font:
        vhea = font["vhea"]
        for attr in ("ascent", "descent", "lineGap"):
            setattr(vhea, attr, _sy(getattr(vhea, attr)))
        for attr in ("caretSlopeRise",):
            setattr(vhea, attr, _sy(getattr(vhea, attr)))
        for attr in ("caretSlopeRun", "caretOffset"):
            setattr(vhea, attr, _sx(getattr(vhea, attr)))


def normalize_font_advances(font: TTFont, target_advance: int) -> None:
    """Set every glyph's advance width to *target_advance* without moving the ink."""
    tables = _FontTables.from_font(font)

    for glyph_name in tables.glyf.keys():
        if glyph_name not in tables.hmtx.metrics:
            continue
        adv, lsb = tables.hmtx.metrics[glyph_name]
        if adv != target_advance:
            tables.hmtx.metrics[glyph_name] = (target_advance, lsb)




# ---------------------------------------------------------------------------
# Single-glyph width adjustments (pad / stretch)
# ---------------------------------------------------------------------------


def pad_glyph_width(
    font: TTFont,
    codepoint: int,
    target_advance: int,
    alignment: Alignment,
) -> None:
    """Widen a glyph's advance width by adding whitespace on one or both sides."""
    cmap = font.getBestCmap()
    if codepoint not in cmap:
        return
    glyph_name = cmap[codepoint]
    tables = _FontTables.from_font(font)
    if glyph_name not in tables.glyf or glyph_name not in tables.hmtx.metrics:
        return
    adv, _ = tables.hmtx.metrics[glyph_name]
    if adv >= target_advance:
        return
    _shift_glyph(tables, glyph_name, alignment.compute_shift(target_advance - adv), target_advance)


def stretch_glyph_width(
    font: TTFont,
    codepoint: int,
    target_advance: int,
) -> None:
    """Horizontally stretch a glyph's geometry to fit *target_advance*."""
    cmap = font.getBestCmap()
    if codepoint not in cmap:
        return
    glyph_name = cmap[codepoint]
    tables = _FontTables.from_font(font)
    if glyph_name not in tables.glyf or glyph_name not in tables.hmtx.metrics:
        return
    _stretch_glyph(tables, glyph_name, target_advance)


# ---------------------------------------------------------------------------
# CJK glyph merging (two-phase)
# ---------------------------------------------------------------------------


def _copy_cjk_glyphs_to_base(
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
    base_tables = _FontTables.from_font(base_font)
    cjk_tables = _FontTables.from_font(cjk_font)

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
            _copy_glyph_into(
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


def _adjust_cjk_glyph_widths(
    base_font: TTFont,
    cjk_font: TTFont,
    target_adv_w: int,
    target_adv_c: int,
    cjk_upm_scale: float,
    typical_scaled_cjk_adv: float,
    stretch_set: set[int],
    alignment_map: dict[int, Alignment],
) -> None:
    """Phase 2 \u2014 Walk the CJK cmap and stretch or pad each copied glyph to its
    target advance width (fullwidth or halfwidth)."""
    cjk_cmap = cjk_font.getBestCmap()
    base_tables = _FontTables.from_font(base_font)
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

        if scaled_adv > typical_scaled_cjk_adv * 0.75:
            target_adv = target_adv_c
        else:
            target_adv = target_adv_w

        # Apply stretch or pad, then center unless an explicit alignment exists
        alignment = alignment_map.get(codepoint)
        if codepoint in stretch_set and scaled_adv > 0:
            _stretch_glyph(base_tables, new_glyph_name, target_adv)
        elif alignment is not None:
            _shift_glyph(
                base_tables, new_glyph_name,
                alignment.compute_shift(target_adv - scaled_adv),
                target_adv,
            )
        else:
            # No explicit alignment — just set the advance without moving ink.
            base_tables.hmtx.metrics[new_glyph_name] = (
                target_adv,
                base_tables.hmtx.metrics[new_glyph_name][1],
            )


def merge_cjk_glyphs(
    base_font: TTFont,
    cjk_font: TTFont,
    target_adv_w: int,
    target_adv_c: int,
    cjk_upm_scale: float,
    y_offset: int,
    typical_scaled_cjk_adv: float,
    stretch_set: set[int],
    alignment_map: dict[int, Alignment],
) -> None:
    """Copy CJK glyphs into the base font and adjust their advance widths.

    This is the public entry point that orchestrates the two internal phases.
    """
    _copy_cjk_glyphs_to_base(base_font, cjk_font, cjk_upm_scale, y_offset)
    _adjust_cjk_glyph_widths(
        base_font, cjk_font, target_adv_w, target_adv_c,
        cjk_upm_scale, typical_scaled_cjk_adv,
        stretch_set, alignment_map,
    )


# ---------------------------------------------------------------------------
# Symbol font merging
# ---------------------------------------------------------------------------


def merge_symbols_into_font(
    base_font: TTFont,
    symbol_font_path: str,
    target_adv_w: int,
) -> None:
    """Overlay a symbol font onto the base font, scaling by UPM ratio.

    Existing glyphs are overwritten when names collide.

    Every top-level symbol glyph's advance
    width is forced to that value after copying, ensuring the merged font has
    a consistent halfwidth advance for all non-CJK glyphs.
    """
    symbol_font = TTFont(symbol_font_path)
    base_cmap = base_font.getBestCmap()
    symbol_cmap = symbol_font.getBestCmap()
    base_tables = _FontTables.from_font(base_font)
    sym_tables = _FontTables(
        glyf=symbol_font["glyf"],
        hmtx=symbol_font["hmtx"],
        vmtx=symbol_font["vmtx"] if "vmtx" in base_font and "vmtx" in symbol_font else None,
    )
    scale = base_font["head"].unitsPerEm / symbol_font["head"].unitsPerEm

    for codepoint, sym_glyph_name in symbol_cmap.items():
        for dep_name in get_glyph_dependencies(sym_glyph_name, sym_tables.glyf):
            _copy_glyph_into(
                sym_tables, base_tables, dep_name, dep_name, base_font,
                scale_x=scale, scale_y=scale,
            )
        base_cmap[codepoint] = sym_glyph_name

        # Force the top-level glyph's advance to the target halfwidth value.
        if target_adv_w > 0 and sym_glyph_name in base_tables.hmtx.metrics:
            adv, lsb = base_tables.hmtx.metrics[sym_glyph_name]
            if adv != target_adv_w:
                base_tables.hmtx.metrics[sym_glyph_name] = (target_adv_w, lsb)

    symbol_font.close()


# ---------------------------------------------------------------------------
# Hint removal
# ---------------------------------------------------------------------------


def remove_font_hints(font: TTFont) -> None:
    """Strip all hinting data from *font* in place.

    Removes font-level hint programs and tables, then clears every per-glyph
    instruction sequence so the output is hint-free.
    """
    # Font-level hint tables.
    for tag in ("fpgm", "prep", "cvt ", "hdmx", "LTSH", "VDMX"):
        if tag in font:
            del font[tag]

    # Per-glyph instruction bytecode stored in the glyf table.
    if "glyf" in font:
        for glyph_name in font["glyf"].keys():
            glyph = font["glyf"][glyph_name]
            if hasattr(glyph, "program"):
                glyph.program = TTProgram()


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
    cjk_font: TTFont,
    cjk_upm_scale: float,
) -> int:
    """Calculate the vertical shift needed to align the CJK baseline
    with the (already-scaled) western baseline."""
    western_os2 = western_font["OS/2"]
    cjk_os2 = cjk_font["OS/2"]
    western_center = (western_os2.sTypoAscender + western_os2.sTypoDescender) / 2.0
    cjk_center = (cjk_os2.sTypoAscender + cjk_os2.sTypoDescender) / 2.0
    return int(round(western_center - cjk_center * cjk_upm_scale))


def merge_vertical_metrics(
    base_font: TTFont,
    cjk_font: TTFont,
    cjk_coord_scale: float,
) -> None:
    """Expand the base font's vertical metrics so they cover the CJK glyphs.

    Each metric is set to ``max(base, scaled_cjk)`` for ascenders and
    ``min(base, scaled_cjk)`` (i.e. largest magnitude) for descenders.
    """
    def _sc(v: int) -> int:
        return int(round(v * cjk_coord_scale))

    b_os2 = base_font["OS/2"]
    c_os2 = cjk_font["OS/2"]
    b_os2.sTypoAscender  = max(b_os2.sTypoAscender,  _sc(c_os2.sTypoAscender))
    b_os2.sTypoDescender = min(b_os2.sTypoDescender, _sc(c_os2.sTypoDescender))
    b_os2.usWinAscent    = max(b_os2.usWinAscent,    _sc(c_os2.usWinAscent))
    b_os2.usWinDescent   = max(b_os2.usWinDescent,   _sc(c_os2.usWinDescent))

    b_hhea = base_font["hhea"]
    c_hhea = cjk_font["hhea"]
    b_hhea.ascent  = max(b_hhea.ascent,  _sc(c_hhea.ascent))
    b_hhea.descent = min(b_hhea.descent, _sc(c_hhea.descent))

    if "vhea" in base_font and "vhea" in cjk_font:
        b_vhea = base_font["vhea"]
        c_vhea = cjk_font["vhea"]
        b_vhea.ascent  = max(b_vhea.ascent,  _sc(c_vhea.ascent))
        b_vhea.descent = min(b_vhea.descent, _sc(c_vhea.descent))


# ---------------------------------------------------------------------------
# Main pipeline
# ---------------------------------------------------------------------------


def compute_scaling_params(
    western_font_path: str,
    cjk_font_path: str,
) -> _ScalingParams:
    """Derive the optimal ``_ScalingParams`` from a western + CJK font pair.

    This is the same closed-form calculation used inside ``process_font``
    when no pre-computed scaling is supplied.  Factoring it out allows
    ``process_family`` to run it once for the reference subfamily and then
    share the result across all other subfamilies.
    """
    western_font = load_font(western_font_path)
    cjk_font = load_font(cjk_font_path)

    western_upm = western_font["head"].unitsPerEm
    cjk_upm = cjk_font["head"].unitsPerEm
    upm = max(western_upm, cjk_upm)
    cjk_upm_scale = upm / float(cjk_upm)

    W = float(get_typical_advance(western_font, ord("A")))
    C = get_typical_advance(cjk_font, ord("\u4e2d")) * cjk_upm_scale

    w_os2 = western_font["OS/2"]
    c_os2 = cjk_font["OS/2"]
    H_w = float(w_os2.sTypoAscender - w_os2.sTypoDescender)
    H_c = (c_os2.sTypoAscender - c_os2.sTypoDescender) * cjk_upm_scale

    A = H_c * 2.0 * W / H_w
    T_opt = (A * A + C * C) / (A + C)
    target_adv_c = int(round(max(C, T_opt)))
    target_adv_w = target_adv_c // 2

    params = _ScalingParams(
        upm=upm,
        target_adv_c=target_adv_c,
        target_adv_w=target_adv_w,
        western_scale_x=target_adv_w / W,
        western_scale_y=H_c / H_w,
        scaled_cjk_adv=int(round(C)),
    )

    western_font.close()
    cjk_font.close()
    return params


def process_font(config: FontMergeConfig, scaling: _ScalingParams | None = None) -> None:
    """Execute the complete font merging pipeline:

    1. Load fonts; use ``scaling`` if provided, otherwise compute it
       automatically from the font pair.
    2. Scale the western font and copy CJK glyphs at natural UPM-normalised
       size (padded to ``target_adv_c``).
    3. Copy and adjust CJK glyphs.
    4. Stretch / pad designated English-side glyphs.
    5. Overlay symbol fonts.
    6. Write metadata and save.

    Parameters
    ----------
    config :
        Per-font settings (paths, metadata, glyph adjustments).
    scaling :
        Pre-computed cell geometry and western scale factors.  When
        ``None`` the scaling is derived on-the-fly from *this* font pair,
        which is equivalent to the standalone behaviour.  Pass a shared
        ``_ScalingParams`` (from ``compute_scaling_params``) to keep all
        subfamilies in a family metrically consistent.
    """
    western_font = load_font(config.western_font_path)
    cjk_font = load_font(config.cjk_font_path)

    cjk_upm = cjk_font["head"].unitsPerEm

    if scaling is None:
        scaling = compute_scaling_params(
            config.western_font_path, config.cjk_font_path
        )

    upm = scaling.upm
    # CJK UPM scale uses the shared UPM so that a different CJK font for an
    # italic subfamily is still placed in the same coordinate space.
    cjk_coord_scale = upm / float(cjk_upm)

    target_adv_c = scaling.target_adv_c
    target_adv_w = scaling.target_adv_w
    scaled_cjk_adv = scaling.scaled_cjk_adv

    print(
        f"  cell: target_adv_c={target_adv_c}, target_adv_w={target_adv_w}\n"
        f"  western scale_x={scaling.western_scale_x:.4f}, scale_y={scaling.western_scale_y:.4f} "
        f"(non-uniformity={(scaling.western_scale_y / scaling.western_scale_x - 1) * 100:.1f}%)\n"
        f"  CJK blank per side={(target_adv_c - scaled_cjk_adv) // 2} units"
    )

    # Apply the (non-uniform) geometry scale to every western glyph.
    scale_font(western_font, scaling.western_scale_x, scaling.western_scale_y)
    western_font["head"].unitsPerEm = upm

    # Force every western glyph's advance to the target halfwidth value.
    normalize_font_advances(western_font, target_adv_w)

    # Baseline alignment
    y_offset = 0
    if config.adjust_baseline:
        y_offset += compute_baseline_y_offset(western_font, cjk_font, cjk_coord_scale)

    stretch_set = parse_codepoints(config.stretch_chars)
    alignment_map = build_alignment_map(config.pad_configs)

    # Merge CJK glyphs (phase 1 copies them; phase 2 pads/stretches to the
    # expanded target advances).
    merge_cjk_glyphs(
        base_font=western_font,
        cjk_font=cjk_font,
        target_adv_w=target_adv_w,
        target_adv_c=target_adv_c,
        cjk_upm_scale=cjk_coord_scale,
        y_offset=y_offset,
        typical_scaled_cjk_adv=scaled_cjk_adv,
        stretch_set=stretch_set,
        alignment_map=alignment_map,
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
    fullwidth_tables = _FontTables.from_font(western_font)
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
    for symbol_path in config.symbol_font_paths:
        merge_symbols_into_font(western_font, symbol_path, target_adv_w=target_adv_w)

    # Metadata & monospace flag
    update_font_metadata(western_font, config)
    if config.mark_as_monospace:
        mark_font_as_monospace(western_font, target_adv_w)

    # Remove hinting data if requested.
    if config.remove_hints:
        remove_font_hints(western_font)

    # Ensure Format 12 cmap subtable exists for any non-BMP codepoints
    # accumulated across all merging stages.
    ensure_cmap_format_12(western_font, western_font.getBestCmap())

    # Save
    western_font.save(config.output_filename)
    western_font.close()
    cjk_font.close()


def process_family(family: FontFamilySpec) -> None:
    """Process all subfamilies of a font family.

    Scaling is computed once from the ``scaling_reference`` subfamily
    (default ``"Regular"``) and reused for every other subfamily.  This
    guarantees that all weights and styles share the same cell geometry,
    even when italic subfamilies use a different CJK typeface.
    """
    ref_name = family.scaling_reference
    ref = family.subfamilies.get(ref_name)
    if ref is None:
        raise ValueError(
            f"scaling_reference '{ref_name}' not found in subfamilies "
            f"for family '{family.new_font_family}'"
        )

    print(
        f"[{family.new_font_family}] "
        f"Computing scaling from '{ref_name}' reference ..."
    )
    scaling = compute_scaling_params(ref.western_font_path, ref.cjk_font_path)
    print(
        f"  upm={scaling.upm}, target_adv_c={scaling.target_adv_c}, "
        f"target_adv_w={scaling.target_adv_w}\n"
        f"  scale_x={scaling.western_scale_x:.4f}, "
        f"scale_y={scaling.western_scale_y:.4f} "
        f"(non-uniformity={(scaling.western_scale_y / scaling.western_scale_x - 1) * 100:.1f}%)"
    )

    for subfamily_name, spec in family.subfamilies.items():
        config = FontMergeConfig(
            output_filename=spec.output_filename,
            western_font_path=spec.western_font_path,
            cjk_font_path=spec.cjk_font_path,
            stretch_chars=family.stretch_chars,
            pad_configs=family.pad_configs,
            symbol_font_paths=family.symbol_font_paths,
            adjust_baseline=family.adjust_baseline,
            new_font_family=family.new_font_family,
            new_font_subfamily=subfamily_name,
            new_author=family.new_author,
            new_description=family.new_description,
            mark_as_monospace=family.mark_as_monospace,
            remove_hints=family.remove_hints,
        )
        print(f"  Processing: {spec.output_filename} ...")
        try:
            process_font(config, scaling=scaling)
            print(f"  Saved: {spec.output_filename}")
        except FileNotFoundError as err:
            print(f"  Error: {err}")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------


def main():
    """Configure and run font merging tasks."""
    _L = os.path.expanduser  # shorthand for ~/Library/Fonts/... paths

    _COMMON = dict(
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
            _L("~/Library/Fonts/SymbolsNerdFont-Regular.ttf"),
            "FlogSymbols.ttf",
        ],
    )

    families = [
        FontFamilySpec(
            new_font_family="Monaspace Argon LXGW Bright TC NF",
            **_COMMON,
            subfamilies={
                "Light": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceArgon-Light.otf"),
                    cjk_font_path=_L("~/Library/Fonts/LXGWBrightTC-Light.ttf"),
                    output_filename="Monaspace Argon LXGW Bright TC NF Light.ttf",
                ),
                "Light Italic": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceArgon-LightItalic.otf"),
                    cjk_font_path=_L("~/Library/Fonts/LXGWBrightTC-Light.ttf"),
                    output_filename="Monaspace Argon LXGW Bright TC NF Light Italic.ttf",
                ),
                "Regular": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceArgon-Regular.otf"),
                    cjk_font_path=_L("~/Library/Fonts/LXGWBrightTC-Regular.ttf"),
                    output_filename="Monaspace Argon LXGW Bright TC NF Regular.ttf",
                ),
                "Italic": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceArgon-Italic.otf"),
                    cjk_font_path=_L("~/Library/Fonts/LXGWBrightTC-Regular.ttf"),
                    output_filename="Monaspace Argon LXGW Bright TC NF Italic.ttf",
                ),
                "Medium": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceArgon-Medium.otf"),
                    cjk_font_path=_L("~/Library/Fonts/LXGWBrightTC-Medium.ttf"),
                    output_filename="Monaspace Argon LXGW Bright TC NF Medium.ttf",
                ),
                "Medium Italic": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceArgon-MediumItalic.otf"),
                    cjk_font_path=_L("~/Library/Fonts/LXGWBrightTC-Medium.ttf"),
                    output_filename="Monaspace Argon LXGW Bright TC NF Medium Italic.ttf",
                ),
            },
        ),
        FontFamilySpec(
            new_font_family="Monaspace Xenon Noto Serif LXGW CJK TC NF",
            **_COMMON,
            subfamilies={
                "Light": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceXenon-Light.otf"),
                    cjk_font_path=_L("~/Library/Fonts/NotoSerifCJKtc-Light.otf"),
                    output_filename="Monaspace Xenon Noto Serif LXGW CJK TC NF Light.ttf",
                ),
                "Light Italic": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceXenon-LightItalic.otf"),
                    cjk_font_path=_L("~/Library/Fonts/LXGWBrightTC-Light.ttf"),
                    output_filename="Monaspace Xenon Noto Serif LXGW CJK TC NF Light Italic.ttf",
                ),
                "Regular": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceXenon-Regular.otf"),
                    cjk_font_path=_L("~/Library/Fonts/NotoSerifCJKtc-Regular.otf"),
                    output_filename="Monaspace Xenon Noto Serif LXGW CJK TC NF Regular.ttf",
                ),
                "Italic": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceXenon-Italic.otf"),
                    cjk_font_path=_L("~/Library/Fonts/LXGWBrightTC-Regular.ttf"),
                    output_filename="Monaspace Xenon Noto Serif LXGW CJK TC NF Italic.ttf",
                ),
                "Medium": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceXenon-Medium.otf"),
                    cjk_font_path=_L("~/Library/Fonts/NotoSerifCJKtc-Medium.otf"),
                    output_filename="Monaspace Xenon Noto Serif LXGW CJK TC NF Medium.ttf",
                ),
                "Medium Italic": SubfamilySpec(
                    western_font_path=_L("~/Library/Fonts/MonaspaceXenon-MediumItalic.otf"),
                    cjk_font_path=_L("~/Library/Fonts/LXGWBrightTC-Medium.ttf"),
                    output_filename="Monaspace Xenon Noto Serif LXGW CJK TC NF Medium Italic.ttf",
                ),
            },
        ),
    ]

    for family in families:
        process_family(family)


if __name__ == "__main__":
    main()
