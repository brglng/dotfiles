" The default runtimepath on windows is $USERPROFILE/vimfiles, but I am not going to use it
if ((has('win32') || has('win64')) && !has('win32unix')) && !has('nvim')
  let &runtimepath = $HOME . '/.vim,' . &runtimepath . ',' . $HOME . '/.vim/after'
endif

let &viewdir = $HOME . '/.cache/vim/view'
if !isdirectory(&viewdir)
  silent! call mkdir($HOME . '/.cache/vim/view', 'p')
endif

if has("patch-8.1.0360")
  set diffopt+=internal,algorithm:patience
endif

" enc, tenc, fenc, fencs, ff settings
" *MUST* be put at the very beginning, in order to prevent potential problems
set fileencodings=ucs-bom,utf-8,gb18030,big5,euc-jp,shift-jis,euc-kr,latin1
if &encoding != 'utf-8'
  if &termencoding == ''
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  let &langmenu = strpart($LANG, 0, 5) . '.UTF-8'
  exe 'language messages ' . strpart($LANG, 0, 5) . '.UTF-8'
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
  if has('iconv')
    function s:QfMakeConv()
      let qflist = getqflist()
      for i in qflist
        let i.text = iconv(i.text, &termencoding, &encoding)
      endfor
      call setqflist(qflist)
    endfunction
    au QuickFixCmdPost * call s:QfMakeConv()
  endif
endif
set fileencoding=utf-8
set fileformats=unix,dos,mac
set fileformat=unix
command! -nargs=+ GB exe iconv("<args>", 'utf-8', 'cp936')

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \   exe "normal! zz" |
  \ endif
"autocmd BufWinLeave ?* if &buflisted && &modifiable && !(&bufhidden) && &buftype == '' | mkview | endif
"autocmd BufWinEnter ?* if &buflisted && &modifiable && !(&bufhidden) && &buftype == '' | silent loadview | endif

" general settings
behave mswin                    " MS Windows behaviors
set mouse=a                     " mouse is on
set nocompatible                " turn of vi compatible mode
set winaltkeys=no
"set helplang=cn                 " Chinese help
"set autoread                    " auto read files modified outside vim
if has('win32') || system('whoami') != "root\n"
  set nobackup                  " do not create backups before editing
  set nowritebackup
endif
set backupcopy=yes
"set noswapfile

set showcmd                   " show commands in normal mode at the right-bottom

set ruler                     " show row,col at the right-bottom

set formatoptions+=mM           " deal with Chinese charactors' wrap correctly
set display=lastline            " display incomplete lines as much as possible
" set ambiwidth=double            " show double-width charactors correctly when encoding=utf8
"set autochdir                   " auto swith cwd to the current file's directory
set hlsearch                    " highlight search results
set incsearch                   " search while inputting
set smartcase
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
set number                      " show line number
"set relativenumber

set laststatus=2

set wildmenu
"if has('unnamedplus')
"    set clipboard+=unnamedplus
"else
"    set clipboard+=unnamed
"endif
set listchars=tab:>-,trail:.,extends:>,precedes:<
" set list
"set scrolloff=3
set sidescrolloff=5
"set cursorline                  " highlight current line
set showmatch                   " blink matched pairs
set matchtime=0
autocmd FileType html,xml setlocal matchpairs+=<:>
set updatetime=500
set ttimeout
set ttimeoutlen=100
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif
if &shell =~# 'fish$'
  set shell=/bin/bash
endif
set history=1000
set tabpagemax=50
set sessionoptions-=options

set confirm
"set switchbuf=usetab,newtab,useopen

" set nostartofline
set splitbelow
set splitright

" set colorcolumn=80

" arrow keys and wrap settings
set wrap                        " auto wrap long lines
set whichwrap=b,s,<,>,[,]       " cursor auto move to next/previous line when reach line's tail/head
set backspace=indent,eol,start  " backspace can delete newlines in insert mode
"set textwidth=78                " auto break lines longer than 78 charactors

if !has('gui_running') && !(has('win32') && !has('win32unix')) && !has('nvim')
  " fix meta-keys under terminal
  let chars = ['s', 'z', 'Z', 'c', 'x', 'v', 'a', '{', '}', 'b', 'f', 'k', '0', '1', '6', '7']
  for c in chars
    exec "set <M-" . c . ">=\e" . c
  endfor
  " set timeout
  set ttimeout
  " set timeoutlen=100
  set ttimeoutlen=1
endif

" backspace in Visual mode deletes selection
vnoremap <BS> d

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

map   <silent> <S-Insert> "+gP
cmap  <silent> <S-Insert> <C-r>+
exe 'inoremap <script> <S-Insert> <C-g>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <S-Insert> ' . paste#paste_cmd['v']

