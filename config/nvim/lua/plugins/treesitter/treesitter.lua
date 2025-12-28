return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufWritePost", "BufNewFile"  },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    init = function(plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treesitter** module to be loaded in time.
        -- Luckily, the only things that those plugins need are the custom queries, which we make available
        -- during startup.
        require("lazy.core.loader").add_to_rtp(plugin)
        require("nvim-treesitter.query_predicates")
    end,
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
        incremental_selection = {
            enable = true,
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

        -- require("nvim-treesitter").install(opts.ensure_installed)
        -- if opts.auto_install then
        --     vim.api.nvim_create_autocmd('FileType', {
        --         group = vim.api.nvim_create_augroup('treesitter.setup', {}),
        --         callback = function(args)
        --             local buf = args.buf
        --             local filetype = args.match
        --
        --             -- you need some mechanism to avoid running on buffers that do not
        --             -- correspond to a language (like oil.nvim buffers), this implementation
        --             -- checks if a parser exists for the current language
        --             local language = vim.treesitter.language.get_lang(filetype) or filetype
        --             if vim.treesitter.language.add(language) then
        --                 vim.wo.foldmethod = 'expr'
        --                 vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        --
        --                 if opts.highlight.enable then
        --                     vim.treesitter.start(buf, language)
        --                 end
        --
        --                 if opts.indent.enable then
        --                     vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        --                 end
        --             end
        --         end,
        --     })
        -- end
    end
}
