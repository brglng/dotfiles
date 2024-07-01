return {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        "neovim/nvim-lspconfig"
    },
    opts = {
        ensure_installed = {
            "bashls",
            "clangd",
            "cmake",
            "lua_ls",
            "marksman",
            "pyright",
            "rust_analyzer",
            "tsserver",
            "vimls"
        }
    }
}
