let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italic = 1
" let g:gruvbox_improved_strings = 1
" let g:gruvbox_improved_warnings = 1
let g:one_allow_italics = 1
let g:quantum_italics = 1
let g:sonokai_style = 'atlantis'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 0

function! s:hi_link(hi_name, fg_hi_name, bg_hi_name)
    let guifg = synIDattr(synIDtrans(hlID(a:fg_hi_name)), 'fg', 'gui')
    if guifg == ''
        let guifg = 'NONE'
    endif
    let ctermfg = synIDattr(synIDtrans(hlID(a:fg_hi_name)), 'fg', 'cterm')
    if ctermfg == ''
        let ctermfg = 'NONE'
    endif
    let guibg = synIDattr(synIDtrans(hlID(a:bg_hi_name)), 'bg', 'gui')
    if guibg == ''
        let guibg = 'NONE'
    endif
    let ctermbg = synIDattr(synIDtrans(hlID(a:bg_hi_name)), 'fg', 'cterm')
    if ctermbg == ''
        let ctermbg = 'NONE'
    endif
    let cmd = 'hi ' . a:hi_name
    if guifg != ''
        let cmd = cmd . ' guifg=' . guifg
    endif
    if ctermfg != ''
        let cmd = cmd . ' ctermfg=' . ctermfg
    endif
    if guibg != ''
        let cmd = cmd . ' guibg=' . guibg
    endif
    if ctermbg != ''
        let cmd = cmd . ' ctermbg=' . ctermbg
    endif
    if guifg != '' || guibg != '' || ctermfg != '' || ctermbg != ''
        execute cmd
    endif
endfunction

function! s:str2rgb(rgb_str)
    call assert_equal(v:t_string, type(a:rgb_str))
    call assert_equal(7, len(a:rgb_str))
    if a:rgb_str[0] == '#'
        return [str2nr(a:rgb_str[1:2], 16), str2nr(a:rgb_str[3:4], 16), str2nr(a:rgb_str[5:6], 16)]
    else
        return [str2nr(a:rgb_str[0:1], 16), str2nr(a:rgb_str[2:3], 16), str2nr(a:rgb_str[4:5], 16)]
    endif
endfunction

function! s:rgb2str(rgb)
    return printf('#%02X%02X%02X', a:rgb[0], a:rgb[1], a:rgb[2])
endfunction

function! s:rgb2hsv(rgb)
    let [r, g, b] = a:rgb
    let rgbmax = max([r, g, b]) + 0.0
    let rgbmin = min([r, g, b]) + 0.0
    if rgbmax == rgbmin
        let h = 0.0
    elseif rgbmax == r && g >= b
        let h = 60.0 * (g - b) / (rgbmax - rgbmin) + 0.0
    elseif rgbmax == r && g < b
        let h = 60.0 * (g - b) / (rgbmax - rgbmin) + 360.0
    elseif rgbmax == g
        let h = 60.0 * (b - r) / (rgbmax - rgbmin) + 120.0
    elseif rgbmax == b
        let h = 60.0 * (r - g) / (rgbmax - rgbmin) + 240.0
    endif
    if rgbmax == 0.0
        let s = 0.0
    else
        let s = 1.0 - rgbmin / rgbmax
    endif
    let v = rgbmax
    return [h, s, v]
endfunction

function! s:hsv2rgb(hsv)
    let [h, s, v] = a:hsv
    let hi = floor(h / 60.0)
    let f = h / 60.0 - hi
    let p = float2nr(v * (1.0 - s))
    let q = float2nr(v * (1.0 - f * s))
    let t = float2nr(v * (1.0 - (1.0 - f) * s))
    if hi == 0
        return [v, t, p]
    elseif hi == 1
        return [q, v, p]
    elseif hi == 2
        return [p, v, t]
    elseif hi == 3
        return [p, q, v]
    elseif hi == 4
        return [t, p, v]
    elseif hi == 5
        return [v, p, q]
    endif
endfunction

