return {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
        'sindrets/diffview.nvim',
        "nvim-lua/plenary.nvim",
        "ibhagwan/fzf-lua"
    },
    opts = {
        disable_commit_confirmation = true,
        graph_style = 'unicode',
        -- kind = 'split',
        integrations = {
            diffview = true
        },
        log_view = {
            -- kind = 'split'
        }
    },
    config = function(_, opts)
        local neogit = require('neogit')
        neogit.setup(opts)
        vim.cmd [[ autocmd FileType Neogit* setlocal foldcolumn=0 nofoldenable ]]
        vim.cmd [[ autocmd FileType NeogitStatus,NeogitPopup,NeogitLogView wincmd J ]]
    end,
    keys = {
        { '<Leader>gg', '<Cmd>Neogit<CR>', desc = 'Neogit' },
        { '<Leader>gl', '<Cmd>Neogit log<CR>', desc = 'Neogit Log' },
    }
}
