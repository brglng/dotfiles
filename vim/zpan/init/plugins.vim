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

" Generic Plugins
Plug 'roxma/nvim-yarp', has('nvim') ? {'on': []} : {}
Plug 'roxma/vim-hug-neovim-rpc', has('nvim') ? {'on': []} : {}
Plug 'tpope/vim-eunuch'
Plug 'tmux-plugins/vim-tmux-focus-events', has('nvim') ? {} : {'on': []}
Plug 'roxma/vim-tmux-clipboard'
Plug 'brglng/vim-im-select'

" Documentation
Plug 'sunaku/vim-dasht'
Plug 'skywind3000/vim-cppman'
Plug 'kkoomen/vim-doge'
Plug 'voldikss/vim-translator'

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
Plug 'liuchengxu/vim-which-key'
" Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
Plug 'liuchengxu/vim-clap', {'do': ':Clap install-binary'}
Plug 'skywind3000/vim-terminal-help'
Plug 'brglng/vim-sidebar-manager'

" Moving Plugins
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'andymass/vim-matchup'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function'
Plug 'sgur/vim-textobj-parameter'

" Editing Plugins
" Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'mg979/vim-visual-multi'
Plug 'Shougo/vinarise.vim', {'do': ':silent! UpdateRemotePlugins'}
" call dein#add('Shougo/deorise.vim')

" FileType Plugins
Plug 'PProvost/vim-ps1'
Plug 'aklt/plantuml-syntax'
Plug 'hynek/vim-python-pep8-indent'
Plug 'sheerun/vim-polyglot'
Plug 'tmux-plugins/vim-tmux'
Plug 'iamcco/markdown-preview.nvim', {'do': {-> mkdp#util#install()}}

" Source Control Plugins
Plug 'tpope/vim-fugitive'
Plug 'will133/vim-dirdiff'
Plug 'gregsexton/gitv'

" Project management
Plug 'editorconfig/editorconfig-vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asynctasks.vim'

" Language Semantic
Plug 'neoclide/coc.nvim', {
  \ 'branch': 'release',
  \ 'do': {-> execute(['UpdateRemotePlugins', 'CocUpdate'], 'silent!')}
  \ }
Plug 'honza/vim-snippets'
Plug 'liuchengxu/vista.vim'
Plug 'pechorin/any-jump.vim'

" Debuggig Plugins
Plug 'puremourning/vimspector'

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
Plug 'arcticicestudio/nord-vim'
Plug 'soft-aesthetic/soft-era-vim'
Plug 'sainnhe/lightline_foobar.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'nightsense/snow'
Plug 'morhetz/gruvbox'

call plug#end()

autocmd VimEnter * call zpan#install_missing_plugins(v:false)

runtime zpan/init/plugins/which_key.vim
runtime zpan/init/plugins/any_jump.vim
runtime zpan/init/plugins/asyncrun.vim
runtime zpan/init/plugins/asynctasks.vim
runtime zpan/init/plugins/clap.vim
if !zpan#is_sudo()
    runtime zpan/init/plugins/coc.vim
    runtime zpan/init/plugins/coc_explorer.vim
    runtime zpan/init/plugins/coc_smartf.vim
endif
runtime zpan/init/plugins/cppman.vim
runtime zpan/init/plugins/dasht.vim
" runtime zpan/init/plugins/defx.vim
" runtime zpan/init/plugins/dein_ui.vim
" runtime zpan/init/plugins/denite.vim
runtime zpan/init/plugins/devicons.vim
runtime zpan/init/plugins/easy_align.vim
runtime zpan/init/plugins/indent_line.vim
" runtime zpan/init/plugins/leaderf.vim
runtime zpan/init/plugins/lightline.vim
runtime zpan/init/plugins/matchup.vim
runtime zpan/init/plugins/nerd_commenter.vim
" runtime zpan/init/plugins/neoformat.vim
" runtime zpan/init/plugins/netrw.vim
runtime zpan/init/plugins/sidebar-manager.vim
runtime zpan/init/plugins/startify.vim
runtime zpan/init/plugins/terminal_help.vim
runtime zpan/init/plugins/undotree.vim
runtime zpan/init/plugins/vim_visual_multi.vim
runtime zpan/init/plugins/vista.vim

" vim: sw=4 sts=4 ts=8 et
