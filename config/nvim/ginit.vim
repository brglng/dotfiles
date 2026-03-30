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
endif

if exists('g:GuiLoaded')
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
