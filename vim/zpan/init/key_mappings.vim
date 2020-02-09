function! Terminal_MetaMode(mode)
    set ttimeout
    if $TMUX != ''
        set ttimeoutlen=30
    elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
        set ttimeoutlen=80
    endif
    if has('nvim') || has('gui_running')
        return
    endif
    function! s:metacode(mode, key)
        if a:mode == 0
            exec "set <M-".a:key.">=\e".a:key
        else
            exec "set <M-".a:key.">=\e]{0}".a:key."~"
        endif
    endfunc
    for i in range(10)
        call s:metacode(a:mode, nr2char(char2nr('0') + i)) 
    endfor
    for i in range(26)
        call s:metacode(a:mode, nr2char(char2nr('a') + i))
        call s:metacode(a:mode, nr2char(char2nr('A') + i))
    endfor
    if a:mode != 0
        for c in [',', '.', '/', ';', '[', ']', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_']
            call s:metacode(a:mode, c)
        endfor
    else
        for c in [',', '.', '/', ';', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_']
            call s:metacode(a:mode, c)
        endfor
    endif
endfunc

" command! -nargs=0 -bang VimMetaInit call Terminal_MetaMode(<bang>0)
call Terminal_MetaMode(0)

" backspace in Visual mode deletes selection
vnoremap <BS> d

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

map   <silent> <S-Insert> "+gP
cmap  <silent> <S-Insert> <C-r>+
exe 'inoremap <script> <S-Insert> <C-g>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <S-Insert> ' . paste#paste_cmd['v']

noremap   <silent> <C-s>  :update<CR>
vnoremap  <silent> <C-s>  <C-c>:update<CR>
inoremap  <silent> <C-s>  <C-o>:update<CR>

noremap   <silent> <C-z>  u
inoremap  <silent> <C-z>  <C-o>u

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

inoremap <silent><expr> <TAB>
      \ zpan#pumselected()
      \ ? coc#_select_confirm()
      \ : coc#expandableOrJumpable() ?
      \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
      \ : "\<TAB>"

inoremap <silent> <expr> <C-Space> coc#refresh()
inoremap <silent> <expr> <C-x><C-x> coc#refresh()

inoremap <expr> <CR>
      \ zpan#pumselected() ?
      \ "\<C-y>" :
      \ "\<CR>"

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

" buffer
nnoremap <silent> <C-Tab>       :bp<CR>
nnoremap <silent> <C-S-Tab>     :bn<CR>

" UI toggles
noremap <silent> <M-1> :call zpan#toggle_coc_explorer()<CR>
noremap <silent> <M-2> :call zpan#toggle_vista()<CR>
noremap <silent> <M-3> :call zpan#toggle_undotree()<CR>
noremap <silent> <M-6> :call zpan#toggle_quickfix()<CR>
noremap <silent> <M-7> :call zpan#toggle_loclist()<CR>
