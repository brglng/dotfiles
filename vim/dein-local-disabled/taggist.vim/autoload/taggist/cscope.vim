" File:         autoload/taggist/cscope.vim
" Author:       Zhaosheng Pan <github.com/brglng>

if exists('g:loaded_taggist_cscope') && g:loaded_taggist_cscope
    finish
endif

let g:loaded_taggist_cscope = 1

function! taggist#cscope#kill()
    silent! cscope kill -1
endfunction

function! taggist#cscope#add(filename, pre_path)
    echoerr 'a:pre_path = ' . a:pre_path
    silent! execute 'silent! cscope add ' . a:filename . ' ' . a:pre_path
endfunction
