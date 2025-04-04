return {
    "SuperBo/fugit2.nvim",
    cond = function() return vim.uv.os_uname().sysname ~= "Windows_NT" end,
    dependencies = {
        'MunifTanjim/nui.nvim',
        'echasnovski/mini.icons',
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
        local function set_fugit2_colors()
            if not vim.g.neovide then
                vim.api.nvim_set_hl(0, 'NormalFloat', { bg = nil })
                vim.api.nvim_set_hl(0, 'FloatBorder', { bg = nil })
            end
        end
        set_fugit2_colors()
        vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
            callback = function()
                set_fugit2_colors()
            end,
        })
        vim.api.nvim_create_autocmd({ 'OptionSet' }, {
            pattern = { 'background' },
            callback = function()
                set_fugit2_colors()
            end,
        })
    end,
}
