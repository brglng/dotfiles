return {
    {
        "williamboman/mason.nvim",
        -- event = "VeryLazy",
        opts = {}
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            ensure_installed = {
                "bash-language-server",
                "clangd",
                "clang-format",
                "cmake-language-server",
                "cmakelang",
                "cmakelint",
                "codelldb",
                "cpplint",
                "cpptools",
                "css-lsp",
                "dhall-lsp",
                "docker-compose-language-service",
                "dockerfile-language-server",
                "gh-actions-language-server",
                "gradle_ls",
                "html-lsp",
                "json-lsp",
                "lemminx",
                "lua-language-server",
                "marksman",
                "matlab-language-server",
                "mypy",
                "nickel-lang-lsp",
                "perlnavigator",
                "powershell-editor-services",
                "prettierd",
                "pyright",
                "ruff",
                "rust-analyzer",
                "stylua",
                "texlab",
                "typescript-language-server",
                "vim-language-server",
                "yaml-language-server"
            }
        }
    }
}
