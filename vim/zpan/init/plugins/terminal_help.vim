let g:terminal_key = '<M-`>'
let g:terminal_height = '15'
let g:terminal_pos = 'botright'

if executable('zsh')
    let g:terminal_shell = 'zsh'
endif

let g:terminal_edit = 'wincmd p | drop'
let g:terminal_kill = 'term'
let g:terminal_list = 0
let g:terminal_cwd = 2

" vim: ts=8 sts=4 sw=4 et
