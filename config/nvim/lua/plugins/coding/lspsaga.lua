return {
    "nvimdev/lspsaga.nvim",
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons'
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
        { "<Leader>cc", "<Cmd>Lspsaga incomping_calls<CR>", mode = "n", desc = "Callers" },
        { "<Leader>cC", "<Cmd>Lspsaga outgoing_calls<CR>", mode = "n", desc = "Callees" },
        { "<Leader>cD", "<Cmd>Lspsaga peek_definition<CR>", mode = "n", desc = "Peek Definitions" },
        { "<Leader>ch", "<Cmd>Lspsaga hover_doc<CR>", mode = "n", desc = "Hover Doc" },
        { "<Leader>co", "<Cmd>Lspsaga outline<CR>", mode = "n", desc = "Outline" },
        { "<Leader>cR", "<Cmd>Lspsaga rename<CR>", mode = "n", desc = "Rename" },
        -- { "K", "<Cmd>Lspsaga hover_doc<CR>", mode = "n", desc = "Hover Doc" },
    }
}
