if !has('nvim') && !zpan#is_sudo()
    augroup Smartf
        autocmd User SmartfEnter :hi Conceal ctermfg=220 guifg=#FF5500
        autocmd User SmartfLeave :hi Conceal ctermfg=239 guifg=#504945
    augroup end
endif
