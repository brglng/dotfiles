vim.o.mousemoveevent = true
vim.o.splitkeep = "screen"
-- vim.o.termsync = false
vim.g.maplocalleader = ","

if vim.g.neovide then
    if vim.uv.os_uname().sysname == "Windows_NT" then
        vim.o.guifont = "Maple Mono NF CN:Flog Symbols:h10:#h-none"
    else
        vim.o.guifont = "Maple Mono NF CN:Flog Symbols:h14:#h-none"
        -- vim.env.PATH = vim.env.HOME .. "/.local/bin:" .. vim.env.HOME .. "/.cargo/bin:" .. vim.env.PATH
    end
    vim.o.linespace = -1
    vim.g.neovide_hide_mouse_when_typing = true
    -- vim.g.experimental_layer_grouping = true
    vim.g.neovide_input_macos_option_key_is_meta = 'both'
    vim.g.neovide_floating_corner_radius = 0.1
    -- vim.g.neovide_cursor_trail_size = 0.2
    vim.g.neovide_cursor_vfx_mode = "torpedo"
    vim.g.neovide_cursor_vfx_particle_density = 10.0
end

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
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = { "norg", "markdown" },
    command = "set conceallevel=3"
})
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = { "markdown" },
    command = "set shiftwidth=2 softtabstop=4 expandtab"
})

local signs = { Error = " ", Warn = " ", Info = " ", Hint = "󰌶 " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focus = false })]]

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

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
    -- concurrency = (function()
    --     if vim.uv.os_uname().sysname == 'Windows_NT' then
    --         return 1
    --     end
    -- end)(),
    change_detection = {
        enabled = false,
    },
    performance = {
        rtp = {
            reset = false
        }
    },
    rocks = {
        enabled = true,
        hererocks = true,
    }
})

vim.cmd [[ colorscheme melange ]]
