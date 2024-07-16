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
        integrations = {
            diffview = true
        }
    },
    config = function(_, opts)
        require("neogit").setup(opts)
        vim.cmd [[ autocmd FileType Neogit* setlocal foldcolumn=0 nofoldenable ]]
    end,
    keys = {
        { '<Leader>gg', '<Cmd>Neogit<CR>', desc = 'Neogit' }
    }
}
