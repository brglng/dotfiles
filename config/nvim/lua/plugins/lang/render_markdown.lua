return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.icons",
    },
    ft = { 'markdown', 'rmd', 'quarto', 'Avante', 'codecompanion' },
    opts = {
        file_types = { 'markdown', 'rmd', 'quarto', 'Avante', 'codecompanion' },
    }
}
