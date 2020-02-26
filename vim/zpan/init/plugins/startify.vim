let g:startify_session_dir = '~/.local/share/vim/session'

let g:startify_lists = [
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ ]

let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_sort = 1

let g:startify_session_before_save = ['call sidebar#close_all()']
let g:startify_session_persistence = 0

function! s:save_session()
    if len(v:this_session) > 0
        call sidebar#close_all()
        execute 'SSave! ' . fnamemodify(v:this_session, ':t')
    endif
endfunction
autocmd VimLeavePre * call s:save_session()

" vim: ts=8 sts=4 sw=4 et
