nmap ; :

" Fix meta key for Vim
if !has('gui_running') && !(has('win32') && !has('win32unix')) && !has('nvim')
  " fix meta-keys under terminal
  let chars = ['s', 'z', 'Z', 'c', 'x', 'v', 'a', '{', '}', 'b', 'f', 'k', '`', '1', '2', '3', '6', '^', ' ']
  for c in chars
    exec "set <M-" . c . ">=\e" . c
  endfor
  " set timeout
  set ttimeout
  " set timeoutlen=100
  set ttimeoutlen=1
endif

" backspace in Visual mode deletes selection
vnoremap <BS> d

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

map   <silent> <S-Insert> "+gP
cmap  <silent> <S-Insert> <C-r>+
exe 'inoremap <script> <S-Insert> <C-g>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <S-Insert> ' . paste#paste_cmd['v']

if !((has('macunix') || has('mac')) && has('gui_running'))
  noremap   <silent> <M-s>  :update<CR>
  vnoremap  <silent> <M-s>  <C-c>:update<CR>
  inoremap  <silent> <M-s>  <C-o>:update<CR>

  noremap   <silent> <M-z>  u
  inoremap  <silent> <M-z>  <C-o>u
  noremap   <silent> <M-Z>  <C-r>
  inoremap  <silent> <M-Z>  <C-o><C-r>

  nnoremap  <silent> <M-c>  "+y
  vnoremap  <silent> <M-c>  "+y

  nnoremap  <silent> <M-x>  "+x
  vnoremap  <silent> <M-x>  "+x

  map       <silent> <M-v>  "+gP
  cmap      <silent> <M-v>  <C-r>+
  inoremap  <silent> <M-v>  <C-o>"+P

  " Pasting blockwise and linewise selections is not possible in Insert and
  " Visual mode without the +virtualedit feature.  They are pasted as if they
  " were characterwise instead.
  " Uses the paste.vim autoload script.
  exe 'inoremap <script> <M-v> <C-g>u' . paste#paste_cmd['i']
  exe 'vnoremap <script> <M-v> ' . paste#paste_cmd['v']

  noremap   <silent> <M-a> gggH<C-o>G
  inoremap  <silent> <M-a> <C-o>gg<C-o>gH<C-o>G
  cnoremap  <silent> <M-a> <C-c>gggH<C-o>G
  onoremap  <silent> <M-a> <C-c>gggH<C-o>G
  snoremap  <silent> <M-a> <C-c>gggH<C-o>G
  xnoremap  <silent> <M-a> <C-c>ggVG
elseif has('gui_macvim')
  set macmeta
endif

inoremap <silent> <C-U> <C-G>u<C-U>

" assume 'noinsert' is in 'completeopt'
function! s:pumselected()
  return pumvisible() && !empty(v:completed_item)
endfunction

inoremap <silent><expr> <TAB>
      \ <SID>pumselected()
      \ ? coc#_select_confirm()
      \ : coc#expandableOrJumpable() ?
      \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
      \ : "\<TAB>"

inoremap <silent> <expr> <C-Space> coc#refresh()
inoremap <silent> <expr> <C-x><C-x> coc#refresh()

inoremap <expr> <CR>
      \ <SID>pumselected() ?
      \ "\<C-y>" :
      \ "\<CR>"

inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<C-o>gj"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<C-o>gk"

if has('nvim')
  cnoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
  cnoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"
endif

" arrows move through screen lines
noremap  <silent> <Down>      gj
noremap  <silent> <Up>        gk

" Some Emacs-like keys in insert mode and command-line mode
inoremap <silent> <expr>    <Home>      col('.') == 1 ? "\<C-O>^" : "\<C-O>0"
inoremap <silent> <expr>    <C-A>       col('.') == 1 ? "\<C-O>^" : "\<C-O>0"
inoremap <silent>           <C-X><C-A>  <C-A>
cnoremap <silent>           <C-A>       <Home>
cnoremap <silent>           <C-X><C-A>  <C-A>

