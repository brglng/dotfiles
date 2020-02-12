set mouse=a

if exists('&termguicolors') && $TERM_PROGRAM != 'Apple_Terminal'
  if !has('nvim')
    " fix bug for vim
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
  endif
  set termguicolors
else
  set t_Co=256
  let g:solarized_use16 = 0
  let g:onedark_termcolors = 256
endif

syntax on
set background=dark
silent! colorscheme nord

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

if has('nvim')
  set signcolumn=yes:2
else
  set signcolumn=yes
endif

" QuickFix and Location windows
autocmd FileType tagbar nnoremap <silent> <buffer> q <C-w>q

autocmd FileType qf call s:setup_quickfix_window(1, 15)
function! s:setup_quickfix_window(minheight, maxheight)
  wincmd J
  if !g:asyncrun_status == 'running'
    let l = 1
    let n_lines = 0
    let w_width = winwidth(0)
    while l <= line('$')
      " number to float for division
      let l_len = strlen(getline(l)) + 0.0
      let line_width = l_len/w_width
      let n_lines += float2nr(ceil(line_width))
      let l += 1
    endw
    exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
    setlocal wrap foldcolumn=0 colorcolumn= signcolumn=no cursorline
  endif
  nnoremap <silent> <buffer> q <C-w>q
endfunction

autocmd QuickFixCmdPost [^l]* nested botright cwindow
autocmd QuickFixCmdPost l*    nested botright lwindow

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
