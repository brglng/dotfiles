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
      \ '1': ["<Plug>lightline#bufferline#go(1)", "buffer-1"],
      \ '2': ["<Plug>lightline#bufferline#go(2)", "buffer-2"],
      \ '3': ["<Plug>lightline#bufferline#go(3)", "buffer-3"],
      \ '4': ["<Plug>lightline#bufferline#go(4)", "buffer-4"],
      \ '5': ["<Plug>lightline#bufferline#go(5)", "buffer-5"],
      \ '6': ["<Plug>lightline#bufferline#go(6)", "buffer-6"],
      \ '7': ["<Plug>lightline#bufferline#go(7)", "buffer-7"],
      \ '8': ["<Plug>lightline#bufferline#go(8)", "buffer-8"],
      \ '9': ["<Plug>lightline#bufferline#go(9)", "buffer-9"],
      \ '0': ["<Plug>lightline#bufferline#go(10)", "buffer-10"],
      \ 'p': [':bp', 'previous-buffer'],
      \ 'n': [':bn', 'next-buffer']
      \ }

let g:which_key_map.w = {
      \ 'name': '+window',
      \ 'p': ['<C-w>p', 'jump-previous-window'],
      \ 'h': ['<C-w>h', 'jump-left-window-left'],
      \ 'j': ['<C-w>j', 'jump-belowing-window'],
      \ 'k': ['<C-w>k', 'jump-aboving-window'],
      \ 'l': ['<C-w>l', 'jump-right-window'],
      \ 'H': ['<C-w>H', 'move-window-to-left'],
      \ 'J': ['<C-w>J', 'move-window-to-bottom'],
      \ 'K': ['<C-w>K', 'move-window-to-top'],
      \ 'L': ['<C-w>L', 'move-window-to-right'],
      \ 'n': ['<C-w>n', 'new-window'],
      \ 'q': ['<C-w>q', 'close-window'],
      \ 'w': ['<C-w>w', 'jump-next-window'],
      \ 'o': ['<C-w>o', 'close-all-other-windows'],
      \ 'v': ['<C-w>v', 'vertically-split-window'],
      \ 's': ['<C-w>s', 'split-window']
      \ }

let g:which_key_map.q = ['<C-w>q', 'close-window']

let g:which_key_map.Q = [':qa', 'quit-vim']

let g:which_key_map.l = {
      \ 'name': '+lists',
      \ ';': [':Leaderf command', 'list-vim-commands'],
      \ 'a': [':CocList actions', 'list-code-actions-of-region'],
      \ 'b': [':Leaderf buffer', 'list-buffers'],
      \ 'C': [':Leaderf colorscheme', 'list-colorschemes'],
      \ 'c': [':CocList commands', 'list-coc-commands'],
      \ 'd': [':CocList diagnostics', 'list-diagnostics'],
      \ 'e': [':CocList extensions', 'list-coc-extensions'],
      \ 'f': [':Leaderf file', 'list-files'],
      \ 'F': [':CocList folders', 'list-folders'],
      \ 'g': [':Leaderf rg', 'grep'],
      \ 'k': [':CocList links', 'list-links'],
      \ 'L': [':CocList locationlist', 'list-loclist'],
      \ 'l': [':Leaderf line', 'search-lines'],
      \ 'm': [':CocList marks', 'list-marks'],
      \ 'M': [':CocList maps', 'list-mappings'],
      \ 'H': {
      \     'name': '+history',
      \     'c': [':Leaderf cmdHistory ', 'list-command-history'],
      \     'j': [':CocList location', 'list-jump-history'],
      \     's': [':Leaderf searchHistory', 'list-search-history'],
      \     't': [':CocList translation', 'list-tranlation-history']
      \ },
      \ 'h': [':Leaderf help', 'list-help-tags'],
      \ 'o': [':Leaderf bufTag', 'list-outline'],
      \ 'q': [':CocList quickfix', 'list-quickfix'],
      \ 'r': [':Leaderf mru', 'list-recent-files'],
      \ 'p': [':CocListResume', 'resume-previous-list'],
      \ 'P': [':CocList snippets', 'list snippets'],
      \ 's': [':CocList -I symbols', 'list-symbols'],
      \ 'S': [':CocList sessions', 'list-sessions'],
      \ 't': [':Leaderf function', 'list-buffer-functions'],
      \ 'w': [':CocList windows', 'list-windows'],
      \ }

nnoremap <Leader>sr     :.,$s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>sg     :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>sR     :.,$s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>sG     :%s/\<<C-r><C-w>\>//g<Left><Left>
let g:which_key_map.s = {
      \ 'name': '+search-replace',
      \ 'r': 'search-replace-to-the-end',
      \ 'g': 'search-replace-whole-file',
      \ 'R': 'search-replace-to-the-end-no-prompt',
      \ 'G': 'search-replace-whole-file-no-prompt'
      \ }

let g:which_key_map.T = {
      \ 'name': '+translate',
      \ 'p': ['<Plug>(coc-translator-p)', 'translate-and-popup'],
      \ 'e': ['<Plug>(coc-translator-e)', 'translate-and-echo'],
      \ 'r': ['<Plug>(coc-translator-r)', 'translate-and-replace']
      \ }

