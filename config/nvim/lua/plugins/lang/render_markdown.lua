return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    ft = { 'markdown', 'rmd', 'quarto', 'Avante', 'codecompanion' },
    opts = {
        file_types = { 'markdown', 'rmd', 'quarto', 'Avante', 'codecompanion' },
    }
}
