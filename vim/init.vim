" The default runtimepath on windows is $USERPROFILE/vimfiles, but I am not going to use it
if ((has('win32') || has('win64')) && !has('win32unix')) || !has('nvim')
  let &runtimepath = $HOME . '/.vim,' . &runtimepath . ',' . $HOME . '/.vim/after'
endif

let &viewdir = $HOME . '/.cache/vim/view'
if !isdirectory(&viewdir)
  if !isdirectory($HOME . '/.cache/vim')
    if !isdirectory($HOME . '/.cache')
      call mkdir($HOME . '/.cache')
    endif
    call mkdir($HOME . '/.cache/vim')
  endif
  call mkdir(&viewdir)
endif

"set diffexpr=MyDiff()
"function MyDiff()
"  let opt = '-a --binary '
"  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
"  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
"  let arg1 = v:fname_in
"  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
"  let arg2 = v:fname_new
"  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
"  let arg3 = v:fname_out
"  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
"  if $VIMRUNTIME =~ ' '
"    if &sh =~ '\<cmd'
"      if empty(&shellxquote)
"        let l:shxq_sav = ''
"        set shellxquote&
"      endif
"      let cmd = '"' . $VIMRUNTIME . '\diff"'
"    else
"      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
"    endif
"  else
"    let cmd = $VIMRUNTIME . '\diff'
"  endif
"  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
"  if exists('l:shxq_sav')
"    let &shellxquote=l:shxq_sav
"  endif
"endfunction

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
if (has('unix') || has('mac') || has('macunix')) && system('whoami') != "root\n"
  set nobackup                  " do not create backups before editing
  set nowritebackup
endif
set backupcopy=yes
"set noswapfile
set showcmd                     " show commands in normal mode at the right-bottom
set ruler                       " show row,col at the right-bottom
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
set cursorline                  " highlight current line
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
runtime! macros/matchit.vim

set confirm
"set switchbuf=usetab,newtab,useopen

set colorcolumn=80

" arrow keys and wrap settings
set wrap                        " auto wrap long lines
set whichwrap=b,s,<,>,[,]       " cursor auto move to next/previous line when reach line's tail/head
set backspace=indent,eol,start  " backspace can delete newlines in insert mode
"set textwidth=78                " auto break lines longer than 78 charactors

let mapleader = "\<Space>"
nmap ; :

" arrows move through screen lines
noremap  <silent> <Down>      gj
noremap  <silent> <Up>        gk
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Up>   <C-o>gk

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
set cinoptions=Ls,:0,l1,g0,N0,t0,(0,u0,U1,w1,Ws,j1,J1,)1000,*1000
set tabstop=8
set softtabstop=4
set expandtab
set smarttab            " use shiftwidth as indent at line's beginning
set shiftwidth=2
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
  if !isdirectory($HOME . '/.cache/vim')
    if !isdirectory($HOME . '/.cache')
      call mkdir($HOME . '/.cache')
    endif
    call mkdir($HOME . '/.cache/vim')
  endif
  call mkdir($HOME . '/.cache/vim/undo')
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
set completeopt=menuone,longest
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
if executable('gtags-cscope')
  set cscopeprg=gtags-cscope
  let $CSCOPE_DB = 'GTAGS'
endif
set cscopequickfix=s-,c-,d-,i-,t-,e-

autocmd FileType help set foldcolumn=0 colorcolumn=

autocmd FileType qf setlocal wrap foldcolumn=0 colorcolumn=
autocmd FileType qf nnoremap <buffer> <silent> q <C-w>p:cclose<CR>:lclose<CR>
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

" =========================== Plugin Settings ================================ {{{
"dein Scripts----------------------------- {{{
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/.local/share/dein/repos/github.com/Shougo/dein.vim

let g:dein#install_process_timeout = 3600 * 2

