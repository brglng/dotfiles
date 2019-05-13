" File:         autoload/taggist.vim
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

if exists('g:loaded_autoload_taggist')
    finish
endif
let g:load_autoload_taggist = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('s:script_dir')
    let s:script_dir = expand('<sfile>:h')
endif

python << EOF
import sys
sys.path.insert(0, vim.eval('s:script_dir'))
import taggist.viminterface
EOF

function! taggist#start()
    python taggist.viminterface.start_server()
endfunction

function! taggist#stop()
    python taggist.viminterface.stop_server()
endfunction

function! taggist#showlog()
    python taggist.viminterface.show_server_log()
endfunction

let &cpo = s:save_cpo
