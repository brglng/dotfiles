call plug#begin('~/.cache/vim/plugged')

Plug 'junegunn/vim-plug'

" Generic Plugins
Plug 'roxma/nvim-yarp', !has('nvim') ? {} : { 'on': [] }
Plug 'roxma/vim-hug-neovim-rpc', !has('nvim') ? {} : { 'on': [] }
Plug 'tpope/vim-eunuch'

" UI Plugins
Plug 'ryanoasis/vim-devicons'
Plug 'justinmk/vim-dirvish'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'Yggdroot/indentLine'
" Plug 'nathanaelkane/vim-indent-guides'
Plug 'mbbill/fencview'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'

" Moving Plugins
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'easymotion/vim-easymotion'
Plug 'rhysd/clever-f.vim'
Plug 'andymass/vim-matchup'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function'
Plug 'sgur/vim-textobj-parameter'

" Editing Plugins
" Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdcommenter'
" Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'Shougo/vinarise.vim'

" FileType Plugins
Plug 'PProvost/vim-ps1'
Plug 'aklt/plantuml-syntax'
Plug 'hynek/vim-python-pep8-indent'
Plug 'sheerun/vim-polyglot'
" Plug 'Shougo/deorise.vim'

" Source Control Plugins
Plug 'tpope/vim-fugitive'
Plug 'will133/vim-dirdiff'
Plug 'gregsexton/gitv'
Plug 'iamcco/sran.nvim', { 'do': { -> sran#util#install() } }
Plug 'iamcco/git-p.nvim'

" Searching plugin: denite.vim and plugins
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'

" Project management
Plug 'Shougo/defx.nvim'
Plug 'kristijanhusak/defx-git'
Plug 'kristijanhusak/defx-icons'
Plug 'editorconfig/editorconfig-vim'
" Plug 'ludovicchabant/vim-gutentags'

" Language Sementic Plugins
" Plug 'neomake/neomake'
Plug 'w0rp/ale'

" if has('win32')
"   let g:ycm_server_python_interpreter = 'py -3'
"   let ycm_python_interpreter = 'py -3'
" else
"   let ycm_python_interpreter = 'python3'
" endif
" if !exists('g:gui_oni')
"   Plug 'Valloric/YouCompleteMe', {'do':  ycm_python_interpreter . ' install.py --clang-completer --racer-completer --tern-completer'})
" endif
" Plug 'tenfyzhong/CompleteParameter.vim'

Plug 'neoclide/coc.nvim', { 'tag': '*', 'do': './install.sh' }
Plug 'honza/vim-snippets'
" Plug 'majutsushi/tagbar'
" Plug 'lvht/tagbar-markdown'
Plug 'liuchengxu/vista.vim'

" Debuggig Plugins
" call dein#add('cpiger/NeoDebug')

" ColorSchemes
Plug 'lifepillar/vim-solarized8'
Plug 'iCyMind/NeoSolarized'
Plug 'sickill/vim-monokai'
Plug 'chriskempson/vim-tomorrow-theme'
" Plug 'chriskempson/base16-vim')
Plug 'junegunn/seoul256.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'soft-aesthetic/soft-era-vim'

call plug#end()

if empty(glob('~/.cache/vim/plugged/vim-plug/plug.vim'))
  autocmd VimEnter * PlugInstall --sync
endif

if !empty(glob('~/.cache/vim/plugged/vim-plug/plug.vim'))
  " runtime zpan/init/plugins/complete_parameter.vim
  runtime zpan/init/plugins/coc.vim
  runtime zpan/init/plugins/defx.vim
  runtime zpan/init/plugins/dein_ui.vim
  runtime zpan/init/plugins/delimit_mate.vim
  runtime zpan/init/plugins/denite.vim
  runtime zpan/init/plugins/endwise.vim
  runtime zpan/init/plugins/git_p.vim
  runtime zpan/init/plugins/lightline.vim
  " runtime zpan/init/plugins/tagbar.vim
  " runtime zpan/init/plugins/ultisnips.vim
  runtime zpan/init/plugins/undotree.vim
  runtime zpan/init/plugins/vista.vim
  " runtime zpan/init/plugins/you_complete_me.vim
endif
