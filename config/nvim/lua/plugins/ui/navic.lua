return {
    "SmiteshP/nvim-navic",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        "neovim/nvim-lspconfig"
    },
    opts = {
        lsp = {
            auto_attach = true
        },
        click = true,
        highlight = true
    }
}
