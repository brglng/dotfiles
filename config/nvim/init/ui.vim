set mouse=a

" 打开功能键超时检测（终端下功能键为一串 ESC 开头的字符串）
set ttimeout

" 功能键超时检测 50 毫秒
set ttimeoutlen=50

"----------------------------------------------------------------------
" 有 tmux 何没有的功能键超时（毫秒）
"----------------------------------------------------------------------
if $TMUX != ''
    set ttimeoutlen=30
elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
    set ttimeoutlen=80
endif

"----------------------------------------------------------------------
" 终端下允许 ALT，详见：http://www.skywind.me/blog/archives/2021
" 记得设置 ttimeout （见 init-basic.vim） 和 ttimeoutlen （上面）
"----------------------------------------------------------------------
if has('nvim') == 0 && has('gui_running') == 0
    function! s:metacode(key)
        exec "set <M-".a:key.">=\e".a:key
    endfunc
    for i in range(10)
        call s:metacode(nr2char(char2nr('0') + i))
    endfor
    for i in range(26)
        call s:metacode(nr2char(char2nr('a') + i))
        call s:metacode(nr2char(char2nr('A') + i))
    endfor
    for c in [',', '.', '/', ';', '{', '}']
        call s:metacode(c)
    endfor
    for c in ['?', ':', '-', '_', '+', '=', "'", '`']
        call s:metacode(c)
    endfor
endif

"----------------------------------------------------------------------
" 终端下功能键设置
"----------------------------------------------------------------------
function! s:key_escape(name, code)
    if has('nvim') == 0 && has('gui_running') == 0
        exec "set ".a:name."=\e".a:code
    endif
endfunc

"----------------------------------------------------------------------
" 功能键终端码矫正
"----------------------------------------------------------------------
call s:key_escape('<F1>', 'OP')
call s:key_escape('<F2>', 'OQ')
call s:key_escape('<F3>', 'OR')
call s:key_escape('<F4>', 'OS')
call s:key_escape('<S-F1>', '[1;2P')
call s:key_escape('<S-F2>', '[1;2Q')
call s:key_escape('<S-F3>', '[1;2R')
call s:key_escape('<S-F4>', '[1;2S')
call s:key_escape('<S-F5>', '[15;2~')
call s:key_escape('<S-F6>', '[17;2~')
call s:key_escape('<S-F7>', '[18;2~')
call s:key_escape('<S-F8>', '[19;2~')
call s:key_escape('<S-F9>', '[20;2~')
call s:key_escape('<S-F10>', '[21;2~')
call s:key_escape('<S-F11>', '[23;2~')
call s:key_escape('<S-F12>', '[24;2~')

"----------------------------------------------------------------------
" 防止tmux下vim的背景色显示异常
" Refer: http://sunaku.github.io/vim-256color-bce.html
"----------------------------------------------------------------------
if !has('nvim') && !has('gui_running') && &term =~ '256color' && $TMUX != ''
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

if !has('nvim') && !has('gui_running')
    let &t_SI = "\<esc>[5 q"  " blinking I-beam in insert mode
    let &t_SR = "\<esc>[3 q"  " blinking underline in replace mode
    let &t_EI = "\<esc>[ q"  " default cursor (usually blinking block) otherwise

    let &t_TI = ''
    let &t_TE = ''

    " Italic support
    let t_ZH = "\e[3m"
    let t_ZR = "\e[23m"

    set guicursor+=i:ver100-iCursor
endif

function! s:hiattr(hi_name, attr)
    let color = synIDattr(synIDtrans(hlID(a:hi_name)), a:attr)
    if color == ''
        return 'NONE'
    endif
    return color
