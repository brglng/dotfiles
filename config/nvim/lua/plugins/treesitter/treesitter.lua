return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        { "nushell/tree-sitter-nu", lazy = true, ft = 'nu' }
    },
    build = ":TSUpdate",
    lazy = false,
    opts = {
        ensure_installed = {
            "bash",
            "c",
            "cmake",
            "cpp",
            "css",
            "diff",
            "dockerfile",
            "doxygen",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "go",
            "html",
            "http",
            "ini",
            "javascript",
            "json",
            "json5",
            "jsonc",
            "latex",
            "lua",
            "make",
            "markdown",
            "markdown_inline",
            "matlab",
            "ninja",
            "norg",
            "nu",
            "objc",
            "perl",
            "python",
            "query",
            "regex",
            "ron",
            "rst",
            "rust",
            "toml",
            "tsx",
            "typescript",
            "vala",
            "vue",
            "vim",
            "vimdoc",
            "xml",
            "yaml"
        },
        sync_install = vim.fn.has('win32') == 1,
        auto_install = true,
        highlight = {
            enable = true,
            -- additional_vim_regex_highlighting = false
        },
        indent = {
            enable = true,
        }
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end
}
