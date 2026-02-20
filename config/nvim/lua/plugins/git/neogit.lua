return {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
        -- 'sindrets/diffview.nvim',
        "esmuellert/codediff.nvim",
        "nvim-lua/plenary.nvim",
    },
    opts = {
        disable_commit_confirmation = true,
        graph_style = 'kitty',
        -- kind = 'split',
        telescope_sorter = function()
            return require("telescope").extensions.fzf.native_fzf_sorter()
        end,
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
        { '<Leader>gf', mode = { "n" }, function() require("neogit").open({ "fetch", kind = "split" }) end, desc = 'Neogit fetch' },
        { '<Leader>gl', mode = { "n" }, function() require("neogit").open({ "log", kind = "split" })() end, desc = 'Neogit log' },
        { '<Leader>gla', mode = { "n" }, function() require("neogit").action("log", 'log_all_references', { '--graph', '--decorate', '--date-order' })() end, desc = 'Neogit log all references' },
        { '<Leader>gll', mode = { "n" }, "<Cmd>NeogitLogCurrent<CR>", desc = 'Neogit log current' },
        { '<Leader>gp', mode = { "n" }, function() require("neogit").open({ "pull", kind = "split" }) end, desc = 'Neogit pull' },
        { '<Leader>gP', mode = { "n" }, function() require("neogit").open({ "push", kind = "split" }) end, desc = 'Neogit push' },
        { '<Leader>gs', mode = { "n" }, function() require("neogit").open({ kind = "split" }) end, desc = 'Neogit split' },
    }
}
