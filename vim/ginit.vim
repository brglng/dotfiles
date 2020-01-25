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
