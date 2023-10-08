require('bufferline').setup({
    options = {
        diagnostics = "coc",
        hover = {
            enabled = true,
            delay = 20,
            reveal = {'close'}
        },
        numbers = function(opts)
            return string.format('%s:%s', opts.ordinal, opts.id)
        end,
        offsets = {
            {
                filetype = "coc-explorer",
                text = " CocExplorer",
                text_align = "left",
                separator = false
            },
            {
                filetype = "vista",
                text = " Vista",
                text_align = "left",
                separator = false
            },
            {
                filetype = "undotree",
                text = " UndoTree",
                text_align = "left",
                separator = false
            },
            {
                filetype = "neo-tree",
                text = " NeoTree",
                text_align = "left",
                separator = false
            }
        },
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
})
