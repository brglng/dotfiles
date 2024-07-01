return {
    "savq/melange-nvim",
    priority = 1000,
    config = function ()
        vim.cmd [[ autocmd ColorScheme melange highlight! clear Cursor ]]
        vim.cmd [[ autocmd ColorScheme melange highlight! Cursor gui=reverse cterm=reverse ]]
        vim.cmd [[ autocmd ColorScheme melange if &background == "light" | highlight! link NotifyINFOIcon DiagnosticInfo | endif ]]
        vim.cmd [[ autocmd ColorScheme melange if &background == "light" | highlight! link NotifyINFOTitle DiagnosticInfo | endif ]]
        vim.cmd [[ autocmd OptionSet background if g:colors_name == "melange" && &background == "light" | highlight! link NotifyINFOTitle DiagnosticInfo | endif ]]
        vim.cmd [[ autocmd OptionSet background if g:colors_name == "melange" && &background == "light" | highlight! link NotifyINFOTitle DiagnosticInfo | endif ]]
    end
}
