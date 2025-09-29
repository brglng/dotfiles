return {
    "nvim-treesitter/nvim-treesitter",
    -- branch = "main",
    dependencies = {
        { "nushell/tree-sitter-nu", lazy = true, ft = 'nu' },
    },
    build = ":TSUpdate",
    lazy = false,
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
            "vala",
            "vue",
            "vim",
            "vimdoc",
            "xml",
            "yaml"
        },
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
        require("nvim-treesitter.configs").setup(opts)

    --     enable if switch to main branch
    --     require("nvim-treesitter").install(opts.ensure_installed)
    --     if opts.auto_install then
    --         vim.api.nvim_create_autocmd('FileType', {
    --             group = vim.api.nvim_create_augroup('treesitter.setup', {}),
    --             callback = function(args)
    --                 local buf = args.buf
    --                 local filetype = args.match
    --
    --                 -- you need some mechanism to avoid running on buffers that do not
    --                 -- correspond to a language (like oil.nvim buffers), this implementation
    --                 -- checks if a parser exists for the current language
    --                 local language = vim.treesitter.language.get_lang(filetype) or filetype
    --                 if vim.treesitter.language.add(language) then
    --                     vim.wo.foldmethod = 'expr'
    --                     vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    --
    --                     if opts.highlight.enable then
    --                         vim.treesitter.start(buf, language)
    --                     end
    --
    --                     if opts.indent.enable then
    --                         vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    --                     end
    --                 end
    --             end,
    --         })
    --     end
    end
}
