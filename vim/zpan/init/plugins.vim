if has('nvim')
  if exists('$CONDA_PYTHON_EXE') && executable('python') && system('which python')[:-2] == $CONDA_PYTHON_EXE
    " We are in Conda environment
    let g:python3_host_prog = $CONDA_PYTHON_EXE
  else
    " search for the python 3 binary in the system with the highest version
    let found_python3_exe = 0
    for minor in range(20, 0, -1)
      if executable('python3' . string(minor))
        let python3_version_major = str2nr(zpan#rstrip(system('python3 -c "import sys; print(sys.version_info[0])"'), "\r\n"))
        let python3_version_minor = str2nr(zpan#rstrip(system('python3 -c "import sys; print(sys.version_info[1])"'), "\r\n"))
        if python3_version_major == 3
          let found_python3_exe = 1
        endif
      endif
    endfor
    if !found_python3_exe
      if executable('python3')
        let python3_version_major = str2nr(zpan#rstrip(system('python3 -c "import sys; print(sys.version_info[0])"'), "\r\n"))
        let python3_version_minor = str2nr(zpan#rstrip(system('python3 -c "import sys; print(sys.version_info[1])"'), "\r\n"))
        if python3_version_major == 3
          let found_python3_exe = 1
        endif
      elseif executable('python')
        let python3_version_major = str2nr(zpan#rstrip(system('python -c "import sys; print(sys.version_info[0])"'), "\r\n"))
        let python3_version_minor = str2nr(zpan#rstrip(system('python -c "import sys; print(sys.version_info[1])"'), "\r\n"))
        if python3_version_major == 3
          let found_python3_exe = 1
        endif
      endif
    endif
  endif
endif

let g:dein#install_process_timeout = 3600 * 24      " internet is too slow in China...
let g:dein#types#git#clone_depth = 1
if &compatible
  set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  " Plugin Manager
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('haya14busa/dein-command.vim')
  call dein#add('wsdjeg/dein-ui.vim')

  " Generic Plugins
  call dein#add('roxma/nvim-yarp', {'if': !has('nvim')})
  call dein#add('roxma/vim-hug-neovim-rpc', {'if': !has('nvim')})
  call dein#add('tpope/vim-eunuch')
  call dein#add('tmux-plugins/vim-tmux-focus-events')
  call dein#add('roxma/vim-tmux-clipboard')

  " UI Plugins
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('justinmk/vim-dirvish')
  call dein#add('itchyny/lightline.vim')
  call dein#add('mengelbrecht/lightline-bufferline')
  call dein#add('Yggdroot/indentLine')
  " call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('mbbill/fencview')
  call dein#add('mbbill/undotree')
  call dein#add('mhinz/vim-startify')
  call dein#add('liuchengxu/vim-which-key')

  " Moving Plugins
  call dein#add('rhysd/clever-f.vim')
  call dein#add('tpope/vim-unimpaired')
  call dein#add('tpope/vim-surround')
  call dein#add('wellle/targets.vim')
  call dein#add('andymass/vim-matchup')
  call dein#add('kana/vim-textobj-user')
  call dein#add('kana/vim-textobj-indent')
  call dein#add('kana/vim-textobj-syntax')
  call dein#add('kana/vim-textobj-function')
  call dein#add('sgur/vim-textobj-parameter')

  " Editing Plugins
  " call dein#add('tpope/vim-commentary')
  call dein#add('scrooloose/nerdcommenter')
  call dein#add('junegunn/vim-easy-align')
  call dein#add('tpope/vim-sleuth')
  call dein#add('tpope/vim-repeat')
  call dein#add('mg979/vim-visual-multi')
  call dein#add('Shougo/vinarise.vim', {'hook_post_update': 'silent! UpdateRemotePlugins'})
  " call dein#add('Shougo/deorise.vim')

  " FileType Plugins
  call dein#add('PProvost/vim-ps1')
  call dein#add('aklt/plantuml-syntax')
  call dein#add('hynek/vim-python-pep8-indent')
  call dein#add('sheerun/vim-polyglot', {'merged': 0})
  call dein#add('tmux-plugins/vim-tmux')

  " Source Control Plugins
  call dein#add('tpope/vim-fugitive')
  call dein#add('will133/vim-dirdiff')
  call dein#add('gregsexton/gitv')

  " Project management
  call dein#add('editorconfig/editorconfig-vim')

  " Language Semantic
  call dein#add('neoclide/coc.nvim', {
        \ 'merged': 0,
        \ 'trusted': 0,
        \ 'rev': 'release',
        \ 'hook_post_update': 'silent! UpdateRemotePlugins | silent! CocUpdate'
        \ })
  call dein#add('honza/vim-snippets')
  call dein#add('liuchengxu/vista.vim')
  " call dein#add('sbdchd/neoformat')

  " Debuggig Plugins
  " call dein#add('cpiger/NeoDebug')

  " ColorSchemes
  call dein#add('lifepillar/vim-solarized8')
  call dein#add('iCyMind/NeoSolarized')
  call dein#add('sickill/vim-monokai')
  call dein#add('chriskempson/vim-tomorrow-theme')
  call dein#add('chriskempson/base16-vim')
  call dein#add('junegunn/seoul256.vim')
  call dein#add('nanotech/jellybeans.vim')
  call dein#add('NLKNguyen/papercolor-theme')
  call dein#add('joshdick/onedark.vim', {'merged': 0})
  call dein#add('arcticicestudio/nord-vim')
  call dein#add('soft-aesthetic/soft-era-vim', {'merged': 0})
  call dein#add('sainnhe/lightline_foobar.vim')

  call dein#end()
  call dein#save_state()
endif
filetype plugin indent on
syntax enable
if dein#check_install()
  call dein#install()
endif
call dein#local($HOME . '/.vim/dein-local', {}, ['vim-im-select'])
call dein#source(['vim-im-select'])

" if !zpan#is_sudo()
runtime zpan/init/plugins/coc.vim
runtime zpan/init/plugins/coc_explorer.vim
runtime zpan/init/plugins/coc_smartf.vim
" endif
runtime zpan/init/plugins/defx.vim
runtime zpan/init/plugins/dein_ui.vim
" runtime zpan/init/plugins/denite.vim
runtime zpan/init/plugins/devicons.vim
runtime zpan/init/plugins/easy_align.vim
runtime zpan/init/plugins/indent_line.vim
runtime zpan/init/plugins/lightline.vim
runtime zpan/init/plugins/matchup.vim
runtime zpan/init/plugins/nerd_commenter.vim
runtime zpan/init/plugins/neoformat.vim
runtime zpan/init/plugins/netrw.vim
runtime zpan/init/plugins/startify.vim
runtime zpan/init/plugins/undotree.vim
runtime zpan/init/plugins/vim_visual_multi.vim
runtime zpan/init/plugins/vista.vim
runtime zpan/init/plugins/which_key.vim
