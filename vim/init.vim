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
set autoread                    " auto read files modified outside vim
if has('win32') || !zpan#is_sudo()
  set nobackup                  " do not create backups before editing
  set nowritebackup
endif
set backupcopy=yes
"set noswapfile

set showcmd                   " show commands in normal mode at the right-bottom
set noshowmode
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
set shortmess+=c
set wildmenu
if has('nvim')
  set wildoptions=pum
endif
"if has('unnamedplus')
"    set clipboard+=unnamedplus
"else
"    set clipboard+=unnamed
"endif
set listchars=tab:>-,trail:.,extends:>,precedes:<
" set list
"set scrolloff=3
set sidescrolloff=5
" set cursorline                  " highlight current line
set showmatch                   " blink matched pairs
set matchtime=0
autocmd FileType html,xml setlocal matchpairs+=<:>
set updatetime=300

" set notimeout
" set timeoutlen=4000
" set ttimeout
" set ttimeoutlen=100

set hidden

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif
if &shell =~# 'fish$'
  set shell=/bin/bash
endif
set history=1000
set tabpagemax=50
set sessionoptions-=options

" set confirm
"set switchbuf=usetab,newtab,useopen

" set nostartofline
" set splitbelow
" set splitright

" set colorcolumn=80

" arrow keys and wrap settings
set wrap                        " auto wrap long lines
set whichwrap=b,s,<,>,[,]       " cursor auto move to next/previous line when reach line's tail/head
set backspace=indent,eol,start  " backspace can delete newlines in insert mode
"set textwidth=78                " auto break lines longer than 78 charactors

set selectmode=                 " always use visual mode

" tab and indent settings
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
set showtabline=2

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
" set foldcolumn=2
autocmd FileType vim setl foldmethod=marker foldnestmax=3
autocmd FileType c setl foldnestmax=1
autocmd FileType cpp setl foldnestmax=3
autocmd FileType python setl foldmethod=indent foldnestmax=2
autocmd FileType * let &l:foldcolumn = &l:foldnestmax + 1

" omni complete settings
set completeopt=menuone,noinsert,noselect
set pumheight=15
silent! set pumblend=15

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
  if executable('vim-rg.cmd')
    let &grepprg = 'vim-rg.cmd --vimgrep'
  elseif executable('vim-ag.cmd')
    let &grepprg = 'vim-ag.cmd --vimgrep'
  endif
else
  if executable('rg')
    let &grepprg = 'rg --vimgrep'
  elseif executable('ag')
    let &grepprg = 'ag --vimgrep'
  endif
endif

" Exuberant-ctags and Cscope settings
set tags=./.tags;,.tags;./tags;tags
if executable('gtags-cscope')
  set cscopeprg=gtags-cscope
  let $CSCOPE_DB = 'GTAGS'
endif
set cscopequickfix=s-,c-,d-,i-,t-,e-

let mapleader = "\<Space>"
runtime zpan/init/plugins.vim
runtime zpan/init/key_mappings.vim
runtime zpan/init/ui.vim
