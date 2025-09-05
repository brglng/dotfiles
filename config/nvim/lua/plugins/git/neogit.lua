return {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
        'sindrets/diffview.nvim',
        "nvim-lua/plenary.nvim",
    },
    opts = {
        disable_commit_confirmation = true,
        graph_style = 'kitty',
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
        { '<Leader>gg', mode = { "n" }, function() require("neogit").open() end, desc = 'Neogit' },
        { '<Leader>gb', mode = { "n" }, function() require("neogit").open({ "branch", kind = "split" }) end, desc = 'Neogit branch' },
        { '<Leader>gc', mode = { "n" }, function() require("neogit").open({ "commit", kind = "split" }) end, desc = 'Neogit commit' },
        { '<Leader>gla', mode = { "n" }, function() require("neogit").action("log", 'log_all_references', { '--graph', '--decorate' })() end, desc = 'Neogit log' },
        { '<Leader>gll', mode = { "n" }, "<Cmd>NeogitLogCurrent<CR>", desc = 'NeogitLogCurrent' },
        { '<Leader>gs', mode = { "n" }, function() require("neogit").open({ kind = "split" }) end, desc = 'Neogit split' },
    }
}
