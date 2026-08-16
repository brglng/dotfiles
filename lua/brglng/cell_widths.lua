-- Parsers for the shared CJK double-width cell table.
--
-- The canonical range table is cell_widths.txt in this directory. Every
-- consumer reads that single file (Vim/Neovim parse it directly in
-- config/nvim/brglng/ui.vim), so the lists can never diverge.
--
-- This module exposes two accessors:
--   * wezterm(): entries shaped for WezTerm's config.cell_widths
--       { { first = ..., last = ..., width = 2 }, ... }
--   * vim():     entries shaped for Vim/Neovim's setcellwidths()
--       { { first, last, width }, ... }
--
-- The rules cover the Unicode East Asian Width "Wide"/"Fullwidth" ranges plus
-- a few "Ambiguous" CJK punctuation marks, and deliberately avoid the Nerd
-- Font private-use areas (U+E000..U+F8FF, U+F0000..U+FFFFD) so Nerd Font icons
-- keep their single width. See cell_widths.txt for the full list.

local function module_dir()
    -- Locate this module's directory without debug.getinfo, which is not
    -- available in WezTerm's sandboxed Lua. package.searchpath resolves the
    -- module file from the active package.path; debug is only a fallback.
    local file = package.searchpath("brglng.cell_widths", package.path)
    if file then
        return file:match("(.*)[/\\]")
    end
    return debug.getinfo(1, "S").source:match("^@(.*)[/\\]") or "."
end

local function parse()
    local path = module_dir() .. "/cell_widths.txt"
    local entries = {}
    local f = assert(io.open(path, "r"))
    for raw in f:lines() do
        local line = raw:gsub("#.*$", ""):gsub("%s+", "")
        if line ~= "" then
            local first, last = line:match("^(%x+)-?(%x*)$")
            first = tonumber(first, 16)
            last = last ~= "" and tonumber(last, 16) or first
            entries[#entries + 1] = { first = first, last = last, width = 2 }
        end
    end
    f:close()
    return entries
end

local entries = parse()

return {
    wezterm = function()
        return entries
    end,
    vim = function()
        local out = {}
        for _, e in ipairs(entries) do
            out[#out + 1] = { e.first, e.last, e.width }
        end
        return out
    end,
}