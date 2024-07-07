return {
    'goolord/alpha-nvim',
    enabled = false,
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-lua/plenary.nvim'
    },
    config = function ()
        require('alpha').setup(
            require('alpha.themes.startify').config
        )
    end
}
