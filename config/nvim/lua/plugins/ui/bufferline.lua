return {
    "akinsho/bufferline.nvim",
    enabled = false,
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    event =  "VeryLazy",
    opts = {
        options = {
            diagnostics = "nvim_lsp",
            show_tab_indicators = true,
            always_show_bufferline = true,
            hover = {
                enabled = true,
                delay = 20,
                reveal = {'close'}
            },
            -- numbers = function(opts)
            --     return string.format('%s:%s', opts.ordinal, opts.id)
            -- end,
            numbers = 'buffer_id',
            offsets = {
                {
                    filetype = "coc-explorer",
                    text = "CocExplorer",
                    text_align = "center",
                    separator = false
                },
                {
                    filetype = "vista",
                    text = "Vista",
                    text_align = "center",
                    separator = false
                },
                {
                    filetype = "undotree",
                    text = "UndoTree",
                    text_align = "center",
                    separator = false
                },
                {
                    filetype = "neo-tree",
                    text = "NeoTree",
                    text_align = "center",
                    separator = false
                }
            },
            -- separator_style = { '', '' }
            -- separator_style = 'slant'
        },
        highlights = {
    	    buffer_selected = { italic = false },
            numbers_selected = { italic = false },
    	    diagnostic_selected = { italic = false },
    	    hint_selected = { italic = false },
            hint_diagnostic_selected = { italic = false },
            info_selected = { italic = false },
            info_diagnostic_selected = { italic = false },
            warning_selected = { italic = false },
            warning_diagnostic_selected = { italic = false },
            error_selected = { italic = false },
            error_diagnostic_selected = { italic = false },
            duplicate_selected = { italic = false },
            duplicate_visible = { italic = false },
            duplicate = { italic = false },
    	    pick_selected = { italic = false },
    	    pick_visible = { italic = false },
    	    pick = { italic = false },
        }
    },
    config = function(_, opts)
        require("bufferline").setup(opts)
        if vim.o.ft == "alpha" then
            vim.o.showtabline = 0
        end
    end
}
