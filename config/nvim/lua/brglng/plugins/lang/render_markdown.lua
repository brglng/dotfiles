return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.icons",
    },
    ft = { 'markdown', 'rmd', 'quarto', 'Avante', 'codecompanion' },
    opts = {
        file_types = { 'markdown', 'rmd', 'quarto', 'Avante', 'codecompanion' },
        latex = {
            enabled = false,
            highlight = "Normal"
        }
    },
    config = function(_, opts)
        require('render-markdown').setup(opts)
        -- require("brglng.hl").transform_tbl {
        --     RenderMarkdownCode = { bg = nil },
        --     RenderMarkdownCodeInline = { bg = nil }
        -- }
    end
}
