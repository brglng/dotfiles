local M = {}

-- sRGB to Linear RGB
---@param r number
---@param g number
---@param b number
---@param gamma number?
---@return number, number, number
function M.rgb_to_linear_rgb(r, g, b, gamma)
    if gamma == nil then
        gamma = 2.2
    end
    local function to_linear(x)
        if x <= 0.04045 then
            return x / 12.92
        else
            return ((x + 0.055) / 1.055) ^ gamma
        end
    end

    return to_linear(r), to_linear(g), to_linear(b)
end

-- Linear RGB to sRGB
---@param lr number
---@param lg number
---@param lb number
---@param gamma number?
---@return number, number, number
function M.linear_rgb_to_rgb(lr, lg, lb, gamma)
    if gamma == nil then
        gamma = 2.2
    end
    local function to_srgb(x)
        if x <= 0.0031308 then
            return x * 12.92
        else
            return 1.055 * (x ^ (1.0 / gamma)) - 0.055
        end
    end

    return to_srgb(lr), to_srgb(lg), to_srgb(lb)
end

-- Linear RGB to Oklab
---@param lr number
---@param lg number
---@param lb number
---@return number, number, number
function M.linear_rgb_to_oklab(lr, lg, lb)
    -- Intermediate values
    local l = 0.4122214708 * lr + 0.5363325363 * lg + 0.0514459929 * lb
    local m = 0.2119034982 * lr + 0.6806995451 * lg + 0.1073969566 * lb
    local s = 0.0883024619 * lr + 0.2817188376 * lg + 0.6299787005 * lb

    l = l ^ (1 / 3)
    m = m ^ (1 / 3)
    s = s ^ (1 / 3)

    -- Oklab coordinates
    local L = 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s
    local a = 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s
    local b = 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s

    return L, a, b
end

-- Oklab to Linear RGB
---@param L number
---@param a number
---@param b number
---@return number, number, number
function M.oklab_to_linear_rgb(L, a, b)
    -- Inverse transform
    local l = L + 0.3963377774 * a + 0.2158037573 * b
    local m = L - 0.1055613458 * a - 0.0638541728 * b
    local s = L - 0.0894841775 * a - 1.2914855480 * b

    -- Cube the values
    l = l * l * l
    m = m * m * m
    s = s * s * s

    -- Convert to linear RGB
    local lr = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
    local lg = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
    local lb = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s

    -- Clamp values
    lr = math.max(0, math.min(1, lr))
    lg = math.max(0, math.min(1, lg))
    lb = math.max(0, math.min(1, lb))

    return lr, lg, lb
end

-- Oklab to Oklch
---@param L number
---@param a number
---@param b number
---@return number, number, number
function M.oklab_to_oklch(L, a, b)
    local C = math.sqrt(a * a + b * b)
    local h = math.atan2(b, a)
    -- Convert h to degrees
    h = h * 180 / math.pi
    -- Ensure h is in [0, 360]
    if h < 0 then
        h = h + 360
    end

    return L, C, h
end

-- Oklch to Oklab
---@param L number
---@param C number
---@param h number
---@return number, number, number
function M.oklch_to_oklab(L, C, h)
    -- Convert h to radians
    local h_rad = h * math.pi / 180

    local a = C * math.cos(h_rad)
    local b = C * math.sin(h_rad)

    return L, a, b
end

-- Linear RGB to Oklch
---@param lr number
---@param lg number
---@param lb number
---@return number, number, number
function M.linear_rgb_to_oklch(lr, lg, lb)
    local L, a, b = M.linear_rgb_to_oklab(lr, lg, lb)
    return M.oklab_to_oklch(L, a, b)
end

-- Oklch to Linear RGB
---@param L number
---@param C number
---@param h number
---@return number, number, number
function M.oklch_to_linear_rgb(L, C, h)
    local _, a, b = M.oklch_to_oklab(L, C, h)
    return M.oklab_to_linear_rgb(L, a, b)
end

-- sRGB to Oklch
---@param r number
---@param g number
---@param b number
---@return number, number, number
function M.rgb_to_oklch(r, g, b)
    local lr, lg, lb = M.rgb_to_linear_rgb(r, g, b)
    return M.linear_rgb_to_oklch(lr, lg, lb)
