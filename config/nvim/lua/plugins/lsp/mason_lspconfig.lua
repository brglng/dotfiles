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
            "dhall_lsp_server",
            "docker_compose_language_service",
            "dockerls",
            "lua_ls",
            "jsonls",
            "marksman",
            "matlab_ls",
            "perlnavigator",
            "powershell_es",
            "pyright",
            "rust_analyzer",
            "ts_ls",
            "vimls",
            "yamlls",
        }
    }
}
