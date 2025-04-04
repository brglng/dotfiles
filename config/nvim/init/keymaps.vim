" backspace in Visual mode deletes selection
vnoremap <BS> d

" Don't copy the contents of an overwritten selection.
" vnoremap <silent> <expr> p match(mode()[0], '^\(V\|S\|\|\)') ? "\"_dP" : (col('.') > strlen(getline('.')) ? "\"_dp" : "\"_dP")

" noremap <silent> <C-s> :update<CR>
" vnoremap <silent> <C-s> <C-c>:update<CR>
" inoremap <silent> <C-s> <C-o>:update<CR>
noremap <silent> <M-s> :update<CR>
vnoremap <silent> <M-s> <C-c>:update<CR>
inoremap <silent> <M-s> <C-o>:update<CR>
noremap <silent> <D-s> :update<CR>
vnoremap <silent> <D-s> <C-c>:update<CR>
inoremap <silent> <D-s> <C-o>:update<CR>

noremap <C-z> u
inoremap <C-z> <C-o>u
noremap <M-z> u
inoremap <M-z> <C-o>u
noremap <D-z> u
inoremap <D-z> <C-o>u

noremap <M-Z> <C-r>
inoremap <M-Z> <C-o><C-r>
noremap <D-S-z> <C-r>
inoremap <D-S-z> <C-o><C-r>

nnoremap <C-c> "+y
vnoremap <C-c> "+y
nnoremap <M-c> "+y
vnoremap <M-c> "+y
nnoremap <C-Insert> "+y
vnoremap <C-Insert> "+y
nnoremap <D-c> "+y
vnoremap <D-c> "+y

nnoremap <M-x> "+x
vnoremap <M-x> "+x
vnoremap <S-Del> "+x
nnoremap <D-x> "+x
vnoremap <D-x> "+x

map <M-v> "+gP
exe 'inoremap <script> <M-v> <C-g>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <M-v> ' . paste#paste_cmd['v']
" cmap <M-v> <C-r>+
map <D-v> "+gP
exe 'inoremap <script> <D-v> <C-g>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <D-v> ' . paste#paste_cmd['v']
" cmap <D-v> <C-r>+

map <S-Insert> "+gP
exe 'inoremap <script> <S-Insert> <C-g>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <S-Insert> ' . paste#paste_cmd['v']
" cmap <S-Insert> <C-r>+

noremap <C-q> <C-v>
inoremap <C-q> <C-o><C-v>

noremap <M-a> gggH<C-o>G
inoremap <M-a> <C-o>gg<C-o>gH<C-o>G
cnoremap <M-a> <C-c>gggH<C-o>G
onoremap <M-a> <C-c>gggH<C-o>G
snoremap <M-a> <C-c>gggH<C-o>G
xnoremap <M-a> <C-c>ggVG
noremap <D-a> gggH<C-o>G
inoremap <D-a> <C-o>gg<C-o>gH<C-o>G
cnoremap <D-a> <C-c>gggH<C-o>G
onoremap <D-a> <C-c>gggH<C-o>G
snoremap <D-a> <C-c>gggH<C-o>G
xnoremap <D-a> <C-c>ggVG

if has('gui_macvim')
    set macmeta
endif

inoremap <silent> <C-u> <C-g>u<C-u>

" arrows move through screen lines
noremap  <silent> <Down>      gj
noremap  <silent> <Up>        gk

" Some Emacs-like keys in insert mode and command-line mode
inoremap <silent> <expr>    <Home>      col('.') == match(getline('.'), '\S') + 1 ? "\<C-o>0" : "\<C-o>^"
inoremap <silent> <expr>    <C-a>       col('.') == match(getline('.'), '\S') + 1 ? "\<C-o>0" : "\<C-o>^"
inoremap <silent>           <C-x><C-a>  <C-a>
cnoremap <silent>           <C-a>       <Home>
cnoremap <silent>           <C-x><C-a>  <C-a>

inoremap <silent> <expr>    <C-b>       getline('.') =~ '^\s*$' && col('.') > strlen(getline('.')) ? "0\<Lt>C-d>\<Lt>Esc>kJs" : "\<Lt>Left>"
cnoremap <silent>           <C-b>       <Left>

inoremap <silent> <expr>    <C-d>       col('.') > strlen(getline('.')) ? "\<Lt>C-d>":"\<Lt>Del>"
cnoremap <silent> <expr>    <C-d>       getcmdpos() > strlen(getcmdline()) ? "\<Lt>C-d>":"\<Lt>Del>"


inoremap <silent> <expr>    <C-f>       col('.') > strlen(getline('.')) ? "\<Lt>C-f>":"\<Lt>Right>"
cnoremap <silent> <expr>    <C-f>       getcmdpos() > strlen(getcmdline())? &cedit : "\<Lt>Right>"

inoremap <silent>   <C-BS>      <C-w>
inoremap <silent>   <M-b>       <C-Left>
inoremap <silent>   <M-f>       <C-Right>
inoremap <silent>   <M-k>       <C-Right><C-w>
inoremap <silent>   <C-x>o      <C-o><C-w>w

cnoremap <silent>   <C-BS>      <C-w>
cnoremap <silent>   <M-b>       <C-Left>
cnoremap <silent>   <M-f>       <C-Right>
cnoremap <silent>   <M-k>       <C-Right><C-w>
cnoremap <silent>   <C-a>       <Home>

nnoremap <silent>   <M-Left>    <C-o>
nnoremap <silent>   <M-Right>   <C-i>

nnoremap <silent> <expr> Q tabpagenr('$') > 1 ? ":tabclose\<CR>" : ":confirm qall\<CR>"

if has('nvim')
    nnoremap <RightMouse> <Nop>
    inoremap <RightMouse> <Nop>
    vnoremap <RightMouse> <Nop>
    nnoremap <2-RightMouse> <Nop>
    inoremap <2-RightMouse> <Nop>
    vnoremap <2-RightMouse> <Nop>
    nnoremap <3-RightMouse> <Nop>
    inoremap <3-RightMouse> <Nop>
    vnoremap <3-RightMouse> <Nop>
    nnoremap <4-RightMouse> <Nop>
    inoremap <4-RightMouse> <Nop>
    vnoremap <4-RightMouse> <Nop>
endif

nnoremap <M-x> :
inoremap <M-x> <C-o>:

" vim: sw=4 ts=8 sts=4 et