let g:which_key_map.g = {
      \ 'name': '+git',
      \ 'b': [':CocList --normal branches', 'list-git-branches'],
      \ 'd': ['<Plug>(coc-git-chunkinfo)', 'show-chunk-diff'],
      \ 'c': ['<Plug>(coc-git-commit)', 'show-commit-log'],
      \ 'f': [':CocList gfiles', 'list-git-files'],
      \ 'l': [':CocList --normal commits', 'list-git-log'],
      \ 'L': [':CocList --normal bcommits', 'list-git-log-of-file'],
      \ 'i': [':CocList --normal issues', 'list-github-issues'],
      \ 'n': ['<Plug>(coc-git-nextchunk)', 'jump-next-chunk'],
      \ 'p': ['<Plug>(coc-git-prevchunk)', 'jump-previous-chunk'],
      \ 's': [':CocList --normal gstatus', 'show-git-status'],
      \ }

vmap <Leader>x= <Plug>(coc-format-selected)
vmap <Leader>xa <Plug>(coc-codeaction-selected)
let g:which_key_map.x = {
      \ 'name': '+language-semantic',
      \ 'a': ['<Plug>(coc-codeaction-selected)', 'do-code-action-on-region'],
      \ 'A': ['<Plug>(coc-codeaction)', 'do-code-action-on-line'],
      \ 'd': ['<Plug>(coc-definition)', 'jump-definition'],
      \ 'k': ['<Plug>(coc-declaration)', 'jump-declaration'],
      \ 't': ['<Plug>(coc-type-definition)', 'jump-type-definition'],
      \ 'i': ['<Plug>(coc-implementation)', 'jump-implementation'],
      \ 'r': ['<Plug>(coc-references)', 'find-references'],
      \ 'R': ['<Plug>(coc-rename)', 'rename-current-symbol'],
      \ 'f': ['CocAction("format")', 'format-buffer'],
      \ '=': ['<Plug>(coc-format-selected)', 'format-region'],
      \ 'K': ["CocAction('doHover')", 'show-documentation'],
      \ 'q': ['<Plug>(coc-fix-current)', 'fix-line'],
      \ 'n': {
      \     'name': '+navigate-declarations',
      \     'd': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''D''})', 'first-child-declaration'],
      \     'l': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''L''})', 'previous-declaration'],
      \     'r': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''R''})', 'next-declaration'],
      \     'u': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''U''})', 'parent-declaration'],
      \ },
      \ 'I': {
      \     'name': '+inheritance-hierarchy',
      \     'b': ['CocLocations(''ccls'', ''$ccls/inheritance'')', 'show-base-types'],
      \     'd': ['CocLocations(''ccls'', ''$ccls/inheritance'', {''derived'': v:true})', 'show-derived-types'],
      \ },
      \ 'c': {
      \     'name': '+call-hierarchy',
      \     'r': ['CocLocations(''ccls'', ''$ccls/call'')', 'show-callers'],
      \     'e': ['CocLocations(''ccls'', ''$ccls/call'', {''callee'': v:true})', 'show-callees'],
      \ },
      \ 'm': {
      \     'name': '+members',
      \     'v': ['CocLocations(''ccls'', ''$ccls/member'')', 'member-vairables'],
      \     'f': ['CocLocations(''ccls'', ''$ccls/member'', {''kind'': 3})', 'member-functions'],
      \     'm': ['CocLocations(''ccls'', ''$ccls/member'', {''kind'': 2})', 'member-types'],
      \ },
      \ 'v': ['CocLocations(''ccls'', ''$ccls/var'')', 'find-all-instances-of-type'],
      \ 'V': ['CocLocations(''ccls'', ''$ccls/var'', {''kind'': 1})', 'find-all-instances-of-the-type-of-symbol'],
      \ }

let g:which_key_map.t = {
      \ 'name': '+ui-toggles',
      \ 'f': ['zpan#toggle_coc_explorer()', 'toggle-file-tree'],
      \ 'i': [':IndentLinesToggle', 'toggle-indent-line'],
      \ 'l': ['zpan#toggle_loclist()', 'toggle-location-list'],
      \ 'o': ['zpan#toggle_vista()', 'toggle-outline'],
      \ 'q': ['zpan#toggle_quickfix()', 'toggle-quickfix'],
      \ 't': ['zpan#toggle_terminal()', 'toggle-terminal'],
      \ 'u': ['zpan#toggle_undotree()', 'toggle-undo-tree']
      \ }

let g:which_key_map.c = {
      \ 'name': '+comments',
      \ 'c': 'comment-lines',
      \ 'n': 'comment-lines-force-nesting',
      \ ' ': 'toggle-comment',
      \ 'm': 'comment-lines-with-block-comment',
      \ 'i': 'toggle-individual-line-comment',
      \ 's': 'comment-lines-documentation-style',
      \ 'y': 'yank-and-comment-lines',
      \ '$': 'comment-to-the-end',
      \ 'A': 'add-comment-to-end-of-line',
      \ 'a': 'switch-comment-delimiters',
      \ 'l': 'comment-left-aligned',
      \ 'b': 'comment-both-side-aligned',
      \ 'u': 'uncomment-lines'
      \ }

let g:which_key_map.a = {
      \ 'a': 'easy-align'
      \ }

let g:which_key_map.f = ['<Plug>(coc-smartf-forward)', 'coc-smartf-forward']
let g:which_key_map.F = ['<Plug>(coc-smartf-backward)', 'coc-smartf-forward']
let g:which_key_map[';'] = ['<Plug>(coc-smartf-repeat)', 'coc-smartf-repeat']
let g:which_key_map[','] = ['<Plug>(coc-smartf-repeat-opposite)', 'coc-smartf-repeat-opposite']

" vim: sw=2 sts=4 ts=8 et
