let g:startify_session_dir = '~/.local/share/nvim/session'

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

let g:startify_session_before_save = ['call sidebar#save_session()']
let g:startify_session_persistence = 1
let g:startify_session_savevars = [
  \ 'g:startify_session_savevars',
  \ 'g:startify_session_savecmds',
  \ 'g:sidebar_session'
  \ ]
let g:startify_session_savecmds = ['call sidebar#load_session()']

" vim: ts=8 sts=4 sw=4 et
