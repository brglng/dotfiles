return {
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        opts = {
            ui = (function()
                if not vim.g.neovide then
                    return {
                        border = {
                            {"╭", "Normal"},
                            {"─", "Normal"},
                            {"╮", "Normal"},
                            {"│", "Normal"},
                            {"╯", "Normal"},
                            {"─", "Normal"},
                            {"╰", "Normal"},
                            {"│", "Normal"},
                        },
                        backdrop = 100
                    }
                end
            end)(),
        },
        config = function(_, opts)
            require("mason").setup(opts)
            if not vim.g.neovide then
                require("brglng.hl").transform_tbl {
                    MasonNormal = { link = "Normal" }
                }
            end
        end
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            ensure_installed = {
                -- "basedpyright",
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
                "emmylua_ls",
                "gh-actions-language-server",
                "html-lsp",
                "json-lsp",
                "lemminx",
                -- "lua-language-server",
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
                "shellcheck",
                "stylua",
                "texlab",
                "ty",
                "typescript-language-server",
                "vim-language-server",
                "yaml-language-server"
            }
        }
    }
}
