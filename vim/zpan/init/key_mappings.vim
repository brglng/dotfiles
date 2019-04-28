nmap ; :

function! s:pumselected()
  return pumvisible() && !empty(v:completed_item) && !(v:completed_item['abbr'] == '' && v:completed_item['info'] == '' && v:completed_item['kind'] == '')
endfunction

let g:ulti_expand_or_jump_res = 0
function s:expand_snippet_or_jump()
  let expanded = UltiSnips#ExpandSnippetOrJump()
  if g:ulti_expand_or_jump_res == 0
    return "\<TAB>"
  else
    return expanded
  endif
endfunction

inoremap <expr> <Esc> pumvisible() ? !empty(v:completed_item) && !(v:completed_item['abbr'] == '' && v:completed_item['info'] == '' && v:completed_item['kind'] == '') ? "\<C-e>" : "\<Esc>" : "\<Esc>"
imap <expr> ( <SID>pumselected() ? complete_parameter#pre_complete('') : "\<Plug>delimitMate("
imap <expr> <CR> <SID>pumselected() ? complete_parameter#pre_complete("\<C-Y>") : "\<Plug>delimitMateCR\<Plug>DiscretionaryEnd"
smap <expr> <TAB> cmp#jumpable(1) ? "\<Plug>(complete_parameter#goto_next_parameter)" : "\<C-R>=\<SID>expand_snippet_or_jump()\<CR>"
imap <expr> <TAB> cmp#jumpable(1) ? "\<Plug>(complete_parameter#goto_next_parameter)" : delimitMate#ShouldJump() ? delimitMate#JumpAny() : "\<C-R>=\<SID>expand_snippet_or_jump()\<CR>"
smap <expr> <S-TAB> cmp#jumpable(0) ? "\<Plug>(complete_parameter#goto_previous_parameter)" : "\<C-R>=UltiSnips#JumpBackwards()\<CR>"
imap <expr> <S-TAB> cmp#jumpable(0) ? "\<Plug>(complete_parameter#goto_previous_parameter)" : "\<C-R>=UltiSnips#JumpBackwards()\<CR>"
imap <C-J> <Plug>(complete_parameter#overload_down)
smap <C-J> <Plug>(complete_parameter#overload_down)
imap <C-K> <Plug>(complete_parameter#overload_up)
smap <C-K> <Plug>(complete_parameter#overload_up)

" arrows move through screen lines
noremap  <Down>      gj
noremap  <Up>        gk
inoremap <Down> <C-o>gj
inoremap <Up>   <C-o>gk

" Some Emkeys in insert mode and command-line mode
inoremap <expr>    <Home>      col('.') == 1 ? "\<C-O>^" : "\<C-O>0"
inoremap <expr>    <C-A>       col('.') == 1 ? "\<C-O>^" : "\<C-O>0"
inoremap           <C-X><C-A>  <C-A>
cnoremap           <C-A>       <Home>
cnoremap           <C-X><C-A>  <C-A>

inoremap <expr>    <C-B>       getline('.') =~ '^\s*$' && col('.') > strlen(getline('.')) ? "0\<Lt>C-D>\<Lt>Esc>kJs" : "\<Lt>Left>"
cnoremap           <C-B>       <Left>

inoremap <expr>    <C-D>       col('.') > strlen(getline('.')) ? "\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr>    <C-D>       getcmdpos() > strlen(getcmdline()) ? "\<Lt>C-D>":"\<Lt>Del>"

inoremap <expr>    <C-E>       col('.') > strlen(getline('.')) <bar><bar> <SID>pumselected() ? "\<Lt>C-E>" : "\<Lt>End>"

inoremap <expr>    <C-F>       col('.') > strlen(getline('.')) ? "\<Lt>C-F>":"\<Lt>Right>"
cnoremap <expr>    <C-F>       getcmdpos() > strlen(getcmdline())? &cedit : "\<Lt>Right>"

inoremap <expr>    <C-n>       <SID>pumselected() ? "\<C-N>" : "\<Down>"
inoremap <expr>    <C-p>       <SID>pumselected() ? "\<C-P>" : "\<Up>"

inoremap           <C-BS>      <C-w>
inoremap           <M-b>       <C-Left>
inoremap           <M-f>       <C-Right>
inoremap           <M-k>       <C-Right><C-w>
inoremap           <C-x>o      <C-o><C-w>w

cnoremap           <C-BS>      <C-w>
cnoremap           <M-b>       <C-Left>
cnoremap           <M-f>       <C-Right>
cnoremap           <M-k>       <C-Right><C-w>
cnoremap           <C-a>       <Home>

" buffer
nnoremap <Leader>bp    :bp<CR>
nnoremap <Leader>bn    :bn<CR>
nnoremap <Leader>b1    :b 1<CR>
nnoremap <Leader>b2    :b 2<CR>
nnoremap <Leader>b3    :b 3<CR>
nnoremap <Leader>b4    :b 4<CR>
nnoremap <Leader>b5    :b 5<CR>
nnoremap <Leader>b6    :b 6<CR>
nnoremap <Leader>b7    :b 7<CR>
nnoremap <Leader>b8    :b 8<CR>
nnoremap <Leader>b9    :b 9<CR>

" window
nnoremap <Leader>wp    <C-w>p
nnoremap <Leader>wn    <C-w>n
nnoremap <Leader>wq    <C-w>q
nnoremap <Leader>q     <C-w>q
nnoremap <Leader>ww    <C-w>w
nnoremap <Leader>ws    <C-w>s
nnoremap <Leader>wv    <C-w>v
nnoremap <Leader>w1    1<C-w>w
nnoremap <Leader>w2    2<C-w>w
nnoremap <Leader>w3    3<C-w>w
nnoremap <Leader>w4    4<C-w>w
nnoremap <Leader>w5    5<C-w>w
nnoremap <Leader>w6    6<C-w>w
nnoremap <Leader>w7    7<C-w>w
nnoremap <Leader>w8    8<C-w>w
nnoremap <Leader>w9    9<C-w>w

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
    if win_filetype == 'defx' || win_filetype == 'tagbar' || win_filetype == 'nerdtree'
      let found_nr = nr
      let found_type = win_filetype
      break
    endif
  endfor

  if found_nr > 0
    if found_type == 'defx'
      Defx
    else
      execute found_nr . 'wincmd q'
      Defx
    endif
  else
    Defx
  endif
endfunction

function! s:toggle_tagbar()
  let found_nr = 0
  let found_type = ''
  for nr in range(1, winnr('$'))
    let win_filetype = getbufvar(winbufnr(nr), '&filetype')
    if win_filetype == 'defx' || win_filetype == 'tagbar' || win_filetype == 'nerdtree'
      let found_nr = nr
      let found_type = win_filetype
      break
    endif
  endfor

  if found_nr > 0
    if found_type == 'tagbar'
      TagbarToggle
    else
      execute found_nr . 'wincmd q'
      TagbarToggle
    endif
  else
    TagbarToggle
  endif
endfunction

nnoremap <silent> <M-1>         :call <SID>toggle_defx()<CR>
nnoremap <silent> <M-7>         :call <SID>toggle_tagbar()<CR>

" QuickFix and Location windows
autocmd FileType qf,help,tagbar nnoremap <silent> q <C-w>q
nnoremap <silent> <M-6> :call <SID>toggle_quickfix()<CR>
nnoremap <silent> <M-^> :call <SID>toggle_loclist()<CR>

" search and replace
nnoremap <Leader>gs     :%s/\<<C-r><C-w>\>/
nnoremap <Leader>gr     :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>gR     :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>s      :.,$s/\<<C-r><C-w>\>/
nnoremap <Leader>r      :.,$s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>R      :.,$s/\<<C-r><C-w>\>//gc<Left><Left><Left>

nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>
