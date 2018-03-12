" e.g.,
"   call brglng#hilink('MyHighlightName', 'StatusLineNC', 'bg', 'Special', 'fg')
function! brglng#hilink(hiname, ...)
    exe "au Syntax,ColorScheme * call call('s:brglng_hilink', " . string([a:hiname] + a:000) . ')'
endfunction

function! s:brglng_hilink(hiname, ...)
    let hi_str = 'hi! ' . a:hiname
    for i in range(0, a:0 - 1, 2)
        let tg_hlname = a:000[i]
        let tg_hlattrname = a:000[i+1]
        let tg_hlid = hlID(tg_hlname)
        let tg_synid = synIDtrans(tg_hlid)
        let is_reverse = synIDattr(tg_synid, 'reverse')
        if tg_hlattrname == 'bg'
            if is_reverse
                let tg_hlattr = synIDattr(tg_synid, 'fg')
            else
                let tg_hlattr = synIDattr(tg_synid, 'bg')
            endif
            if has('gui_running')
                let hi_str = hi_str . ' ' . 'guibg=' . tg_hlattr
            else
                let hi_str = hi_str . ' ' . 'ctermbg=' . tg_hlattr
            endif
        elseif tg_hlattrname == 'fg'
            if is_reverse
                let tg_hlattr = synIDattr(tg_synid, 'bg')
            else
                let tg_hlattr = synIDattr(tg_synid, 'fg')
            endif
            if has('gui_running')
                let hi_str = hi_str . ' ' . 'guifg=' . tg_hlattr
            else
                let hi_str = hi_str . ' ' . 'ctermfg=' . tg_hlattr
            endif
        endif
    endfor
    exe hi_str
endfunction
