return {
    "romgrk/barbar.nvim",
    enabled = false,
    dependencies = {
        'lewis6991/gitsigns.nvim',
        'echasnovski/mini.icons',
    },
    event = { "VeryLazy" },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
        icons = {
            separator_at_end = false,
        },
        sidebar_filetypes = {
            ['neo-tree'] = {
                text = "NeoTree",
                align = "center",
            }
        }
    },
    keys = {
        { '<Leader>b', mode = 'n', "<Cmd>BufferPick<CR>", desc = 'Buffer Pick' },
        { '<Leader>B', mode = 'n', "<Cmd>BufferPickDelete<CR>", desc = 'Buffer Pick Delete' },
        { '[b', mode = 'n', "<Cmd>BufferPrevious<CR>", desc = 'Previous Buffer' },
        { ']b', mode = 'n', "<Cmd>BufferNext<CR>", desc = 'Next Buffer' },
    },
    config = function(_, opts)
        local set_barbar_color = function()
            local brglng = require("brglng")
            local Normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
            local NormalFloat = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
            local DiagnosticError = vim.api.nvim_get_hl(0, { name = 'DiagnosticError', link = false })
            local Comment = vim.api.nvim_get_hl(0, { name = 'Comment', link = false })
            local Special = vim.api.nvim_get_hl(0, { name = 'Special', link = false })

            local fill_bg = brglng.color.darken(Normal.bg, 0.2)
            local inactive_bg = brglng.color.darken(Normal.bg, 0.1)
            local visible_bg = brglng.color.darken(Normal.bg, 0.05)

            vim.api.nvim_set_hl(0, "TabLineFill", {
                bg = fill_bg
            })
            vim.api.nvim_set_hl(0, 'BufferCurrent', {
                fg = Normal.fg,
                bold = true,
                bg = Normal.bg,
            })
            vim.api.nvim_set_hl(0, 'BufferCurrentMod', {
                fg = DiagnosticError.fg,
                bold = true,
                bg = Normal.bg,
            })
            vim.api.nvim_set_hl(0, 'BufferCurrentSign', {
                fg = Special.fg,
                bold = true,
                bg = Normal.bg,
            })
            vim.api.nvim_set_hl(0, 'BufferCurrentTarget', {
                fg = 'red',
                bold = true,
                bg = Normal.bg,
            })
            vim.api.nvim_set_hl(0, 'BufferInactive', {
                fg = Comment.fg,
                bg = inactive_bg
            })
            vim.api.nvim_set_hl(0, 'BufferInactiveSign', {
                fg = fill_bg,
                bg = inactive_bg
            })
            vim.api.nvim_set_hl(0, 'BufferInactiveTarget', {
                fg = 'red',
                bold = true,
                bg = inactive_bg
            })
            vim.api.nvim_set_hl(0, 'BufferVisible', {
                fg = Comment.fg,
                bg = brglng.color.darken(Normal.bg, 0.05),
            })
            vim.api.nvim_set_hl(0, 'BufferVisibleSign', {
                fg = fill_bg,
                bg = visible_bg
            })
            vim.api.nvim_set_hl(0, 'BufferVisibleTarget', {
                fg = 'red',
                bold = true,
                bg = visible_bg
            })
            vim.api.nvim_set_hl(0, "BufferOffset", {
                fg = Comment.fg,
                bg = NormalFloat.bg
            })
        end
        set_barbar_color()
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_barbar_color
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_barbar_color
        })

        require("barbar").setup(opts)

        if vim.o.ft == "alpha" then
            vim.o.showtabline = 0
        end
    end,
}
