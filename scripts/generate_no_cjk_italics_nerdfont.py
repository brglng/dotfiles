#!/usr/bin/env python3
import copy

from fontTools.ttLib import TTFont


def get_cjk_unicodes() -> list[int]:
    """
    Returns a list of Unicode codepoints for CJK characters and related punctuation.

    This includes ideographs, fullwidth forms, general punctuation, and
    enclosed CJK letters/months (like parenthesized Chinese numerals).

    Returns
    -------
    list[int]
        A list of integers representing the Unicode codepoints.
    """
    ranges = [
        (0x2000, 0x206F),
        (0x2E80, 0x2EFF),
        (0x3000, 0x303F),
        (0x3200, 0x32FF),
        (0x3400, 0x4DBF),
        (0x4E00, 0x9FFF),
        (0xFE30, 0xFE4F),
        (0xFF00, 0xFFEF),
    ]

    unicodes = []
    for start, end in ranges:
        unicodes.extend(range(start, end + 1))

    return unicodes


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


def rename_font(font: TTFont, suffix: str) -> None:
    """
    Appends a suffix to the internal font name records.

    Parameters
    ----------
    font : TTFont
        The font object to be modified.
    suffix : str
        The suffix to append to the font names (e.g., "NF").
    """
    name_table = font["name"]
    target_ids = {1, 3, 4, 6, 16}

    for record in name_table.names:
        if record.nameID in target_ids:
            text = record.toStr()
            if suffix not in text:
                if record.nameID == 6:
                    text = f"{text}-{suffix}"
                else:
                    text = f"{text} {suffix}"

                record.string = text.encode(record.getEncoding())


