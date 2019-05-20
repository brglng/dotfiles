nmap ; :

" assume 'noinsert' is in 'completeopt'
function! s:pumselected()
  return pumvisible() && !empty(v:completed_item)
endfunction

" function! s:pre_complete_cr()
"   return substitute(complete_parameter#pre_complete("\<C-y>"), '(', "\<C-v>(", 'g')
" endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ <SID>pumselected() ?
      \ coc#_select_confirm() :
      \ coc#expandable() ?
      \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand',''])\<CR>" :
      \ coc#jumpable() ?
      \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-jump',''])\<CR>" :
      \ <SID>check_back_space() ?
      \ "\<TAB>" :
      \ coc#refresh()

inoremap <silent> <expr> <C-x><C-x> coc#refresh()

" imap <expr> <CR>
"       \ <SID>pumselected() ?
"       \ "\<C-y>" :
"       \ "\<Plug>DiscretionaryEnd"

inoremap <expr> <CR>
      \ <SID>pumselected() ?
      \ "\<C-y>" :
      \ "\<CR>"

" inoremap <silent> <expr> <Esc> pumvisible() ? !empty(v:completed_item) ? "\<Lt>C-e>" : "\<Lt>Esc>" : "\<Lt>Esc>"
" imap <silent> <expr> ( <SID>pumselected() ? complete_parameter#pre_complete('(') : "\<Plug>delimitMate("
" imap <silent> <expr> <CR> <SID>pumselected() ? <SID>pre_complete_cr() : "\<Plug>delimitMateCR\<Plug>DiscretionaryEnd"

" https://github.com/Valloric/YouCompleteMe/issues/2696
" imap <silent> <BS> <C-R>=YcmOnDeleteChar()<CR><Plug>delimitMateBS
" imap <silent> <C-h> <C-R>=YcmOnDeleteChar()<CR><Plug>delimitMateBS
" function! YcmOnDeleteChar()
"   if pumvisible()
"     return "\<C-y>"
"   endif
"   return "" 
" endfunction

" autocmd VimEnter * smap <silent> <expr> <TAB> cmp#jumpable(1) ? "\<Lt>Plug>(complete_parameter#goto_next_parameter)" : "\<Lt>C-r>=UltiSnips#ExpandSnippetOrJump()\<Lt>CR>"
" autocmd VimEnter * imap <silent> <expr> <TAB> delimitMate#ShouldJump() ? delimitMate#JumpAny() : "\<Lt>C-r>=UltiSnips#ExpandSnippetOrJump()\<Lt>CR>"
" smap <silent> <expr> <S-TAB> cmp#jumpable(0) ? "\<Plug>(complete_parameter#goto_previous_parameter)" : "\<C-R>=UltiSnips#JumpBackwards()\<CR>"
" imap <silent> <expr> <S-TAB> cmp#jumpable(0) ? "\<Plug>(complete_parameter#goto_previous_parameter)" : "\<C-R>=UltiSnips#JumpBackwards()\<CR>"
" imap <silent> <C-j> <Plug>(complete_parameter#goto_next_parameter);
" smap <silent> <C-j> <Plug>(complete_parameter#goto_next_parameter);
" imap <silent> <C-k> <Plug>(complete_parameter#goto_previous_parameter);
" smap <silent> <C-k> <Plug>(complete_parameter#goto_previous_parameter);
" imap <silent> <M-j> <Plug>(complete_parameter#overload_down)
" smap <silent> <M-j> <Plug>(complete_parameter#overload_down)
" imap <silent> <M-k> <Plug>(complete_parameter#overload_up)
" smap <silent> <M-k> <Plug>(complete_parameter#overload_up)

" arrows move through screen lines
noremap  <silent> <Down>      gj
noremap  <silent> <Up>        gk
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Up>   <C-o>gk

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

inoremap <silent> <expr>    <C-E>       col('.') > strlen(getline('.')) <bar><bar> <SID>pumselected() ? "\<Lt>C-E>" : "\<Lt>End>"

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
      if &lines > 30
        botright 15split
        execute 'buffer ' . found_bufnr
      else
        botright split
        execute 'buffer ' . found_bufnr
      endif
    else
      if &lines > 30
        if has('nvim')
          execute 'botright 15split term://' . &shell
        else
          botright terminal
          resize 15
        endif
      else
        if has('nvim')
          execute 'botright split term://' . &shell
        else
          botright terminal
        endif
      endif
    endif
  endif
endfunction

nnoremap <silent> <M-`> :call <SID>toggle_terminal()<CR>

nnoremap <silent> <M-1> :call <SID>toggle_defx()<CR>
" nnoremap <silent> <M-2> :call <SID>toggle_tagbar()<CR>
nnoremap <silent> <M-2> :call <SID>toggle_vista()<CR>
nnoremap <silent> <M-3> :call <SID>toggle_undotree()<CR>

" QuickFix and Location windows
autocmd FileType qf,help,man,tagbar nnoremap <silent> <buffer> q <C-w>q
nnoremap <silent> <M-6> :call <SID>toggle_quickfix()<CR>
nnoremap <silent> <M-^> :call <SID>toggle_loclist()<CR>

" search and replace
nnoremap <Leader>gs    :%s/\<<C-r><C-w>\>/
nnoremap <Leader>gr    :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>gR    :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>s     :.,$s/\<<C-r><C-w>\>/
nnoremap <Leader>r     :.,$s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>R     :.,$s/\<<C-r><C-w>\>//gc<Left><Left><Left>
