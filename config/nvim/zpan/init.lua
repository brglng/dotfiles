vim.opt.mousemoveevent = true

require("catppuccin").setup()

require("tokyonight").setup({
    style = "night",
})

local actions = require("diffview.actions")
require("diffview").setup {}

require('neogit').setup {
    disable_commit_confirmation = true,
    integrations = {
        diffview = true
    },
    kind = 'replace',
    sections = {
        unstaged = {
            folded = false
        },
        staged = {
            folded = false
        },
        untracked = {
            folded = false
        },
        stashes = {
            folded = false
        },
        unpulled = {
            folded = true
        },
        unmerged = {
            folded = false
        },
        recent = {
            folded = true
        },
  },
}

require("bufferline").setup {
    options = {
        diagnostics = "coc",
        highlights = require("catppuccin.groups.integrations.bufferline").get(),
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
                text = "[Explorer]",
                text_align = "left",
                separator = true
            },
            {
                filetype = "vista",
                text = "[Outline]",
                text_align = "left",
                separator = true
            },
            {
                filetype = "undotree",
                text = "[Undo Tree]",
                text_align = "left",
                separator = true
            },
        },
    }
}

require("indent_blankline").setup {
    show_end_of_line = false,
    filetype_exclude = {"startify"}
}

require("scrollbar").setup()
