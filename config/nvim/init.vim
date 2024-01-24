" The default runtimepath on windows is $USERPROFILE/vimfiles, but I am not going to use it
if ((has('win32') || has('win64')) && !has('win32unix')) && !has('nvim')
    let &runtimepath = $HOME . '/.vim,' . &runtimepath . ',' . $HOME . '/.vim/after'
endif

if !has('nvim')
    let &runtimepath = &runtimepath . ',/home/linuxbrew/.linuxbrew/share/vim/vimfiles'
    let &runtimepath = &runtimepath . ',/usr/local/share/vim/vimfiles'
endif

if has('nvim')
    let s:viewdir = $HOME . '/.cache/nvim/view'
else
    let s:viewdir = $HOME . '/.cache/vim/view'
endif
if !isdirectory(s:viewdir)
    if !zpan#is_sudo()
        silent call mkdir(s:viewdir, 'p')
        let &viewdir = s:viewdir
    endif
else
    let &viewdir = s:viewdir
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
set backup
set writebackup
set backupcopy=yes
if has('nvim')
    let s:backupdir = $HOME . '/.cache/nvim/backup'
else
    let s:backupdir = $HOME . '/.cache/vim/backup'
endif
if !isdirectory(s:backupdir)
    if !zpan#is_sudo()
        silent call mkdir(s:backupdir, 'p')
        let &backupdir = s:backupdir
    endif
else
    let &backupdir = s:backupdir
endif

set swapfile
if has('nvim')
    let s:directory = $HOME . '/.cache/nvim/swap'
else
    let s:directory = $HOME . '/.cache/vim/swap'
endif
if !isdirectory(s:directory)
    if !zpan#is_sudo()
        silent call mkdir(s:directory, 'p')
        let &directory = s:directory
    endif
else
    let &directory = s:directory
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
" set cursorline                  " highlight current line
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
let g:vim_indent_cont = 2

autocmd BufRead,BufNewFile *.md set filetype=markdown
" autocmd BufRead,BufNewFile *.md set spell

if has('nvim')
    let s:undodir = $HOME . '/.cache/nvim/undo'
else
    let s:undodir = $HOME . '/.cache/vim/undo'
endif
if !isdirectory(s:undodir)
    if !zpan#is_sudo()
        silent call mkdir(s:undodir, 'p')
        let &undodir = s:undodir
    endif
else
    let &undodir = s:undodir
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
"       \ if winline() <= winheight('%') - 4 |
"       \   let &pumheight = min([winheight('%') - winline() - 1, 15]) |
"       \ else |
"       \   set pumheight=15 |
"       \ endif


" set formatoptions+=a

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

call plug#begin('~/.local/share/vim/plugged')

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
" Plug 'roxma/nvim-yarp', VimOnly()
" Plug 'roxma/vim-hug-neovim-rpc', VimOnly()
" Plug 'tmux-plugins/vim-tmux-focus-events', NeovimOnly()
" Plug 'roxma/vim-tmux-clipboard'
Plug 'brglng/vim-im-select'

" Documentation
Plug 'sunaku/vim-dasht'
Plug 'skywind3000/vim-cppman'
" Plug 'kkoomen/vim-doge'

" UI Plugins
Plug 'ryanoasis/vim-devicons'
Plug 'justinmk/vim-dirvish'
Plug 'itchyny/lightline.vim', VimOnly()
Plug 'mengelbrecht/lightline-bufferline', VimOnly()
Plug 'Yggdroot/indentLine', VimOnly()
Plug 'mbbill/fencview'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'liuchengxu/vim-which-key'
Plug 'Yggdroot/LeaderF'
Plug 'Yggdroot/LeaderF-marks'
Plug 'tamago324/LeaderF-filer'
Plug 'brglng/vim-sidebar-manager'

" Moving Plugins
Plug 'rhysd/clever-f.vim', VimOnly()
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround', VimOnly()
Plug 'wellle/targets.vim'
Plug 'andymass/vim-matchup'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function', VimOnly()
Plug 'sgur/vim-textobj-parameter', VimOnly()

" Editing Plugins
Plug 'tomtom/tcomment_vim', VimOnly()
Plug 'junegunn/vim-easy-align'
" Plug 'tpope/vim-endwise'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'bootleq/vim-cycle'
Plug 'mg979/vim-visual-multi'

" FileType Plugins
Plug 'PProvost/vim-ps1'
Plug 'aklt/plantuml-syntax'
Plug 'hynek/vim-python-pep8-indent'
Plug 'sheerun/vim-polyglot'
Plug 'tmux-plugins/vim-tmux'

" Source Control Plugins
Plug 'tpope/vim-fugitive'

" Project management
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asynctasks.vim'