if !((has('macunix') || has('mac')) && has('gui_running'))
  noremap   <silent> <M-s>  :update<CR>
  vnoremap  <silent> <M-s>  <C-c>:update<CR>
  inoremap  <silent> <M-s>  <C-o>:update<CR>

  noremap   <silent> <M-z>  u
  inoremap  <silent> <M-z>  <C-o>u
  noremap   <silent> <M-Z>  <C-r>
  inoremap  <silent> <M-Z>  <C-o><C-r>

  nnoremap  <silent> <M-c>  "+y
  vnoremap  <silent> <M-c>  "+y

  nnoremap  <silent> <M-x>  "+x
  vnoremap  <silent> <M-x>  "+x

  map       <silent> <M-v>  "+gP
  cmap      <silent> <M-v>  <C-r>+
  inoremap  <silent> <M-v>  <C-o>"+P

  " Pasting blockwise and linewise selections is not possible in Insert and
  " Visual mode without the +virtualedit feature.  They are pasted as if they
  " were characterwise instead.
  " Uses the paste.vim autoload script.
  exe 'inoremap <script> <M-v> <C-g>u' . paste#paste_cmd['i']
  exe 'vnoremap <script> <M-v> ' . paste#paste_cmd['v']

  noremap   <silent> <M-a> gggH<C-o>G
  inoremap  <silent> <M-a> <C-o>gg<C-o>gH<C-o>G
  cnoremap  <silent> <M-a> <C-c>gggH<C-o>G
  onoremap  <silent> <M-a> <C-c>gggH<C-o>G
  snoremap  <silent> <M-a> <C-c>gggH<C-o>G
  xnoremap  <silent> <M-a> <C-c>ggVG
elseif has('gui_macvim')
  set macmeta
endif

inoremap <silent> <C-U> <C-G>u<C-U>

set selectmode=                 " always use visual mode

" tab and incdent settings
set autoindent
set cindent
set cinoptions=Ls,l1,g0,N-s,E-s,t0,(0,u0,U1,w1,Ws,m1,j1,J1,)10000,*10000
set tabstop=8
set softtabstop=4
set expandtab
set smarttab            " use shiftwidth as indent at line's beginning
set shiftwidth=4
set shiftround
set preserveindent
set copyindent
set smartindent
filetype plugin on
filetype plugin indent on
if exists('&breakindent')
  autocmd FileType *
        \ if &filetype == '' || &filetype == 'markdown' || &filetype == 'txt' |
        \   setlocal nobreakindent |
        \   setlocal showbreak= |
        \ else |
        \   setlocal breakindent |
        \   setlocal showbreak=⤷\  |
        \ endif
endif

"autocmd FileType c,cpp
"      \   setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab
"autocmd FileType asm,masm,makefile,make
"      \   setl tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab nosmarttab
"autocmd FileType make setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab list
"autocmd FileType ahdl,vhdl
"      \   setl tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab nosmarttab
"autocmd FileType xml,xslt,html,css,java,javascript,vb,vim,php
"      \   setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab
"autocmd FileType aicasmx
"      \   setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab
"      \       nocindent
"autocmd FileType vim setl fileformat=unix
"autocmd FileType dosbatch,masm,vb setl fileformat=dos
"autocmd FileType make set list

autocmd BufRead,BufNewFile *.md set filetype=markdown
" autocmd BufRead,BufNewFile *.md set spell

set undofile
if !isdirectory($HOME . '/.cache/vim/undo')
  call mkdir($HOME . '/.cache/vim/undo', 'p')
endif
set undodir=$HOME/.cache/vim/undo

" fold settings
set foldmethod=syntax
"set foldminlines=500
set foldlevel=99
set foldlevelstart=99
set foldnestmax=1
set foldcolumn=2
autocmd FileType vim setl foldmethod=marker foldnestmax=3
autocmd FileType c setl foldnestmax=1
autocmd FileType cpp setl foldnestmax=3
autocmd FileType python setl foldmethod=indent foldnestmax=2
autocmd FileType * let &l:foldcolumn = &l:foldnestmax + 1

" omni complete settings
set completeopt=menuone,noinsert,noselect
set pumheight=15

" Always show the complete popup under the cursor,
" except when the cursor is at the last 3 lines on the screen.
" When the cursor is at the last 3 lines on the screen,
" always set pumheight=3
" autocmd CursorMoved,CursorMovedI *
      " \ if winline() <= winheight('%') - 4 |
      " \   let &pumheight = winheight('%') - winline() - 1 |
      " \ else |
      " \   set pumheight=3 |
      " \ endif

if has('win32')
  if executable('vim-ag.cmd')
    let &grepprg = 'vim-ag.cmd --vimgrep'
  endif
else
  if executable('ag')
    let &grepprg = 'ag --vimgrep'
  endif
endif

" Exuberant-ctags and Cscope settings
set tags=./.tags;,.tags
if executable('gtags-cscope')
  set cscopeprg=gtags-cscope
  let $CSCOPE_DB = 'GTAGS'
endif
set cscopequickfix=s-,c-,d-,i-,t-,e-

autocmd FileType help set foldcolumn=0 colorcolumn=

autocmd FileType qf setlocal wrap foldcolumn=0 colorcolumn=
autocmd FileType qf wincmd J
autocmd FileType qf call Vimrc_adjustQuickFixWindowHeight(1, 10)
function! Vimrc_adjustQuickFixWindowHeight(minheight, maxheight)
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
endfunction

