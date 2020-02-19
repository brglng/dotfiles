let g:sidebars = {
  \ 'coc-explorer': {
  \     'position': 'left',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'coc-explorer'},
  \     'open': 'CocCommand explorer --no-toggle',
  \     'close': 'CocCommand explorer --toggle'
  \ },
  \ 'vista': {
  \     'position': 'left',
  \     'check_win': {nr -> bufname(winbufnr(nr)) =~ '__vista__'},
  \     'open': 'Vista',
  \     'close': 'Vista!'
  \ },
  \ 'undotree': {
  \     'position': 'left',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'undotree'},
  \     'open': 'UndotreeShow',
  \     'close': 'UndotreeHide'
  \ },
  \ 'quickfix': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') =~ 'qf' && !getwininfo(win_getid(nr))[0]['loclist']},
  \     'open': 'copen',
  \     'close': 'cclose'
  \ },
  \ 'loclist': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') =~ 'qf' && getwininfo(win_getid(nr))[0]['loclist']},
  \     'open': 'lopen',
  \     'close': 'lclose'
  \ },
  \ 'terminal': {
  \     'position': 'bottom',
  \     'get_win': {-> exists('t:__terminal_bid__') ? bufwinnr(t:__terminal_bid__) : 0},
  \     'open': 'call TerminalOpen()',
  \     'close': 'call TerminalClose()'
  \ }
  \ }

let g:sidebar_close_tab_on_closing_last_buffer = 1

" vim: ts=8 sts=4 sw=4 et
