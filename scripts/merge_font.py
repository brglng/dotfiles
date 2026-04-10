#!/usr/bin/env python3
import copy
from dataclasses import dataclass
from enum import Enum
import math
from typing import Any

from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._c_m_a_p import cmap_format_12
from fontTools.ttLib.tables._g_l_y_f import GlyphCoordinates


class Alignment(Enum):
    """
    Defines the horizontal alignment when padding glyphs with whitespace.
    """
    LEFT = "left"
    CENTER = "center"
    RIGHT = "right"


class ScaleStrategy(Enum):
    """
    Defines the scaling strategies for merging English and CJK fonts.
    """
    ENGLISH_KEEP_CJK_SCALE_GAP = "english_keep_cjk_scale_gap"
    ENGLISH_SCALE_GAP_CJK_KEEP = "english_scale_gap_cjk_keep"
    ENGLISH_STRETCH_CJK_KEEP = "english_stretch_cjk_keep"
    OPTIMAL_SCALE_BOTH = "optimal_scale_both"
    NO_STRETCH = "no_stretch"


@dataclass
class PadConfig:
    """
    Configuration for padding specific characters with whitespace.

    Attributes
    ----------
    chars : list[str | int | tuple[int, int]]
        A list of characters, codepoints, or ranges to pad.
    alignment : Alignment
        The alignment strategy for the padding.
    """
    chars: list[str | int | tuple[int, int]]
    alignment: Alignment


