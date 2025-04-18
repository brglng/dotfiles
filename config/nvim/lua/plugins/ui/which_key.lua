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
                    -- return {"▔", "▔" ,"▔", " ", " ", " ", " ", " " }
                    return {"─", "─" ,"─", " ", " ", " ", " ", " " }
                end
            end)(),
            -- border = {"", "" ,"", "", "", "", "", "" },
            -- border = 'rounded'
            title = true,
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

        local brglng = require("brglng")
        if not vim.g.neovide then
            brglng.hl.transform_tbl {
                WhichKeyTitle = { fg = "FloatTitle.fg", bg = "NormalFloat.bg" },
                WhichKeyBorder = { fg = "WinSeparator.fg", bg = "NormalFloat.bg" },
                WhichKeyNormal = { link = "NormalFloat" },
            }
        end

        require("which-key").add {
            { "<Leader>b", group = "Buffer" },
            { "<Leader>c", group = "Code" },
            { "<Leader>cc", group = "Call Hierarchy" },
            { "<Leader>d", group = "Debug" },
            { "<Leader>f", group = "Fuzzy Finder" },
            { "<Leader>g", group = "Git" },
            { "<Leader>h", group = "Hunk" },
            { "<Leader>s", group = "Search & Replace", mode = { "n", "v" } },
            { "<Leader>sr", mode = "n", ":.,$s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>", desc = "Search & Ask for Replace from Cursor to End" },
            { "<Leader>sg", mode = "n", ":%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>", desc = "Search & Ask for Replace in Whole Buffer" },
            { "<Leader>sR", mode = "n", ":.,$s/\\<<C-r><C-w>\\>//g<Left><Left>", desc = "Search & Replace from Cursor to End" },
            { "<Leader>sG", mode = "n", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", desc = "Search & Replace in Whole Buffer" },
            -- { "<Leader>w", group = "Window" }
        }
    end
}
