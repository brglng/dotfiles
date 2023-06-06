vim.opt.mousemoveevent = false

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
    filetype = {"python"}
}

-- place this in one of your configuration file(s)
local hop = require('hop')
hop.setup()
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR })
end, {remap=true})
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, hint_offset = -1 })
end, {remap=true})
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, hint_offset = 1 })
end, {remap=true})