inoremap <silent> <expr>    <C-B>       getline('.') =~ '^\s*$' && col('.') > strlen(getline('.')) ? "0\<Lt>C-D>\<Lt>Esc>kJs" : "\<Lt>Left>"
cnoremap <silent>           <C-B>       <Left>

inoremap <silent> <expr>    <C-D>       col('.') > strlen(getline('.')) ? "\<Lt>C-D>":"\<Lt>Del>"
cnoremap <silent> <expr>    <C-D>       getcmdpos() > strlen(getcmdline()) ? "\<Lt>C-D>":"\<Lt>Del>"

" inoremap <silent> <expr>    <C-E>       col('.') > strlen(getline('.')) <bar><bar> <SID>pumselected() ? "\<Lt>C-E>" : "\<Lt>End>"
inoremap <silent> <expr>    <C-E>       col('.') > strlen(getline('.')) ? "\<Lt>C-E>" : "\<Lt>End>"

inoremap <silent> <expr>    <C-F>       col('.') > strlen(getline('.')) ? "\<Lt>C-F>":"\<Lt>Right>"
cnoremap <silent> <expr>    <C-F>       getcmdpos() > strlen(getcmdline())? &cedit : "\<Lt>Right>"

inoremap <silent> <expr>    <C-n>       <SID>pumselected() ? "\<C-N>" : "\<Down>"
inoremap <silent> <expr>    <C-p>       <SID>pumselected() ? "\<C-P>" : "\<Up>"

inoremap <silent>           <C-BS>      <C-w>
inoremap <silent>           <M-b>       <C-Left>
inoremap <silent>           <M-f>       <C-Right>
inoremap <silent>           <M-k>       <C-Right><C-w>
inoremap <silent>           <C-x>o      <C-o><C-w>w

cnoremap <silent>           <C-BS>      <C-w>
cnoremap <silent>           <M-b>       <C-Left>
cnoremap <silent>           <M-f>       <C-Right>
cnoremap <silent>           <M-k>       <C-Right><C-w>
cnoremap <silent>           <C-a>       <Home>

nnoremap <silent> <M-Left>      <C-o>
nnoremap <silent> <M-Right>     <C-i>

" buffer
nnoremap <silent> <C-Tab>       :bp<CR>
nnoremap <silent> <C-S-Tab>     :bn<CR>
nnoremap <silent> <Leader>bp    :bp<CR>
nnoremap <silent> <Leader>bn    :bn<CR>
nmap <silent> <Leader>b1 <Plug>lightline#bufferline#go(1)
nmap <silent> <Leader>b2 <Plug>lightline#bufferline#go(2)
nmap <silent> <Leader>b3 <Plug>lightline#bufferline#go(3)
nmap <silent> <Leader>b4 <Plug>lightline#bufferline#go(4)
nmap <silent> <Leader>b5 <Plug>lightline#bufferline#go(5)
nmap <silent> <Leader>b6 <Plug>lightline#bufferline#go(6)
nmap <silent> <Leader>b7 <Plug>lightline#bufferline#go(7)
nmap <silent> <Leader>b8 <Plug>lightline#bufferline#go(8)
nmap <silent> <Leader>b9 <Plug>lightline#bufferline#go(9)
nmap <silent> <Leader>b0 <Plug>lightline#bufferline#go(10)

" window
nnoremap <silent> <Leader>wp    <C-w>p
nnoremap <silent> <Leader>wn    <C-w>n
nnoremap <silent> <Leader>wq    <C-w>q
nnoremap <silent> <Leader>q     <C-w>q
nnoremap <silent> <Leader>ww    <C-w>w
nnoremap <silent> <Leader>wo    <C-w>o
nnoremap <silent> <Leader>ws    <C-w>s
nnoremap <silent> <Leader>wv    <C-w>v
nnoremap <silent> <Leader>w1    1<C-w>w
nnoremap <silent> <Leader>w2    2<C-w>w
nnoremap <silent> <Leader>w3    3<C-w>w
nnoremap <silent> <Leader>w4    4<C-w>w
nnoremap <silent> <Leader>w5    5<C-w>w
nnoremap <silent> <Leader>w6    6<C-w>w
nnoremap <silent> <Leader>w7    7<C-w>w
nnoremap <silent> <Leader>w8    8<C-w>w
nnoremap <silent> <Leader>w9    9<C-w>w