" autocmd QuickFixCmdPost [^l]* nested botright cwindow
" autocmd QuickFixCmdPost l*    nested botright lwindow

" au WinEnter * if &filetype != 'qf' | cclose | lclose | endif

" disabled because of some side effects
" if has('unix') && !has('mac') && !has('macunix') && has('timers')
"   let s:prevIbusEngine = ''
"
"   function s:imInsertEnterTimerCallback(timer)
"     " dirty hack: InsertEnter is raised before entering insert mode,
"     "             so start a timer until mode is switched to insert.
"     if mode()[0] != 'i'
"       call timer_start(1, function("<SID>imInsertEnterTimerCallback"))
"     else
"       " echomsg 'imInsertEnter: mode: ' . mode() . ', prevIbusEngine: ' . s:prevIbusEngine
"       if s:prevIbusEngine != ''
"         silent! exe '!ibus engine ' . s:prevIbusEngine . ' &'
"       endif
"     endif
"   endfunction
"
"   function s:imInsertEnter()
"     call timer_start(1, function("<SID>imInsertEnterTimerCallback"))
"   endfunction
"   autocmd InsertEnter * call s:imInsertEnter()
"
"   function s:imInsertLeave()
"     let s:prevIbusEngine = system('ibus engine')[:-2]
"     " echomsg 'imInsertLeave: mode: ' . mode() . ', prevIbusEngine: ' . s:prevIbusEngine
"     silent! !ibus engine xkb:us::eng &
"   endfunction
"   autocmd InsertLeave * call s:imInsertLeave()
"
"   function s:imFocusGained()
"     " echomsg 'imFocusGained: mode: ' . mode() . ', prevIbusEngine: ' . s:prevIbusEngine . ', prevIbusEngine: ' . s:prevIbusEngine
"     let s:prevIbusEngine = system('ibus engine')[:-2]
"     if mode()[0] != 'i'
"       silent! !ibus engine xkb:us::eng &
"     endif
"   endfunction
"   autocmd FocusGained * call s:imFocusGained()
"
"   function s:imFocusLost()
"     " echomsg 'imFocusLost: mode: ' . mode() . ', prevIbusEngine: ' . s:prevIbusEngine . ', prevIbusEngine: ' . s:prevIbusEngine
"     if mode()[0] != 'i'
"       if s:prevIbusEngine != ''
"         silent! exe '!ibus engine ' . s:prevIbusEngine . ' &'
"       endif
"     endif
"   endfunction
"   autocmd FocusLost * call s:imFocusLost()
" endif

" Netrw
" let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = -30

" =========================== Plugin Settings ================================ {{{
let mapleader = "\<Space>"
runtime zpan/init/plugins.vim
runtime zpan/init/key_mappings.vim
runtime zpan/init/ui.vim

" indentLine settings
" let g:indentLine_char = '┊'
let g:indentLine_first_char = ''
let g:indentLine_faster = 1
let g:indentLine_enabled = 0
nnoremap <silent> <Leader>il :IndentLinesToggle<CR>

" match-up
let g:matchup_matchparen_status_offscreen = 0

" vim-airline settings
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_nr_format = '%s '
let g:airline_powerline_fonts = 1

" NERDCommenter
let NERDDefaultAlign = 'left'
let NERDSpaceDelims = 1

" Git Gutter
if has('win32')
  let g:gitgutter_realtime = 0
  let g:gitgutter_eager = 0
endif

" ConqueGDB
let g:ConqueGdb_Leader = '<Leader>cg'

" ALE
let g:ale_sign_error = '✗'
let g:ale_sign_warning = "\uf071"
let g:ale_linters = {'c': [], 'cpp': []}
let g:ale_python_pylint_executable = 'python3'
let g:ale_python_pylint_options = '-m pylint -d E265 -d E501 -d E201 -d E202 -d E111 -d W0311 -d C0111 -d C0103 -d C0326 -d C0111 -d E114 -d E122 -d E402 -d E203 -d E241'
let g:ale_python_flake8_executable = 'python3'
let g:ale_python_flake8_options = '-m flake8 --ignore=W0311,E265,E501,E201,E202,E111,E114,E122,E402,E203,E241'

" Neomake
let g:neomake_c_enabled_makers = []
let g:neomake_cpp_enabled_makers = []
let g:neomake_error_sign = {'text': '✗', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {
    \   'text': "\uf071",
    \   'texthl': 'NeomakeWarningSign',
    \ }
" let g:neomake_message_sign = {
"      \   'text': '>',
"      \   'texthl': 'NeomakeMessageSign',
"      \ }
" let g:neomake_info_sign = {'text': 'i', 'texthl': 'NeomakeInfoSign'}
" call neomake#configure#automake('nrwi', 10)

" DevIcons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
" let g:DevIconsEnableFoldersOpenClose = 1

" Gutentags
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_cache_dir = $HOME . '/.cache/vim/gutentags'
if !isdirectory(g:gutentags_cache_dir)
  silent! call mkdir(g:gutentags_cache_dir, 'p')
endif
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAligh)

" Startify
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
