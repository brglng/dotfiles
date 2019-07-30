set timeoutlen=300
let g:mapleader = "\<Space>"

silent! call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<C-u>WhichKeyVisual '<Space>'<CR>

" autocmd! FileType which_key
" autocmd  FileType which_key silent! setlocal winblend=15

let g:which_key_map =  {}

let g:which_key_map.b = {
      \ 'name': '+buffer',
      \ '1': ["<Plug>lightline#bufferline#go(1)", "switch to buffer 1"],
      \ '2': ["<Plug>lightline#bufferline#go(2)", "switch to buffer 2"],
      \ '3': ["<Plug>lightline#bufferline#go(3)", "switch to buffer 3"],
      \ '4': ["<Plug>lightline#bufferline#go(4)", "switch to buffer 4"],
      \ '5': ["<Plug>lightline#bufferline#go(5)", "switch to buffer 5"],
      \ '6': ["<Plug>lightline#bufferline#go(6)", "switch to buffer 6"],
      \ '7': ["<Plug>lightline#bufferline#go(7)", "switch to buffer 7"],
      \ '8': ["<Plug>lightline#bufferline#go(8)", "switch to buffer 8"],
      \ '9': ["<Plug>lightline#bufferline#go(9)", "switch to buffer 9"],
      \ '0': ["<Plug>lightline#bufferline#go(10)", "switch to buffer 10"],
      \ 'p': [':bp', 'switch to previous buffer'],
      \ 'n': [':bn', 'switch to next buffer']
      \ }

let g:which_key_map.w = {
      \ 'name': '+window',
      \ 'p': ['<C-w>p', 'move to previous window'],
      \ 'h': ['<C-w>h', 'move to left window'],
      \ 'j': ['<C-w>j', 'move to below window'],
      \ 'k': ['<C-w>k', 'move to above window'],
      \ 'l': ['<C-w>l', 'move to right window'],
      \ 'H': ['<C-w>H', 'move current window to the left'],
      \ 'J': ['<C-w>J', 'move current window to the bottom'],
      \ 'K': ['<C-w>K', 'move current window to the top'],
      \ 'L': ['<C-w>L', 'move current window to the right'],
      \ 'n': ['<C-w>n', 'create new window'],
      \ 'q': ['<C-w>q', 'close current window'],
      \ 'w': ['<C-w>w', 'move to next window'],
      \ 'o': ['<C-w>o', 'close all other windows'],
      \ 'v': ['<C-w>v', 'vertically split window'],
      \ 's': ['<C-w>s', 'horizontally split window']
      \ }

let g:which_key_map.q = ['<C-w>q', 'close current window']

let g:which_key_map.Q = [':qa', 'quit vim']

let g:which_key_map.l = {
      \ 'name': '+lists',
      \ ';': [':CocList vimcommands', 'list vim commands'],
      \ 'a': [':CocList actions', 'list actions of selected region'],
      \ 'b': [':CocList buffers', 'list buffers'],
      \ 'C': [':CocList colors', 'list colorschemes'],
      \ 'c': [':CocList commands', 'list coc commands'],
      \ 'd': [':CocList diagnostics', 'list diagnostics'],
      \ 'e': [':CocList extensions', 'list coc extensions'],
      \ 'f': [':CocList files', 'list files under cwd recursively'],
      \ 'F': [':CocList folders', 'list current workspace folders'],
      \ 'g': [':CocList grep', 'grep files under cwd'],
      \ 'k': [':CocList links', 'list links of current buffer'],
      \ 'L': [':CocList locationlist', 'list location list'],
      \ 'l': [':CocList lines', 'search lines by regex'],
      \ 'm': [':CocList marks', 'list marks'],
      \ 'M': [':CocList maps', 'list key mappings'],
      \ 'H': {
      \     'name': '+history',
      \     'c': [':CocList cmdhistory', 'list history of commands'],
      \     'l': [':CocList location', 'list history jump locations'],
      \     's': [':CocList searchhistory', 'list history of search'],
      \     't': [':CocList translation', 'list history of translation']
      \ },
      \ 'h': [':CocList helptags', 'list vim help tags'],
      \ 'o': [':CocList outline', 'list outline'],
      \ 'q': [':CocList quickfix', 'list quickfix'],
      \ 'r': [':CocList mru', 'list recent files'],
      \ 'p': [':CocListResume', 'resume previous list'],
      \ 'P': [':CocList snippets', 'list snippets'],
      \ 's': [':CocList -I symbols', 'list symbols'],
      \ 'S': [':CocList sessions', 'list sessions'],
      \ 'w': [':CocList words', 'search words in current file'],
      \ 'W': [':CocList windows', 'list windows'],
      \ }

nnoremap <Leader>sr     :.,$s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>sg     :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>sR     :.,$s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>sG     :%s/\<<C-r><C-w>\>//g<Left><Left>
let g:which_key_map.s = {
      \ 'name': '+search-replace',
      \ 'r': 'search to the end for current word and replace',
      \ 'g': 'search whole file for current word and replace',
      \ 'R': 'search to the end for current word and replace without prompt',
      \ 'G': 'search whole file for current word and replace without prompt'
      \ }

let g:which_key_map.T = {
      \ 'name': '+translate',
      \ 'p': ['<Plug>(coc-translator-p)', 'translate the word under cursor and popup'],
      \ 'e': ['<Plug>(coc-translator-e)', 'translate the word under cursor and echo'],
      \ 'r': ['<Plug>(coc-translator-r)', 'translate and replace the word under cursor']
      \ }

