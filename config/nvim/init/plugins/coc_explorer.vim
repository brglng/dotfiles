if !has('nvim') && !zpan#is_sudo()
    autocmd FileType coc-explorer setlocal foldcolumn=0
endif