end

-- Oklch to sRGB
---@param L number
---@param C number
---@param h number
---@return number, number, number
function M.oklch_to_rgb(L, C, h)
    local lr, lg, lb = M.oklch_to_linear_rgb(L, C, h)
    return M.linear_rgb_to_rgb(lr, lg, lb)
end

-- Lighten a color
---@param r number [0.0, 1.0]
---@param g number [0.0, 1.0]
---@param b number [0.0, 1.0]
---@param amount number [0.0, 1.0]
---@return number, number, number
function M.lighten_rgb(r, g, b, amount)
    -- Convert RGB to OKLCH
    local L, c, h = M.rgb_to_oklch(r, g, b)

    -- Scale lightness towards 1.0 (white)
    -- This formula ensures a perceptually uniform change
    L = L + (1.0 - L) * amount

    -- Convert back to RGB
    return M.oklch_to_rgb(L, c, h)
end

-- Darken a color
---@param r number [0.0, 1.0]
---@param g number [0.0, 1.0]
---@param b number [0.0, 1.0]
---@param amount number [0.0, 1.0]
---@return number, number, number
function M.darken_rgb(r, g, b, amount)
    -- Convert RGB to OKLCH
    local L, c, h = M.rgb_to_oklch(r, g, b)

    -- Scale lightness towards 0.0 (black)
    -- This formula ensures a perceptually uniform change
    L = L * (1.0 - amount)

    -- Convert back to RGB
    return M.oklch_to_rgb(L, c, h)
end

