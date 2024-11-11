return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    lazy = true,
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        -- preset = "modern",
        win = {
            -- width = '100%',
            border = (function()
                if vim.g.neovide then
                    return "none"
                else
                    return {"▔", "▔" ,"▔", " ", " ", " ", " ", " " }
                end
            end)(),
            -- border = {"", "" ,"", "", "", "", "", "" },
            -- border = 'rounded'
            title = false,
            title_pos = "center",
        },
        layout = {
            align = "center"
        },
        icons = {
            rules = false
        }
    },
    config = function(_, opts)
        require('which-key').setup(opts)

        local colorutil = require('brglng.colorutil')
        local set_which_key_color = function()
            local WinSeparator = vim.api.nvim_get_hl(0, { name = 'WinSeparator', link = false })
            -- local WhichKeyFloat = vim.api.nvim_get_hl(0, { name = 'WhichKeyFloat', link = false })
            local WhichKeyFloat = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
            local Normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
            if vim.o.background == 'dark' then
                vim.api.nvim_set_hl(0, 'WhichKeyBorder', {
                    fg = colorutil.reduce_value(Normal.bg, 0.002),
                    bg = WhichKeyFloat.bg
                })
            else
                vim.api.nvim_set_hl(0, 'WhichKeyBorder', {
                    fg = colorutil.transparency(WinSeparator.fg, Normal.bg, 0.2),
                    bg = WhichKeyFloat.bg
                })
            end
            -- vim.api.nvim_set_hl(0, 'WhichKeyFloat', { link = 'Normal' })
        end
        set_which_key_color()
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_which_key_color
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_which_key_color
        })

        require("which-key").add {
            { "<Leader>c", group = "Code" },
            { "<Leader>d", group = "Debug" },
            { "<Leader>f", group = "Fuzzy Finder" },
            { "<Leader>g", group = "Git" },
            { "<Leader>h", group = "Hunk" },
            { "<Leader>s", group = "Search & Replace", mode = { "n", "v" } },
            { "<Leader>sr", mode = "n", ":.,$s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>", desc = "Search & Ask for Replace from Cursor to End" },
            { "<Leader>sg", mode = "n", ":%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>", desc = "Search & Ask for Replace in Whole Buffer" },
            { "<Leader>sR", mode = "n", ":.,$s/\\<<C-r><C-w>\\>//g<Left><Left>", desc = "Search & Replace from Cursor to End" },
            { "<Leader>sG", mode = "n", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", desc = "Search & Replace in Whole Buffer" },
            { "<Leader>w", group = "Window" }
        }
    end
}