let g:which_key_map.g = {
      \ 'name': '+git',
      \ 'b': [':CocList --normal branches', 'list git branches'],
      \ 'd': ['<Plug>(coc-git-chunkinfo)', 'show chunk diff at current position'],
      \ 'c': ['<Plug>(coc-git-commit)', 'show detailed commit log of current file'],
      \ 'f': [':CocList gfiles', 'list git files'],
      \ 'l': [':CocList --normal commits', 'git log'],
      \ 'L': [':CocList --normal bcommits', 'git log of current file'],
      \ 'i': [':CocList --normal issues', 'list GitHub issues'],
      \ 'n': ['<Plug>(coc-git-nextchunk)', 'next chunk'],
      \ 'p': ['<Plug>(coc-git-prevchunk)', 'previous chunk'],
      \ 's': [':CocList --normal gstatus', 'git status'],
      \ }

vmap <Leader>x= <Plug>(coc-format-selected)
vmap <Leader>xa <Plug>(coc-codeaction-selected)
let g:which_key_map.x = {
      \ 'name': '+language-semantic',
      \ 'a': ['<Plug>(coc-codeaction-selected)', 'do code action on selected region'],
      \ 'A': ['<Plug>(coc-codeaction)', 'do code action on current line'],
      \ 'd': ['<Plug>(coc-definition)', 'go to definition'],
      \ 'k': ['<Plug>(coc-declaration)', 'go to declaration'],
      \ 't': ['<Plug>(coc-type-definition)', 'go to type definition'],
      \ 'i': ['<Plug>(coc-implementation)', 'go to implementation'],
      \ 'r': ['<Plug>(coc-references)', 'find references'],
      \ 'R': ['<Plug>(coc-rename)', 'rename current symbol'],
      \ 'f': ['CocAction("format")', 'format current buffer'],
      \ '=': ['<Plug>(coc-format-selected)', 'format selected region'],
      \ 'K': ["CocAction('doHover')", 'show documentation of current symbol'],
      \ 'q': ['<Plug>(coc-fix-current)', 'fix current line'],
      \ 'n': {
      \     'name': '+navigate-declarations',
      \     'd': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''D''})', 'first child declaration'],
      \     'l': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''L''})', 'previous declaration'],
      \     'r': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''R''})', 'next declaration'],
      \     'u': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''U''})', 'parent declaration'],
      \ },
      \ 'I': {
      \     'name': '+inheritance-hierarchy',
      \     'b': ['CocLocations(''ccls'', ''$ccls/inheritance'')', 'show base classes'],
      \     'd': ['CocLocations(''ccls'', ''$ccls/inheritance'', {''derived'': v:true})', 'show derived classes'],
      \ },
      \ 'c': {
      \     'name': '+call-hierarchy',
      \     'r': ['CocLocations(''ccls'', ''$ccls/call'')', 'show callers'],
      \     'e': ['CocLocations(''ccls'', ''$ccls/call'', {''callee'': v:true})', 'show callees'],
      \ },
      \ 'm': {
      \     'name': '+members',
      \     'v': ['CocLocations(''ccls'', ''$ccls/member'')', 'member vairables'],
      \     'f': ['CocLocations(''ccls'', ''$ccls/member'', {''kind'': 3})', 'member functions'],
      \     'm': ['CocLocations(''ccls'', ''$ccls/member'', {''kind'': 2})', 'member types'],
      \ },
      \ 'v': ['CocLocations(''ccls'', ''$ccls/var'')', 'find all instances of this type'],
      \ 'V': ['CocLocations(''ccls'', ''$ccls/var'', {''kind'': 1})', 'find all instances of the type of current symbol'],
      \ }

let g:which_key_map.t = {
      \ 'name': '+ui-toggles',
      \ 'f': ['zpan#toggle_defx()', 'toggle file tree'],
      \ 'i': [':IndentLinesToggle', 'toggle indent line'],
      \ 'l': ['zpan#toggle_loclist()', 'toggle location list'],
      \ 'o': ['zpan#toggle_vista()', 'toggle outline'],
      \ 'q': ['zpan#toggle_quickfix()', 'toggle quickfix'],
      \ 't': ['zpan#toggle_terminal()', 'toggle terminal'],
      \ 'u': ['zpan#toggle_undotree()', 'toggle undo tree']
      \ }

let g:which_key_map.c = {
      \ 'name': '+comments',
      \ 'c': 'comment out the selected lines',
      \ 'n': 'comment out the selected lines (force nesting)',
      \ ' ': 'toggle comment of the selected lines',
      \ 'm': 'comment out the selected lines using multiline comment',
      \ 'i': 'toggles the comment of the selected lines individually',
      \ 's': 'comment out the selected lines using documentation style',
      \ 'y': 'yank and comment out the selected lines',
      \ '$': 'comment out from cursor to the end of line',
      \ 'A': 'add comment to the end of line and insert',
      \ 'a': 'switch to the alternative set of delimiters',
      \ 'l': 'comment out the current line or selection (left aligned)',
      \ 'b': 'comment out the current line or selection (both side aligned)',
      \ 'u': 'uncomment the selected lines'
      \ }

let g:which_key_map.a = {
      \ 'a': 'easy-align'
      \ }

" vim: sw=2 sts=4 ts=8 et
