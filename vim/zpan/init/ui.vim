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
if &term =~ '256color' && $TMUX != ''
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

if has('termguicolors')
    " fix bug for vim
    if !has('nvim')
        if &term =~# '^screen\|^tmux'
            let &t_8f = "\e[38;2;%lu;%lu;%lum"
            let &t_8b = "\e[48;2;%lu;%lu;%lum"
        endif
    endif
    set termguicolors
endif

let &t_SI = "\<esc>[5 q"  " blinking I-beam in insert mode
let &t_SR = "\<esc>[3 q"  " blinking underline in replace mode
let &t_EI = "\<esc>[ q"  " default cursor (usually blinking block) otherwise

let &t_TI = ''
let &t_TE = ''

" Italic support
let t_ZH = "\e[3m"
let t_ZR = "\e[23m"

set guicursor+=i:ver100-iCursor

syntax on
set background=light
let g:ayucolor = "light"
let g:gruvbox_italic = 1
let g:one_allow_italics = 1
silent! colorscheme ayu

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
        set guifont=FuraCodeNerdFontC-Regular:h11,Ubuntu_Mono_for_Powerline:h13,Consolas:h12,Lucida_Console:h12,Courier_New:h12
    elseif has('mac') || has('macunix')
        set guifont=FuraCodeNerdFontC-Regular:h14,Ubuntu_Mono_for_Powerline:h13,Menlo:h12
    elseif has('unix')
        if system('uname -s') == "Linux\n"
            " font height bug of GVim on Ubuntu
            let $LC_ALL='en_US.UTF-8'
        endif
        set guifont=Fura\ Code\ Nerd\ Font\ 11,Ubuntu\ Mono\ for\ Powerline\ 13,DejaVu\ Sans\ Mono\ 12
    endif

    if has('mac') || has('macunix')
        set guifontwide=Noto_Sans_CJK_SC:h12,Noto_Sans_CJK_TC:h12,Noto_Sans_CJK_JP:h12,Noto_Sans_CJK_KR:h12,Hiragino_Sans_GB:h12,STHeiti:h12
    elseif has('unix')
        set guifontwide=Noto\ Sans\ CJK\ SC\ 12,Noto\ Sans\ CJK\ TC\ 12,Noto\ Sans\ CJK\ JP\ 12,Noto\ Sans\ CJK\ KR\ 12,WenQuanYi\ Zen\ Hei\ 12,WenQuanYi\ Micro\ Hei\ 12
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
