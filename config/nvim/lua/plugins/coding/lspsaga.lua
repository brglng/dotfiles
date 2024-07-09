return {
    "nvimdev/lspsaga.nvim",
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons'
    },
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
        ui = {
            -- border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
        }
    }
}
