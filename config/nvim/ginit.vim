if has('gui_running')
    set mousehide
    set lines=48
    set columns=100
    " if has('win32')
    " autocmd GUIEnter * simalt ~x
    " endif

    set guioptions+=aA
    set guioptions-=T
    " set guioptions-=r
    " set guioptions-=L
    set guioptions-=l
    set guioptions-=b
    if has('unix') && !has('mac') && !has('macunix')
        set guioptions-=m
    endif

    " Alt-Space is System menu
    if has("gui_running")
        noremap <M-Space> :simalt ~<CR>
        inoremap <M-Space> <C-O>:simalt ~<CR>
        cnoremap <M-Space> <C-C>:simalt ~<CR>
    endif

    if has('win32') || has('win64')
        set guifont=FiraCodeNerdFontComplete-Regular:h13
    elseif has('mac') || has('macunix')
        set guifont=FiraCodeNerdFontComplete-Regular:h13
    elseif has('unix')
        if system('uname -s') == "Linux\n"
            " font height bug of GVim on Ubuntu
            let $LC_ALL='en_US.UTF-8'
        endif
        set guifont=Fura\ Code\ Nerd\ Font\ 11
    endif
endif

if exists('g:GuiLoaded')
    GuiFont! FuraCode Nerd Font:h11
    GuiLinespace 0
    GuiTabline 0
endif

if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility
    set guifont=FuraCode\ Nerd\ Font:h15
    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
    " FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true

    FVimFontAntialias v:true
    FVimFontAutohint v:false
    FVimFontSubpixel v:false
    FVimFontLcdRender v:true
    FVimFontHintLevel 'none'
endif

" vim: ts=8 sts=4 sw=4 et