@dataclass
class FontMergeConfig:
    """
    Configuration for a single font merging process.

    Attributes
    ----------
    output_filename : str
        The path for the output font file.
    english_font_path : str
        The path to the base English font.
    cjk_font_path : str
        The path to the CJK font.
    scaling_strategy : ScaleStrategy
        The strategy used to scale the fonts.
    stretch_chars : list[str | int | tuple[int, int]]
        Characters to stretch to double width.
    pad_configs : list[PadConfig]
        Configurations for characters that need double width padding.
    weight_english : float
        The weight for English font optimal scaling.
    symbol_font_paths : list[str]
        Paths to symbol fonts to merge.
    adjust_baseline : bool
        Whether to adjust the baseline of the CJK font.
    cjk_y_offset : int
        The manual vertical offset for CJK glyphs.
    new_font_family : str
        The new font family name.
    new_font_subfamily : str
        The new font subfamily name.
    new_author : str
        The author name for the metadata.
    new_description : str
        The description for the metadata.
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


def calculate_optimal_rho(english_ratio: float, cjk_ratio: float, weight_english: float) -> float:
    """
    Calculate the optimal English advance width to height ratio.

    Parameters
    ----------
    english_ratio : float
        The width to height ratio of the English font.
    cjk_ratio : float
        The width to height ratio of the CJK font.
    weight_english : float
        The weight assigned to the English font scaling.

    Returns
    -------
    float
        The optimal advance width to height ratio.
    """
    weight_cjk = 1.0 - weight_english
    ln_rho = (weight_english * math.log(english_ratio) +
              weight_cjk * math.log(cjk_ratio / 2.0))
    return math.exp(ln_rho)


def ensure_cmap_format_12(font: TTFont, cmap_mapping: dict[int, str]) -> None:
    """
    Ensure the font has a Format 12 cmap table if there are characters outside the BMP.

    Parameters
    ----------
    font : TTFont
        The font object to check and update.
    cmap_mapping : dict[int, str]
        The complete cmap mapping to apply.
    """
    has_format_12 = False
    for table in font["cmap"].tables:
        if table.format == 12:
            has_format_12 = True
            break

    if not has_format_12:
        needs_format_12 = False
        for codepoint in cmap_mapping.keys():
            if codepoint > 0xFFFF:
                needs_format_12 = True
                break

        if needs_format_12:
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


def get_cjk_unicodes() -> list[int]:
    """
    Returns a list of Unicode codepoints for CJK characters and related punctuation.

    Returns
    -------
    list[int]
        A list of integers representing the Unicode codepoints.
    """
    ranges = [
        (0x2000, 0x206F),  # General Punctuation (quotes, dashes, ellipses, formatting spaces)
        (0x2E80, 0x2EFF),  # CJK Radicals Supplement (radicals often used as standalone characters in dictionaries)
        (0x3000, 0x303F),  # CJK Symbols and Punctuation (ideographic comma, period, corner brackets, etc.)
        (0x3200, 0x32FF),  # Enclosed CJK Letters and Months (parenthesized or circled characters, ideographs, and numbers)
        (0x3400, 0x4DBF),  # CJK Unified Ideographs Extension A (Rare and historical Hanzi/Kanji/Hanja characters)
        (0x4E00, 0x9FFF),  # CJK Unified Ideographs (The core block for common Chinese, Japanese, and Korean characters)
        (0xFE30, 0xFE4F),  # CJK Compatibility Forms (Vertical punctuation variants for traditional top-to-bottom writing)
        (0xFF00, 0xFFEF),  # Halfwidth and Fullwidth Forms (Fullwidth Latin letters, numbers, and punctuation for CJK alignment)
    ]

    unicodes = []
    for start, end in ranges:
        unicodes.extend(range(start, end + 1))

    return unicodes


def get_codepoints(chars: list[str | int | tuple[int, int]]) -> set[int]:
    """
    Parses a list of characters, codepoints, or ranges into a set of codepoints.

    Parameters
    ----------
    chars : list[str | int | tuple[int, int]]
        A list containing single characters, integer codepoints, or tuples of start/end codepoints.

    Returns
    -------
    set[int]
        A set of integer codepoints.
    """
    codepoints = set()
    for item in chars:
        if isinstance(item, str):
            if len(item) == 1:
                codepoints.add(ord(item))
        elif isinstance(item, int):
            codepoints.add(item)
        elif isinstance(item, tuple) and len(item) == 2:
            start, end = item
            codepoints.update(range(start, end + 1))
    return codepoints


def get_glyph_dependencies(glyph_name: str, glyf_table: dict) -> set[str]:
    """
    Recursively finds all component glyphs required by a composite glyph.

    Parameters
    ----------
    glyph_name : str
        The name of the glyph to analyze.
    glyf_table : dict
        The font's glyph table mapping names to glyph objects.

    Returns
    -------
    set[str]
        A set of glyph names that the target glyph depends on.
    """
    dependencies = {glyph_name}

    if glyph_name not in glyf_table:
        return dependencies

    glyph = glyf_table[glyph_name]
    if glyph.isComposite():
        for component in glyph.components:
            dependencies.update(get_glyph_dependencies(component.glyphName, glyf_table))

    return dependencies


def get_typical_advance(font: TTFont, char_code: int) -> int:
    """
    Gets the advance width of a typical character for basis calculations.

    Parameters
    ----------
    font : TTFont
        The font object to extract metrics from.
    char_code : int
        The Unicode codepoint of the character.

    Returns
    -------
    int
        The advance width of the specified character.
    """
    cmap = font.getBestCmap()
    if char_code in cmap:
        glyph_name = cmap[char_code]
        return font["hmtx"].metrics[glyph_name][0]
    return font["head"].unitsPerEm // 2


def scale_font_glyphs(font: TTFont, scale_x: float, scale_y: float):
    """
    Scales all glyphs in the given font by the specified X and Y factors.
    Also handles vertical metrics alignment for non-uniform scaling.

    Parameters
    ----------
    font : TTFont
        The font to apply scaling to.
    scale_x : float
        The horizontal scaling factor.
    scale_y : float
        The vertical scaling factor.
    """
    if scale_x == 1.0 and scale_y == 1.0:
        return

    glyf = font["glyf"]
    hmtx = font["hmtx"]
    has_vmtx = "vmtx" in font
    
    if has_vmtx:
        vmtx = font["vmtx"]

    for glyph_name, glyph in glyf.items():
        if glyph.isComposite():
            for comp in glyph.components:
                if hasattr(comp, "x") and comp.x is not None:
                    comp.x = int(round(comp.x * scale_x))
                if hasattr(comp, "y") and comp.y is not None:
                    comp.y = int(round(comp.y * scale_y))
                if hasattr(comp, "transform"):
                    try:
                        (xx, xy), (yx, yy) = comp.transform
                        comp.transform = ((xx * scale_x, xy * scale_x), (yx * scale_y, yy * scale_y))
                    except ValueError:
                        pass
        else:
            if hasattr(glyph, "coordinates"):
                coords = []
                for x, y in glyph.coordinates:
                    coords.append((int(round(x * scale_x)), int(round(y * scale_y))))
                glyph.coordinates = GlyphCoordinates(coords)

        if glyph_name in hmtx.metrics:
            adv, lsb = hmtx.metrics[glyph_name]
            hmtx.metrics[glyph_name] = (int(round(adv * scale_x)), int(round(lsb * scale_x)))

        if has_vmtx and glyph_name in vmtx.metrics:
            v_adv, tsb = vmtx.metrics[glyph_name]
            vmtx.metrics[glyph_name] = (int(round(v_adv * scale_y)), int(round(tsb * scale_y)))


def shift_glyph_and_metrics(base_glyf: dict, base_hmtx: Any, glyph_name: str, shift_x: int, target_advance: int):
    """
    Shifts the glyph horizontally and updates its metrics.

    Parameters
    ----------
    base_glyf : dict
        The base glyph table.
    base_hmtx : dict
        The horizontal metrics table.
    glyph_name : str
        The name of the glyph to shift.
    shift_x : int
        The horizontal shift distance.
    target_advance : int
        The new advance width for the metric table.
    """
    glyph = base_glyf[glyph_name]
    if shift_x != 0:
        if glyph.isComposite():
            for comp in glyph.components:
                if hasattr(comp, "x") and comp.x is not None:
                    comp.x += shift_x
        else:
            if hasattr(glyph, "coordinates"):
                coords = []
                for x, y in glyph.coordinates:
                    coords.append((x + shift_x, y))
                glyph.coordinates = GlyphCoordinates(coords)

    _, current_lsb = base_hmtx.metrics[glyph_name]
    base_hmtx.metrics[glyph_name] = (target_advance, current_lsb + shift_x)


def merge_cjk_glyphs(
    base_font: TTFont,
    cjk_font: TTFont,
    target_adv_c: int,
    target_adv_e: int,
    cjk_upm_scale: float,
    y_offset: int,
    typical_scaled_cjk_adv: float,
    strategy: ScaleStrategy,
    stretch_set: set[int],
    alignment_map: dict[int, Alignment]
):
    """
    Copies CJK glyphs from the CJK font to the base font, applying
    scaling, Y-offset, and centering them within the designated advance width.

    Parameters
    ----------
    base_font : TTFont
        The base English font to merge into.
    cjk_font : TTFont
        The CJK font to merge from.
    target_adv_c : int
        The target advance width for fullwidth characters.
    target_adv_e : int
        The target advance width for halfwidth characters.
    upm_scale : float
        The scaling factor based on the difference in units per em.
    y_offset : int
        The vertical offset to align baselines.
    typical_scaled_cjk_adv : float
        The advance width of a standard scaled CJK character.
    strategy : ScaleStrategy
        The scaling strategy configured by the user.
    stretch_set : set[int]
        Codepoints that require horizontal stretching.
    alignment_map : dict[int, Alignment]
        Alignment configurations for specific codepoints.
    """
    base_cmap = base_font.getBestCmap()
    cjk_cmap = cjk_font.getBestCmap()
    cjk_unicodes = get_cjk_unicodes()

    base_glyf = base_font["glyf"]
    cjk_glyf = cjk_font["glyf"]
    base_hmtx = base_font["hmtx"]
    cjk_hmtx = cjk_font["hmtx"]

    has_vmtx = "vmtx" in base_font and "vmtx" in cjk_font
    if has_vmtx:
        base_vmtx = base_font["vmtx"]
        cjk_vmtx = cjk_font["vmtx"]

    for codepoint in cjk_unicodes:
        if codepoint in cjk_cmap:
            cjk_glyph_name = cjk_cmap[codepoint]
            dependencies = get_glyph_dependencies(cjk_glyph_name, cjk_glyf)

            for dep_name in dependencies:
                new_dep_name = f"cjk_{dep_name}"

                if new_dep_name not in base_glyf:
                    if dep_name in cjk_glyf:
                        copied_glyph = copy.deepcopy(cjk_glyf[dep_name])

                        if copied_glyph.isComposite():
                            for comp in copied_glyph.components:
                                if hasattr(comp, "x") and comp.x is not None:
                                    comp.x = int(round(comp.x * cjk_upm_scale))
                                if hasattr(comp, "y") and comp.y is not None:
                                    comp.y = int(round(comp.y * cjk_upm_scale))
                                    if dep_name == cjk_glyph_name:
                                        comp.y += y_offset
                        else:
                            if hasattr(copied_glyph, "coordinates"):
                                coords = []
                                for x, y in copied_glyph.coordinates:
                                    y_val = int(round(y * cjk_upm_scale))
                                    if dep_name == cjk_glyph_name:
                                        y_val += y_offset
                                    coords.append((
                                        int(round(x * cjk_upm_scale)),
                                        y_val
                                    ))
                                copied_glyph.coordinates = GlyphCoordinates(coords)

                        base_glyf[new_dep_name] = copied_glyph
                        if new_dep_name not in base_font.glyphOrder:
                            base_font.glyphOrder.append(new_dep_name)

                    if dep_name in cjk_hmtx.metrics:
                        adv, lsb = cjk_hmtx.metrics[dep_name]
                        base_hmtx.metrics[new_dep_name] = (
                            int(round(adv * cjk_upm_scale)),
                            int(round(lsb * cjk_upm_scale))
                        )

                    if has_vmtx and dep_name in cjk_vmtx.metrics:
                        v_adv, tsb = cjk_vmtx.metrics[dep_name]
                        scaled_tsb = int(round(tsb * cjk_upm_scale))
                        if dep_name == cjk_glyph_name:
                            scaled_tsb -= y_offset
                        base_vmtx.metrics[new_dep_name] = (
                            int(round(v_adv * cjk_upm_scale)),
                            scaled_tsb
                        )

            base_cmap[codepoint] = f"cjk_{cjk_glyph_name}"

    processed_set = set()

    for codepoint, cjk_glyph_name in cjk_cmap.items():
        if codepoint in cjk_unicodes:
            new_glyph_name = f"cjk_{cjk_glyph_name}"
            
            if new_glyph_name in base_glyf and new_glyph_name not in processed_set:
                processed_set.add(new_glyph_name)

                original_adv = cjk_hmtx.metrics[cjk_glyph_name][0]
                scaled_adv = int(round(original_adv * cjk_upm_scale))

                if strategy == ScaleStrategy.NO_STRETCH:
                    final_target_adv = scaled_adv
                else:
                    if scaled_adv > typical_scaled_cjk_adv * 0.75:
                        final_target_adv = target_adv_c
                    else:
                        final_target_adv = target_adv_e

                if codepoint in stretch_set and scaled_adv > 0:
                    scale_factor = final_target_adv / float(scaled_adv)
                    glyph = base_glyf[new_glyph_name]
                    
                    if scale_factor != 1.0:
                        if glyph.isComposite():
                            for comp in glyph.components:
                                if hasattr(comp, "x") and comp.x is not None:
                                    comp.x = int(round(comp.x * scale_factor))
                                if hasattr(comp, "transform"):
                                    try:
                                        (xx, xy), (yx, yy) = comp.transform
                                        comp.transform = ((xx * scale_factor, xy * scale_factor), (yx, yy))
                                    except ValueError:
                                        pass
                        else:
                            if hasattr(glyph, "coordinates"):
                                coords = []
                                for x, y in glyph.coordinates:
                                    coords.append((int(round(x * scale_factor)), y))
                                glyph.coordinates = GlyphCoordinates(coords)
                                
                    _, current_lsb = base_hmtx.metrics[new_glyph_name]
                    base_hmtx.metrics[new_glyph_name] = (
                        final_target_adv,
                        int(round(current_lsb * scale_factor))
                    )
                else:
                    alignment = alignment_map.get(codepoint, Alignment.CENTER)
                    
                    if alignment == Alignment.LEFT:
                        shift_x = 0
                    elif alignment == Alignment.CENTER:
                        shift_x = (final_target_adv - scaled_adv) // 2
                    elif alignment == Alignment.RIGHT:
                        shift_x = final_target_adv - scaled_adv
                    else:
                        shift_x = 0

                    shift_glyph_and_metrics(
                        base_glyf,
                        base_hmtx,
                        new_glyph_name,
                        shift_x,
                        final_target_adv
                    )

    ensure_cmap_format_12(base_font, base_cmap)


def pad_glyph_width(font: TTFont, codepoint: int, target_advance: int, alignment: Alignment):
    """
    Increases the advance width of a glyph by padding it with whitespace based on alignment.

    Parameters
    ----------
    font : TTFont
        The font object containing the glyph.
    codepoint : int
        The Unicode codepoint of the glyph to be padded.
    target_advance : int
        The target advance width to reach.
    alignment : Alignment
        The horizontal alignment.
    """
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

    diff = target_advance - adv

    if alignment == Alignment.LEFT:
        shift_x = 0
    elif alignment == Alignment.CENTER:
        shift_x = diff // 2
    elif alignment == Alignment.RIGHT:
        shift_x = diff
    else:
        shift_x = 0

    if shift_x > 0:
        glyph = glyf[glyph_name]

        if glyph.isComposite():
            for comp in glyph.components:
                if hasattr(comp, "x") and comp.x is not None:
                    comp.x += shift_x
        else:
            if hasattr(glyph, "coordinates"):
                coords = []
                for x, y in glyph.coordinates:
                    coords.append((x + shift_x, y))
                glyph.coordinates = GlyphCoordinates(coords)

    hmtx.metrics[glyph_name] = (target_advance, current_lsb + shift_x)


def stretch_glyph_width(font: TTFont, codepoint: int, target_advance: int):
    """
    Stretches a specific glyph's geometry horizontally to match a new advance width.

    Parameters
    ----------
    font : TTFont
        The font object containing the glyph.
    codepoint : int
        The Unicode codepoint of the glyph to be stretched.
    target_advance : int
        The target advance width to reach.
    """
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
    glyph = glyf[glyph_name]

    if glyph.isComposite():
        for comp in glyph.components:
            if hasattr(comp, "x") and comp.x is not None:
                comp.x = int(round(comp.x * scale_factor))
            if hasattr(comp, "transform"):
                try:
                    (xx, xy), (yx, yy) = comp.transform
                    comp.transform = ((xx * scale_factor, xy), (yx * scale_factor, yy))
                except ValueError:
                    pass
    else:
        if hasattr(glyph, "coordinates"):
            coords = []
            for x, y in glyph.coordinates:
                coords.append((int(round(x * scale_factor)), y))
            glyph.coordinates = GlyphCoordinates(coords)

    hmtx.metrics[glyph_name] = (target_advance, int(round(lsb * scale_factor)))


def merge_symbols_into_font(base_font: TTFont, symbol_font_path: str):
    """
    Merges a symbol font into the base font, scaling it based on UPM ratios.
    Directly overwrites glyphs and metrics if conflicts occur.

    Parameters
    ----------
    base_font : TTFont
        The font object into which symbols will be merged.
    symbol_font_path : str
        The file path to the symbol font.
    """
    symbol_font = TTFont(symbol_font_path)
    base_cmap = base_font.getBestCmap()
    symbol_cmap = symbol_font.getBestCmap()

    base_glyf = base_font["glyf"]
    symbol_glyf = symbol_font["glyf"]
    base_hmtx = base_font["hmtx"]
    symbol_hmtx = symbol_font["hmtx"]

    has_vmtx = "vmtx" in base_font and "vmtx" in symbol_font
    if has_vmtx:
        base_vmtx = base_font["vmtx"]
        symbol_vmtx = symbol_font["vmtx"]

    base_upem = base_font["head"].unitsPerEm
    symbol_upem = symbol_font["head"].unitsPerEm
    scale = base_upem / symbol_upem

    for codepoint, sym_glyph_name in symbol_cmap.items():
        dependencies = get_glyph_dependencies(sym_glyph_name, symbol_glyf)

        for dep_name in dependencies:
            if dep_name in symbol_glyf:
                copied_glyph = copy.deepcopy(symbol_glyf[dep_name])

                if copied_glyph.isComposite():
                    for comp in copied_glyph.components:
                        if scale != 1.0:
                            if hasattr(comp, "x") and comp.x is not None:
                                comp.x = int(round(comp.x * scale))
                            if hasattr(comp, "y") and comp.y is not None:
                                comp.y = int(round(comp.y * scale))
                            if hasattr(comp, "transform"):
                                try:
                                    (xx, xy), (yx, yy) = comp.transform
                                    comp.transform = ((xx * scale, xy * scale), (yx * scale, yy * scale))
                                except ValueError:
                                    pass
                else:
                    if scale != 1.0 and hasattr(copied_glyph, "coordinates"):
                        coords = []
                        for x, y in copied_glyph.coordinates:
                            coords.append((int(round(x * scale)), int(round(y * scale))))
                        copied_glyph.coordinates = GlyphCoordinates(coords)

                base_glyf[dep_name] = copied_glyph
                if dep_name not in base_font.glyphOrder:
                    base_font.glyphOrder.append(dep_name)

            if dep_name in symbol_hmtx.metrics:
                adv, lsb = symbol_hmtx.metrics[dep_name]
                if scale != 1.0:
                    adv = int(round(adv * scale))
                    lsb = int(round(lsb * scale))
                base_hmtx.metrics[dep_name] = (adv, lsb)

            if has_vmtx and dep_name in symbol_vmtx.metrics:
                v_adv, tsb = symbol_vmtx.metrics[dep_name]
                if scale != 1.0:
                    v_adv = int(round(v_adv * scale))
                    tsb = int(round(tsb * scale))
                base_vmtx.metrics[dep_name] = (v_adv, tsb)

        base_cmap[codepoint] = sym_glyph_name

    ensure_cmap_format_12(base_font, base_cmap)
    symbol_font.close()


def update_font_metadata(font: TTFont, config: FontMergeConfig):
    """
    Updates the naming and metadata tables for the merged font.

    Parameters
    ----------
    font : TTFont
        The font object to update metadata for.
    config : FontMergeConfig
        The configuration containing the metadata fields.
    """
    name_table = font["name"]
    full_name = f"{config.new_font_family} {config.new_font_subfamily}"
    ps_name = f"{config.new_font_family.replace(' ', '')}-{config.new_font_subfamily.replace(' ', '')}"

    for record in name_table.names:
        text = record.toStr()
        new_text = text

        if record.nameID in (1, 16):
            new_text = config.new_font_family
        elif record.nameID in (2, 17):
            new_text = config.new_font_subfamily
        elif record.nameID == 3:
            new_text = f"Merged:{full_name}"
        elif record.nameID == 4:
            new_text = full_name
        elif record.nameID == 6:
            new_text = ps_name
        elif record.nameID in (8, 9):
            new_text = config.new_author
        elif record.nameID == 10:
            new_text = config.new_description

        if new_text != text:
            record.string = new_text.encode(record.getEncoding())


def scale_vertical_metrics(font: TTFont, scale: float):
    """
    Scales the vertical metrics tables (head, OS/2, hhea) by the given factor.

    Parameters
    ----------
    font : TTFont
        The font object to update.
    scale : float
        The scaling factor.
    """
    if scale == 1.0:
        return

    os2 = font["OS/2"]
    os2.sTypoAscender = int(round(os2.sTypoAscender * scale))
    os2.sTypoDescender = int(round(os2.sTypoDescender * scale))
    os2.sTypoLineGap = int(round(os2.sTypoLineGap * scale))
    os2.usWinAscent = int(round(os2.usWinAscent * scale))
    os2.usWinDescent = int(round(os2.usWinDescent * scale))
    os2.sxHeight = int(round(os2.sxHeight * scale))
    os2.sCapHeight = int(round(os2.sCapHeight * scale))
    os2.ySubscriptXSize = int(round(os2.ySubscriptXSize * scale))
    os2.ySubscriptYSize = int(round(os2.ySubscriptYSize * scale))
    os2.ySubscriptXOffset = int(round(os2.ySubscriptXOffset * scale))
    os2.ySubscriptYOffset = int(round(os2.ySubscriptYOffset * scale))
    os2.ySuperscriptXSize = int(round(os2.ySuperscriptXSize * scale))
    os2.ySuperscriptYSize = int(round(os2.ySuperscriptYSize * scale))
    os2.ySuperscriptXOffset = int(round(os2.ySuperscriptXOffset * scale))
    os2.ySuperscriptYOffset = int(round(os2.ySuperscriptYOffset * scale))
    os2.yStrikeoutSize = int(round(os2.yStrikeoutSize * scale))
    os2.yStrikeoutPosition = int(round(os2.yStrikeoutPosition * scale))

    hhea = font["hhea"]
    hhea.ascent = int(round(hhea.ascent * scale))
    hhea.descent = int(round(hhea.descent * scale))
    hhea.lineGap = int(round(hhea.lineGap * scale))
    hhea.caretSlopeRise = int(round(hhea.caretSlopeRise * scale))
    hhea.caretOffset = int(round(hhea.caretOffset * scale))

    if "vhea" in font:
        vhea = font["vhea"]
        vhea.ascent = int(round(vhea.ascent * scale))
        vhea.descent = int(round(vhea.descent * scale))
        vhea.lineGap = int(round(vhea.lineGap * scale))


def process_font(config: FontMergeConfig):
    """
    Executes the complete font merging process based on the given configuration.

    Parameters
    ----------
    config : FontMergeConfig
        The configuration for the processing steps.
    """
    eng_font = TTFont(config.english_font_path)
    cjk_font = TTFont(config.cjk_font_path)

    eng_upm = eng_font["head"].unitsPerEm
    cjk_upm = cjk_font["head"].unitsPerEm
    upm = max(eng_upm, cjk_upm)
    eng_upm_scale = upm / float(eng_upm)
    cjk_upm_scale = upm / float(cjk_upm)

    eng_typical_adv = get_typical_advance(eng_font, ord('A'))
    cjk_typical_adv = get_typical_advance(cjk_font, ord('中'))
    scaled_eng_adv = eng_typical_adv * eng_upm_scale
    scaled_cjk_adv = cjk_typical_adv * cjk_upm_scale

    if config.scaling_strategy == ScaleStrategy.ENGLISH_KEEP_CJK_SCALE_GAP:
        target_adv_e = int(round(scaled_eng_adv))
        eng_scale_x = eng_upm_scale
        eng_scale_y = eng_upm_scale
        target_adv_c = target_adv_e * 2

    elif config.scaling_strategy == ScaleStrategy.ENGLISH_SCALE_GAP_CJK_KEEP:
        target_adv_e = int(round(scaled_cjk_adv / 2.0))
        ratio = target_adv_e / float(eng_typical_adv)
        eng_scale_x = ratio
        eng_scale_y = ratio
        target_adv_c = target_adv_e * 2

    elif config.scaling_strategy == ScaleStrategy.ENGLISH_STRETCH_CJK_KEEP:
        target_adv_e = int(round(scaled_cjk_adv / 2.0))
        eng_scale_x = target_adv_e / float(eng_typical_adv)
        eng_scale_y = eng_upm_scale
        target_adv_c = target_adv_e * 2

    elif config.scaling_strategy == ScaleStrategy.OPTIMAL_SCALE_BOTH:
        eng_ratio = eng_typical_adv / float(eng_upm)
        cjk_ratio = cjk_typical_adv / float(cjk_upm)
        optimal_rho = calculate_optimal_rho(eng_ratio, cjk_ratio, config.weight_english)

        target_adv_e = int(round(upm * optimal_rho))
        eng_scale_x = target_adv_e / float(eng_typical_adv)
        eng_scale_y = eng_upm_scale
        target_adv_c = target_adv_e * 2

    elif config.scaling_strategy == ScaleStrategy.NO_STRETCH:
        target_adv_e = int(round(scaled_eng_adv))
        target_adv_c = int(round(scaled_cjk_adv))
        eng_scale_x = eng_upm_scale
        eng_scale_y = eng_upm_scale

    scale_font_glyphs(eng_font, eng_scale_x, eng_scale_y)
    scale_vertical_metrics(eng_font, eng_scale_y)

    eng_font["head"].unitsPerEm = upm

    y_offset = config.cjk_y_offset
    if config.adjust_baseline:
        # Use CJK font's original metrics and the upm scales (before glyph scaling was applied)
        # English font's OS/2 has already been scaled by eng_scale_y above
        eng_os2 = eng_font["OS/2"]
        cjk_os2 = cjk_font["OS/2"]
        eng_center = (eng_os2.sTypoAscender + eng_os2.sTypoDescender) / 2.0
        cjk_center = (cjk_os2.sTypoAscender + cjk_os2.sTypoDescender) / 2.0
        scaled_cjk_center = cjk_center * cjk_upm_scale
        y_offset += int(round(eng_center - scaled_cjk_center))

    stretch_set = get_codepoints(config.stretch_chars)
    alignment_map: dict[int, Alignment] = {}
    for pad_config in config.pad_configs:
        for cp in get_codepoints(pad_config.chars):
            alignment_map[cp] = pad_config.alignment

    merge_cjk_glyphs(
        eng_font,
        cjk_font,
        target_adv_c,
        target_adv_e,
        cjk_upm_scale,
        y_offset,
        scaled_cjk_adv,
        config.scaling_strategy,
        stretch_set,
        alignment_map
    )

    cjk_codepoint_set = set(get_cjk_unicodes())
    for codepoint in stretch_set:
        if codepoint not in cjk_codepoint_set:
            stretch_glyph_width(eng_font, codepoint, target_adv_c)

    for pad_config in config.pad_configs:
        pad_codepoints = get_codepoints(pad_config.chars)
        for codepoint in pad_codepoints:
            if codepoint not in cjk_codepoint_set:
                pad_glyph_width(eng_font, codepoint, target_adv_c, pad_config.alignment)

    for symbol_font_path in config.symbol_font_paths:
        merge_symbols_into_font(eng_font, symbol_font_path)

    update_font_metadata(eng_font, config)
    eng_font.save(config.output_filename)

    eng_font.close()
    cjk_font.close()


def main():
    """
    Main entry point for configuring and processing font merging tasks.
    """
    configs = [
        FontMergeConfig(
            output_filename="MyMergedFont-Regular.ttf",
            english_font_path="SourceCodePro-Regular.ttf",
            cjk_font_path="LXGWBrightCodeTC-Regular.ttf",
            scaling_strategy=ScaleStrategy.OPTIMAL_SCALE_BOTH,
            stretch_chars=["—", "…"],
            pad_configs=[
                PadConfig(
                    chars=["‘", "“"],
                    alignment=Alignment.RIGHT
                ),
                PadConfig(
                    chars=["’", "”"],
                    alignment=Alignment.LEFT
                ),
                PadConfig(
                    chars=["．"],
                    alignment=Alignment.CENTER
                )
            ],
            weight_english=0.5,
            symbol_font_paths=["SymbolsNerdFontMono-Regular.ttf", "FlogSymbols.ttf"],
            adjust_baseline=True,
            cjk_y_offset=0,
            new_font_family="My Merged Code",
            new_font_subfamily="Regular",
            new_author="Automated Script",
            new_description="A programmer font with optimized CJK spacing."
        ),
    ]

    for config in configs:
        print(f"Processing: {config.output_filename} ...")
        try:
            process_font(config)
            print(f"Successfully saved {config.output_filename}")
        except FileNotFoundError as error_msg:
            print(f"Error: {error_msg}")


if __name__ == "__main__":
    main()
