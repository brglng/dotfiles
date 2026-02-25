let s:SEP = has('win32') ? '\' : '/'

" The default runtimepath on windows is $USERPROFILE/vimfiles, but I am not going to use it
if ((has('win32') || has('win64')) && !has('win32unix')) && !has('nvim')
    let &runtimepath = $HOME . '\.vim,' . &runtimepath . ',' . $HOME . '\.vim\after'
endif

if !has('nvim')
    let &runtimepath = &runtimepath . ',' . s:SEP . 'usr'. s:SEP . 'local' . s:SEP . 'share' . s:SEP . 'vim' . s:SEP . 'vimfiles'
endif

if exists('g:neovide')
    if has('win32')
        let $PATH = $HOME . '\.local\bin;' . $HOME . '\.cargo\bin;' . $PATH
    else
        let $PATH = $HOME . '/.local/bin:' . $HOME . '/.cargo/bin:' . $HOME . '/.pixi/bin:' . $PATH
    endif
endif

if !has('nvim')
    if has('win32')
        let s:viewdir = $LOCALAPPDATA . '\vim-data\view'
    else
        let s:viewdir = $HOME . '/.local/state/vim/view'
    endif
    if !isdirectory(s:viewdir)
        if !brglng#is_sudo()
            silent call mkdir(s:viewdir, 'p')
            let &viewdir = s:viewdir
        endif
    else
        let &viewdir = s:viewdir
    endif
endif

if system('hostname')[:-2] == 'zhaosheng-MacBookAir2022.local'
    let $XDG_RUNTIME_DIR = $HOME . '/.local/tmp'
    let $TMPDIR = $HOME . '/.local/tmp'
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
set mouse=a                     " mouse is on
set nocompatible                " turn of vi compatible mode
set winaltkeys=no
"set helplang=cn                 " Chinese help
set autoread                    " auto read files modified outside vim
if !brglng#is_sudo()
    set nobackup                  " do not create backups before editing
    set nowritebackup
endif
set backup
set writebackup
set backupcopy=yes
if has('nvim')
    let s:backupdir = stdpath('state') . '/backup'
else
    if has('win32')
        let s:backupdir = $LOCALAPPDATA . '\vim-data\backup'
    else
        let s:backupdir = $HOME . '/.local/state/vim/backup'
    endif
endif
if !isdirectory(s:backupdir)
    if !brglng#is_sudo()
        silent call mkdir(s:backupdir, 'p')
        let &backupdir = s:backupdir
    endif
else
    let &backupdir = s:backupdir
endif

set swapfile
if !has('nvim')
    if has('win32')
        let s:directory = $LOCALAPPDATA . '\vim-data\swap'
    else
        let s:directory = $HOME . '/.local/state/vim/swap'
    endif
    if !isdirectory(s:directory)
        if !brglng#is_sudo()
            silent call mkdir(s:directory, 'p')
            let &directory = s:directory
        endif
    else
        let &directory = s:directory
    endif
endif

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
" set relativenumber

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
set cursorline                  " highlight current line
set showmatch                   " blink matched pairs
set matchtime=0
autocmd FileType html,xml setlocal matchpairs+=<:>
set updatetime=300

set hidden

if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j " Delete comment character when joining commented lines
endif
set history=1000
set tabpagemax=50
set sessionoptions-=globals
set sessionoptions-=localoptions
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
set mousemodel=popup
set keymodel=startsel,stopsel
set selection=exclusive

" tab and indent settings
set autoindent
set cindent
set cinoptions=Ls,l1,g0,N-s,E-s,t0,(0,u0,U1,w1,Ws,m1,j1,J1,)10000,*10000
set tabstop=4
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
" if exists('&breakindent')
"     autocmd FileType *
"     \   if index(['', 'markdown', 'txt', 'norg'], &filetype) >= 0 |
"     \       if &filetype == 'norg' |
"     \           setlocal breakindent |
"     \       else |
"     \           setlocal nobreakindent |
"     \       endif |
"     \       setlocal showbreak= |
"     \   else |
"     \       setlocal breakindent |
"     \       setlocal showbreak=⤷\  |
"     \   endif
" endif
set breakindent
set showtabline=2
let g:vim_indent_cont = 0

autocmd BufRead,BufNewFile *.md set filetype=markdown
" autocmd BufRead,BufNewFile *.md set spell

if !has('nvim')
    if has('win32')
        let s:undodir = $LOCALAPPDATA . '\vim-data\undo'
    else
        let s:undodir = $HOME . '/.local/state/vim/undo'
    endif
    if !isdirectory(s:undodir)
        if !brglng#is_sudo()
            silent call mkdir(s:undodir, 'p')
            let &undodir = s:undodir
        endif
    else
        let &undodir = s:undodir
    endif
endif
set undofile

" fold settings
set foldmethod=syntax
"set foldminlines=500
set foldcolumn=1
set foldlevel=99
set foldlevelstart=99
set foldenable
" set foldnestmax=1
" autocmd FileType vim setl foldmethod=marker foldnestmax=3 foldcolumn=4
" autocmd FileType c setl foldnestmax=1 foldcolumn=2
" autocmd FileType cpp setl foldnestmax=3 foldcolumn=4
" autocmd FileType python setl foldmethod=indent foldnestmax=2 foldcolumn=3
" autocmd FileType rust setl foldnestmax=2 foldcolumn=3
" autocmd FileType * let &l:foldcolumn = &l:foldnestmax + 1
set diffopt+=context:99999

