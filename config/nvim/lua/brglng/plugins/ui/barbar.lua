return {
    "romgrk/barbar.nvim",
    enabled = false,
    dependencies = {
        'lewis6991/gitsigns.nvim',
        "echasnovski/mini.icons",
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
        local brglng = require("brglng")
        brglng.hl.transform_tbl {
            TabLineFill = { fg = "TabLineFill.fg", bg = { "darken", from = "Normal.bg", amount = 0.2 } },
            BufferCurrent = { fg = "Normal.fg", bg = "Normal.bg", bold = true },
            BufferCurrentMod = { fg = "DiagnosticError.fg", bg = "Normal.bg", bold = true },
            BufferCurrentSign = { fg = "Special.fg", bg = "Normal.bg", bold = true },
            BufferCurrentTarget = { fg = "red", bg = "Normal.bg", bold = true },
            BufferInactive = { fg = "Comment.fg", bg = { "darken", from = "Normal.bg", amount = 0.1 } },
            BufferInactiveSign = {
                fg = { "darken",  from = "Normal.bg", amount = 0.2 },
                bg = { "darken", from = "Normal.bg", amount = 0.1 }
            },
            BufferInactiveTarget = { fg = "red", bg = { "darken", from = "Normal.bg", amount = 0.1 }, bold = true },
            BufferVisible = { fg = "Comment.fg", bg = { "darken", from = "Normal.bg", amount = 0.05 } },
            BufferVisibleSign = {
                fg = { "darken", from = "Normal.bg", amount = 0.2 },
                bg = { "darken", from = "Normal.bg", amount = 0.05 }
            },
            BufferVisibleTarget = { fg = "red", bg = { "darken", from = "Normal.bg", amount = 0.05 }, bold = true },
            BufferOffset = { fg = "Comment.fg", bg = "NormalFloat.bg,Normal.bg" },
        }

        require("barbar").setup(opts)

        if vim.o.ft == "alpha" then
            vim.o.showtabline = 0
        end
    end,
}
