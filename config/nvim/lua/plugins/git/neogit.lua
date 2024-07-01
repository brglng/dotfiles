return {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
        'sindrets/diffview.nvim',
        "nvim-lua/plenary.nvim",
        "ibhagwan/fzf-lua"
    },
    config = function()
        require("neogit").setup {
            disable_commit_confirmation = true,
            integrations = {
                diffview = true
            }
        }

        vim.cmd [[ autocmd FileType Neogit* setlocal foldcolumn=0 nofoldenable ]]
    end
}
