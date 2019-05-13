" File:         plugin/taggist.vim
" Author:       Zhaosheng Pan <github.com/brglng>

if v:version < 700
    finish
endif

if !has('python') && !has('python3')
    finish
endif

if !has('clientserver')
    finish
endif

if exists('g:loaded_plugin_taggist')
    finish
endif
let g:loaded_plugin_taggist = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:taggist_interval')
    let g:taggist_interval = 30
endif

if !exists('g:taggist_vim_bin')
    let g:taggist_vim_bin = 'vim'
endif

if !exists('g:taggist_python_bin')
    let g:taggist_python_bin = 'python'
endif

if !exists('g:taggist_config_file_name')
    let g:taggist_config_file_name = '.taggist.py'
endif

if !exists('g:taggist_indexers')
    let g:taggist_indexers = ['exuberant_ctags', 'cscope']
endif

autocmd VimLeave * call taggist#stop()

"command! -nargs=0 TaggistUpdate call taggist#update()

command! -nargs=0 -complete=file TaggistStart call taggist#start()
command! -nargs=0 TaggistStop call taggist#stop()
command! -nargs=0 TaggistShowLog call taggist#showlog()

let &cpo = s:save_cpo
