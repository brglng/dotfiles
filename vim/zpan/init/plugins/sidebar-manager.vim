call sidebar#register({
  \ 'name': 'coc-explorer',
  \ 'position': 'left',
  \ 'check_nr': {nr -> getwinvar(nr, '&filetype') ==# 'coc-explorer'},
  \ 'open': 'CocCommand explorer --no-toggle',
  \ 'close': 'CocCommand explorer --toggle'
  \})

call sidebar#register({
  \ 'name': 'vista',
  \ 'position': 'left',
  \ 'check_nr': {nr -> bufname(winbufnr(nr)) =~ '__vista__'},
  \ 'open': 'Vista',
  \ 'close': 'Vista!'
  \ })

call sidebar#register({
  \ 'name': 'undotree',
  \ 'position': 'left',
  \ 'check_nr': {nr -> getwinvar(nr, '&filetype') ==# 'undotree'},
  \ 'open': 'UndotreeShow',
  \ 'close': 'UndotreeHide'
  \ })

call sidebar#register({
  \ 'name': 'quickfix',
  \ 'position': 'bottom',
  \ 'check_nr': {nr -> getwinvar(nr, '&filetype') =~ 'qf' && !getwininfo(win_getid(nr))[0]['loclist']},
  \ 'open': 'copen',
  \ 'close': 'cclose'
  \ })

call sidebar#register({
  \ 'name': 'loclist',
  \ 'position': 'bottom',
  \ 'check_nr': {nr -> getwinvar(nr, '&filetype') =~ 'qf' && getwininfo(win_getid(nr))[0]['loclist']},
  \ 'open': 'lopen',
  \ 'close': 'lclose'
  \ })

" vim: ts=8 sts=4 sw=4 et
