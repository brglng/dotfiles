vim.opt.mousemoveevent = true
vim.diagnostic.config {
    virtual_text = false,
    float = {
        -- border = "rounded"
    }
}
vim.env.DEBUG_CODEIUM = "error"
vim.g.maplocalleader = ","

vim.filetype.add {
    extension = {
        norg = "norg",
        nu = "nu"
    },
    pattern = {
        [".*"] = {
            priority = -math.huge,
            function(_, bufnr)
                local shebang = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
                if vim.regex([[^#!.*\<nu\>]]):match_str(shebang) then
                    return "nu"
                end
            end,
        },
    },
}
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.nu"},
    command = "setfiletype nu | TSBufEnable highlight"
})
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.norg"},
    command = "setfiletype norg | TSBufEnable highlight"
})
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"norg", "markdown"},
    command = "set conceallevel=3"
})

local signs = { Error = " ", Warn = " ", Info = " ", Hint = "󰌶 " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focus = false })]]

-- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
-- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
--     opts = opts or {}
--     opts.border = opts.border or "rounded"
--     return orig_util_open_floating_preview(contents, syntax, opts, ...)
-- end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
    change_detection = {
        enabled = false,
    },
    performance = {
        rtp = {
            reset = false
        }
    },
    rocks = {
        enabled = false,
    }
})
