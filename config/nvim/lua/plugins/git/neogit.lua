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
        { '<Leader>g', mode = { "n" }, function() require("neogit").open() end, desc = 'Neogit' },
    }
}
