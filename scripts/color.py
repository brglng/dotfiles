#!/usr/bin/env python3
import string
import sys


def rgba_from_str(rgba: str):
    if rgba.startswith('0x'):
        rgba_stripped = rgba[2:]
    if rgba.startswith('#'):
        rgba_stripped = rgba[1:]
    else:
        rgba_stripped = rgba
    if not len(rgba_stripped) == 8:
        raise ValueError(f'invalid RGBA color: {rgba}')

    hex_value = int(rgba_stripped, 16)

    r = (hex_value >> 24) & 0xff
    g = (hex_value >> 16) & 0xff
    b = (hex_value >> 8) & 0xff
    alpha = ((hex_value) & 0xff) / 0xff

    return r, g, b, alpha


def rgb_from_str(rgb: str):
    if rgb.startswith('0x'):
        rgb_stripped = rgb[2:]
    if rgb.startswith('#'):
        rgb_stripped = rgb[1:]
    else:
        rgb_stripped = rgb
    if not len(rgb_stripped) == 6:
        raise ValueError(f'invalid RGB color: {rgb}')

    hex_value = int(rgb_stripped, 16)
    r = (hex_value >> 16) & 0xff
    g = (hex_value >> 8) & 0xff
    b = (hex_value) & 0xff

    return r, g, b


def rgba2rgb(rgba, bg_rgb):
    r, g, b, alpha = rgba
    bg_r, bg_g, bg_b = bg_rgb
    result_r = round((1 - alpha) * bg_r + alpha * r)
    result_g = round((1 - alpha) * bg_g + alpha * g)
    result_b = round((1 - alpha) * bg_b + alpha * b)
    return result_r, result_g, result_b


# https://github.com/skywind3000/vim/blob/master/tools/script/rgb_fit_256.py
PALETTE_256 = [
    '#000000', '#800000', '#008000', '#808000', '#000080', '#800080', '#008080', '#c0c0c0',
    '#808080', '#ff0000', '#00ff00', '#ffff00', '#0000ff', '#ff00ff', '#00ffff', '#ffffff',
    '#000000', '#00005f', '#000087', '#0000af', '#0000d7', '#0000ff', '#005f00', '#005f5f',
    '#005f87', '#005faf', '#005fd7', '#005fff', '#008700', '#00875f', '#008787', '#0087af',
    '#0087d7', '#0087ff', '#00af00', '#00af5f', '#00af87', '#00afaf', '#00afd7', '#00afff',
    '#00d700', '#00d75f', '#00d787', '#00d7af', '#00d7d7', '#00d7ff', '#00ff00', '#00ff5f',
    '#00ff87', '#00ffaf', '#00ffd7', '#00ffff', '#5f0000', '#5f005f', '#5f0087', '#5f00af',
    '#5f00d7', '#5f00ff', '#5f5f00', '#5f5f5f', '#5f5f87', '#5f5faf', '#5f5fd7', '#5f5fff',
    '#5f8700', '#5f875f', '#5f8787', '#5f87af', '#5f87d7', '#5f87ff', '#5faf00', '#5faf5f',
    '#5faf87', '#5fafaf', '#5fafd7', '#5fafff', '#5fd700', '#5fd75f', '#5fd787', '#5fd7af',
    '#5fd7d7', '#5fd7ff', '#5fff00', '#5fff5f', '#5fff87', '#5fffaf', '#5fffd7', '#5fffff',
    '#870000', '#87005f', '#870087', '#8700af', '#8700d7', '#8700ff', '#875f00', '#875f5f',
    '#875f87', '#875faf', '#875fd7', '#875fff', '#878700', '#87875f', '#878787', '#8787af',
    '#8787d7', '#8787ff', '#87af00', '#87af5f', '#87af87', '#87afaf', '#87afd7', '#87afff',
    '#87d700', '#87d75f', '#87d787', '#87d7af', '#87d7d7', '#87d7ff', '#87ff00', '#87ff5f',
    '#87ff87', '#87ffaf', '#87ffd7', '#87ffff', '#af0000', '#af005f', '#af0087', '#af00af',
    '#af00d7', '#af00ff', '#af5f00', '#af5f5f', '#af5f87', '#af5faf', '#af5fd7', '#af5fff',
    '#af8700', '#af875f', '#af8787', '#af87af', '#af87d7', '#af87ff', '#afaf00', '#afaf5f',
    '#afaf87', '#afafaf', '#afafd7', '#afafff', '#afd700', '#afd75f', '#afd787', '#afd7af',
    '#afd7d7', '#afd7ff', '#afff00', '#afff5f', '#afff87', '#afffaf', '#afffd7', '#afffff',
    '#d70000', '#d7005f', '#d70087', '#d700af', '#d700d7', '#d700ff', '#d75f00', '#d75f5f',
    '#d75f87', '#d75faf', '#d75fd7', '#d75fff', '#d78700', '#d7875f', '#d78787', '#d787af',
    '#d787d7', '#d787ff', '#d7af00', '#d7af5f', '#d7af87', '#d7afaf', '#d7afd7', '#d7afff',
    '#d7d700', '#d7d75f', '#d7d787', '#d7d7af', '#d7d7d7', '#d7d7ff', '#d7ff00', '#d7ff5f',
    '#d7ff87', '#d7ffaf', '#d7ffd7', '#d7ffff', '#ff0000', '#ff005f', '#ff0087', '#ff00af',
    '#ff00d7', '#ff00ff', '#ff5f00', '#ff5f5f', '#ff5f87', '#ff5faf', '#ff5fd7', '#ff5fff',
    '#ff8700', '#ff875f', '#ff8787', '#ff87af', '#ff87d7', '#ff87ff', '#ffaf00', '#ffaf5f',
    '#ffaf87', '#ffafaf', '#ffafd7', '#ffafff', '#ffd700', '#ffd75f', '#ffd787', '#ffd7af',
    '#ffd7d7', '#ffd7ff', '#ffff00', '#ffff5f', '#ffff87', '#ffffaf', '#ffffd7', '#ffffff',
    '#080808', '#121212', '#1c1c1c', '#262626', '#303030', '#3a3a3a', '#444444', '#4e4e4e',
    '#585858', '#626262', '#6c6c6c', '#767676', '#808080', '#8a8a8a', '#949494', '#9e9e9e',
    '#a8a8a8', '#b2b2b2', '#bcbcbc', '#c6c6c6', '#d0d0d0', '#dadada', '#e4e4e4', '#eeeeee',
]

