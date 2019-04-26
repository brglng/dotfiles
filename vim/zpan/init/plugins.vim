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

  " Dein
  call dein#add($HOME . '/.local/share/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('haya14busa/dein-command.vim')
  call dein#add('wsdjeg/dein-ui.vim')

  " Generic Plugins
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#add('tpope/vim-eunuch')
  call dein#add('justinmk/vim-dirvish')

  " UI Plugins
  " call dein#add('scrooloose/nerdtree')
  " call dein#add('jistr/vim-nerdtree-tabs')
  call dein#add('Shougo/defx.nvim')
  call dein#add('kristijanhusak/defx-git')
  call dein#add('kristijanhusak/defx-icons')

  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

  call dein#add('Yggdroot/indentLine')
  " call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('majutsushi/tagbar')
  call dein#add('lvht/tagbar-markdown')
  call dein#add('mbbill/fencview')
  call dein#add('mbbill/undotree')
  call dein#add('ryanoasis/vim-devicons')
  " call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
  call dein#add('Xuyuanp/nerdtree-git-plugin')
  call dein#add('mhinz/vim-startify')

  " Moving and Editing Plugins
  if !exists('g:gui_oni')
    call dein#add('tpope/vim-unimpaired')
    call dein#add('tpope/vim-surround')
  endif
  call dein#add('wellle/targets.vim')
  "call dein#add('tpope/vim-commentary')
  call dein#add('scrooloose/nerdcommenter')
  "call dein#add('auto-pairs')
  " call dein#add('Raimondi/delimitMate')
  call dein#add('easymotion/vim-easymotion')
  " call dein#add('godlygeek/tabular')
  call dein#add('junegunn/vim-easy-align')
  " call dein#add('tpope/vim-endwise')
  call dein#add('tpope/vim-sleuth')
  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets')
  " call dein#add('Shougo/neosnippet.vim')
  " call dein#add('Shougo/neosnippet-snippets')
  call dein#add('rhysd/clever-f.vim')
  call dein#add('andymass/vim-matchup')
  call dein#add('tpope/vim-repeat')
  call dein#add('kana/vim-textobj-user')
  call dein#add('kana/vim-textobj-indent')
  call dein#add('kana/vim-textobj-syntax')
  call dein#add('kana/vim-textobj-function')
  call dein#add('sgur/vim-textobj-parameter')

  call dein#add('Shougo/vinarise.vim')

  " FileType Plugins
  call dein#add('PProvost/vim-ps1')
  call dein#add('aklt/plantuml-syntax')
  call dein#add('hynek/vim-python-pep8-indent')
  call dein#add('sheerun/vim-polyglot')

  " Source Control Plugins
  " call dein#add('airblade/vim-gitgutter')
  call dein#add('mhinz/vim-signify')
  call dein#add('tpope/vim-fugitive')
  call dein#add('will133/vim-dirdiff')
  call dein#add('gregsexton/gitv')

  " Searching plugin: denite.vim and plugins
  call dein#add('Shougo/denite.nvim')
  call dein#add('Shougo/neomru.vim')

  " ColorSchemes
  " call dein#add('lifepillar/vim-solarized8')
  " call dein#add('sickill/vim-monokai')
  " call dein#add('chriskempson/vim-tomorrow-theme')
  " call dein#add('chriskempson/base16-vim')
  " call dein#add('junegunn/seoul256.vim')
  " call dein#add('nanotech/jellybeans.vim')
  " call dein#add('NLKNguyen/papercolor-theme')
  " call dein#add('joshdick/onedark.vim')
  call dein#add('arcticicestudio/nord-vim')
  " call dein#add('soft-aesthetic/soft-era-vim')

  " Project Management
  call dein#add('editorconfig/editorconfig-vim')
  " call dein#add('ludovicchabant/vim-gutentags')

  " Language Sementic Plugins
  " call dein#add('neomake/neomake')
  call dein#add('w0rp/ale')
  if has('win32')
    let g:ycm_server_python_interpreter = 'py -3'
    let ycm_python_interpreter = 'py - 3'
  else
    let ycm_python_interpreter = 'python3'
  endif

  if !exists('g:gui_oni')
    call dein#add('Valloric/YouCompleteMe', {'build':  ycm_python_interpreter . ' install.py --clang-completer --racer-completer --tern-completer'})
  endif
  " call dein#add('Shougo/deoplete.nvim')
  " call dein#add('Shougo/deoplete-clangx')
  let g:deoplete#enable_at_startup = 1
  " call dein#add('tweekmonster/deoplete-clang2')
  if !has('win32')
    " call dein#add('autozimu/LanguageClient-neovim', {'rev': 'next', 'build': 'bash install.sh'})
  endif
  call dein#add('tenfyzhong/CompleteParameter.vim')

  " Debug
  " call dein#add('cpiger/NeoDebug')

  call dein#local($HOME . '/.vim/dein-local')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts------------------------- }}}

runtime zpan/init/plugins/complete_parameter.vim
runtime zpan/init/plugins/defx.vim
runtime zpan/init/plugins/dein-ui.vim
runtime zpan/init/plugins/denite.vim
runtime zpan/init/plugins/ultisnips.vim
runtime zpan/init/plugins/you_complete_me.vim
