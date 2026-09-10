local dotfiles_dir = vim.fs.normalize(vim.fs.dirname(debug.getinfo(1, "S").source:sub(2)) .. "../../..")

package.path = dotfiles_dir .. "/lua/?.lua;"
    .. dotfiles_dir .. "/lua/?/init.lua;"
    .. package.path

vim.cmd("source " .. dotfiles_dir .. "/config/nvim/init.vim")

vim.o.mousemoveevent = true
vim.o.splitkeep = "screen"
vim.o.termsync = true
vim.g.maplocalleader = "\\"

if vim.g.neovide then
    if vim.uv.os_uname().sysname == "Windows_NT" or vim.fn.has("wsl") == 1 then
        vim.g.neovide_scale_factor = 10.0 / 14.0
    end
    -- vim.o.linespace = -0
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_progress_bar_enabled = true
    vim.g.experimental_layer_grouping = true
    vim.g.neovide_input_macos_option_key_is_meta = 'both'
    -- vim.g.neovide_floating_corner_radius = 0.2
    -- vim.g.neovide_refresh_rate_idle = 60
    -- vim.g.neovide_no_idle = true
    -- vim.g.neovide_cursor_trail_size = 0.2
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
    vim.g.neovide_cursor_vfx_particle_density = 20.0

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
            function(_, bufnr)
                local shebang = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
                if vim.regex([[^#!.*\<nu\>]]):match_str(shebang) then
                    return "nu"
                end
            end,
            { priority = -math.huge },
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

vim.opt.viewoptions:append("folds")
vim.opt.sessionoptions:remove("folds")

-- Delayed restoration, after filetype/fold setup.
local auto_view_group = vim.api.nvim_create_augroup("AutoSaveView", { clear = true })

local function valid_view_buffer(buf)
    return vim.api.nvim_buf_is_valid(buf)
        and vim.bo[buf].buflisted
        and vim.bo[buf].modifiable
        and vim.bo[buf].bufhidden == ""
        and vim.bo[buf].buftype == ""
end

local function prepare_treesitter_folds(buf, win)
    local ok, foldmethod = pcall(function()
        return vim.wo[win].foldmethod
    end)
    if not ok or foldmethod ~= "expr" then
        return
    end

    local ok_expr, foldexpr = pcall(function()
        return vim.wo[win].foldexpr
    end)
    if not ok_expr or not foldexpr:find("treesitter", 1, true) then
        return
    end

    if not vim.treesitter or not vim.treesitter.language then
        return
    end

    local filetype = vim.bo[buf].filetype
    local ok_lang, lang = pcall(vim.treesitter.language.get_lang, filetype)
    if not ok_lang or not lang then
        return
    end

    local ok_parser, parser = pcall(vim.treesitter.get_parser, buf, lang)
    if ok_parser and parser then
        pcall(function()
            parser:parse()
        end)
    end
end

vim.api.nvim_create_autocmd("BufWinLeave", {
    group = auto_view_group,
    pattern = "?*",
    callback = function(args)
        if valid_view_buffer(args.buf) then
            vim.cmd("silent! mkview")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = auto_view_group,
    pattern = "?*",
    callback = function(args)
        local buf = args.buf
        if not valid_view_buffer(buf) then
            return
        end

        local win = vim.api.nvim_get_current_win()

        vim.schedule(function()
            if not valid_view_buffer(buf)
                or not vim.api.nvim_win_is_valid(win)
                or vim.api.nvim_win_get_buf(win) ~= buf
            then
                return
            end

            prepare_treesitter_folds(buf, win)

            vim.api.nvim_win_call(win, function()
                vim.cmd("silent! loadview")
            end)
        end)
    end,
})

vim.api.nvim_set_hl(0, "LazyNormal", { link = "Normal" })
require("lazy").setup("brglng/plugins", {
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
    concurrency = 4,
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

vim.cmd.colorscheme("rose-pine")

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

-- require('vim._core.ui2').enable()
