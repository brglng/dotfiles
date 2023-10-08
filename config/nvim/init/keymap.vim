" backspace in Visual mode deletes selection
vnoremap <BS> d

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

noremap <silent> <C-s> :update<CR>
vnoremap <silent> <C-s> <C-c>:update<CR>
inoremap <silent> <C-s> <C-o>:update<CR>
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

" inoremap <silent> <expr> <TAB>
"   \ zpan#pumselected()
"   \ ? coc#pum#confirm()
"   \ : coc#expandableOrJumpable() ?
"   \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
"   \ : "\<TAB>"

" function s:expand_ultimate_autopair_cr()
"     return luaeval("require('ultimate-autopair.core').run(vim.api.nvim_replace_termcodes('<CR>', true, true, true))")
" endfunction
" inoremap <silent> <expr> <CR> zpan#pumselected() ? coc#pum#confirm() : "\<C-g>u" . <SID>expand_ultimate_autopair_cr() . "\<C-r>=coc#on_enter()\<CR>\<C-r>=EndwiseDiscretionary()<CR>"

" inoremap <silent> <expr> <Esc> coc#pum#visible() ? "\<C-o>:call coc#pum#cancel()\<CR>\<Esc>" : "\<Esc>"

" inoremap <silent> <expr> <Down> coc#pum#visible() ? coc#pum#next(1) : "\<C-o>gj"
" inoremap <silent> <expr> <Up> coc#pum#visible() ? coc#pum#prev(1) : "\<C-o>gk"

" arrows move through screen lines
noremap  <silent> <Down>      gj
noremap  <silent> <Up>        gk

" Some Emacs-like keys in insert mode and command-line mode
inoremap <silent> <expr>    <Home>      col('.') == 1 ? "\<C-o>^" : "\<C-o>0"
inoremap <silent> <expr>    <C-a>       col('.') == 1 ? "\<C-o>^" : "\<C-o>0"
inoremap <silent>           <C-x><C-a>  <C-a>
cnoremap <silent>           <C-a>       <Home>
cnoremap <silent>           <C-x><C-a>  <C-a>

inoremap <silent> <expr>    <C-b>       getline('.') =~ '^\s*$' && col('.') > strlen(getline('.')) ? "0\<Lt>C-d>\<Lt>Esc>kJs" : "\<Lt>Left>"
cnoremap <silent>           <C-b>       <Left>

inoremap <silent> <expr>    <C-d>       col('.') > strlen(getline('.')) ? "\<Lt>C-d>":"\<Lt>Del>"
cnoremap <silent> <expr>    <C-d>       getcmdpos() > strlen(getcmdline()) ? "\<Lt>C-d>":"\<Lt>Del>"

" inoremap <silent> <expr>    <C-e>       coc#pum#visible() ? coc#pum#cancel() : col('.') > strlen(getline('.')) ? "\<Lt>C-e>" : "\<Lt>End>"

inoremap <silent> <expr>    <C-f>       col('.') > strlen(getline('.')) ? "\<Lt>C-f>":"\<Lt>Right>"
cnoremap <silent> <expr>    <C-f>       getcmdpos() > strlen(getcmdline())? &cedit : "\<Lt>Right>"

" inoremap <silent> <expr>    <C-n>       coc#pum#visible() ? coc#pum#next(1) : "\<Down>"
" inoremap <silent> <expr>    <C-p>       coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"

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

nnoremap <silent>   Q           :confirm qall<CR>

" buffer
nnoremap <silent>   <C-Tab>     :bp<CR>
nnoremap <silent>   <C-S-Tab>   :bn<CR>

" UI toggles
if has('nvim')
    noremap <silent> <M-1> :call sidebar#toggle('neo-tree-filesystem')<CR>
    noremap <silent> <M-2> :call sidebar#toggle('neo-tree-document-symbols')<CR>
    noremap <silent> <M-3> :call sidebar#toggle('neo-tree-buffers')<CR>
    noremap <silent> <M-4> :call sidebar#toggle('neo-tree-git-status')<CR>
    noremap <silent> <M-8> :call sidebar#toggle('trouble-document-diagnostics')<CR>
    noremap <silent> <M-9> :call sidebar#toggle('trouble-workspace-diagnostics')<CR>
    noremap <silent> <M-0> :call sidebar#toggle('trouble-lsp-references')<CR>
    noremap <silent> <M--> :call sidebar#toggle('trouble-lsp-definitions')<CR>
    noremap <silent> <M-=> :call sidebar#toggle('trouble-lsp-type-definitions')<CR>
else
    noremap <silent> <M-2> :call sidebar#toggle('vista')<CR>
endif
noremap <silent> <M-6> :call sidebar#toggle('quickfix')<CR>
noremap <silent> <M-7> :call sidebar#toggle('loclist')<CR>
noremap <silent> <M-5> :call sidebar#toggle('undotree')<CR>
noremap <silent> <M-\> :call sidebar#toggle('terminal')<CR>
if has('nvim')
    tnoremap <silent> <M-1> <C-\><C-n>:call sidebar#toggle('neo-tree-filesystem')<CR>
    tnoremap <silent> <M-2> <C-\><C-n>:call sidebar#toggle('neo-tree-document-symbols')<CR>
    tnoremap <silent> <M-3> <C-\><C-n>:call sidebar#toggle('neo-tree-buffers')<CR>
    tnoremap <silent> <M-4> <C-\><C-n>:call sidebar#toggle('neo-tree-git-status')<CR>
    tnoremap <silent> <M-5> <C-\><C-n>:call sidebar#toggle('undotree')<CR>
    tnoremap <silent> <M-6> <C-\><C-n>:call sidebar#toggle('quickfix')<CR>
    tnoremap <silent> <M-7> <C-\><C-n>:call sidebar#toggle('loclist')<CR>
    tnoremap <silent> <M-8> <C-\><C-n>:call sidebar#toggle('trouble-document-diagnostics')<CR>
    tnoremap <silent> <M-9> <C-\><C-n>:call sidebar#toggle('trouble-workspace-diagnostics')<CR>
    tnoremap <silent> <M-0> <C-\><C-n>:call sidebar#toggle('trouble-lsp-references')<CR>
    tnoremap <silent> <M--> <C-\><C-n>:call sidebar#toggle('trouble-lsp-definitions')<CR>
    tnoremap <silent> <M-=> <C-\><C-n>:call sidebar#toggle('trouble-lsp-type-definitions')<CR>
    tnoremap <silent> <M-\> <C-\><C-n>:call sidebar#toggle('terminal')<CR>
else
    tnoremap <silent> <M-2> <C-_>:call sidebar#toggle('vista')<CR>
    tnoremap <silent> <M-5> <C-_>:call sidebar#toggle('undotree')<CR>
    tnoremap <silent> <M-6> <C-_>:call sidebar#toggle('quickfix')<CR>
    tnoremap <silent> <M-7> <C-_>:call sidebar#toggle('loclist')<CR>
    tnoremap <silent> <M-\> <C-_>:call sidebar#toggle('terminal')<CR>
endif

" Fuzzy finder
nnoremap <silent> <C-p> :Leaderf file<CR>

if has('nvim')
    nnoremap <RightMouse> <Nop>
    inoremap <RightMouse> <Nop>
    inoremap <C-x><C-x> <Cmd>lua require('cmp').complete()<CR>
endif

nnoremap ; :

" vim: sw=4 ts=8 sts=4 et