" Required:
if dein#load_state($HOME . '/.local/share/dein')
  call dein#begin($HOME . '/.local/share/dein')

  " Let dein manage dein
  " Required:
  call dein#add($HOME . '/.local/share/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  " call dein#add('Shougo/neosnippet.vim')
  " call dein#add('Shougo/neosnippet-snippets')

  " You can specify revision/branch/tag.
  " call dein#add('Shougo/deol.nvim', { 'rev': 'a1b5108fd' })

  " UI Plugins
  call dein#add('scrooloose/nerdtree')
  call dein#add('jistr/vim-nerdtree-tabs')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('Yggdroot/indentLine')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('majutsushi/tagbar')
  call dein#add('mbbill/fencview')
  call dein#add('mbbill/undotree')
  call dein#add('ryanoasis/vim-devicons')

  " Moving and Editing Plugins
  call dein#add('tpope/vim-unimpaired')
  call dein#add('wellle/targets.vim')
  "call dein#add('tpope/vim-commentary')
  call dein#add('scrooloose/nerdcommenter')
  "call dein#add('auto-pairs')
  call dein#add('Raimondi/delimitMate')
  call dein#add('easymotion/vim-easymotion')
  call dein#add('tpope/vim-surround')
  call dein#add('godlygeek/tabular')
  call dein#add('tpope/vim-endwise')
  call dein#add('tpope/vim-sleuth')
  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets')

  " FileType Plugins
  call dein#add('PProvost/vim-ps1')
  call dein#add('aklt/plantuml-syntax')
  call dein#add('hynek/vim-python-pep8-indent')
  call dein#add('sheerun/vim-polyglot')

  " Source Control Plugins
  " call dein#add('Xuyuanp/nerdtree-git-plugin')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-fugitive')
  call dein#add('will133/vim-dirdiff')

  " Building and Syntax Checking Plugins
  call dein#add('neomake/neomake')
  " call dein#add('w0rp/ale')

  " Debugging Plugins
  call dein#add('gilligan/vim-lldb')
  call dein#add('vim-scripts/Conque-GDB')

  " Searching plugin: denite.vim and plugins
  call dein#add('Shougo/denite.nvim')
  call dein#add('Shougo/neomru.vim')

  " ColorSchemes
  call dein#add('lifepillar/vim-solarized8')
  call dein#add('sickill/vim-monokai')
  call dein#add('chriskempson/vim-tomorrow-theme')
  call dein#add('chriskempson/base16-vim')
  call dein#add('junegunn/seoul256.vim')
  call dein#add('nanotech/jellybeans.vim')
  call dein#add('NLKNguyen/papercolor-theme')
  call dein#add('joshdick/onedark.vim')

  if has('win32')
    let g:ycm_server_python_interpreter = 'py -3'
    let ycm_python_interpreter = 'py - 3'
  else
    let ycm_python_interpreter = 'python3'
  endif
  call dein#add('Valloric/YouCompleteMe', { 'build':  ycm_python_interpreter . ' install.py --clang-completer --racer-completer --tern-completer' })

  call dein#local($HOME . '/.vim/dein-local')

  call dein#disable(['indentLine', 'vim-devicons', 'vim-lldb'])

  " Required:
  call dein#end()
  " call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts------------------------- }}}

" UltiSnips settings {{{
" let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" }}}

" YouCompleteMe settings {{{
autocmd FileType c,cpp,objc,objcpp,cs,go,javascript,python,rust,typescript
      \   nnoremap <buffer> <silent> <F12>   :YcmCompleter GoTo<CR>
autocmd FileType cs,go,javascript,python,rust,typescript
      \   nnoremap <buffer> <silent> <C-]>   :YcmCompleter GoTo<CR>
autocmd FileType javascript,python,typescript
      \   nnoremap <buffer> <silent> <S-F12> :YcmCompleter GoToReferences<CR> |
      \   nnoremap <buffer> <silent> <C-\>s  :YcmCompleter GoToReferences<CR>
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1

"let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_key_invoke_completion = '<C-x><C-x>'

let g:ycm_global_ycm_extra_conf = $HOME . '/.vim/ycm_extra_conf_global.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_max_diagnostics_to_display = 10000
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings = 1

let g:ycm_rust_src_path = $HOME . '/.local/src/rust/src'

"let g:ycm_error_symbol = '⨉'
"let g:ycm_warning_symbol = '⚠'

function! s:onCompleteDone()
  let abbr = v:completed_item.abbr
  let startIdx = stridx(abbr,"(")
  if startIdx < 0
    return abbr
  endif
  let endIdx = strridx(abbr,")")
  if endIdx - startIdx > 1
    let argsStr = strpart(abbr, startIdx+1, endIdx - startIdx -1)
    "let argsList = split(argsStr, ",")

    let argsList = []
    let arg = ''
    let countParen = 0
    for i in range(strlen(argsStr))
      if argsStr[i] == ',' && countParen == 0
        call add(argsList, arg)
        let arg = ''
      elseif argsStr[i] == '('
        let countParen += 1
        let arg = arg . argsStr[i]
      elseif argsStr[i] == ')'
        let countParen -= 1
        let arg = arg . argsStr[i]
      else
        let arg = arg . argsStr[i]
      endif
    endfor
    if arg != '' && countParen == 0
      call add(argsList, arg)
    endif
  else
    let argsList = []
  endif

  let snippet = '('
  let c = 1
  for i in argsList
    if c > 1
      let snippet = snippet . ", "
    endif
    " strip space
    let arg = substitute(i, '^\s*\(.\{-}\)\s*$', '\1', '')
    let snippet = snippet . '${' . c . ":" . arg . '}'
    let c += 1
  endfor
  let snippet = snippet . ')' . "$0"
  return UltiSnips#Anon(snippet)
