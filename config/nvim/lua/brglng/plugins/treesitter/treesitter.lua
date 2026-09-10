return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "MeanderingProgrammer/treesitter-modules.nvim"
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufWritePost", "BufNewFile"  },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
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
            "latex",
            "lua",
            "make",
            "markdown",
            "markdown_inline",
            "matlab",
            "nickel",
            "ninja",
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
            -- C/C++/cmake use the Lua bridge below (backslash splices for
            -- C/C++; everything else delegates to treesitter queries).
            disable = { "c", "cpp", "cmake" },
        },
        endwise = {
            enable = true,
        }
    },
    config = function(_, opts)
        -- require("nvim-treesitter.configs").setup(opts)

        require("treesitter-modules").setup(opts)

        local indent_group = vim.api.nvim_create_augroup("brglng-treesitter-indent", {})
        vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "FileType" }, {
            group = indent_group,
            pattern = { "c", "cpp", "cmake" },
            callback = function(args)
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(args.buf)
                        and (vim.bo[args.buf].filetype == "c"
                            or vim.bo[args.buf].filetype == "cpp"
                            or vim.bo[args.buf].filetype == "cmake") then
                        vim.bo[args.buf].indentexpr =
                            "v:lua.require'brglng.treesitter_indent'.indentexpr()"
                    end
                end)
            end,
        })

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
