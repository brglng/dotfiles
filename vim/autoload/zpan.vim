function! zpan#is_sudo() abort
  return $SUDO_USER !=# '' && $USER !=# $SUDO_USER && $HOME !=# expand('~'.$USER)
endfunction

function! zpan#rstrip(str, chars) abort
  if strlen(a:str) > 0 && strlen(a:chars) > 0
    let i = strlen(a:str) - 1
    while i >= 0
      if stridx(a:chars, a:str[i]) >= 0
        let i -= 1
      else
        break
      endif
    endwhile
    if i == -1
      let i = 0
    endif
    return a:str[0:i]
  else
    return a:str
  endif
endfunction

function! zpan#get_os() abort
  if (has('win32') || has('win64')) && !has('win32unix') && !has('unix')
    return 'Windows'
  elseif executable('uname')
    let uname_s = im_select#rstrip(system('uname -s'), " \r\n")
    if uname_s ==# 'Linux' && match(system('uname -r'), 'Microsoft') >= 0
      return 'Windows'
    elseif uname_s ==# 'Linux'
      return 'Linux'
    elseif uname_s ==# 'Darwin'
      return 'macOS'
    elseif match(uname_s, '\cCYGWIN') >= 0
      return 'Windows'
    elseif match(uname_s, '\cMINGW') >= 0
      return 'Windows'
    else
      return ''
    endif
  else
    return ''
  endif
endfunction

function! zpan#pumselected() abort
  return pumvisible() && !empty(v:completed_item)
endfunction

function! zpan#is_tool_window(...) abort
  if len(a:000) == 0
    return index(['coc-explorer', 'defx', 'denite', 'gitv', 'help', 'man', 'qf', 'undotree'], &filetype) >= 0 || expand('%:t') =~ '__Tagbar__\|__vista__'
  elseif len(a:000) == 1
    let winnr = a:1
    let bufnr = winbufnr(winnr)
    let fname = bufname(bufnr)
    let filetype = getwinvar(winnr, '&filetype')
    return index(['defx', 'denite', 'gitv', 'help', 'man', 'qf', 'undotree'], filetype) >= 0 || fname =~ '__Tagbar__\|__vista__'
  else
    echoerr "must be 0 or 1 arguments"
  endif
endfunction

function! zpan#toggle_quickfix() abort
  let found_nr = 0
  for nr in range(1, winnr('$'))
    if getbufvar(winbufnr(nr), '&filetype') == 'qf'
      let found_nr = nr
      break
    endif
  endfor

  if found_nr > 0
    if getwininfo(win_getid(nr))[0]['loclist']
      lclose
      copen
    else
      cclose
    endif
  else
    copen
  endif
endfunction

function! zpan#toggle_loclist() abort
  let found_nr = 0
  for nr in range(1, winnr('$'))
    if getbufvar(winbufnr(nr), '&filetype') == 'qf'
      let found_nr = nr
      break
    endif
  endfor

  if found_nr > 0
    if getwininfo(win_getid(nr))[0]['loclist']
      lclose
    else
      cclose
      lopen
    endif
  else
    lopen
  endif
endfunction

function! zpan#toggle_coc_explorer() abort
  let found_nr = 0
  let found_type = ''
  for nr in range(1, winnr('$'))
    let win_filetype = getbufvar(winbufnr(nr), '&filetype')
    if index(['coc-explorer', 'defx', 'nerdtree', 'undotree'], win_filetype) >= 0 || bufname(winbufnr(nr)) =~ '__Tagbar__\|__vista__'
      let found_nr = nr
      let found_type = win_filetype
      break
    endif
  endfor

  if found_nr > 0 && found_type != 'coc_explorer'
    execute found_nr . 'wincmd q'
  endif

  CocCommand explorer
endfunction

