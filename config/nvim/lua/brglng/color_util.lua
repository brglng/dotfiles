local M = {}

local function fix(x)
    if x >= 0 then
        return math.floor(x)
    else
        return math.ceil(x)
    end
end

function M.rgb2str(r, g, b)
    assert(type(r) == "number" and type(g) == "number" and type(b) == "number")
    return string.format("#02x%02x%02x", r, g, b)
end

function M.str2rgb(rgb_str)
    local r, g, b = string.match(rgb_str, "^#?(%x%x)(%x%x)(%x%x)$")
    assert(r ~= nil and g ~= nil and b ~= nil)
    return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
end

function M.extract_rgb(rgb)
    local r = math.floor(rgb / 16 ^ 4)
    local g = math.floor((rgb - r * 16 ^ 4) / (16 ^ 2))
    local b = rgb - r * 16 ^ 4 - g * 16 ^ 2
    return r, g, b
end

function M.combine_rgb(r, g, b)
    return math.floor(r) * 16 ^ 4 + math.floor(g) * 16 ^ 2 + math.floor(b)
end

function M.rgb2hsv(r, g, b)
    assert(type(r) == "number" and type(g) == "number" and type(b) == "number")
    local rgbmax = math.max(r, g, b)
    local rgbmin = math.min(r, g, b)

    local h
    if rgbmax == rgbmin then
        h = 0
    elseif rgbmax == r and g >= b then
        h = 60 * (g - b) / (rgbmax - rgbmin)
    elseif rgbmax == r and g < b then
        h = 60 * (g - b) / (rgbmax - rgbmin) + 360
    elseif rgbmax == g then
        h = 60 * (b - r) / (rgbmax - rgbmin) + 120
    elseif rgbmax == b then
        h = 60 * (r - g) / (rgbmax - rgbmin) + 240
    end

    local s
    if rgbmax == 0 then
        s = 0
    else
        s = 1 - rgbmin / rgbmax
    end

    local v = rgbmax

    return h, s, v
end

function M.hsv2rgb(h, s, v)
    local hi = math.floor(h / 60)
    local f = h / 60 - hi
    local p = fix(v * (1 - s))
    local q = fix(v * (1 - f * s))
    local t = fix(v * (1 - (1 - f) * s))
    if hi == 0 then
        return v, t, p
    elseif hi == 1 then
        return q, v, p
    elseif hi == 2 then
        return p, v, t
    elseif hi == 3 then
        return p, q, v
    elseif hi == 4 then
        return t, p, v
    elseif hi == 5 then
        return v, p, q
    end
end

function M.middle_color(rgb1, rgb2)
    if rgb1 == nil or rgb2 == nil then
        return nil
    end

    local r1, g1, b1 = M.extract_rgb(rgb1)
    local r2, g2, b2 = M.extract_rgb(rgb2)
    local h1, s1, v1 = M.rgb2hsv(r1, g1, b1)
    local h2, s2, v2 = M.rgb2hsv(r2, g2, b2)

    local h
    if math.abs(h1 - h2) <= 180 then
        h = (h1 + h2) / 2
    else
        h = ((360 - h1) + (360 - h2)) / 2
    end
    local s = (s1 + s2) / 2
    local v = (v1 + v2) / 2
    local r, g, b = M.hsv2rgb(h, s, v)
    return M.combine_rgb(r, g, b)
end

function M.add_value(rgb, proportion)
    if rgb == nil then
        return nil
    end

    local r, g, b = M.extract_rgb(rgb)
    local h, s, v = M.rgb2hsv(r, g, b)

    v = v * (1 - proportion) + proportion
    r, g, b = M.hsv2rgb(h, s, v)
    return M.combine_rgb(r, g, b)
end

function M.reduce_value(rgb, proportion)
    if rgb == nil then
        return nil
    end

    local r, g, b = M.extract_rgb(rgb)
    local h, s, v = M.rgb2hsv(r, g, b)

    v = v * (1 - proportion)
    r, g, b = M.hsv2rgb(h, s, v)
    return M.combine_rgb(r, g, b)
end

function M.add_saturation(rgb, proportion)
    if rgb == nil then
        return nil
    end

    local r, g, b = M.extract_rgb(rgb)
    local h, s, v = M.rgb2hsv(r, g, b)

    s = proportion + (1 - proportion) * s
    r, g, b = M.hsv2rgb(h, s, v)
    return M.combine_rgb(r, g, b)
end

function M.reduce_saturation(rgb, proportion)
    if rgb == nil then
        return nil
    end

    local r, g, b = M.extract_rgb(rgb)
    local h, s, v = M.rgb2hsv(r, g, b)

    s = s * (1 - proportion)
    r, g, b = M.hsv2rgb(h, s, v)
    return M.combine_rgb(r, g, b)
end

function M.transparency(fg, bg, alpha)
    if fg == nil or bg == nil then
        return nil
    end

    local fg_r, fg_g, fg_b = M.extract_rgb(fg)
    local bg_r, bg_g, bg_b = M.extract_rgb(bg)
    local fg_h, fg_s, fg_v = M.rgb2hsv(fg_r, fg_g, fg_b)
    local _, bg_s, bg_v = M.rgb2hsv(bg_r, bg_g, bg_b)

    local h = fg_h
    local s = fg_s * alpha + bg_s * (1 - alpha)
    local v = fg_v * alpha + bg_v * (1 - alpha)
    local r, g, b = M.hsv2rgb(h, s, v)
    return M.combine_rgb(r, g, b)
end

return M