def merge_symbols_into_font(base_font: TTFont, symbol_font_path: str) -> None:
    """
    Copies all mapped glyphs from a symbol font into the base font.

    Renames imported glyphs to prevent naming collisions and overwrites
    the character mapping carefully to prevent overflow issues.

    Parameters
    ----------
    base_font : TTFont
        The target font object to merge symbols into.
    symbol_font_path : str
        The file path to the symbol font to be merged.
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

    # prefix = f"{symbol_font_path.split('.')[0]}_"
    prefix = ""

    for codepoint, sym_glyph_name in symbol_cmap.items():
        dependencies = get_glyph_dependencies(sym_glyph_name, symbol_glyf)

        for dep_name in dependencies:
            new_dep_name = f"{prefix}{dep_name}"

            if new_dep_name not in base_glyf:
                if dep_name in symbol_glyf:
                    copied_glyph = copy.deepcopy(symbol_glyf[dep_name])

                    if copied_glyph.isComposite():
                        for comp in copied_glyph.components:
                            comp.glyphName = f"{prefix}{comp.glyphName}"

                    base_glyf[new_dep_name] = copied_glyph

                if dep_name in symbol_hmtx.metrics:
                    base_hmtx.metrics[new_dep_name] = copy.deepcopy(symbol_hmtx.metrics[dep_name])

                if has_vmtx and dep_name in symbol_vmtx.metrics:
                    base_vmtx.metrics[new_dep_name] = copy.deepcopy(symbol_vmtx.metrics[dep_name])

        base_cmap[codepoint] = f"{prefix}{sym_glyph_name}"

    for table in base_font["cmap"].tables:
        if table.isUnicode():
            if table.format == 4:
                for codepoint, name in base_cmap.items():
                    if codepoint <= 0xFFFF:
                        table.cmap[codepoint] = name
            else:
                table.cmap.update(base_cmap)

    symbol_font.close()


def replace_cjk_glyphs(upright_font: TTFont, italic_font: TTFont) -> None:
    """
    Copies CJK glyph outlines and metrics from the upright font to the italic font.

    Parameters
    ----------
    upright_font : TTFont
        The upright base font containing the desired CJK glyphs.
    italic_font : TTFont
        The italic font to be modified.
    """
    upright_cmap = upright_font.getBestCmap()
    italic_cmap = italic_font.getBestCmap()

    cjk_unicodes = get_cjk_unicodes()

    upright_glyf = upright_font["glyf"]
    italic_glyf = italic_font["glyf"]
    upright_hmtx = upright_font["hmtx"]
    italic_hmtx = italic_font["hmtx"]

    has_vmtx = "vmtx" in upright_font and "vmtx" in italic_font
    if has_vmtx:
        upright_vmtx = upright_font["vmtx"]
        italic_vmtx = italic_font["vmtx"]

    for codepoint in cjk_unicodes:
        if codepoint in upright_cmap and codepoint in italic_cmap:
            upright_glyph_name = upright_cmap[codepoint]
            italic_glyph_name = italic_cmap[codepoint]

            if upright_glyph_name in upright_glyf and italic_glyph_name in italic_glyf:
                italic_glyf[italic_glyph_name] = copy.deepcopy(upright_glyf[upright_glyph_name])

            if upright_glyph_name in upright_hmtx.metrics and italic_glyph_name in italic_hmtx.metrics:
                italic_hmtx.metrics[italic_glyph_name] = copy.deepcopy(upright_hmtx.metrics[upright_glyph_name])

            if has_vmtx:
                if upright_glyph_name in upright_vmtx.metrics and italic_glyph_name in italic_vmtx.metrics:
                    italic_vmtx.metrics[italic_glyph_name] = copy.deepcopy(upright_vmtx.metrics[upright_glyph_name])


def process_font_family(upright_path: str, italic_path: str, symbol_paths: list[str], upright_out: str, italic_out: str) -> None:
    """
    Processes a pair of upright and italic fonts, replacing CJK and merging symbols.

    Parameters
    ----------
    upright_path : str
        The file path to the original upright font.
    italic_path : str
        The file path to the original italic font.
    symbol_paths : list[str]
        A list of file paths to the symbol fonts to merge.
    upright_out : str
        The file path to save the processed upright font.
    italic_out : str
        The file path to save the processed italic font.
    """
    upright_font = TTFont(upright_path)
    italic_font = TTFont(italic_path)

    rename_font(upright_font, "NF")
    rename_font(italic_font, "NF")

    replace_cjk_glyphs(upright_font, italic_font)

    for sym_path in symbol_paths:
        print(f"  Merging {sym_path} into {upright_path}...")
        merge_symbols_into_font(upright_font, sym_path)

        print(f"  Merging {sym_path} into {italic_path}...")
        merge_symbols_into_font(italic_font, sym_path)

    upright_font.save(upright_out)
    italic_font.save(italic_out)

    upright_font.close()
    italic_font.close()


def main() -> None:
    """
    Main entry point for processing the font files.
    """
    symbol_fonts = [
        "SymbolsNerdFontMono-Regular.ttf",
        "FlogSymbols.ttf"
    ]

    font_pairs = [
        (
            "LXGWBrightCodeTC-Regular.ttf",
            "LXGWBrightCodeTC-Italic.ttf",
            "LXGWBrightCodeTC-Regular-NF.ttf",
            "LXGWBrightCodeTC-Italic-NF.ttf"
        ),
        (
            "LXGWBrightCodeTC-ExtraLight.ttf",
            "LXGWBrightCodeTC-ExtraLightItalic.ttf",
            "LXGWBrightCodeTC-ExtraLight-NF.ttf",
            "LXGWBrightCodeTC-ExtraLightItalic-NF.ttf"
        ),
        (
            "LXGWBrightCodeTC-Light.ttf",
            "LXGWBrightCodeTC-LightItalic.ttf",
            "LXGWBrightCodeTC-Light-NF.ttf",
            "LXGWBrightCodeTC-LightItalic-NF.ttf"
        )
    ]

    for upright, italic, up_out, it_out in font_pairs:
        print(f"Processing pair: {upright} & {italic}")
        try:
            process_font_family(upright, italic, symbol_fonts, up_out, it_out)
            print(f"Successfully saved {up_out} and {it_out}\n")
        except FileNotFoundError as error_msg:
            print(f"Error: {error_msg}")


if __name__ == "__main__":
    main()