endfunction

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
    if exists('g:loaded_lightline')
        let palette = lightline#palette()
        execute 'hi Lf_hl_popup_inputText guifg=' . palette.normal.middle[0][0] . ' guibg=' . palette.normal.middle[0][1] . ' ctermfg=' . palette.normal.middle[0][2] . ' ctermbg=' . palette.normal.middle[0][3]
        execute 'hi Lf_hl_popup_blank guifg=' . palette.normal.middle[0][0] . ' guibg=' . palette.normal.middle[0][1] . ' ctermfg=' . palette.normal.middle[0][2] . ' ctermbg=' . palette.normal.middle[0][3]
        execute 'hi Lf_hl_popup_normalMode guifg=' . palette.normal.left[0][0] . ' guibg=' . palette.normal.left[0][1] . ' ctermfg=' . palette.normal.left[0][2] . ' ctermbg=' . palette.normal.left[0][3]
        execute 'hi Lf_hl_popup_inputMode guifg=' . palette.insert.left[0][0] . ' guibg=' . palette.insert.left[0][1] . ' ctermfg=' . palette.insert.left[0][2] . ' ctermbg=' . palette.insert.left[0][3]
        execute 'hi Lf_hl_popup_lineInfo guifg=' . palette.normal.right[1][0] . ' guibg=' . palette.normal.right[1][1] . ' ctermfg=' . palette.normal.right[1][2] . ' ctermbg=' . palette.normal.right[1][3]
        execute 'hi Lf_hl_popup_total guifg=' . palette.normal.right[0][0] . ' guibg=' . palette.normal.right[0][1] . ' ctermfg=' . palette.normal.right[0][2] . ' ctermbg=' . palette.normal.right[0][3]
        execute 'hi Lf_hl_popup_category guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
        execute 'hi Lf_hl_popup_nameOnlyMode guifg=' . palette.normal.left[1][0] . ' guibg=' . s:middle_color(palette.normal.left[1][1], palette.normal.middle[0][1])
        execute 'hi Lf_hl_popup_fullPathMode guifg=' . palette.normal.left[1][0] . ' guibg=' . s:middle_color(palette.normal.left[1][1], palette.normal.middle[0][1])
        execute 'hi Lf_hl_popup_fuzzyMode guifg=' . palette.normal.left[1][0] . ' guibg=' . s:middle_color(palette.normal.left[1][1], palette.normal.middle[0][1])
        execute 'hi Lf_hl_popup_regexMode guifg=' . palette.normal.left[1][0] . ' guibg=' . s:middle_color(palette.normal.left[1][1], palette.normal.middle[0][1])
        execute 'hi Lf_hl_popup_cwd guifg=' . palette.normal.middle[0][0] . ' guibg=' . palette.normal.middle[0][1] . ' ctermfg=' . palette.normal.middle[0][2] . ' ctermbg=' . palette.normal.middle[0][3]
    elseif has('nvim') && luaeval('require("lualine") ~= nil')
        execute 'hi Lf_hl_popup_inputText guifg=' . synIDattr(synIDtrans(hlID('lualine_c_normal')), 'fg') . ' guibg=' . synIDattr(synIDtrans(hlID('lualine_c_normal')), 'bg')
        execute 'hi Lf_hl_popup_blank guifg=' . synIDattr(synIDtrans(hlID('lualine_c_normal')), 'fg') . ' guibg=' . synIDattr(synIDtrans(hlID('lualine_c_normal')), 'bg')
        execute 'hi Lf_hl_popup_normalMode guifg=' . synIDattr(synIDtrans(hlID('lualine_a_normal')), 'fg') . ' guibg=' . synIDattr(synIDtrans(hlID('lualine_a_normal')), 'bg')
        execute 'hi Lf_hl_popup_inputMode guifg=' . synIDattr(synIDtrans(hlID('lualine_a_insert')), 'fg') . ' guibg=' . synIDattr(synIDtrans(hlID('lualine_a_insert')), 'bg')
        execute 'hi Lf_hl_popup_lineInfo guifg=' . synIDattr(synIDtrans(hlID('lualine_b_normal')), 'fg') . ' guibg=' . synIDattr(synIDtrans(hlID('lualine_b_normal')), 'bg')
        execute 'hi Lf_hl_popup_total guifg=' . synIDattr(synIDtrans(hlID('lualine_a_normal')), 'fg') . ' guibg=' . synIDattr(synIDtrans(hlID('lualine_a_normal')), 'bg')
        execute 'hi Lf_hl_popup_category guifg=' . synIDattr(synIDtrans(hlID('lualine_b_normal')), 'fg') . ' guibg=' . synIDattr(synIDtrans(hlID('lualine_b_normal')), 'bg')
        execute 'hi Lf_hl_popup_nameOnlyMode guifg=' . synIDattr(synIDtrans(hlID('lualine_b_normal')), 'fg') . ' guibg=' . s:middle_color(synIDattr(synIDtrans(hlID('lualine_b_normal')), 'bg'), synIDattr(synIDtrans(hlID('lualine_c_normal')), 'bg'))
        execute 'hi Lf_hl_popup_fullPathMode guifg=' . synIDattr(synIDtrans(hlID('lualine_b_normal')), 'fg') . ' guibg=' . s:middle_color(synIDattr(synIDtrans(hlID('lualine_b_normal')), 'bg'), synIDattr(synIDtrans(hlID('lualine_c_normal')), 'bg'))
        execute 'hi Lf_hl_popup_fuzzyMode guifg=' . synIDattr(synIDtrans(hlID('lualine_b_normal')), 'fg') . ' guibg=' . s:middle_color(synIDattr(synIDtrans(hlID('lualine_b_normal')), 'bg'), synIDattr(synIDtrans(hlID('lualine_c_normal')), 'bg'))
        execute 'hi Lf_hl_popup_regexMode guifg=' . synIDattr(synIDtrans(hlID('lualine_b_normal')), 'fg') . ' guibg=' . s:middle_color(synIDattr(synIDtrans(hlID('lualine_b_normal')), 'bg'), synIDattr(synIDtrans(hlID('lualine_c_normal')), 'bg'))
        execute 'hi Lf_hl_popup_cwd guifg=' . synIDattr(synIDtrans(hlID('lualine_c_normal')), 'fg') . ' guibg=' . synIDattr(synIDtrans(hlID('lualine_c_normal')), 'bg')
    endif
    " hi link Lf_hl_popup_window Normal
    " hi link Lf_hl_popupBorder FloatBorder
    execute 'hi Lf_hl_popup_window guifg=' . synIDattr(synIDtrans(hlID('Normal')), 'fg') . ' guibg=' . s:middle_color(synIDattr(synIDtrans(hlID('Normal')), 'bg'), synIDattr(synIDtrans(hlID('CursorLine')), 'bg'))
    execute 'hi Lf_hl_popupBorder guifg=' . synIDattr(synIDtrans(hlID('FloatBorder')), 'fg')
    highlight link Lf_hl_cursorline CursorLine
    highlight link Lf_hl_match Search