endfunction

autocmd VimEnter * imap <expr> (
      \ pumvisible() && exists('v:completed_item') && !empty(v:completed_item) &&
      \ v:completed_item.word != '' && (v:completed_item.kind == 'f' \|\|
      \ v:completed_item.kind == 'm') ?
      \ "\<C-R>=\<SID>onCompleteDone()\<CR>" : "<Plug>delimitMate("

autocmd VimEnter * imap <expr> <CR>
      \ pumvisible() ?
      \   (exists('v:completed_item') && !empty(v:completed_item) &&
      \     v:completed_item.word != '' && (v:completed_item.kind == 'f' \|\|
      \     v:completed_item.kind == 'm')) ?
      \       "\<C-R>=\<SID>onCompleteDone()\<CR>" :
      \       "\<C-y>" :
      \   "\<Plug>delimitMateCR\<Plug>DiscretionaryEnd"

" }}}

let g:syntastic_auto_loc_list = 0

" NERDTree settings
let g:NERDTreeDirArrows = 1
"let g:NERDTreeWinSize = 40

" NERDTreeTabs settings {{{
let g:nerdtree_tabs_open_on_gui_startup = 0
nnoremap <silent> <M-1> :NERDTreeTabsToggle<CR>
inoremap <silent> <M-1> <C-o>:NERDTreeTabsToggle<CR>
" }}}

" Tagbar settings
nnoremap <silent> <M-0> :TagbarToggle<CR>
inoremap <silent> <M-0> <C-o>:TagbarToggle<CR>

" Indent Guides settings
"autocmd FileType python IndentGuidesEnable
"let g:indent_guides_color_change_percent = 5
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" indentLine settings
"let g:indentLine_char = '┊'
let g:indentLine_first_char = ''
let g:indentLine_faster = 1

" Taggist settings {{{
if has('win32') || has('win64')
  let g:taggist_vim_bin = 'vim.bat'
endif
let g:taggist_indexers = ['cscope']
" }}}

" delimiterMate settings
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
let g:delimitMate_balance_matchpairs = 1
autocmd VimEnter * imap <silent> <expr> <TAB> delimitMate#ShouldJump() ? delimitMate#JumpAny() : "\<C-r>=UltiSnips#ExpandSnippetOrJump()\<CR>"
autocmd VimEnter * inoremap <S-TAB> <S-TAB>

" vim-airline settings
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_nr_format = '%s '
let g:airline_powerline_fonts = 1

" MiniBufExpl
if 0
  let g:miniBufExplCycleArround = 1
  let g:miniBufExplUseSingleClick = 1
  let g:did_minibufexplorer_syntax_inits = 1

  au FileType minibufexpl call s:MiniBufExplHighlights()

  function! s:MiniBufExplHighlights()
    hi link MBENormal               Normal
    hi link MBEChanged              String
    hi link MBEVisibleNormal        Special
    hi link MBEVisibleChanged       Error
    hi link MBEVisibleActiveNormal  StatusLineNC
    call brglng#hilink('MBEVisibleActiveChanged', 'StatusLineNC', 'bg', 'Error', 'fg')
  endfunction
endif

" NERDCommenter
let NERDSpaceDelims = 1

" Git Gutter
if has('win32')
  let g:gitgutter_realtime = 0
  let g:gitgutter_eager = 0
endif

" ConqueGDB
nnoremap <Leader>g <Nop>
let g:ConqueGdb_Leader = '<Leader>g'

" ALE
" let g:ale_sign_error = '⨉'
let g:ale_sign_warning = '>>'
let g:ale_linters = {'c': [], 'cpp': []}
let g:ale_python_pylint_options = '-d E265 -d E501 -d E201 -d E202 -d E111 -d W0311 -d C0111 -d C0103 -d C0326 -d C0111 -E114 -E122'
let g:ale_python_flake8_args = '--ignore=W0311,E265,E501,E201,E202,E111,E114,E122'

" Neomake
call neomake#configure#automake({
      \ 'TextChanged': {},
      \ 'InsertLeave': {},
      \ 'BufWritePost': {'delay': 0},
      \ 'BufWinEnter': {},
      \ }, 500)

