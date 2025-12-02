return {
    "SuperBo/fugit2.nvim",
    enabled = false,
    cond = function() return vim.uv.os_uname().sysname ~= "Windows_NT" end,
    dependencies = {
        'MunifTanjim/nui.nvim',
        "echasnovski/mini.icons",
        'nvim-lua/plenary.nvim',
        {
            'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
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
    },
    config = function(_, opts)
        require('fugit2').setup(opts)
        vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
            pattern = { '*' },
            callback = function()
                if vim.o.filetype:find("^fugit2.*") then
                    if vim.g.neovide then
                        vim.o.winhighlight = "Normal:NormalFloat"
                    else
                        vim.o.winhighlight = "NormalFloat:Normal,FloatBorder:Normal"
                    end
                end
            end,
        })
    end,
}