PALETTE_AYU_LIGHT = [
    '#000000', '#ec420e', '#67c605', '#ed8515', '#3694d0', '#864cc0', '#41b487', '#bbbbbb',
    '#555555', '#ca4e57', '#94d507', '#e0bb38', '#5555ff', '#9161c0', '#4bd49d', '#ffffff'
] + PALETTE_256[16:]

PALETTES = {
    'ayu_light': PALETTE_AYU_LIGHT
}

def _rgb2256(palette: str, rgb):
    r, g, b = rgb
    nearest_index = -1
    nearest_dist = 0xff * 0xff * 64 * 64 * 4
    for index in range(256):
        r256, g256, b256 = rgb_from_str(PALETTES[palette][index])
        dist = (((g - g256) * 59) ** 2)
        if dist >= nearest_dist:
            continue
        dist += (((r - r256) * 30) ** 2)
        if dist >= nearest_dist:
            continue
        dist += (((b - b256) * 11) ** 2)
        if dist < nearest_dist:
            nearest_dist = dist
            nearest_index = index
    return nearest_index


def rgb2256(palette: str, rgb):
    r, g, b = rgb
    inv_r = 255 - r
    inv_g = 255 - g
    inv_b = 255 - b
    return _rgb2256(palette, rgb), _rgb2256(palette, (inv_r, inv_g, inv_b))


def rgba2256(palette: str, rgba, bg_rgb):
    r, g, b, alpha = rgba
    bg_r, bg_g, bg_b = bg_rgb
    real_r = ((1 - alpha) * bg_r + alpha * r)
    real_g = ((1 - alpha) * bg_g + alpha * g)
    real_b = ((1 - alpha) * bg_b + alpha * b)
    inv_r = 255 - real_r
    inv_g = 255 - real_g
    inv_b = 255 - real_b
    return _rgb2256(palette, (real_r, real_g, real_b)), _rgb2256(palette, (inv_r, inv_g, inv_b))


def print_rgb(rgb):
    bg_r, bg_g, bg_b = rgb
    r, g, b = 255 - bg_r, 255 - bg_g, 255 - bg_b
    code_str = f'{bg_r:0>2x}{bg_g:0>2x}{bg_b:0>2x}'
    print(f"\x1b[48;2;{bg_r};{bg_g};{bg_b}m\x1b[38;2;{r};{g};{b}m{code_str}\x1b[0m")


def print_256(color):
    bg, fg = color
    print(f'\x1b[48;5;{bg}m\x1b[38;5;{fg}m{bg}\x1b[0m')


def main(argv):
    if len(argv) < 3:
        sys.exit('python3 color.py palette rgb\n'
                 'python3 color.py palette rgba bg_rgb')

    palette = argv[1]

    if len(argv) == 3:
        rgb = argv[2]
        print_rgb(rgb_from_str(rgb))
        print_256(rgb2256(palette, rgb_from_str(rgb)))
    else:
        rgba = argv[2]
        bg_rgb = argv[3]

        if not len(rgba) == 8:
            sys.exit(f'Incorrect RGBA color code: {rgba}')

        for c in rgba:
            if not c in string.hexdigits:
                sys.exit(f'Incorrect RGBA color code: {rgba}')

        if not len(bg_rgb) == 6:
            sys.exit(f'Incorrect RGB color code: {bg_rgb}')

        for c in bg_rgb:
            if not c in string.hexdigits:
                sys.exit(f'Incorrect RGB color code: {bg_rgb}')

        print_rgb(rgba2rgb(rgba_from_str(rgba), rgb_from_str(bg_rgb)))
        print_256(rgba2256(palette, rgba_from_str(rgba), rgb_from_str(bg_rgb)))


if __name__ == '__main__':
    main(sys.argv)