-- Calculate a color between two RGB colors
---@param r1 number [0.0, 1.0]
---@param g1 number [0.0, 1.0]
---@param b1 number [0.0, 1.0]
---@param r2 number [0.0, 1.0]
---@param g2 number [0.0, 1.0]
---@param b2 number [0.0, 1.0]
---@param mix number [0.0, 1.0], t=0.0 returns the first color, t=1.0 returns the second color
---@return number, number, number
function M.interpolate_rgb(r1, g1, b1, r2, g2, b2, mix)
    -- Clamp t to [0,1] range
    mix = math.max(0.0, math.min(1.0, mix))

    -- Convert both colors to OKLCH
    local L1, C1, h1 = M.rgb_to_oklch(r1, g1, b1)
    local L2, C2, h2 = M.rgb_to_oklch(r2, g2, b2)

    -- Linearly interpolate L and C
    local L = L1 + (L2 - L1) * mix
    local C = C1 + (C2 - C1) * mix

    -- Handle special case where either color has zero chroma
    -- In such cases, the hue is meaningless and we can use the other color's hue
    if C1 < 0.0001 then h1 = h2 end
    if C2 < 0.0001 then h2 = h1 end

    -- Interpolate hue (special case since it's an angle)
    local h

    -- Calculate the shortest path around the color wheel
    local delta_h = h2 - h1
    if delta_h > 180 then
        delta_h = delta_h - 360
    elseif delta_h < -180 then
        delta_h = delta_h + 360
    end

    h = h1 + delta_h * mix

    -- Ensure h stays in [0, 360] range
    if h < 0 then
        h = h + 360
    elseif h > 360 then
        h = h - 360
    end

    -- Convert back to RGB
    return M.oklch_to_rgb(L, C, h)
end

-- Blend a foreground color over a background color with given opacity using OKLCH color space
-- Input: 
--   fr, fg, fb: foreground RGB color in [0.0, 1.0] range
--   br, bg, bb: background RGB color in [0.0, 1.0] range
--   opacity: the opacity of the foreground color in [0.0, 1.0] range
-- Output: blended r, g, b in [0.0, 1.0] range
---@param fg_r number [0.0, 1.0]
---@param fg_g number [0.0, 1.0]
---@param fg_b number [0.0, 1.0]
---@param bg_r number [0.0, 1.0]
---@param bg_g number [0.0, 1.0]
---@param bg_b number [0.0, 1.0]
---@param opacity number [0.0, 1.0]
---@return number, number, number
function M.blend_rgb(fg_r, fg_g, fg_b, bg_r, bg_g, bg_b, opacity)
    -- Clamp opacity to [0,1] range
    opacity = math.max(0.0, math.min(1.0, opacity))

    -- Convert foreground and background to OKLCH
    local fg_L, fg_C, fg_h = M.rgb_to_oklch(fg_r, fg_g, fg_b)
    local bg_L, bg_C, bg_h = M.rgb_to_oklch(bg_r, bg_g, bg_b)

    -- Blend lightness and chroma using linear interpolation
    local L = fg_L * opacity + bg_L * (1 - opacity)
    local C = fg_C * opacity + bg_C * (1 - opacity)

    -- Handle special cases where either color has zero chroma
    -- In such cases, the hue is meaningless
    if fg_C < 0.0001 then fg_h = bg_h end
    if bg_C < 0.0001 then bg_h = fg_h end

    -- Convert back to RGB
    return M.oklch_to_rgb(L, C, fg_h)
end

function M.rgb_to_hex(r, g, b)
    -- Convert from [0.0, 1.0] to [0, 255]
    local r_byte = math.floor(r * 255 + 0.5)
    local g_byte = math.floor(g * 255 + 0.5)
    local b_byte = math.floor(b * 255 + 0.5)

    -- Ensure values are in [0, 255] range
    r_byte = math.max(0, math.min(255, r_byte))
    g_byte = math.max(0, math.min(255, g_byte))
    b_byte = math.max(0, math.min(255, b_byte))

    -- Format as hex string
    return string.format("#%02X%02X%02X", r_byte, g_byte, b_byte)
end

---@param hex string
---@return number, number, number
function M.hex_to_rgb(hex)
    -- Remove the leading '#' if present
    if hex:sub(1, 1) == "#" then
        hex = hex:sub(2)
    end

    -- Ensure the hex string is 6 characters long
    if #hex ~= 6 then
        error("Invalid hex color format. Expected 6 characters.")
    end

    -- Parse the hex string into RGB components
    local r = tonumber(hex:sub(1, 2), 16) / 255
    local g = tonumber(hex:sub(3, 4), 16) / 255
    local b = tonumber(hex:sub(5, 6), 16) / 255

    return r, g, b
end

---@param rgb string
---@param amount number [0.0, 1.0]
---@return string
function M.lighten(rgb, amount)
    local r, g, b = M.hex_to_rgb(rgb)
    r, g, b = M.lighten_rgb(r, g, b, amount)
    return M.rgb_to_hex(r, g, b)
end

---@param rgb string
---@param amount number [0.0, 1.0]
---@return string
function M.darken(rgb, amount)
    local r, g, b = M.hex_to_rgb(rgb)
    r, g, b = M.darken_rgb(r, g, b, amount)
    return M.rgb_to_hex(r, g, b)
end

---@param rgb string
---@param amount number [0.0, 1.0]
---@return string
function M.emboss(rgb, amount)
    if vim.o.background == "dark" then
        return M.lighten(rgb, amount)
    else
        return M.darken(rgb, amount)
    end
end

---@param rgb string
---@param amount number [0.0, 1.0]
---@return string
function M.deboss(rgb, amount)
    if vim.o.background == "dark" then
        return M.darken(rgb, amount)
    else
        return M.lighten(rgb, amount)
    end
end

---@param rgb1 string
---@param rgb2 string
---@param mix number [0.0, 1.0]
---@return string
function M.interpolate(rgb1, rgb2, mix)
    local r1, g1, b1 = M.hex_to_rgb(rgb1)
    local r2, g2, b2 = M.hex_to_rgb(rgb2)
    local r, g, b = M.interpolate_rgb(r1, g1, b1, r2, g2, b2, mix)
    return M.rgb_to_hex(r, g, b)
end

---@param rgb1 string
---@param rgb2 string
---@return string
function M.middle(rgb1, rgb2)
    return M.interpolate(rgb1, rgb2, 0.5)
end

---@param fg string
---@param bg string
---@param opacity number
---@return string
function M.blend(fg, bg, opacity)
    local fg_r, fg_g, fg_b = M.hex_to_rgb(fg)
    local bg_r, bg_g, bg_b = M.hex_to_rgb(bg)
    local r, g, b = M.blend_rgb(fg_r, fg_g, fg_b, bg_r, bg_g, bg_b, opacity)
    return M.rgb_to_hex(r, g, b)
end

return M
