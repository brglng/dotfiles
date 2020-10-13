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

if has('termguicolors') && !has('gui_running')
    " fix bug for vim
    if !has('nvim')
        if &term =~# '^screen\|^tmux'
            let &t_8f = "\e[38;2;%lu;%lu;%lum"
            let &t_8b = "\e[48;2;%lu;%lu;%lum"
        endif
    endif
    set termguicolors
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

let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italic = 1
" let g:gruvbox_improved_strings = 1
" let g:gruvbox_improved_warnings = 1
let g:one_allow_italics = 1
let g:quantum_italics = 1

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

function! s:set_leaderf_highlights()
    " {'inactive': {'right': [['#7c6f64', '#3c3836', '243', '237'], ['#7c6f64', '#3c3836', '243', '237']], 'middle': [['#7c6f64', '#3c3836', '243', '237']], 'left': [['#7c6f64', '#3c3836', '243', '237'], ['#7c6f64', '#3c3836', '243', '237']]}, 'replace': {'right': [['#1d2021', '#8ec07c', '234', '108'], ['#ebdbb2', '#504945', '223', '239']], 'middle': [['#a89984', '#504945', '246', '239']], 'left': [['#1d2021', '#8ec07c', '234', '108', 'bold'], ['#ebdbb2', '#504945', '223', '239']]}, 'normal': {'right': [['#1d2021', '#a89984', '234', '246'], ['#a89984', '#504945', '246', '239']], 'middle': [['#a89984', '#3c3836', '246', '237']], 'warning': [['#504945', '#fabd2f', '239', '214']], 'left': [['#1d2021', '#a89984', '234', '246', 'bold'], ['#a89984', '#504945', '246', '239']], 'error': [['#1d2021', '#fe8019', '234', '208']]}, 'terminal': {'right': [['#1d2021', '#b8bb26', '234', '142'], ['#ebdbb2', '#504945', '223', '239']], 'middle': [['#a89984', '#504945', '246', '239']], 'left': [['#1d2021', '#b8bb26', '234', '142', 'bold'], ['#ebdbb2', '#504945', '223', '239']]}, 'tabline': {'right': [['#1d2021', '#fe8019', '234', '208']], 'middle': [['#1d2021', '#1d2021', '234', '234']], 'left': [['#a89984', '#504945', '246', '239']], 'tabsel': [['#1d2021', '#a89984', '234', '246']]}, 'visual': {'right': [['#1d2021', '#fe8019', '234', '208'], ['#1d2021', '#7c6f64', '234', '243']], 'middle': [['#a89984', '#3c3836', '246', '237']], 'left': [['#1d2021', '#fe8019', '234', '208', 'bold'], ['#1d2021', '#7c6f64', '234', '243']]}, 'insert': {'right': [['#1d2021', '#83a598', '234', '109'], ['#ebdbb2', '#504945', '223', '239']], 'middle': [['#a89984', '#504945', '246', '239']], 'left': [['#1d2021', '#83a598', '234', '109', 'bold'], ['#ebdbb2', '#504945', '223', '239']]}}
    let palette = lightline#palette()
    highlight link Lf_hl_cursorline Cursorline
    execute 'hi Lf_hl_popup_inputText guifg=' . palette.normal.middle[0][0] . ' guibg=' . palette.normal.middle[0][1] . ' ctermfg=' . palette.normal.middle[0][2] . ' ctermbg=' . palette.normal.middle[0][3]
    execute 'hi Lf_hl_popup_blank guifg=' . palette.inactive.left[0][0] . ' guibg=' . palette.inactive.left[0][1] . ' ctermfg=' . palette.inactive.left[0][2] . ' ctermbg=' . palette.inactive.left[0][3]
    highlight link Lf_hl_popup_window Pmenu
    execute 'hi Lf_hl_popup_normalMode guifg=' . palette.normal.left[0][0] . ' guibg=' . palette.normal.left[0][1] . ' ctermfg=' . palette.normal.left[0][2] . ' ctermbg=' . palette.normal.left[0][3]
    execute 'hi Lf_hl_popup_inputMode guifg=' . palette.insert.left[0][0] . ' guibg=' . palette.insert.left[0][1] . ' ctermfg=' . palette.insert.left[0][2] . ' ctermbg=' . palette.insert.left[0][3]
    execute 'hi Lf_hl_popup_lineInfo guifg=' . palette.normal.right[1][0] . ' guibg=' . palette.normal.right[1][1] . ' ctermfg=' . palette.normal.right[1][2] . ' ctermbg=' . palette.normal.right[1][3]
    execute 'hi Lf_hl_popup_total guifg=' . palette.normal.right[0][0] . ' guibg=' . palette.normal.right[0][1] . ' ctermfg=' . palette.normal.right[0][2] . ' ctermbg=' . palette.normal.right[0][3]
    execute 'hi Lf_hl_popup_category guifg=' . palette.normal.left[0][0] . ' guibg=' . palette.normal.left[0][1] . ' ctermfg=' . palette.normal.left[0][2] . ' ctermbg=' . palette.normal.left[0][3]
    execute 'hi Lf_hl_popup_nameOnlyMode guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
    execute 'hi Lf_hl_popup_fullPathMode guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
    execute 'hi Lf_hl_popup_fuzzyMode guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
    execute 'hi Lf_hl_popup_regexMode guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
    execute 'hi Lf_hl_popup_cwd guifg=' . palette.normal.left[1][0] . ' guibg=' . palette.normal.left[1][1] . ' ctermfg=' . palette.normal.left[1][2] . ' ctermbg=' . palette.normal.left[1][3]
    execute 'hi Lf_hl_popup_File_sep0 guifg=' . palette.insert.left[0][1] . ' guibg=' . palette.normal.left[1][0] . ' ctermfg=' . palette.insert.left[0][3] . ' ctermbg=' . palette.normal.left[1][2]
    highlight link Lf_hl_match Search
endfunction

function! s:set_colorscheme()
    let [hour, minute] = split(strftime('%H:%M', localtime()), ':')
    let hour = str2nr(hour)
    let minute = str2nr(minute)
    if ((hour == 5 && minute >= 30) || hour > 5) && (hour < 18 || (hour == 18 && minute < 45))
        set background=light
        silent! colorscheme onehalflight
        let g:lightline.colorscheme = 'one'
    else
        set background=dark
        silent! colorscheme onehalfdark
        let g:lightline.colorscheme = 'onehalfdark'
    endif
    syntax on
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
        elseif g:colors_name =~# 'gruvbox'
            let g:lightline.colorscheme = 'gruvbox'
        elseif g:colors_name ==# 'onehalflight'
            let g:lightline.colorscheme = 'one'
        else
            let g:lightline.colorscheme =
              \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
        endif
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
    endif
    syntax on
    call s:set_leaderf_highlights()
endfunction

function! s:on_set_background()
    if exists('g:loaded_lightline')
        execute 'source ' . globpath(&rtp, 'autoload/lightline/colorscheme/' . g:lightline.colorscheme . '.vim')
        call lightline#colorscheme()
        call lightline#update()
    endif
    syntax on
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
