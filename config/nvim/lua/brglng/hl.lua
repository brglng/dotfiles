local color = require("brglng.color")

---@param hl_fallback_list string | string[]
local function get_attr(hl_fallback_list)
    if type(hl_fallback_list) == "string" then
        hl_fallback_list = { hl_fallback_list }
    end
    for _, hl_fallback in ipairs(hl_fallback_list) do
        for _, hl_name_dot_attr in ipairs(vim.split(hl_fallback, ",", { trimempty = true })) do
            local name, attr = hl_name_dot_attr:match("^([^%.]+)%.([^%.]+)$")
            if name and attr then
                local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
                if hl.reverse == true and attr == "fg" and hl.fg then
                    return hl.bg
                elseif hl.reverse == true and attr == "bg" and hl.bg then
                    return hl.fg
                elseif hl[attr] then
                    return hl[attr]
                end
            else
                error("Invalid highlight color: " .. hl_name_dot_attr)
            end
        end
    end
end

---@alias HighlightTransformType "lighten" | "darken" | "emboss" | "deboss" | "interpolate" | "middle" | "blend"
---@alias HighlightTransform { [1]?: HighlightTransformType, transform: HighlightTransformType, from?: string | string[], fg?: string | string[], bg?: string | string[], amount?: number, mix?: number, opacity?: number }
---@param opts HighlightTransform | function: HighlightTransform
---@return integer
local function transform_one(opts)
    if type(opts) == "function" then
        opts = opts()
    end

    local count = 0
    for _, t in ipairs({ "lighten", "darken", "emboss", "deboss", "interpolate", "middle", "blend" }) do
        if opts.transform == t then
            count = count + 1
        end
    end
    if count > 1 then
        error("Multiple transforms is not supported: " .. vim.inspect(opts))
    end

    local transform = opts.transform or opts[1]

    if transform == "lighten" then
        assert(type(opts.from) == "string" or type(opts.from) == "table", "lighten requires `from`")
        assert(type(opts.amount) == "number", "lighten requires `amount`")
        return color.lighten(get_attr(opts.from), opts.amount)
    elseif transform == "darken" then
        assert(type(opts.from) == "string" or type(opts.from) == "table", "darken requires `from`")
        assert(type(opts.amount) == "number", "darken requires `amount`")
        return color.darken(get_attr(opts.from), opts.amount)
    elseif transform == "emboss" then
        assert(type(opts.from) == "string" or type(opts.from) == "table", "emboss requires `from`")
        assert(type(opts.amount) == "number", "emboss requires `amount`")
        return color.emboss(get_attr(opts.from), opts.amount)
    elseif transform == "deboss" then
        assert(type(opts.from) == "string" or type(opts.from) == "table", "deboss requires `from`")
        assert(type(opts.amount) == "number", "deboss requires `amount`")
        return color.deboss(get_attr(opts.from), opts.amount)
    elseif transform == "interpolate" then
        assert(type(opts.from) == "table" and #opts.from >= 2, "interpolate requires `from`")
        assert(type(opts.mix) == "number", "interpolate requires `mix`")
        return color.interpolate(get_attr(opts.from[1]), get_attr(opts.from[2]), opts.mix)
    elseif transform == "middle" then
        assert(type(opts.from) == "table" and #opts.from >= 2, "middle requires `from`")
        assert(type(opts.mix) == "number", "middle requires `mix`")
        return color.middle(get_attr(opts.from[1]), get_attr(opts.from[2]))
    elseif transform == "blend" then
        assert((type(opts.fg) == "string" or type(opts.fg) == "table") and (type(opts.fg) == "string" or type(opts.fg) == "table"), "blend requires `fg` and `bg`")
        assert(type(opts.opacity) == "number", "blend requires `opacity`")
        return color.blend(get_attr(opts.fg), get_attr(opts.bg), opts.opacity)
    else
        error("Invalid highlight transform: " .. vim.inspect(opts))
    end
end

---@alias HighlightTransformDef string | string[] | HighlightTransform
---@alias HighlightTransformFunction function
---@alias HighlightTransformTable { fg?: HighlightTransformDef | HighlightTransformFunction, bg?: HighlightTransformDef | HighlightTransformFunction, link?: string, bold?: boolean | string, italic?: boolean | string, underline?: boolean | string, undercurl?: boolean | string, strikethrough?: boolean | string }
---@param tbl table<string, HighlightTransformTable> | function: HighlightTransformTable
local function transform_tbl(tbl)
    local function cb(is_autocmd)
        if type(tbl) == "function" then
            tbl = tbl(is_autocmd)
        end
        for hl_name, hl_opts in pairs(tbl) do
            local result = {}
            if type(hl_opts) == "function" then
                hl_opts = hl_opts()
            end
            for attr, opts in pairs(hl_opts) do
                if type(opts) == "function" then
                    opts = opts()
                end
                if type(opts) == "table" then
                    result[attr] = transform_one(opts)
                elseif type(opts) == "string" and attr ~= "link" then
                    result[attr] = get_attr(opts)
                else
                    result[attr] = opts
                end
            end
            vim.api.nvim_set_hl(0, hl_name, result)
        end
    end
    cb(false)
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function () cb(true) end,
    })
    vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = function () cb(true) end,
    })
end

return {
    get_attr =  get_attr,
    transform_one = transform_one,
    transform_tbl = transform_tbl,
}