nnoremap <silent> <Leader>Q     :qa<CR>

function! s:toggle_quickfix()
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

function! s:toggle_loclist()
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

function! s:toggle_defx()
  let found_nr = 0
  let found_type = ''
  for nr in range(1, winnr('$'))
    let win_filetype = getbufvar(winbufnr(nr), '&filetype')
    if index(['defx', 'nerdtree', 'undotree'], win_filetype) >= 0 || bufname(winbufnr(nr)) =~ '__Tagbar__\|__vista__'
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

function! s:toggle_tagbar()
  let found_nr = 0
  let found_type = ''
  for nr in range(1, winnr('$'))
    let win_filetype = getbufvar(winbufnr(nr), '&filetype')
    if index(['defx', 'nerdtree', 'undotree'], win_filetype) >= 0 || bufname(winbufnr(nr)) =~ '__Tagbar__\|__vista__'
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

function! s:toggle_vista()
  let found_nr = 0
  let found_type = ''
  for nr in range(1, winnr('$'))
    let win_filetype = getbufvar(winbufnr(nr), '&filetype')
    if index(['defx', 'nerdtree', 'undotree'], win_filetype) >= 0 || bufname(winbufnr(nr)) =~ '__Tagbar__\|__vista__'
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

function! s:toggle_undotree()
  let found_nr = 0
  let found_type = ''
  for nr in range(1, winnr('$'))
    let win_filetype = getbufvar(winbufnr(nr), '&filetype')
    if index(['defx', 'nerdtree', 'undotree'], win_filetype) >= 0 || bufname(winbufnr(nr)) =~ '__Tagbar__\|__vista__'
      let found_nr = nr
      let found_type = win_filetype
      break
    endif
  endfor

  if found_nr > 0 && found_type != 'undotree'
    execute found_nr . 'wincmd q'
  endif

  UndotreeToggle
endfunction

let s:prev_terminal_height = 0
function! s:toggle_terminal()
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

if has('nvim')
  nnoremap <silent> <M-0> :call <SID>toggle_terminal()<CR>i
  inoremap <silent> <M-0> <Esc>:call <SID>toggle_terminal()<CR>i
else
  nnoremap <silent> <M-0> :call <SID>toggle_terminal()<CR>
  inoremap <silent> <M-0> <Esc>:call <SID>toggle_terminal()<CR>
endif
tnoremap <silent> <M-0> <C-\><C-n>:call <SID>toggle_terminal()<CR>

nnoremap <silent> <M-1> :call <SID>toggle_defx()<CR>
inoremap <silent> <M-1> <Esc>:call <SID>toggle_defx()<CR>
nnoremap <silent> <M-2> :call <SID>toggle_vista()<CR>
inoremap <silent> <M-2> <Esc>:call <SID>toggle_vista()<CR>
nnoremap <silent> <M-3> :call <SID>toggle_undotree()<CR>
inoremap <silent> <M-3> <Esc>:call <SID>toggle_undotree()<CR>

" QuickFix and Location windows
autocmd FileType qf,help,man,tagbar nnoremap <silent> <buffer> q <C-w>q
nnoremap <silent> <M-6> :call <SID>toggle_quickfix()<CR>
inoremap <silent> <M-6> <Esc>:call <SID>toggle_quickfix()<CR>
nnoremap <silent> <M-^> :call <SID>toggle_loclist()<CR>
inoremap <silent> <M-^> <Esc>:call <SID>toggle_loclist()<CR>

" search and replace
nnoremap <Leader>gs    :%s/\<<C-r><C-w>\>/
nnoremap <Leader>gr    :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>gR    :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>s     :.,$s/\<<C-r><C-w>\>/
nnoremap <Leader>r     :.,$s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>R     :.,$s/\<<C-r><C-w>\>//gc<Left><Left><Left>
