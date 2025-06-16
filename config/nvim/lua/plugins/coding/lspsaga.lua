return {
    "nvimdev/lspsaga.nvim",
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        "echasnovski/mini.icons",
    },
    event = "LspAttach",
    opts = {
        code_action = {
            extend_gitsigns = true,
            show_server_name = true,
        },
        diagnostic = {
            diagnostic_only_current = false
        },
        lightbulb = {
            sign = false,
            virtual_text = false
        },
        outline = {
            close_after_jump = true,
            layout = 'float'
        },
        symbol_in_winbar = {
            enable = false,
        },
        hover = {
            enable = false,
        },
        ui = {
            -- border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
            border = "rounded"
        }
    },
    keys = {
        -- { "<Leader>lc", "<Cmd>Lspsaga incomping_calls<CR>", mode = "n", desc = "Callers" },
        -- { "<Leader>lC", "<Cmd>Lspsaga outgoing_calls<CR>", mode = "n", desc = "Callees" },
        { "<Leader>lD", "<Cmd>Lspsaga peek_definition<CR>", mode = "n", desc = "Lspsaga peek_definition" },
        { "<Leader>lh", "<Cmd>Lspsaga hover_doc<CR>", mode = "n", desc = "Lspsaga hover_doc" },
        { "<Leader>lo", "<Cmd>Lspsaga outline<CR>", mode = "n", desc = "Lspsaga outline" },
        { "<Leader>lR", "<Cmd>Lspsaga rename<CR>", mode = "n", desc = "Lspsaga rename" },
    }
}
