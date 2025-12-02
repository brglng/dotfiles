vim.o.mousemoveevent = true
vim.o.splitkeep = "screen"
-- vim.o.termsync = false
vim.g.maplocalleader = ","

if vim.g.neovide then
    if vim.uv.os_uname().sysname == "Windows_NT" or vim.fn.has("wsl") == 1 then
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

if vim.fn.has("win32") == 1 then
--     -- https://github.com/neovim/neovim/issues/25033#issuecomment-1717700044
--     vim.api.nvim_create_autocmd({ "BufAdd" }, {
--         callback = function()
--             local name = vim.api.nvim_buf_get_name(0)
--             if name:sub(2, 2) == ":" then
--                 name = name:gsub("\\", "/"):gsub("^%l", string.upper)
--                 vim.api.nvim_buf_set_name(0, name)
--             end
--         end,
--     })
--
--     -- https://github.com/neovim/neovim/issues/8587#issuecomment-2439415252
--     vim.api.nvim_create_autocmd({ "QuitPre" }, {
--         callback = function ()
--             local files = vim.fs.find(function (name, path)
--                 return name:match("^main%.shada%.tmp%..*")
--             end, { path = vim.fn.stdpath("data") .. "/shada" })
--             for _, file in ipairs(files) do
--                 os.remove(file)
--             end
--         end
--     })
end

-- https://www.reddit.com/r/neovim/comments/f0qx2y/automatically_reload_file_if_contents_changed/
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
        end
    end,
})
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
    pattern = "*",
    callback = function()
        vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
    end,
})

vim.api.nvim_set_hl(0, "LazyNormal", { link = "Normal" })
require("lazy").setup("plugins", {
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
    git = {
        timeout = 3600,
    },
    change_detection = {
        enabled = false,
    },
    performance = {
        -- cache = {
        --     enabled = false,
        -- },
        rtp = {
            reset = false
        }
    },
    rocks = {
        enabled = true,
        hererocks = true,
    },
    ui = (function()
        if not vim.g.neovide then
            return {
                border = {
                    {"╭", "Normal"},
                    {"─", "Normal"},
                    {"╮", "Normal"},
                    {"│", "Normal"},
                    {"╯", "Normal"},
                    {"─", "Normal"},
                    {"╰", "Normal"},
                    {"│", "Normal"},
                },
                backdrop = 100
            }
        end
    end)(),
})
if not vim.g.neovide then
    require("brglng.hl").transform_tbl {
        LazyNormal = { link = "Normal" }
    }
end

vim.cmd.colorscheme("catppuccin")

require("brglng.pixi").setup()

vim.o.exrc = true
local project_root = vim.fs.root(0, { ".nvim.lua", ".nvimrc", ".exrc" })
if project_root then
    vim.uv.chdir(project_root)
else
    if vim.g.neovide and vim.fn.argc(-1) == 0 then
        vim.uv.chdir(vim.env.HOME or vim.env.USERPROFILE)
    end
end