function! s:middle_color(rgb1_str, rgb2_str)
    let [h1, s1, v1] = s:rgb2hsv(s:str2rgb(a:rgb1_str))
    let [h2, s2, v2] = s:rgb2hsv(s:str2rgb(a:rgb2_str))
    if abs(h1 - h2) <= 180.0
        let h = (h1 + h2) / 2.0
    else
        let h = ((360.0 - h1) + (360.0 - h2)) / 2.0
    endif
    let s = (s1 + s2) / 2.0
    let v = (v1 + v2) / 2.0
    let rgb = s:hsv2rgb([h, s, v])
    return s:rgb2str([float2nr(rgb[0]), float2nr(rgb[1]), float2nr(rgb[2])])
endfunction

function! s:set_leaderf_highlights()
    let palette = lightline#palette()
    highlight link Lf_hl_cursorline CursorLine
    execute 'hi Lf_hl_popup_inputText guifg=' . palette.normal.middle[0][0] . ' guibg=' . palette.normal.middle[0][1] . ' ctermfg=' . palette.normal.middle[0][2] . ' ctermbg=' . palette.normal.middle[0][3]
    execute 'hi Lf_hl_popup_blank guifg=' . palette.normal.middle[0][0] . ' guibg=' . palette.normal.middle[0][1] . ' ctermfg=' . palette.normal.middle[0][2] . ' ctermbg=' . palette.normal.middle[0][3]
    " hi link Lf_hl_popup_window Normal
    execute 'hi Lf_hl_popup_window guifg=' . synIDattr(synIDtrans(hlID('Normal')), 'fg') . ' guibg=' . s:middle_color(synIDattr(synIDtrans(hlID('Normal')), 'bg'), synIDattr(synIDtrans(hlID('CursorLine')), 'bg'))
    execute 'hi Lf_hl_popup_normalMode guifg=' . palette.normal.left[0][0] . ' guibg=' . palette.normal.left[0][1] . ' ctermfg=' . palette.normal.left[0][2] . ' ctermbg=' . palette.normal.left[0][3]
    execute 'hi Lf_hl_popup_inputMode guifg=' . palette.insert.left[0][0] . ' guibg=' . palette.insert.left[0][1] . ' ctermfg=' . palette.insert.left[0][2] . ' ctermbg=' . palette.insert.left[0][3]
    execute 'hi Lf_hl_popup_lineInfo guifg=' . palette.normal.right[1][0] . ' guibg=' . palette.normal.right[1][1] . ' ctermfg=' . palette.normal.right[1][2] . ' ctermbg=' . palette.normal.right[1][3]
    execute 'hi Lf_hl_popup_total guifg=' . palette.normal.right[0][0] . ' guibg=' . palette.normal.right[0][1] . ' ctermfg=' . palette.normal.right[0][2] . ' ctermbg=' . palette.normal.right[0][3]
    execute 'hi Lf_hl_popup_category guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
    execute 'hi Lf_hl_popup_nameOnlyMode guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
    execute 'hi Lf_hl_popup_fullPathMode guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
    execute 'hi Lf_hl_popup_fuzzyMode guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
    execute 'hi Lf_hl_popup_regexMode guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
    execute 'hi Lf_hl_popup_cwd guifg=' . palette.normal.middle[0][0] . ' guibg=' . palette.normal.middle[0][1] . ' ctermfg=' . palette.normal.middle[0][2] . ' ctermbg=' . palette.normal.middle[0][3]
    highlight link Lf_hl_match Search
endfunction

function! s:set_colorscheme()
    let [hour, minute] = split(strftime('%H:%M', localtime()), ':')
    let hour = str2nr(hour)
    let minute = str2nr(minute)
    if ((hour == 5 && minute >= 30) || hour > 5) && (hour < 18 || (hour == 18 && minute < 45))
        let g:ayucolor = 'light'
        silent! colorscheme tokyonight-day
        set background=light
        let g:lightline.colorscheme = 'tokyonight'
    else
        let g:ayucolor = 'dark'
        silent! colorscheme tokyonight-night
        set background=dark
        let g:lightline.colorscheme = 'tokyonight'
    endif
    " syntax on
    " call s:set_leaderf_highlights()
endfunction
call s:set_colorscheme()
autocmd VimEnter * call s:set_leaderf_highlights()

