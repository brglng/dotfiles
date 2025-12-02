local color = require("brglng.color")

local M = {}

---@param hl_fallback_list number | string | string[]
function M.get_attr(hl_fallback_list)
    if type(hl_fallback_list) == "number" then
        return hl_fallback_list
    elseif type(hl_fallback_list) == "string" then
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
---@alias HighlightTransform { [1]?: HighlightTransformType, transform: HighlightTransformType, from?: number | string | string[], fg?: number | string | string[], bg?: number | string | string[], amount?: number, mix?: number, opacity?: number }
---@param opts HighlightTransform | function: HighlightTransform
---@return integer
function M.transform_one(opts)
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
        assert(type(opts.from) == "number" or type(opts.from) == "string" or type(opts.from) == "table", "lighten requires `from`")
        assert(type(opts.amount) == "number", "lighten requires `amount`")
        return color.lighten(M.get_attr(opts.from), opts.amount)
    elseif transform == "darken" then
        assert(type(opts.from) == "number" or type(opts.from) == "string" or type(opts.from) == "table", "darken requires `from`")
        assert(type(opts.amount) == "number", "darken requires `amount`")
        return color.darken(M.get_attr(opts.from), opts.amount)
    elseif transform == "emboss" then
        assert(type(opts.from) == "number" or type(opts.from) == "string" or type(opts.from) == "table", "emboss requires `from`")
        assert(type(opts.amount) == "number", "emboss requires `amount`")
        return color.emboss(M.get_attr(opts.from), opts.amount)
    elseif transform == "deboss" then
        assert(type(opts.from) == "number" or type(opts.from) == "string" or type(opts.from) == "table", "deboss requires `from`")
        assert(type(opts.amount) == "number", "deboss requires `amount`")
        return color.deboss(M.get_attr(opts.from), opts.amount)
    elseif transform == "interpolate" then
        assert(type(opts.from) == "number" or type(opts.from) == "table" and #opts.from >= 2, "interpolate requires `from`")
        assert(type(opts.mix) == "number", "interpolate requires `mix`")
        return color.interpolate(M.get_attr(opts.from[1]), M.get_attr(opts.from[2]), opts.mix)
    elseif transform == "middle" then
        assert(type(opts.from) == "table" and #opts.from >= 2, "middle requires `from`")
        return color.middle(M.get_attr(opts.from[1]), M.get_attr(opts.from[2]))
    elseif transform == "blend" then
        assert(type(opts.fg) == "number" or type(opts.fg) == "string" or type(opts.fg) == "table", "blend requires `fg`")
        assert(type(opts.bg) == "number" or type(opts.bg) == "string" or type(opts.bg) == "table", "blend requires `bg`")
        assert(type(opts.opacity) == "number", "blend requires `opacity`")
        return color.blend(M.get_attr(opts.fg), M.get_attr(opts.bg), opts.opacity)
    else
        error("Invalid highlight transform: " .. vim.inspect(opts))
    end
end

---@alias HighlightTransformDef number | string | string[] | HighlightTransform
---@alias HighlightTransformFunction function: HighlightTransformDef
---@alias HighlightTransformTable { fg?: HighlightTransformDef | HighlightTransformFunction, bg?: HighlightTransformDef | HighlightTransformFunction, link?: string, bold?: boolean | string, italic?: boolean | string, underline?: boolean | string, undercurl?: boolean | string, strikethrough?: boolean | string }
---@alias HighlightTransformTableFunction function: HighlightTransformTable?
---@param tbl table<string, HighlightTransformTable | HighlightTransformTableFunction> | function: HighlightTransformTable
function M.transform_tbl(tbl)
    local function cb(tbl, colors_name, background)
        if type(tbl) == "function" then
            tbl = tbl(colors_name, background)
        end
        if not tbl then
            return
        end
        for hl_name, hl_opts in pairs(tbl) do
            local result = {}
            if type(hl_opts) == "function" then
                hl_opts = hl_opts()
            end
            if hl_opts then
                for attr, opts in pairs(hl_opts) do
                    if type(opts) == "function" then
                        opts = opts()
                    end
                    if type(opts) == "table" then
                        result[attr] = M.transform_one(opts)
                    elseif (type(opts) == "number" or type(opts) == "string") and (attr == "fg" or attr == "bg") then
                        result[attr] = M.get_attr(opts)
                    else
                        result[attr] = opts
                    end
                end
                result.force = true
                vim.api.nvim_set_hl(0, hl_name, result)
            end
        end
    end
    cb(tbl, vim.g.colors_name, vim.o.background)
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function(ev)
            return cb(tbl, ev.match, vim.o.background)
        end,
    })
    vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = function()
            return cb(tbl, vim.g.colors_name, vim.o.background)
        end,
    })
end

function M.modify_colorscheme(colorscheme_pattern, tbl)
    M.transform_tbl(function(colors_name, background)
        if colors_name and colors_name:match(colorscheme_pattern) then
            if type(tbl) == "function" then
                tbl = tbl(background)
            end
            return tbl
        end
    end)
end

return M