" DevIcons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
" let g:DevIconsEnableFoldersOpenClose = 1

" Denite.vim {{{
call denite#custom#option('_', 'auto_resize', 1)
call denite#custom#option('_', 'vertical_preview', 1)
" call denite#custom#option('_', 'auto_highlight', 0)
call denite#custom#option('_', 'highlight_matched_char', 'Underlined')
call denite#custom#var('file_rec', 'command', ['bfind'])
call denite#custom#source('file,' .
      \                   'file_rec,' .
      \                   'directory_rec',
      \                   'matchers', ['matcher_fuzzy', 'matcher_project_files'])
"call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])
let g:neomru#file_mru_ignore_pattern = '\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(\\\\\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)\|\%(^\%(fugitive\)://\)\|\%(^\%(term\)://\)'
call denite#custom#var('file_mru', 'ignore_pattern', '\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(\\\\\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)\|\%(^\%(fugitive\)://\)\|\%(^\%(term\)://\)')
let g:neomru#directory_mru_ignore_pattern = '\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(\\\\\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'
call denite#custom#var('directory_mru', 'ignore_pattern', '\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(\\\\\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)')
if executable('ag')
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
elseif executable('ack')
  call denite#custom#var('grep', 'command', ['ack'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--ackrc', $HOME.'/.ackrc', '-H',
        \  '--nopager', '--nocolor', '--nogroup', '--column'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--match'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
elseif executable('win32')
  call denite#custom#var('grep', 'command', ['findstr'])
  call denite#custom#var('grep', 'recursive_opts', ['/s'])
  call denite#custom#var('grep', 'default_opts', ['/n'])
endif

call denite#custom#map('insert', '<TAB>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<S-TAB>', '<denite:move_to_previous_line>', 'noremap')

" }}}

" UI settings {{{
set mouse=a

if has('gui_running') || exists('g:GuiLoaded') || exists('g:nyaovim_version') || exists('g:gui_oni')
  if exists('&termguicolors')
    set termguicolors
  endif
  if has('nvim')
    call rpcnotify(1, 'Gui', 'Font', 'Fira Code:h11')
    call rpcnotify(1, 'Gui', 'Linespace', '0')
    " call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
  endif
else
  set t_Co=16
  let g:solarized_use16 = 1
  let g:onedark_termcolors = 16
endif

syntax on
set background=dark
colorscheme solarized8

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
    set guifont=Fira_Code:h11,Ubuntu_Mono_for_Powerline:h13,Consolas:h12,Lucida_Console:h12,Courier_New:h12
  elseif has('mac') || has('macunix')
    set guifont=Fira_Code:h14,Ubuntu_Mono_for_Powerline:h13,Menlo:h12
  elseif has('unix')
    if system('uname -s') == "Linux\n"
      " font height bug of GVim on Ubuntu
      let $LC_ALL='en_US.UTF-8'
    endif
    set guifont=Fira\ Code\ 11,Ubuntu\ Mono\ for\ Powerline\ 13,DejaVu\ Sans\ Mono\ 12
  endif
  if has('mac') || has('macunix')
    set guifontwide=Noto_Sans_CJK_SC:h12,Noto_Sans_CJK_TC:h12,Noto_Sans_CJK_JP:h12,Noto_Sans_CJK_KR:h12,Hiragino_Sans_GB:h12,STHeiti:h12
  elseif has('unix')
    set guifontwide=Noto\ Sans\ CJK\ SC\ 12,Noto\ Sans\ CJK\ TC\ 12,Noto\ Sans\ CJK\ JP\ 12,Noto\ Sans\ CJK\ KR\ 12,WenQuanYi\ Zen\ Hei\ 12,WenQuanYi\ Micro\ Hei\ 12
  endif
endif
" }}}

" Key bindings