endfunction

function! s:set_lualine_highlights()
    if has('nvim')
lua << EOF
    local lualine = require('lualine')
    if lualine ~= nil then
        local my_theme = require("lualine.themes.gruvbox")
        my_theme.insert.c = my_theme.normal.c
        my_theme.visual.c = my_theme.normal.c
        my_theme.replace.c = my_theme.normal.c
        my_theme.command.c = my_theme.normal.c
        lualine.setup({ theme = my_theme })
    end
EOF
    endif
endfunction

function! s:set_neotree_highlights()
    if has('nvim')
        execute "hi NeoTreeTabActive guifg=" . synIDattr(synIDtrans(hlID('NeoTreeNormal')), 'fg') . " guibg=" . synIDattr(synIDtrans(hlID('NeoTreeNormal')), 'bg')
        execute "hi NeoTreeTabInactive guibg=" . s:middle_color(synIDattr(synIDtrans(hlID('BufferLineBackground')), 'bg'), synIDattr(synIDtrans(hlID('NeoTreeNormal')), 'bg'))
        execute "hi NeoTreeTabSeparatorInactive guifg=" . synIDattr(synIDtrans(hlID('BufferLineBuffer')), 'fg') . " guibg=" . s:middle_color(synIDattr(synIDtrans(hlID('BufferLineBackground')), 'bg'), synIDattr(synIDtrans(hlID('NeoTreeNormal')), 'bg'))
        execute "hi NeoTreeTabSeparatorActive guifg=" . synIDattr(synIDtrans(hlID('NeoTreeNormal')), 'fg') . " guibg=" . synIDattr(synIDtrans(hlID('NeoTreeNormal')), 'bg')
    endif
