" File:         plugin/taggist.vim
" Maintainer:   Zhaosheng Pan <brglng at gmail dot com>
" Version:      0.1.0
" License:      LGPL

if v:version < 700
    finish
endif

if !has('python') && !has('python3')
    finish
endif

if exists('g:loaded_plugin_taggist')
    finish
endif
let g:loaded_plugin_taggist = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:taggist_update_interval')
    let g:taggist_update_interval = 30
endif

command! -nargs=? -complete=file TaggistStart call taggist#start(<f-args>)
command! -nargs=0 TaggistStop call taggist#stop()
command! -nargs=0 TaggistUpdate call taggist#update()

augroup Taggist
    autocmd BufWritePost,CursorHold,CursorHoldI,CursorMoved,CursorMovedI * call taggist#update_regularly()
augroup END

let &cpo = s:save_cpo
