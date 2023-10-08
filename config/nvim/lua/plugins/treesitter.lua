require("nvim-treesitter.configs").setup({
    ensure_installed = {"bash", "c", "cmake", "cpp", "css", "diff", "dockerfile", "doxygen", "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore", "go", "html", "http", "ini", "javascript", "json", "latex", "lua", "make", "markdown", "markdown_inline", "matlab", "objc", "perl", "python", "query", "regex", "rust", "toml", "tsx", "typescript", "vala", "vue", "vim", "vimdoc", "xml", "yaml"},
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    }
})
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