endfunction

function! s:set_noice_highlights()
    if hlexists('DiagnosticSignInfo')
        execute 'hi! NoiceCmdlinePopupBorder guifg=' . s:hiattr('DiagnosticSignInfo', 'fg') . ' guibg=NONE'
        execute 'hi! NoiceCmdlinePopupTitle guifg=' . s:hiattr('DiagnosticSignInfo', 'fg') . ' guibg=NONE'
        execute 'hi! NoiceCmdlineIcon guifg=' . s:hiattr('DiagnosticSignInfo', 'fg') . ' guibg=NONE'
    endif
endfunction

function! s:set_illuminated_highlights()
    hi! link IlluminatedWordText CursorLine
    hi! link IlluminatedWordRead CursorLine
    hi! link IlluminatedWordWrite CursorLine
endfunction

function! s:set_colorscheme()
    let [hour, minute] = split(strftime('%H:%M', localtime()), ':')
    let hour = str2nr(hour)
    let minute = str2nr(minute)
    if ((hour == 5 && minute >= 30) || hour > 5) && (hour < 17 || (hour == 17 && minute < 45))
        if has('nvim')
            colorscheme gruvbox
        else
            colorscheme gruvbox-material
        endif
        set background=light
        if exists('g:loaded_lightline')
            let g:lightline.colorscheme = 'gruvbox'
        endif
    else
        if has('nvim')
            colorscheme gruvbox
        else
            colorscheme gruvbox-material
        endif
        set background=dark
        if exists('g:loaded_lightline')
            let g:lightline.colorscheme = 'gruvbox'
        endif
    endif
    syntax on
    " call s:set_leaderf_highlights()
endfunction
call s:set_colorscheme()

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
    call s:set_lualine_highlights()
    call s:set_neotree_highlights()
    call s:set_noice_highlights()
    call s:set_illuminated_highlights()
endfunction

function! s:on_set_background()
    if exists('g:loaded_lightline')
        let colorfile = globpath(&rtp, 'autoload/lightline/colorscheme/' . g:lightline.colorscheme . '.vim')
        if colorfile != ''
            execute 'source ' . colorfile
            call lightline#enable()
        endif
    endif
    syntax on
    call s:set_leaderf_highlights()
    call s:set_lualine_highlights()
    call s:set_neotree_highlights()
    call s:set_noice_highlights()
    call s:set_illuminated_highlights()
endfunction

augroup ZpanColorScheme
    autocmd!
    autocmd VimEnter * call s:on_colorscheme()
    autocmd ColorScheme * call s:on_colorscheme()
    autocmd OptionSet background call s:on_set_background()
augroup END

if exists('g:gui_oni') || exists('g:gui_gonvim')
    set laststatus=0
endif

if has('nvim')
    set signcolumn=yes:2
else
    set signcolumn=yes
endif

" QuickFix and Location windows
autocmd FileType tagbar nnoremap <silent> <buffer> q <C-w>q

function! s:setup_quickfix_window()
    wincmd J
    if &lines >= 30
        15wincmd _
    endif
    setlocal wrap foldcolumn=0 colorcolumn= signcolumn=no cursorline nobuflisted
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

autocmd FileType terminal,toggleterm set foldcolumn=0 signcolumn=no statuscolumn=

" vim: ts=8 sts=4 sw=4 et
