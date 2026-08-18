set mousehide
set lines=48
set columns=100

" if has('win32')
" autocmd GUIEnter * simalt ~x
" endif

set guioptions+=aA
set guioptions-=T
" set guioptions-=r
" set guioptions-=L
set guioptions-=l
set guioptions-=b
if has('unix') && !has('mac') && !has('macunix')
    set guioptions-=m
endif

" Alt-Space is System menu
noremap <M-Space> :simalt ~<CR>
inoremap <M-Space> <C-O>:simalt ~<CR>
cnoremap <M-Space> <C-C>:simalt ~<CR>

" vim: ts=8 sts=4 sw=4 et
