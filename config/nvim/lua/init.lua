vim.o.mousemoveevent = true
vim.o.splitkeep = "screen"
-- vim.o.termsync = false
vim.g.maplocalleader = ","

if vim.g.neovide then
    if vim.uv.os_uname().sysname == "Windows_NT" or vim.fn.has("wsl") then
        vim.g.neovide_scale_factor = 10.0 / 14.0
    end
    -- vim.o.linespace = -0
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.experimental_layer_grouping = true
    vim.g.neovide_input_macos_option_key_is_meta = 'both'
    -- vim.g.neovide_floating_corner_radius = 0.2
    -- vim.g.neovide_refresh_rate_idle = 60
    -- vim.g.neovide_no_idle = true
    -- vim.g.neovide_cursor_trail_size = 0.2
    vim.g.neovide_cursor_vfx_mode = "torpedo"
    -- vim.g.neovide_cursor_vfx_particle_density = 20.0

    -- local function my_set_ime(args)
    --     if args.event:match("Enter$") then
    --         vim.g.neovide_input_ime = true
    --     else
    --         vim.g.neovide_input_ime = false
    --     end
    -- end
    --
    -- local my_ime_input = vim.api.nvim_create_augroup("my_ime_input", { clear = true })
    --
    -- vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    --     group = my_ime_input,
    --     pattern = "*",
    --     callback = my_set_ime
    -- })
    --
    -- vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
    --     group = my_ime_input,
    --     pattern = "[/\\?]",
    --     callback = my_set_ime
    -- })
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

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.hl.on_yank { higroup = "CurSearch", timeout = 300 }
    end
})

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

vim.cmd.colorscheme("rose-pine")
