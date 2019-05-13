" File:         autoload/taggist.vim
" Maintainer:   Zhaosheng Pan <brglng at gmail dot com>
" Version:      0.1.0
" License:      LGPL

if v:version < 700
    finish
endif

if !has('python') && !has('python3')
    finish
endif

if exists('g:loaded_autoload_taggist')
    finish
endif
let g:loaded_autoload_taggist = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('s:autoload_dir')
    let s:autoload_dir = expand('<sfile>:h')
endif

python << EOF
import os
import sys
import vim
import platform
import glob
import time
import threading

sys.path.append(vim.eval('s:autoload_dir'))

import vim_taggist

vim_taggist_proj = None
vim_taggist_thread = None
vim_taggist_cscope_thread = None
vim_taggist_last_update_time = 0

def vim_taggist_load_proj(proj_file_name=''):
    if proj_file_name:
        proj_file = open(proj_file_name, 'r')
        proj_dict = eval(proj_file.read())
        proj_file.close()
    else:
        proj_dict = None

    proj = vim_taggist.Project(proj_dict)

    vim.command('silent! set tags=' + proj.tags_file_name)
    vim.command(
        'silent! set path=' + ','.join(
            [d for globs in proj.include_dirs.values()
                for g in globs
                    for d in glob.glob(g)
                        if os.path.isdir(d)]))

    return proj

def vim_taggist_update_cscope_db():
    global vim_taggist_proj
    global vim_taggist_cscope_thread
    global vim_taggist_last_update_time

    if vim_taggist_proj:
        if vim_taggist_cscope_thread is None:
            if vim_taggist_last_update_time == 0 or time.time() - vim_taggist_last_update_time >= vim.eval('g:taggist_update_interval'):
                vim.command('silent! cscope kill -1')
                vim_taggist_last_update_time = time.time()
                vim_taggist_cscope_thread = threading.Thread(target=vim_taggist_proj.update_cscope_db)
                vim_taggist_cscope_thread.daemon = True
                vim_taggist_cscope_thread.start()
        elif not vim_taggist_cscope_thread.is_alive():
            vim.command('silent! cscope add ' + vim_taggist_proj.cscope_out_file_name)
            vim_taggist_cscope_thread = None

def vim_taggist_update_tags():
    global vim_taggist_proj

    if vim_taggist_proj:
        vim_taggist_proj.update_tags()

def vim_taggist_update():
    if vim_taggist_proj:
        vim_taggist_update_tags()
        vim_taggist_update_cscope_db()

def vim_taggist_start(proj_file_name=''):
    global vim_taggist_proj
    global vim_taggist_thread

    if vim_taggist_thread:
        vim_taggist_thread.stop()

    if vim.eval("exists('g:taggist_default_project')") == '1':
        for (k, v) in vim.eval('g:taggist_default_project').items():
            if k in vim_taggist.default_project_dict:
                vim_taggist.default_project_dict[k] = v

    if proj_file_name:
        vim.command('silent! cd ' + os.path.normpath(os.path.dirname(proj_file_name)))
        proj_file_name = os.path.split(proj_file_name)[1]
        vim_taggist_proj = vim_taggist_load_proj(proj_file_name)
    else:
        try:
            vim_taggist_proj = vim_taggist_load_proj('.vim_taggist')
        except IOError:
            if platform.system() == 'Windows':
                try:
                    vim_taggist_proj = vim_taggist_load_proj('_vim_taggist')
                except IOError:
                    vim_taggist_proj = vim_taggist_load_proj()

    vim_taggist_thread = vim_taggist.Timer(
        int(vim.eval('g:taggist_update_interval')),
        vim_taggist_update_tags
    )

    vim_taggist_thread.daemon = True
    vim_taggist_thread.start()

def vim_taggist_stop():
    global vim_taggist_thread

    if vim_taggist_thread:
        vim_taggist_thread.stop()
EOF

function! taggist#start(...)
    set noautochdir
    if a:0 == 1
        python vim_taggist_start(vim.eval('a:1'))
    elseif a:0 == 0
        python vim_taggist_start()
    endif
    python vim_taggist_update_cscope_db()
endfunction

function! taggist#stop()
    python vim_taggist_stop()
endfunction

function! taggist#update()
    python vim_taggist_update()
endfunction

function! taggist#update_regularly()
    python vim_taggist_update_cscope_db()
endfunction

let &cpo = s:save_cpo
