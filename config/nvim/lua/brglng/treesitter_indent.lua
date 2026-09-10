local M = {}

local function continues_with_backslash(line)
    return line ~= nil and line:match('\\%s*$') ~= nil
end

--- Treesitter supplies bracket indentation; Lua handles C/C++ line splices,
--- which are removed before they become syntax-tree nodes.  cmake delegates
--- straight to the treesitter engine.
function M.indentexpr()
    local lnum = vim.v.lnum
    local ft = vim.bo.filetype
    if (ft == 'c' or ft == 'cpp') and lnum > 1 then
        local previous = vim.api.nvim_buf_get_lines(0, lnum - 2, lnum - 1, false)[1]
        if continues_with_backslash(previous) then
            return vim.fn.indent(lnum - 1)
        end
    end

    local ok, indentexpr = pcall(function()
        return require('nvim-treesitter').indentexpr()
    end)
    if ok then
        return indentexpr
    end
    return -1
end

return M
