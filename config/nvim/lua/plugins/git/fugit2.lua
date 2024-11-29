return {
    "SuperBo/fugit2.nvim",
    cond = false,
    dependencies = {
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
        'nvim-lua/plenary.nvim',
        {
            'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
            dependencies = { 'stevearc/dressing.nvim' }
        },
        {
            'sindrets/diffview.nvim'
        }
    },
    cmd = { 'Fugit2', 'Fugit2Blame', 'Fugit2Diff', 'Fugit2Graph' },
    opts = {
        width = '62%',
        height = '90%',
        external_diffview = true,
    },
    keys = {
        { '<Leader>gf', mode = 'n', '<Cmd>Fugit2<CR>', desc = 'Fugit2' },
        -- { '<Leader>gl', mode = 'n', '<Cmd>Fugit2Graph<CR>', desc = 'Graph' },
    }
}