function! s:on_colorscheme()
    if exists('g:loaded_lightline')
        if g:colors_name =~# 'solarized'
            let g:lightline.colorscheme = 'solarized'
        elseif g:colors_name =~# 'soft-era'
            let g:lightline.colorscheme = 'softera_alter'
        elseif g:colors_name =~# 'ayu'
            let g:lightline.colorscheme = 'ayu'
        elseif g:colors_name ==# 'onehalflight'
            let g:lightline.colorscheme = 'one'
        elseif g:colors_name =~# 'tokyonight'
            let g:lightline.colorscheme = 'tokyonight'
        else
            let g:lightline.colorscheme = substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
        endif
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
    endif
    " syntax on
    call s:set_leaderf_highlights()
endfunction

function! s:on_set_background()
    if exists('g:loaded_lightline')
        let colorfile = globpath(&rtp, 'autoload/lightline/colorscheme/' . g:lightline.colorscheme . '.vim')
        if colorfile != ''
            call lightline#colorscheme()
            call lightline#update()
        endif
    endif
    " syntax on
    call s:set_leaderf_highlights()
endfunction

augroup ZpanColorScheme
    autocmd!
    autocmd ColorScheme * call s:on_colorscheme()
    autocmd OptionSet background call s:on_set_background()
augroup END

" autocmd Syntax,ColorScheme * highlight! link SignColumn LineNr
" autocmd Syntax,ColorScheme * highlight! link FoldColumn LineNr
" autocmd Syntax,ColorScheme * highlight! link VertSplit LineNr
" autocmd Syntax,ColorScheme * highlight! link StatusLine TabLine
" autocmd Syntax,ColorScheme * highlight! link StatusLineNC TabLineSel
" autocmd Syntax,ColorScheme * highlight! link MoreMsg TabLineFill
" autocmd Syntax,ColorScheme * highlight! link ModeMsg TabLineFill
" autocmd Syntax,ColorScheme * highlight! link SpecialKey Normal
" autocmd Syntax,ColorScheme * highlight! link WildMenu Pmenu
" autocmd Syntax,ColorScheme * highlight! link Question NonText
" autocmd Syntax,ColorScheme * highlight! link WarningMsg DiffChange
" autocmd Syntax,ColorScheme * highlight! link PmenuSBar Pmenu
" autocmd Syntax,ColorScheme * highlight! link PmenuThumb PmenuSel

if exists('g:gui_oni') || exists('g:gui_gonvim')
    set laststatus=0
endif

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

" if has('nvim')
"     set signcolumn=yes:2
" else
"     set signcolumn=yes
" endif

" QuickFix and Location windows
autocmd FileType tagbar nnoremap <silent> <buffer> q <C-w>q

function! s:setup_quickfix_window()
    wincmd J
    if &lines >= 30
        15wincmd _
    endif
    setlocal wrap foldcolumn=0 colorcolumn= signcolumn=no cursorline
    nnoremap <silent> <buffer> q <C-w>q
endfunction
autocmd FileType qf call s:setup_quickfix_window()
autocmd BufWinEnter * if &filetype ==# 'qf' | call s:setup_quickfix_window() | endif

autocmd QuickFixCmdPost [^l]* nested botright cwindow
autocmd QuickFixCmdPost l*    nested botright lwindow

function! s:setup_coc_explorer()
    wincmd H
    40wincmd |
endfunction
autocmd FileType coc-explorer call s:setup_coc_explorer()
autocmd BufWinEnter * if &filetype ==# 'coc-explorer' | call s:setup_coc_explorer() | endif

function! s:setup_help_window()
    if winwidth('%') >= 180
        wincmd L
        vertical resize 90
    endif
    setlocal foldcolumn=0 signcolumn=no colorcolumn= wrap nonumber
    nnoremap <silent> <buffer> q <C-w>q
endfunction
autocmd BufWinEnter * if &filetype ==# 'help' | call s:setup_help_window() | endif
autocmd FileType help call s:setup_help_window()

function! s:setup_man_window()
    if winwidth('%') >= 180
        wincmd L
        vertical resize 90
    endif
    setlocal foldcolumn=0 signcolumn=no colorcolumn= wrap bufhidden nobuflisted noswapfile nonumber
    nnoremap <silent> <buffer> q <C-w>q
endfunction
autocmd BufWinEnter * if &filetype ==# 'man' | call s:setup_man_window() | endif
autocmd FileType man call s:setup_man_window()

" vim: ts=8 sts=4 sw=4 et
