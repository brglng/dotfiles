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
                "basedpyright",
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
                -- "emmylua_ls",
                "gh-actions-language-server",
                "gradle_ls",
                "html-lsp",
                "json-lsp",
                "lemminx",
                "lua-language-server",
                "marksman",
                "matlab-language-server",
                "nickel-lang-lsp",
                "perlnavigator",
                "powershell-editor-services",
                "prettierd",
                -- "pyrefly",
                -- "pyright",
                "ruff",
                "rust-analyzer",
                "stylua",
                "texlab",
                -- "ty",
                "typescript-language-server",
                "vim-language-server",
                "yaml-language-server"
            }
        }
    }
}