" Some Emacs-like keys in insert mode and command-line mode
inoremap <silent> <C-n>     <Down>
inoremap <silent> <C-p>     <Up>
inoremap <silent> <C-b>     <Left>
inoremap <silent> <C-f>     <Right>
inoremap <silent> <C-BS>    <C-w>
inoremap <silent> <M-b>     <C-Left>
inoremap <silent> <M-f>     <C-Right>
inoremap <silent> <M-k>     <C-Right><C-w>
inoremap <silent> <C-a>     <C-o>^
inoremap <silent> <C-e>     <End>
inoremap <silent> <C-x>o    <C-o><C-w>w

cnoremap <silent> <C-b>     <Left>
cnoremap <silent> <C-f>     <Right>
cnoremap <silent> <C-BS>    <C-w>
cnoremap <silent> <M-b>     <C-Left>
cnoremap <silent> <M-f>     <C-Right>
cnoremap <silent> <M-k>     <C-Right><C-w>
cnoremap <silent> <C-a>     <Home>

" buffer
nnoremap <silent> <Leader>bp    :bp<CR>
nnoremap <silent> <Leader>bn    :bn<CR>
nnoremap <silent> <Leader>b1    :b 1<CR>
nnoremap <silent> <Leader>b2    :b 2<CR>
nnoremap <silent> <Leader>b3    :b 3<CR>
nnoremap <silent> <Leader>b4    :b 4<CR>
nnoremap <silent> <Leader>b5    :b 5<CR>
nnoremap <silent> <Leader>b6    :b 6<CR>
nnoremap <silent> <Leader>b7    :b 7<CR>
nnoremap <silent> <Leader>b8    :b 8<CR>
nnoremap <silent> <Leader>b9    :b 9<CR>

" window
nnoremap <silent> <Leader>wp    <C-w>p
nnoremap <silent> <Leader>wn    <C-w>n
nnoremap <silent> <Leader>wq    <C-w>q
nnoremap <silent> <Leader>ww    <C-w>w
nnoremap <silent> <Leader>ws    <C-w>s
nnoremap <silent> <Leader>wv    <C-w>v
nnoremap <silent> <Leader>w1    1<C-w>w
nnoremap <silent> <Leader>w2    2<C-w>w
nnoremap <silent> <Leader>w3    3<C-w>w
nnoremap <silent> <Leader>w4    4<C-w>w
nnoremap <silent> <Leader>w5    5<C-w>w
nnoremap <silent> <Leader>w6    6<C-w>w
nnoremap <silent> <Leader>w7    7<C-w>w
nnoremap <silent> <Leader>w8    8<C-w>w
nnoremap <silent> <Leader>w9    9<C-w>w

" QuickFix and Location windows
nnoremap <silent> <Leader>cw    :call <SID>QuickFixToggle('copen')<CR>
nnoremap <silent> <Leader>lw    :call <SID>QuickFixToggle('lopen')<CR>
function! s:QuickFixToggle(opencmd)
  let quickfix_opened = 0
  for nr in range(1, winnr('$'))
    if getbufvar(winbufnr(nr), '&buftype') == 'quickfix'
      let quickfix_opened = 1
      break
    endif
  endfor
  if quickfix_opened == 1
    if getbufvar(bufnr('%'), '&buftype') == 'quickfix'
      wincmd p
    endif
    cclose
    lclose
  else
    execute 'botright ' . a:opencmd
    "wincmd p
  endif
endfunction

" search and replace
nnoremap <Leader>gs     :%s/\<<C-r><C-w>\>/
nnoremap <Leader>gr     :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>gR     :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>s      :.,$s/\<<C-r><C-w>\>/
nnoremap <Leader>r      :.,$s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>R      :.,$s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" denite
nnoremap <silent> <Leader>df :Denite -buffer-name=file_rec      -resume file_rec<CR>
nnoremap <silent> <Leader>dd :Denite -buffer-name=file          -resume file<CR>
nnoremap <silent> <Leader>db :Denite -buffer-name=buffer                buffer<CR>
nnoremap <silent> <Leader>dg :Denite -buffer-name=grep          -resume grep<CR>
nnoremap <silent> <Leader>dG :Denite -buffer-name=grep                  grep<CR>
nnoremap <silent> <Leader>dl :Denite -buffer-name=line_<C-r>%   -resume line<CR>
nnoremap <silent> <Leader>dL :Denite -buffer-name=line_<C-r>%           line<CR>
nnoremap <silent> <Leader>do :Denite -buffer-name=outline               outline<CR>
nnoremap <silent> <Leader>dr :Denite -buffer-name=file_mru      -resume file_mru<CR>
nnoremap <silent> <Leader>dR :Denite -buffer-name=file_mru              file_mru<CR>
