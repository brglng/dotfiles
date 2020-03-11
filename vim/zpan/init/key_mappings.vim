" backspace in Visual mode deletes selection
vnoremap <BS> d

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>

noremap <C-Z> u
inoremap <C-Z> <C-O>u

noremap <M-z> <C-r>
inoremap <M-z> <C-o><C-r>

nnoremap <C-C> "+y
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

nnoremap <M-x> "+x
vnoremap <M-x> "+x
vnoremap <S-Del> "+x

map <M-v> "+gP
exe 'inoremap <script> <M-v> <C-G>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <M-v> ' . paste#paste_cmd['v']
cmap <M-v> <C-R>+

map <S-Insert> "+gP
exe 'inoremap <script> <S-Insert> <C-G>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <S-Insert> ' . paste#paste_cmd['v']
cmap <S-Insert> <C-R>+

noremap <C-Q> <C-V>
inoremap <C-Q> <C-O><C-V>

noremap <M-a> gggH<C-o>G
inoremap <M-a> <C-o>gg<C-o>gH<C-o>G
cnoremap <M-a> <C-c>gggH<C-o>G
onoremap <M-a> <C-c>gggH<C-o>G
snoremap <M-a> <C-c>gggH<C-o>G
xnoremap <M-a> <C-c>ggVG

if has('gui_macvim')
    set macmeta
endif

inoremap <silent> <C-U> <C-G>u<C-U>

inoremap <silent><expr> <TAB>
  \ zpan#pumselected()
  \ ? coc#_select_confirm()
  \ : coc#expandableOrJumpable() ?
  \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
  \ : "\<TAB>"

inoremap <silent> <expr> <C-Space> coc#refresh()
inoremap <silent> <expr> <C-x><C-x> coc#refresh()

inoremap <expr> <CR> zpan#pumselected() ? coc#_select_confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

inoremap <expr> <Esc> pumvisible() ? "\<C-e>\<Esc>" : "\<Esc>"

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

" inoremap <silent> <expr>    <C-E>       col('.') > strlen(getline('.')) <bar><bar> zpan#pumselected() ? "\<Lt>C-E>" : "\<Lt>End>"
inoremap <silent> <expr>    <C-E>       col('.') > strlen(getline('.')) ? "\<Lt>C-E>" : "\<Lt>End>"

inoremap <silent> <expr>    <C-F>       col('.') > strlen(getline('.')) ? "\<Lt>C-F>":"\<Lt>Right>"
cnoremap <silent> <expr>    <C-F>       getcmdpos() > strlen(getcmdline())? &cedit : "\<Lt>Right>"

inoremap <silent> <expr>    <C-n>       zpan#pumselected() ? "\<C-N>" : "\<Down>"
inoremap <silent> <expr>    <C-p>       zpan#pumselected() ? "\<C-P>" : "\<Up>"

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

nnoremap <silent> Q :confirm qall<CR>

" buffer
nnoremap <silent> <C-Tab>       :bp<CR>
nnoremap <silent> <C-S-Tab>     :bn<CR>

" UI toggles
noremap <silent> <M-1> :call sidebar#toggle('coc-explorer')<CR>
noremap <silent> <M-2> :call sidebar#toggle('vista')<CR>
noremap <silent> <M-3> :call sidebar#toggle('undotree')<CR>
noremap <silent> <M-6> :call sidebar#toggle('quickfix')<CR>
noremap <silent> <M-7> :call sidebar#toggle('loclist')<CR>
noremap <silent> <M-=> :call sidebar#toggle('terminal')<CR>
if has('nvim')
    tnoremap <silent> <M-1> <C-\><C-n>:call sidebar#toggle('coc-explorer')<CR>
    tnoremap <silent> <M-2> <C-\><C-n>:call sidebar#toggle('vista')<CR>
    tnoremap <silent> <M-3> <C-\><C-n>:call sidebar#toggle('undotree')<CR>
    tnoremap <silent> <M-6> <C-\><C-n>:call sidebar#toggle('quickfix')<CR>
    tnoremap <silent> <M-7> <C-\><C-n>:call sidebar#toggle('loclist')<CR>
    tnoremap <silent> <M-=> <C-\><C-n>:call sidebar#toggle('terminal')<CR>
else
    tnoremap <silent> <M-1> <C-_>:call sidebar#toggle('coc-explorer')<CR>
    tnoremap <silent> <M-2> <C-_>:call sidebar#toggle('vista')<CR>
    tnoremap <silent> <M-3> <C-_>:call sidebar#toggle('undotree')<CR>
    tnoremap <silent> <M-6> <C-_>:call sidebar#toggle('quickfix')<CR>
    tnoremap <silent> <M-7> <C-_>:call sidebar#toggle('loclist')<CR>
    tnoremap <silent> <M-=> <C-_>:call sidebar#toggle('terminal')<CR>
endif

" Fuzzy finder
nnoremap <silent> <C-p> :Clap files<CR>

" Tasks
noremap <silent> <F5> :CocList --normal tasks<CR>
inoremap <silent> <F5> <C-o>:CocList --normal tasks<CR>

" vim: sw=4 ts=8 sts=4 et