" omni complete settings
set completeopt=menuone,noinsert,noselect
set pumheight=15
silent! set pumblend=0

" Always show the complete popup under the cursor,
" except when the cursor is at the last 3 lines on the screen.
" When the cursor is at the last 3 lines on the screen,
" always set pumheight=15
" autocmd CursorMoved,CursorMovedI *
" \   if winline() <= winheight('%') - 4 |
" \       let &pumheight = min([winheight('%') - winline() - 1, 15]) |
" \   else |
" \       set pumheight=15 |
" \   endif

" set formatoptions+=a
set formatoptions-=ro

if executable('rg')
    let &grepprg = 'rg --vimgrep'
elseif executable('ag')
    let &grepprg = 'ag --vimgrep'
endif

" Exuberant-ctags and Cscope settings
set tags=./.tags;,.tags;./tags;tags
if exists('&cscopeprg') && exists('&cscopequickfix')
    if executable('gtags-cscope')
        set cscopeprg=gtags-cscope
        let $CSCOPE_DB = 'GTAGS'
    endif
    set cscopequickfix=s-,c-,d-,i-,t-,e-
endif

let mapleader = "\<Space>"

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

if has('nvim')
    if exists('$CONDA_PYTHON_EXE') && executable('python') && system('which python')[:-2] == $CONDA_PYTHON_EXE
        " We are in Conda environment
        let g:python3_host_prog = $CONDA_PYTHON_EXE
    elseif executable('python3')
        let g:python3_host_prog = system('which python3')[:-2]
    elseif executable('python') && system("python -c 'import sys; print(sys.version_info[0])'")[:-2] == '3'
        let g:python3_host_prog = system('which python')[:-2]
    endif
endif

" let g:loaded_netrw       = 1
" let g:loaded_netrwPlugin = 1

let g:plug_timeout = 300

let s:plugdir = has('win32') ? $LOCALAPPDATA .. '\vim-data\plugged' : '~/.local/state/vim/plugged'
call plug#begin(s:plugdir)

function! VimOnly(...)
    if a:0 > 1
        return extendnew(a:1, has('nvim') ? {'on': []} : {})
    else
        return has('nvim') ? {'on': []} : {}
    endif
endfunction

function! NeovimOnly(...)
    if a:0 > 1
        return extendnew(a:1, has('nvim') ? {} : {'on': []})
    else
        return has('nvim') ? {} : {'on': []}
    endif
endfunction

" Generic Plugins
runtime init/plugins/cppman.vim
" runtime init/plugins/nvim_yarp.vim
" runtime init/plugins/hug_neovim_rpc.vim
" runtime init/plugins/tmux_focus_events.vim
" runtime init/plugins/tmux_clipboard.vim
runtime init/plugins/im_select.vim

" Documentation
" runtime init/plugins/doge.vim
" runtime init/plugins/dasht.vim

" UI Plugins
" runtime init/plugins/devicons.vim
" runtime init/plugins/dirvish.vim
" runtime init/plugins/lightline.vim
" runtime init/plugins/fencview.vim
runtime init/plugins/undotree.vim
" runtime init/plugins/startify.vim
" runtime init/plugins/which_key.vim
runtime init/plugins/sidebar_manager.vim
" runtime init/plugins/defx.vim
" runtime init/plugins/netrw.vim
" runtime init/plugins/terminal_help.vim
" runtime init/plugins/vista.vim
" runtime init/plugins/dein_ui.vim
" runtime init/plugins/indent_line.vim

" Fuzzy Finder
" runtime init/plugins/denite.vim
" runtime init/plugins/leaderf.vim
" runtime init/plugins/clap.vim

" Moving Plugins
" runtime init/plugins/clever_f.vim
" runtime init/plugins/unimpaired.vim
" runtime init/plugins/surround.vim
" runtime init/plugins/targets.vim
" runtime init/plugins/matchup.vim
" runtime init/plugins/textobj.vim

" Editing Plugins
" runtime init/plugins/nerd_commenter.vim
" runtime init/plugins/tcomment.vim
runtime init/plugins/easy_align.vim
" runtime init/plugins/endwise.vim
" runtime init/plugins/sleuth.vim
runtime init/plugins/repeat.vim
runtime init/plugins/abolish.vim
runtime init/plugins/cycle.vim
" runtime init/plugins/vim_visual_multi.vim

" FileType Plugins
" runtime init/plugins/ps1.vim
" runtime init/plugins/plantuml_syntax.vim
" runtime init/plugins/python_pep8_indent.vim
" runtime init/plugins/polyglot.vim
" runtime init/plugins/tmux.vim

" Source Control Plugins
" runtime init/plugins/fugitive.vim

" Project management
runtime init/plugins/asyncrun.vim
runtime init/plugins/asynctasks.vim

" LSP
" runtime init/plugins/coc.vim
" runtime init/plugins/coc_explorer.vim
" runtime init/plugins/coc_smartf.vim
" runtime init/plugins/snippets.vim
" runtime init/plugins/any_jump.vim
" runtime init/plugins/neoformat.vim

" ColorSchemes
runtime init/plugins/colors/init.vim

call plug#end()

call brglng#install_missing_plugins(v:true)

if has('nvim')
    runtime lua/init.lua
endif

runtime init/keymaps.vim
runtime init/ui.vim

" vim: ts=8 sts=4 sw=4 et
