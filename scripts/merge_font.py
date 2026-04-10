#!/usr/bin/env python3
"""Font merging script that combines English and CJK fonts with configurable
scaling strategies, symbol font overlays, and metadata customization."""
import copy
from dataclasses import dataclass
from enum import Enum
import math
from typing import Any

from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._c_m_a_p import cmap_format_12
from fontTools.ttLib.tables._g_l_y_f import GlyphCoordinates


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


class ScaleStrategy(Enum):
    """Scaling strategies for combining English and CJK fonts."""

    ENGLISH_KEEP_CJK_SCALE_GAP = "english_keep_cjk_scale_gap"
    ENGLISH_SCALE_GAP_CJK_KEEP = "english_scale_gap_cjk_keep"
    ENGLISH_STRETCH_CJK_KEEP = "english_stretch_cjk_keep"
    OPTIMAL_SCALE_BOTH = "optimal_scale_both"
    NO_STRETCH = "no_stretch"


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
    output_filename : str
        Output font file path.
    english_font_path : str
        Path to the base English font.
    cjk_font_path : str
        Path to the CJK font.
    scaling_strategy : ScaleStrategy
        Strategy used to reconcile English / CJK advance widths.
    stretch_chars : list[str | int | tuple[int, int]]
        Characters to stretch horizontally to double width.
    pad_configs : list[PadConfig]
        Per-character padding rules.
    weight_english : float
        Weight for English font in the OPTIMAL_SCALE_BOTH strategy.
    symbol_font_paths : list[str]
        Paths to symbol fonts to overlay.
    adjust_baseline : bool
        Whether to auto-align CJK baseline to English baseline.
    cjk_y_offset : int
        Manual vertical offset applied to CJK glyphs.
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
    """

    output_filename: str
    english_font_path: str
    cjk_font_path: str
    scaling_strategy: ScaleStrategy
    stretch_chars: list[str | int | tuple[int, int]]
    pad_configs: list[PadConfig]
    weight_english: float
    symbol_font_paths: list[str]
    adjust_baseline: bool
    cjk_y_offset: int
    new_font_family: str
    new_font_subfamily: str
    new_author: str
    new_description: str
    mark_as_monospace: bool


@dataclass
class ScaleParams:
    """Computed scaling parameters derived from a ScaleStrategy.

    Attributes
    ----------
    target_adv_e : int
        Target advance width for halfwidth (English) characters.
    target_adv_c : int
        Target advance width for fullwidth (CJK) characters.
    eng_scale_x : float
        Horizontal scaling factor for the English font.
    eng_scale_y : float
        Vertical scaling factor for the English font.
    """

    target_adv_e: int
    target_adv_c: int
    eng_scale_x: float
    eng_scale_y: float


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
    def scale_horizontal(glyph: Any, scale_x: float) -> None:
        """Scale only the horizontal axis (used for stretching)."""
        if glyph.isComposite():
            for comp in glyph.components:
                if hasattr(comp, "x") and comp.x is not None:
                    comp.x = int(round(comp.x * scale_x))
                if hasattr(comp, "transform"):
                    try:
                        (xx, xy), (yx, yy) = comp.transform
                        comp.transform = ((xx * scale_x, xy * scale_x), (yx, yy))
                    except ValueError:
                        pass
        elif hasattr(glyph, "coordinates"):
            glyph.coordinates = GlyphCoordinates([
                (int(round(x * scale_x)), y)
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
    def scale_and_offset_y(
        glyph: Any,
        upm_scale: float,
        y_offset: int,
        apply_y_offset: bool,
    ) -> None:
        """Scale by *upm_scale* and optionally apply a vertical offset."""
        if glyph.isComposite():
            for comp in glyph.components:
                if hasattr(comp, "x") and comp.x is not None:
                    comp.x = int(round(comp.x * upm_scale))
                if hasattr(comp, "y") and comp.y is not None:
                    comp.y = int(round(comp.y * upm_scale))
                    if apply_y_offset:
                        comp.y += y_offset
        elif hasattr(glyph, "coordinates"):
            coords = []
            for x, y in glyph.coordinates:
                y_val = int(round(y * upm_scale))
                if apply_y_offset:
                    y_val += y_offset
                coords.append((int(round(x * upm_scale)), y_val))
            glyph.coordinates = GlyphCoordinates(coords)


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
    """Add a Format 12 cmap subtable when non-BMP codepoints are present."""
    has_format_12 = any(t.format == 12 for t in font["cmap"].tables)

    if not has_format_12 and any(cp > 0xFFFF for cp in cmap_mapping):
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
# Scaling strategy computation
# ---------------------------------------------------------------------------


def _calculate_optimal_rho(
    english_ratio: float,
    cjk_ratio: float,
    weight_english: float,
) -> float:
    """Weighted geometric mean of English and half-CJK width-to-height ratios."""
    weight_cjk = 1.0 - weight_english
    ln_rho = (weight_english * math.log(english_ratio)
              + weight_cjk * math.log(cjk_ratio / 2.0))
    return math.exp(ln_rho)


def compute_scale_params(
    strategy: ScaleStrategy,
    eng_upm: int,
    cjk_upm: int,
    upm: int,
    eng_upm_scale: float,
    scaled_eng_adv: float,
    scaled_cjk_adv: float,
    eng_typical_adv: int,
    cjk_typical_adv: int,
    weight_english: float,
) -> ScaleParams:
    """Derive concrete advance widths and scaling factors from the chosen strategy."""
    if strategy is ScaleStrategy.ENGLISH_KEEP_CJK_SCALE_GAP:
        target_adv_e = int(round(scaled_eng_adv))
        return ScaleParams(
            target_adv_e=target_adv_e,
            target_adv_c=target_adv_e * 2,
            eng_scale_x=eng_upm_scale,
            eng_scale_y=eng_upm_scale,
        )

    if strategy is ScaleStrategy.ENGLISH_SCALE_GAP_CJK_KEEP:
        target_adv_e = int(round(scaled_cjk_adv / 2.0))
        ratio = target_adv_e / float(eng_typical_adv)
        return ScaleParams(
            target_adv_e=target_adv_e,
            target_adv_c=target_adv_e * 2,
            eng_scale_x=ratio,
            eng_scale_y=ratio,
        )

    if strategy is ScaleStrategy.ENGLISH_STRETCH_CJK_KEEP:
        target_adv_e = int(round(scaled_cjk_adv / 2.0))
        return ScaleParams(
            target_adv_e=target_adv_e,
            target_adv_c=target_adv_e * 2,
            eng_scale_x=target_adv_e / float(eng_typical_adv),
            eng_scale_y=eng_upm_scale,
        )

    if strategy is ScaleStrategy.OPTIMAL_SCALE_BOTH:
        eng_ratio = eng_typical_adv / float(eng_upm)
        cjk_ratio = cjk_typical_adv / float(cjk_upm)
        optimal_rho = _calculate_optimal_rho(eng_ratio, cjk_ratio, weight_english)
        target_adv_e = int(round(upm * optimal_rho))
        return ScaleParams(
            target_adv_e=target_adv_e,
            target_adv_c=target_adv_e * 2,
            eng_scale_x=target_adv_e / float(eng_typical_adv),
            eng_scale_y=eng_upm_scale,
        )

    # ScaleStrategy.NO_STRETCH
    return ScaleParams(
        target_adv_e=int(round(scaled_eng_adv)),
        target_adv_c=int(round(scaled_cjk_adv)),
        eng_scale_x=eng_upm_scale,
        eng_scale_y=eng_upm_scale,
    )


# ---------------------------------------------------------------------------
# Whole-font glyph scaling
# ---------------------------------------------------------------------------


def scale_font_glyphs(font: TTFont, scale_x: float, scale_y: float) -> None:
    """Scale every glyph and its metrics by (*scale_x*, *scale_y*)."""
    if scale_x == 1.0 and scale_y == 1.0:
        return

    glyf = font["glyf"]
    hmtx = font["hmtx"]
    vmtx = font["vmtx"] if "vmtx" in font else None

    for glyph_name, glyph in glyf.items():
        GlyphTransformer.scale(glyph, scale_x, scale_y)

        if glyph_name in hmtx.metrics:
            adv, lsb = hmtx.metrics[glyph_name]
            hmtx.metrics[glyph_name] = (
                int(round(adv * scale_x)),
                int(round(lsb * scale_x)),
            )

        if vmtx and glyph_name in vmtx.metrics:
            v_adv, tsb = vmtx.metrics[glyph_name]
            vmtx.metrics[glyph_name] = (
                int(round(v_adv * scale_y)),
                int(round(tsb * scale_y)),
            )


def scale_vertical_metrics(font: TTFont, scale: float) -> None:
    """Scale all global vertical metric fields (OS/2, hhea, vhea) by *scale*."""
    if scale == 1.0:
        return

    def _s(value: int) -> int:
        return int(round(value * scale))

    os2 = font["OS/2"]
    for attr in (
        "sTypoAscender", "sTypoDescender", "sTypoLineGap",
        "usWinAscent", "usWinDescent",
        "sxHeight", "sCapHeight",
        "ySubscriptXSize", "ySubscriptYSize",
        "ySubscriptXOffset", "ySubscriptYOffset",
        "ySuperscriptXSize", "ySuperscriptYSize",
        "ySuperscriptXOffset", "ySuperscriptYOffset",
        "yStrikeoutSize", "yStrikeoutPosition",
    ):
        setattr(os2, attr, _s(getattr(os2, attr)))

    hhea = font["hhea"]
    for attr in ("ascent", "descent", "lineGap", "caretSlopeRise", "caretOffset"):
        setattr(hhea, attr, _s(getattr(hhea, attr)))

    if "vhea" in font:
        vhea = font["vhea"]
        for attr in ("ascent", "descent", "lineGap"):
            setattr(vhea, attr, _s(getattr(vhea, attr)))


# ---------------------------------------------------------------------------
# Single-glyph width adjustments (pad / stretch / shift)
# ---------------------------------------------------------------------------


def _shift_glyph_and_metrics(
    glyf_table: dict,
    hmtx_table: Any,
    glyph_name: str,
    shift_x: int,
    target_advance: int,
) -> None:
    """Shift a glyph horizontally and write *target_advance* into hmtx."""
    GlyphTransformer.shift_horizontal(glyf_table[glyph_name], shift_x)
    _, current_lsb = hmtx_table.metrics[glyph_name]
    hmtx_table.metrics[glyph_name] = (target_advance, current_lsb + shift_x)


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
    glyf = font["glyf"]
    hmtx = font["hmtx"]

    if glyph_name not in glyf or glyph_name not in hmtx.metrics:
        return

    adv, current_lsb = hmtx.metrics[glyph_name]
    if adv >= target_advance:
        return

    shift_x = alignment.compute_shift(target_advance - adv)
    GlyphTransformer.shift_horizontal(glyf[glyph_name], shift_x)
    hmtx.metrics[glyph_name] = (target_advance, current_lsb + shift_x)


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
    glyf = font["glyf"]
    hmtx = font["hmtx"]

    if glyph_name not in glyf or glyph_name not in hmtx.metrics:
        return

    adv, lsb = hmtx.metrics[glyph_name]
    if adv == 0:
        return

    scale_factor = target_advance / float(adv)
    GlyphTransformer.scale_horizontal(glyf[glyph_name], scale_factor)
    hmtx.metrics[glyph_name] = (target_advance, int(round(lsb * scale_factor)))


# ---------------------------------------------------------------------------
# CJK glyph merging (two-phase)
# ---------------------------------------------------------------------------


def _copy_cjk_glyphs_to_base(
    base_font: TTFont,
    cjk_font: TTFont,
    cjk_upm_scale: float,
    y_offset: int,
) -> None:
    """Phase 1 \u2014 Deep-copy every CJK glyph (and its dependencies) from the CJK
    font into the base font, applying UPM scaling and vertical offset.

    Copied glyphs are prefixed with ``cjk_`` to avoid name collisions.
    """
    base_cmap = base_font.getBestCmap()
    cjk_cmap = cjk_font.getBestCmap()

    base_glyf = base_font["glyf"]
    cjk_glyf = cjk_font["glyf"]
    base_hmtx = base_font["hmtx"]
    cjk_hmtx = cjk_font["hmtx"]

    has_vmtx = "vmtx" in base_font and "vmtx" in cjk_font
    base_vmtx = base_font["vmtx"] if has_vmtx else None
    cjk_vmtx = cjk_font["vmtx"] if has_vmtx else None

    for codepoint in CJK_CODEPOINT_LIST:
        if codepoint not in cjk_cmap:
            continue

        cjk_glyph_name = cjk_cmap[codepoint]
        dependencies = get_glyph_dependencies(cjk_glyph_name, cjk_glyf)

        for dep_name in dependencies:
            new_dep_name = f"cjk_{dep_name}"
            if new_dep_name in base_glyf:
                continue

            # Copy and scale glyph outlines
            if dep_name in cjk_glyf:
                copied = copy.deepcopy(cjk_glyf[dep_name])
                is_top_level = dep_name == cjk_glyph_name
                GlyphTransformer.scale_and_offset_y(
                    copied, cjk_upm_scale, y_offset, apply_y_offset=is_top_level,
                )
                base_glyf[new_dep_name] = copied
                if new_dep_name not in base_font.glyphOrder:
                    base_font.glyphOrder.append(new_dep_name)

            # Copy and scale horizontal metrics
            if dep_name in cjk_hmtx.metrics:
                adv, lsb = cjk_hmtx.metrics[dep_name]
                base_hmtx.metrics[new_dep_name] = (
                    int(round(adv * cjk_upm_scale)),
                    int(round(lsb * cjk_upm_scale)),
                )

            # Copy and scale vertical metrics
            if base_vmtx and cjk_vmtx and dep_name in cjk_vmtx.metrics:
                v_adv, tsb = cjk_vmtx.metrics[dep_name]
                scaled_tsb = int(round(tsb * cjk_upm_scale))
                if dep_name == cjk_glyph_name:
                    scaled_tsb -= y_offset
                base_vmtx.metrics[new_dep_name] = (
                    int(round(v_adv * cjk_upm_scale)),
                    scaled_tsb,
                )

        base_cmap[codepoint] = f"cjk_{cjk_glyph_name}"


def _adjust_cjk_glyph_widths(
    base_font: TTFont,
    cjk_font: TTFont,
    params: ScaleParams,
    cjk_upm_scale: float,
    typical_scaled_cjk_adv: float,
    strategy: ScaleStrategy,
    stretch_set: set[int],
    alignment_map: dict[int, Alignment],
) -> None:
    """Phase 2 \u2014 Walk the CJK cmap and stretch or pad each copied glyph to its
    target advance width (fullwidth or halfwidth)."""
    cjk_cmap = cjk_font.getBestCmap()
    base_glyf = base_font["glyf"]
    base_hmtx = base_font["hmtx"]
    cjk_hmtx = cjk_font["hmtx"]
    processed: set[str] = set()

    for codepoint, cjk_glyph_name in cjk_cmap.items():
        if codepoint not in CJK_CODEPOINT_SET:
            continue

        new_glyph_name = f"cjk_{cjk_glyph_name}"
        if new_glyph_name not in base_glyf or new_glyph_name in processed:
            continue
        processed.add(new_glyph_name)

        # Determine target advance width
        original_adv = cjk_hmtx.metrics[cjk_glyph_name][0]
        scaled_adv = int(round(original_adv * cjk_upm_scale))

        if strategy is ScaleStrategy.NO_STRETCH:
            target_adv = scaled_adv
        elif scaled_adv > typical_scaled_cjk_adv * 0.75:
            target_adv = params.target_adv_c
        else:
            target_adv = params.target_adv_e

        # Apply stretch or pad
        if codepoint in stretch_set and scaled_adv > 0:
            scale_factor = target_adv / float(scaled_adv)
            if scale_factor != 1.0:
                GlyphTransformer.scale_horizontal(base_glyf[new_glyph_name], scale_factor)
            _, current_lsb = base_hmtx.metrics[new_glyph_name]
            base_hmtx.metrics[new_glyph_name] = (
                target_adv,
                int(round(current_lsb * scale_factor)),
            )
        else:
            alignment = alignment_map.get(codepoint, Alignment.CENTER)
            shift_x = alignment.compute_shift(target_adv - scaled_adv)
            _shift_glyph_and_metrics(
                base_glyf, base_hmtx, new_glyph_name, shift_x, target_adv,
            )


def merge_cjk_glyphs(
    base_font: TTFont,
    cjk_font: TTFont,
    params: ScaleParams,
    cjk_upm_scale: float,
    y_offset: int,
    typical_scaled_cjk_adv: float,
    strategy: ScaleStrategy,
    stretch_set: set[int],
    alignment_map: dict[int, Alignment],
) -> None:
    """Copy CJK glyphs into the base font and adjust their advance widths.

    This is the public entry point that orchestrates the two internal phases.
    """
    _copy_cjk_glyphs_to_base(base_font, cjk_font, cjk_upm_scale, y_offset)
    _adjust_cjk_glyph_widths(
        base_font, cjk_font, params,
        cjk_upm_scale, typical_scaled_cjk_adv,
        strategy, stretch_set, alignment_map,
    )
    ensure_cmap_format_12(base_font, base_font.getBestCmap())


# ---------------------------------------------------------------------------
# Symbol font merging
# ---------------------------------------------------------------------------


def merge_symbols_into_font(base_font: TTFont, symbol_font_path: str) -> None:
    """Overlay a symbol font onto the base font, scaling by UPM ratio.

    Existing glyphs are overwritten when names collide.
    """
    symbol_font = TTFont(symbol_font_path)
    base_cmap = base_font.getBestCmap()
    symbol_cmap = symbol_font.getBestCmap()

    base_glyf = base_font["glyf"]
    symbol_glyf = symbol_font["glyf"]
    base_hmtx = base_font["hmtx"]
    symbol_hmtx = symbol_font["hmtx"]

    has_vmtx = "vmtx" in base_font and "vmtx" in symbol_font
    base_vmtx = base_font["vmtx"] if has_vmtx else None
    symbol_vmtx = symbol_font["vmtx"] if has_vmtx else None

    scale = base_font["head"].unitsPerEm / symbol_font["head"].unitsPerEm

    for codepoint, sym_glyph_name in symbol_cmap.items():
        for dep_name in get_glyph_dependencies(sym_glyph_name, symbol_glyf):
            # Copy and scale glyph outlines
            if dep_name in symbol_glyf:
                copied = copy.deepcopy(symbol_glyf[dep_name])
                if scale != 1.0:
                    GlyphTransformer.scale(copied, scale, scale)
                base_glyf[dep_name] = copied
                if dep_name not in base_font.glyphOrder:
                    base_font.glyphOrder.append(dep_name)

            # Copy and scale horizontal metrics
            if dep_name in symbol_hmtx.metrics:
                adv, lsb = symbol_hmtx.metrics[dep_name]
                if scale != 1.0:
                    adv, lsb = int(round(adv * scale)), int(round(lsb * scale))
                base_hmtx.metrics[dep_name] = (adv, lsb)

            # Copy and scale vertical metrics
            if base_vmtx and symbol_vmtx and dep_name in symbol_vmtx.metrics:
                v_adv, tsb = symbol_vmtx.metrics[dep_name]
                if scale != 1.0:
                    v_adv, tsb = int(round(v_adv * scale)), int(round(tsb * scale))
                base_vmtx.metrics[dep_name] = (v_adv, tsb)

        base_cmap[codepoint] = sym_glyph_name

    ensure_cmap_format_12(base_font, base_cmap)
    symbol_font.close()


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


def mark_font_as_monospace(font: TTFont, target_adv_e: int) -> None:
    """Flag the font as monospaced in OS/2, panose, and post tables."""
    os2 = font["OS/2"]
    os2.xAvgCharWidth = target_adv_e

    # Family types 2\u20134 use bProportion=9 for monospaced; type 5 uses 3.
    mono_proportion = {2: 9, 3: 9, 4: 9, 5: 3}
    if os2.panose.bFamilyType in mono_proportion:
        os2.panose.bProportion = mono_proportion[os2.panose.bFamilyType]

    font["post"].isFixedPitch = 1


# ---------------------------------------------------------------------------
# Baseline alignment
# ---------------------------------------------------------------------------


def compute_baseline_y_offset(
    eng_font: TTFont,
    cjk_font: TTFont,
    cjk_upm_scale: float,
) -> int:
    """Calculate the vertical shift needed to align the CJK baseline
    with the (already-scaled) English baseline."""
    eng_os2 = eng_font["OS/2"]
    cjk_os2 = cjk_font["OS/2"]
    eng_center = (eng_os2.sTypoAscender + eng_os2.sTypoDescender) / 2.0
    cjk_center = (cjk_os2.sTypoAscender + cjk_os2.sTypoDescender) / 2.0
    return int(round(eng_center - cjk_center * cjk_upm_scale))


# ---------------------------------------------------------------------------
# Main pipeline
# ---------------------------------------------------------------------------


def process_font(config: FontMergeConfig) -> None:
    """Execute the complete font merging pipeline:

    1. Load fonts and compute UPM scaling factors.
    2. Derive advance-width targets from the chosen strategy.
    3. Scale the English font glyphs and metrics.
    4. Copy and adjust CJK glyphs.
    5. Stretch / pad designated English-side glyphs.
    6. Overlay symbol fonts.
    7. Write metadata and save.
    """
    eng_font = TTFont(config.english_font_path)
    cjk_font = TTFont(config.cjk_font_path)

    # UPM normalisation
    eng_upm = eng_font["head"].unitsPerEm
    cjk_upm = cjk_font["head"].unitsPerEm
    upm = max(eng_upm, cjk_upm)
    eng_upm_scale = upm / float(eng_upm)
    cjk_upm_scale = upm / float(cjk_upm)

    # Measure representative advance widths
    eng_typical_adv = get_typical_advance(eng_font, ord("A"))
    cjk_typical_adv = get_typical_advance(cjk_font, ord("\u4e2d"))
    scaled_eng_adv = eng_typical_adv * eng_upm_scale
    scaled_cjk_adv = cjk_typical_adv * cjk_upm_scale

    # Compute strategy-dependent parameters
    params = compute_scale_params(
        strategy=config.scaling_strategy,
        eng_upm=eng_upm, cjk_upm=cjk_upm, upm=upm,
        eng_upm_scale=eng_upm_scale,
        scaled_eng_adv=scaled_eng_adv, scaled_cjk_adv=scaled_cjk_adv,
        eng_typical_adv=eng_typical_adv, cjk_typical_adv=cjk_typical_adv,
        weight_english=config.weight_english,
    )

    # Scale English font
    scale_font_glyphs(eng_font, params.eng_scale_x, params.eng_scale_y)
    scale_vertical_metrics(eng_font, params.eng_scale_y)
    eng_font["head"].unitsPerEm = upm

    # Baseline alignment
    y_offset = config.cjk_y_offset
    if config.adjust_baseline:
        y_offset += compute_baseline_y_offset(eng_font, cjk_font, cjk_upm_scale)

    # Merge CJK glyphs
    stretch_set = parse_codepoints(config.stretch_chars)
    alignment_map = build_alignment_map(config.pad_configs)

    merge_cjk_glyphs(
        base_font=eng_font,
        cjk_font=cjk_font,
        params=params,
        cjk_upm_scale=cjk_upm_scale,
        y_offset=y_offset,
        typical_scaled_cjk_adv=scaled_cjk_adv,
        strategy=config.scaling_strategy,
        stretch_set=stretch_set,
        alignment_map=alignment_map,
    )

    # Stretch / pad English-side glyphs that fall outside CJK ranges
    for codepoint in stretch_set:
        if codepoint not in CJK_CODEPOINT_SET:
            stretch_glyph_width(eng_font, codepoint, params.target_adv_c)

    for pad_cfg in config.pad_configs:
        for codepoint in parse_codepoints(pad_cfg.chars):
            if codepoint not in CJK_CODEPOINT_SET:
                pad_glyph_width(eng_font, codepoint, params.target_adv_c, pad_cfg.alignment)

    # Merge symbol fonts
    for symbol_path in config.symbol_font_paths:
        merge_symbols_into_font(eng_font, symbol_path)

    # Metadata & monospace flag
    update_font_metadata(eng_font, config)
    if config.mark_as_monospace:
        mark_font_as_monospace(eng_font, params.target_adv_e)

    # Save
    eng_font.save(config.output_filename)
    eng_font.close()
    cjk_font.close()


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------


def main() -> None:
    """Configure and run font merging tasks."""
    configs = [
        FontMergeConfig(
            output_filename="MyMergedFont-Regular.ttf",
            english_font_path="SourceCodePro-Regular.ttf",
            cjk_font_path="LXGWBrightCodeTC-Regular.ttf",
            scaling_strategy=ScaleStrategy.OPTIMAL_SCALE_BOTH,
            stretch_chars=["\u2014", "\u2026"],
            pad_configs=[
                PadConfig(chars=["\u2018", "\u201C"], alignment=Alignment.RIGHT),
                PadConfig(chars=["\u2019", "\u201D"], alignment=Alignment.LEFT),
                PadConfig(chars=["\uff0e"], alignment=Alignment.CENTER),
            ],
            weight_english=0.5,
            symbol_font_paths=[
                "SymbolsNerdFontMono-Regular.ttf",
                "FlogSymbols.ttf",
            ],
            adjust_baseline=True,
            cjk_y_offset=0,
            new_font_family="My Merged Code",
            new_font_subfamily="Regular",
            new_author="Automated Script",
            new_description="A programmer font with optimized CJK spacing.",
            mark_as_monospace=True,
        ),
    ]

    for config in configs:
        print(f"Processing: {config.output_filename} ...")
        try:
            process_font(config)
            print(f"Successfully saved {config.output_filename}")
        except FileNotFoundError as err:
            print(f"Error: {err}")


if __name__ == "__main__":
    main()
