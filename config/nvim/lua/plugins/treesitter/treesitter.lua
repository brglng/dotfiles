return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        { "nushell/tree-sitter-nu", lazy = true, ft = 'nu' },
        "RRethy/nvim-treesitter-endwise",
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treesitter** module to be loaded in time.
        -- Luckily, the only things that those plugins need are the custom queries, which we make available
        -- during startup.
        require("lazy.core.loader").add_to_rtp(plugin)
        require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
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
            "nickel",
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
            -- "vala",
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
        },
        endwise = {
            enable = true,
        }
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end
}
