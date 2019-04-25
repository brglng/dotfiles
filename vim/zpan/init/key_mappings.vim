" Some Emacs-like keys in insert mode and command-line mode
" inoremap <silent> <C-n>     <Down>
" inoremap <silent> <C-p>     <Up>
" inoremap <silent> <C-b>     <Left>
" inoremap <silent> <C-f>     <Right>
" inoremap <silent> <C-BS>    <C-w>
" inoremap <silent> <M-b>     <C-Left>
" inoremap <silent> <M-f>     <C-Right>
" inoremap <silent> <M-k>     <C-Right><C-w>
" inoremap <silent> <C-a>     <C-o>^
" inoremap <silent> <C-e>     <End>
" inoremap <silent> <C-x>o    <C-o><C-w>w

" cnoremap <silent> <C-b>     <Left>
" cnoremap <silent> <C-f>     <Right>
" cnoremap <silent> <C-BS>    <C-w>
" cnoremap <silent> <M-b>     <C-Left>
" cnoremap <silent> <M-f>     <C-Right>
" cnoremap <silent> <M-k>     <C-Right><C-w>
" cnoremap <silent> <C-a>     <Home>

" buffer
nnoremap <silent> <Leader>bp    :bp<CR>
nnoremap <silent> <Leader>bn    :bn<CR>
nnoremap <silent> <Leader>b1    :b 1<CR>
nnoremap <silent> <Leader>b2    :b 2<CR>
nnoremap <silent> <Leader>b3    :b 3<CR>
nnoremap <silent> <Leader>b4    :b 4<CR>
nnoremap <silent> <Leader>b5    :b 5<CR>
nnoremap <silent> <Leader>b6    :b 6<CR>
nnoremap <silent> <Leader>b7    :b 7<CR>
nnoremap <silent> <Leader>b8    :b 8<CR>
nnoremap <silent> <Leader>b9    :b 9<CR>

" window
nnoremap <silent> <Leader>wp    <C-w>p
nnoremap <silent> <Leader>wn    <C-w>n
nnoremap <silent> <Leader>wq    <C-w>q
nnoremap <silent> <Leader>q     <C-w>q
nnoremap <silent> <Leader>ww    <C-w>w
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

nnoremap <silent> <M-1>         :Defx<CR>
nnoremap <silent> <M-7>         :TagbarToggle<CR>

" QuickFix and Location windows
nnoremap <silent> <Leader>cw    :call <SID>QuickFixToggle('copen')<CR>
nnoremap <silent> <Leader>lw    :call <SID>QuickFixToggle('lopen')<CR>
function! s:QuickFixToggle(opencmd)
  let quickfix_opened = 0
  for nr in range(1, winnr('$'))
    if getbufvar(winbufnr(nr), '&buftype') == 'quickfix'
      let quickfix_opened = 1
      break
    endif
  endfor
  if quickfix_opened == 1
    if getbufvar(bufnr('%'), '&buftype') == 'quickfix'
      wincmd p
    endif
    cclose
    lclose
  else
    execute 'botright ' . a:opencmd
    "wincmd p
  endif
endfunction

" search and replace
nnoremap <Leader>gs     :%s/\<<C-r><C-w>\>/
nnoremap <Leader>gr     :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>gR     :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>s      :.,$s/\<<C-r><C-w>\>/
nnoremap <Leader>r      :.,$s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>R      :.,$s/\<<C-r><C-w>\>//gc<Left><Left><Left>

nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>
