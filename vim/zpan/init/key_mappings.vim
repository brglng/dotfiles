let mapleader = "\<Space>"
nmap ; :

autocmd VimEnter * imap <expr> ( pumvisible() ?  complete_parameter#pre_complete('()') : "("
autocmd VimEnter * imap <expr> <CR> pumvisible() ? complete_parameter#pre_complete('()') : "\<CR>"
autocmd VimEnter * smap <silent> <expr> <TAB> cmp#jumpable(1) ? "\<Plug>(complete_parameter#goto_next_parameter)" : "\<C-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
autocmd VimEnter * imap <silent> <expr> <TAB> cmp#jumpable(1) ? "\<Plug>(complete_parameter#goto_next_parameter)" : "\<C-R>=UltiSnips#ExpandSnippetOrJump()\<CR>"
autocmd VimEnter * smap <silent> <expr> <S-TAB> cmp#jumpable(0) ? "\<Plug>(complete_parameter#goto_previous_parameter)" : "\<C-R>=UltiSnips#JumpBackwards()\<CR>"
autocmd VimEnter * imap <silent> <expr> <S-TAB> cmp#jumpable(0) ? "\<Plug>(complete_parameter#goto_previous_parameter)" : "\<C-R>=UltiSnips#JumpBackwards()\<CR>"
imap <C-J> <Plug>(complete_parameter#overload_down)
smap <C-J> <Plug>(complete_parameter#overload_down)
imap <C-K> <Plug>(complete_parameter#overload_up)
smap <C-K> <Plug>(complete_parameter#overload_up)

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

inoremap <silent> <expr>    <C-E>       col('.') > strlen(getline('.')) <bar><bar> pumvisible() ? "\<Lt>C-E>" : "\<Lt>End>"

inoremap <silent> <expr>    <C-F>       col('.') > strlen(getline('.')) ? "\<Lt>C-F>":"\<Lt>Right>"
cnoremap <silent> <expr>    <C-F>       getcmdpos() > strlen(getcmdline())? &cedit : "\<Lt>Right>"

inoremap <silent> <expr>    <C-n>       pumvisible() ? "\<C-N>" : "\<Down>"
inoremap <silent> <expr>    <C-p>       pumvisible() ? "\<C-P>" : "\<Up>"

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
autocmd FileType qf,help nnoremap <silent> q <C-w>q
nnoremap <silent> <M-6> :call <SID>QuickFixToggle('copen')<CR>
nnoremap <silent> <M-^> :call <SID>QuickFixToggle('lopen')<CR>
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
