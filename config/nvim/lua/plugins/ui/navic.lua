return {
    "SmiteshP/nvim-navic",
    enabled = true,
    -- event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    lazy = true,
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