" Language Semantic
" Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':silent! UpdateRemotePlugins'}
" Plug 'honza/vim-snippets'
Plug 'liuchengxu/vista.vim', VimOnly()

" ColorSchemes
Plug 'lifepillar/vim-solarized8'
Plug 'iCyMind/NeoSolarized'
Plug 'sickill/vim-monokai'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'chriskempson/base16-vim'
Plug 'junegunn/seoul256.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'joshdick/onedark.vim'
Plug 'rakr/vim-one'
Plug 'arcticicestudio/nord-vim'
Plug 'soft-aesthetic/soft-era-vim'
Plug 'sainnhe/lightline_foobar.vim', VimOnly()
Plug 'Luxed/ayu-vim'
" Plug 'nightsense/snow'
Plug 'cocopon/iceberg.vim'
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'hzchirs/vim-material'
Plug 'KeitaNakamura/neodark.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/forest-night'
Plug 'sainnhe/edge'
Plug 'sainnhe/sonokai'
Plug 'zeis/vim-kolor'
Plug 'EdenEast/nightfox.nvim'
Plug 'wuelnerdotexe/vim-enfocado'

call plug#end()

call zpan#install_missing_plugins(v:true)

runtime init/plugins/which_key.vim
" runtime init/plugins/any_jump.vim
runtime init/plugins/asyncrun.vim
runtime init/plugins/asynctasks.vim
" runtime init/plugins/clap.vim
if !zpan#is_sudo()
    " runtime init/plugins/coc.vim
    " runtime init/plugins/coc_explorer.vim
    " runtime init/plugins/coc_smartf.vim
endif
runtime init/plugins/cppman.vim
runtime init/plugins/cycle.vim
runtime init/plugins/dasht.vim
runtime init/plugins/doge.vim
" runtime init/plugins/defx.vim
" runtime init/plugins/dein_ui.vim
" runtime init/plugins/denite.vim
runtime init/plugins/devicons.vim
runtime init/plugins/easy_align.vim
" runtime init/plugins/endwise.vim
runtime init/plugins/im_select.vim
if !has('nvim')
    runtime init/plugins/indent_line.vim
endif
runtime init/plugins/leaderf.vim
if !has('nvim')
    runtime init/plugins/lightline.vim
endif
runtime init/plugins/matchup.vim
runtime init/plugins/nerd_commenter.vim
" runtime init/plugins/neoformat.vim
" runtime init/plugins/netrw.vim
runtime init/plugins/sidebar_manager.vim
runtime init/plugins/startify.vim
" runtime init/plugins/terminal_help.vim
runtime init/plugins/undotree.vim
runtime init/plugins/vim_visual_multi.vim
runtime init/plugins/vista.vim

runtime init/plugins/ayu.vim
runtime init/plugins/gruvbox_material.vim
runtime init/plugins/one.vim
runtime init/plugins/quantum.vim
runtime init/plugins/sonokai.vim
runtime init/plugins/everforest.vim

if has('nvim')
    runtime lua/init.lua
endif

runtime init/keymaps.vim
runtime init/ui.vim

function! s:find_project_root()
    let found = v:false
    let marker = ''
    let project_root = getcwd()
    while v:true
        if !empty(glob(project_root . '/.vim', v:true, v:true))
            let found = v:true
            let marker = '.vim'
            break
        endif
        if !empty(glob(project_root . '/.nvim', v:true, v:true))
            let found = v:true
            let marker = '.nvim'
            break
        endif
        let parentdir = simplify(project_root . '/..')
        if parentdir ==# project_root
            break
        endif
        let project_root = parentdir
    endwhile
    return [found, project_root, marker]
endfunction

function! s:load_local_config()
    let [found, project_root, marker] = s:find_project_root()
    if found
        let project_runtime = project_root . '/' . marker
        if isdirectory(project_runtime)
            let allrtp = split(&runtimepath, ',')
            for i in range(len(allrtp))
                let allrtp[i] = resolve(allrtp[i])
            endfor
            if index(allrtp, resolve(project_runtime)) < 0
                let &runtimepath = project_runtime . ',' . &runtimepath . ',' . project_runtime . '/after'
                if has('nvim') && !empty(glob(project_runtime . '/init.lua', v:true, v:true))
                    let init_script = project_runtime . '/init.lua'
                    echoerr 'Loading ' . init_script
                    execute 'source ' . init_script
                elseif !empty(glob(project_runtime . '/init.vim', v:true, v:true))
                    let init_script = project_runtime . '/init.vim'
                    echoerr 'Loading ' . init_script
                    execute 'source ' . init_script
                endif
                execute 'chdir ' . project_root
            endif
        else
            execute 'source ' . project_runtime
            execute 'chdir ' . project_root
        endif
    endif
endfunction
auto VimEnter * call s:load_local_config()

" vim: ts=8 sts=4 sw=4 et
