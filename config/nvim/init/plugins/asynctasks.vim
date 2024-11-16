let g:asynctasks_term_focus = 0
let g:asynctasks_complete = 1

if has('linux')
    let g:asynctasks_system = 'linux'
elseif has('mac')
    let g:asynctasks_system = 'macos'
elseif has('win64')
    let g:asynctasks_system = 'win64'
elseif has('win32')
    let g:asynctasks_system = 'win32'
elseif has('wsl')
    let g:asynctasks_system = 'wsl'
endif

let g:asynctasks_config_name = '.vim/tasks.ini'

Plug 'skywind3000/asynctasks.vim'
