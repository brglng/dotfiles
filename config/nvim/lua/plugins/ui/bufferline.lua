return {
    "akinsho/bufferline.nvim",
    enabled = true,
    version = "*",
    dependencies = {
        "echasnovski/mini.icons",
    },
    event =  "VeryLazy",
    opts = {
        options = {
            max_name_length = 40,
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
                    separator = true,
                },
                {
                    filetype = "vista",
                    text = "Vista",
                    text_align = "center",
                    separator = true
                },
                {
                    filetype = "undotree",
                    text = "UndoTree",
                    text_align = "center",
                    separator = true
                },
                {
                    filetype = "neo-tree",
                    text = "NeoTree",
                    text_align = "center",
                    separator = true
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

    	    pick_selected = {
    	        fg = "red",
    	        bold = true,
    	        italic = false
    	    },
    	    pick_visible = {
    	        fg = "red",
    	        bold = true,
    	        italic = false
    	    },
    	    pick = {
    	        fg = "red",
    	        bold = true,
    	        italic = false
    	    },
        }
    },
    config = function(_, opts)
        require("bufferline").setup(opts)
        if vim.o.ft == "alpha" then
            vim.o.showtabline = 0
        end
    end,
    keys = {
        { '[b', mode = 'n', "<Cmd>BufferLineCyclePrev<CR>", desc = 'Previous Buffer' },
        { ']b', mode = 'n', "<Cmd>BufferLineCycleNext<CR>", desc = 'Next Buffer' },
        -- { "<Leader>b", mode = "n",  desc = "Buffer" },
        -- { "<Leader>bb", mode = "n",  "<Cmd>BufferLinePick<CR>", desc = "Buffer Pick" },
        -- { "<Leader>bd", mode = "n",  "<Cmd>BufferLinePickClose<CR>", desc = "Buffer Pick Close" },
        -- { "<Leader>bh", mode = "n",  "<Cmd>BufferLineMovePrev<CR>", desc = "Buffer Move Left" },
        -- { "<Leader>bl", mode = "n",  "<Cmd>BufferLineMoveNext<CR>", desc = "Buffer Move Right" },
    }
}