function! zpan#toggle_defx() abort
  let found_nr = 0
  let found_type = ''
  for nr in range(1, winnr('$'))
    let win_filetype = getbufvar(winbufnr(nr), '&filetype')
    if index(['coc-explorer', 'defx', 'nerdtree', 'undotree'], win_filetype) >= 0 || bufname(winbufnr(nr)) =~ '__Tagbar__\|__vista__'
      let found_nr = nr
      let found_type = win_filetype
      break
    endif
  endfor

  if found_nr > 0 && found_type != 'defx'
    execute found_nr . 'wincmd q'
  endif

  Defx
endfunction

function! zpan#toggle_tagbar() abort
  let found_nr = 0
  let found_type = ''
  for nr in range(1, winnr('$'))
    let win_filetype = getbufvar(winbufnr(nr), '&filetype')
    if index(['coc-explorer', 'defx', 'nerdtree', 'undotree'], win_filetype) >= 0 || bufname(winbufnr(nr)) =~ '__Tagbar__\|__vista__'
      let found_nr = nr
      let found_type = win_filetype
      break
    endif
  endfor

  if found_nr > 0 && bufname(winbufnr(found_nr)) =~ '__Tagbar__'
    execute found_nr . 'wincmd q'
  endif

  TagbarToggle
endfunction

function! zpan#toggle_vista() abort
  let found_nr = 0
  let found_type = ''
  for nr in range(1, winnr('$'))
    let win_filetype = getbufvar(winbufnr(nr), '&filetype')
    if index(['coc-explorer', 'defx', 'nerdtree', 'undotree'], win_filetype) >= 0 || bufname(winbufnr(nr)) =~ '__Tagbar__\|__vista__'
      let found_nr = nr
      let found_type = win_filetype
      break
    endif
  endfor

  if found_nr > 0 && bufname(winbufnr(found_nr)) !~ '__vista__'
      execute found_nr . 'wincmd q'
  endif

  Vista!!
endfunction

function! zpan#toggle_undotree() abort
  let found_nr = 0
  let found_type = ''
  for nr in range(1, winnr('$'))
    let win_filetype = getbufvar(winbufnr(nr), '&filetype')
    if index(['coc-explorer', 'defx', 'nerdtree', 'undotree'], win_filetype) >= 0 || bufname(winbufnr(nr)) =~ '__Tagbar__\|__vista__'
      let found_nr = nr
      let found_type = win_filetype
      break
    endif
  endfor

  if found_nr > 0 && found_type != 'undotree'
    execute found_nr . 'wincmd q'
  endif

  UndotreeToggle
  UndotreeToggle
  UndotreeToggle
endfunction

let s:prev_terminal_height = 0
function! zpan#toggle_terminal() abort
  let found_winnr = 0
  for winnr in range(1, winnr('$'))
    if getbufvar(winbufnr(winnr), '&buftype') == 'terminal'
      let found_winnr = winnr
    endif
  endfor

  if found_winnr > 0
    execute found_winnr . 'wincmd q'
  else
    let found_bufnr = 0
    for bufnr in filter(range(1, bufnr('$')), 'bufexists(v:val)')
      if getbufvar(bufnr, '&buftype') == 'terminal'
        let found_bufnr = bufnr
      endif
    endfor
    if found_bufnr > 0
      if s:prev_terminal_height > 0
        execute 'botright ' . s:prev_terminal_height . 'split'
        execute 'buffer ' . found_bufnr
        set winfixheight
      else
        if &lines > 30
          botright 15split
          execute 'buffer ' . found_bufnr
          set winfixheight
        else
          botright split
          execute 'buffer ' . found_bufnr
          set winfixheight
        endif
      endif
    else
      if &lines > 30
        if has('nvim')
          execute 'botright 15split term://' . &shell
        else
          botright terminal
          resize 15
          set winfixheight
        endif
      else
        if has('nvim')
          execute 'botright split term://' . &shell
        else
          botright terminal
          set winfixheight
        endif
      endif
    endif
  endif
endfunction
au WinLeave * if &buftype == 'terminal' && winnr() > 1 | let s:prev_terminal_height = winheight('%') | endif
