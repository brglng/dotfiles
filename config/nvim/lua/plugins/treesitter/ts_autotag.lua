return {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    ft = { "html", "javascript", "jsx", "markdown", "typescript", "vue", "xml" },
    opts = {}
}
