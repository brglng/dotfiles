set timeoutlen=300
let g:which_key_use_floating_win = 0
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

silent! call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <Leader> :<C-u>WhichKey '<Space>'<CR>
vnoremap <silent> <Leader> :<C-u>WhichKeyVisual '<Space>'<CR>

" autocmd! FileType which_key
" autocmd  FileType which_key silent! setlocal winblend=15

let g:which_key_map =  {}

let g:which_key_map.a = {
  \ 'a': 'easy-align'
  \ }

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
  \ 'n': [':bn', 'next-buffer'],
  \ '/': [':Clap buffers', 'search-for-a-buffer']
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

let g:which_key_map.f = ['<Plug>(coc-smartf-forward)', 'coc-smartf-forward']
let g:which_key_map.F = ['<Plug>(coc-smartf-backward)', 'coc-smartf-forward']
let g:which_key_map[';'] = ['<Plug>(coc-smartf-repeat)', 'coc-smartf-repeat']
let g:which_key_map[','] = ['<Plug>(coc-smartf-repeat-opposite)', 'coc-smartf-repeat-opposite']

let g:which_key_map['g'] = {
  \ 'name': '+goto',
  \ 'c': {
  \     'name': '+call-hierarchy',
  \     'r': ['CocLocations(''ccls'', ''$ccls/call'')', 'show-callers'],
  \     'e': ['CocLocations(''ccls'', ''$ccls/call'', {''callee'': v:true})', 'show-callees'],
  \ },
  \ 'd': ['<Plug>(coc-definition)', 'goto-definition'],
  \ 'i': ['<Plug>(coc-implementation)', 'goto-implementation'],
  \ 'I': {
  \     'name': '+inheritance-hierarchy',
  \     'b': ['CocLocations(''ccls'', ''$ccls/inheritance'')', 'base-types'],
  \     'd': ['CocLocations(''ccls'', ''$ccls/inheritance'', {''derived'': v:true})', 'derived-types'],
  \ },
  \ 'k': ['<Plug>(coc-declaration)', 'goto-declaration'],
  \ 'n': {
  \     'name': '+navigating-declarations',
  \     'd': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''D''})', 'goto-first-child-declaration'],
  \     'l': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''L''})', 'goto-previous-declaration'],
  \     'r': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''R''})', 'goto-next-declaration'],
  \     'u': ['CocLocations(''ccls'', ''$ccls/navigate'', {''direction'': ''U''})', 'goto-parent-declaration'],
  \ },
  \ 'm': {
  \     'name': '+members',
  \     'v': ['CocLocations(''ccls'', ''$ccls/member'')', 'member-vairables'],
  \     'f': ['CocLocations(''ccls'', ''$ccls/member'', {''kind'': 3})', 'member-functions'],
  \     'm': ['CocLocations(''ccls'', ''$ccls/member'', {''kind'': 2})', 'member-types'],
  \ },
  \ 't': ['<Plug>(coc-type-definition)', 'goto-type-definition'],
  \ 'v': ['CocLocations(''ccls'', ''$ccls/var'')', 'find-all-instances-of-type'],
  \ 'V': ['CocLocations(''ccls'', ''$ccls/var'', {''kind'': 1})', 'find-all-instances-of-the-type-of-symbol'],
  \ }

let g:which_key_map['i'] = [':IndentLinesToggle', 'toggle-indent-line']

let g:which_key_map['j'] = {
  \ 'name': '+any-jump',
  \ 'a': [':AnyJump', 'jump-to-definition'],
  \ 'b': [':AnyJumpBack', 'jump-back'],
  \ 'l': [':AnyJumpLastResults', 'retore-previous-search-window']
  \ }

let g:which_key_map['p'] = {
  \ 'name': '+fuzzy-finder',
  \ ' ': [':Clap providers', 'show-providers'],
  \ ';': [':Clap command', 'find-commands'],
  \ 'C': [':Clap colors', 'find-colors'],
  \ 'c': [':CocList commands', 'find-coc-commands'],
  \ 'd': [':Clap filer', 'show-file-tree'],
  \ 'e': [':CocList extensions', 'find-coc-extensions'],
  \ 'f': [':Clap files', 'find-files'],
  \ 'F': [':CocList folders', 'find-folders'],
  \ 'g': [':Clap grep', 'grep'],
  \ 'j': [':Clap jumps', 'show-jumps'],
  \ 'k': [':CocList links', 'list-links'],
  \ 'L': [':Clap loclist', 'show-loclist'],
  \ 'l': [':Clap blines', 'search-buffer-lines'],
  \ 'm': [':Clap marks', 'show-marks'],
  \ 'M': [':CocList maps', 'list-mappings'],
  \ 'H': {
  \     'name': '+history',
  \     'c': [':Clap command_history', 'show-command-history'],
  \     'j': [':CocList location', 'list-jump-history']
  \ },
  \ 'h': [':Clap help_tags', 'find-help'],
  \ 'o': [':Clap tags', 'search-buffer-tags'],
  \ 'P': [':CocList snippets', 'list snippets'],
  \ 'q': [':Clap quickfix', 'show-quickfix'],
  \ 'r': [':Clap history', 'find-recent-files'],
  \ 'R': [':Clap registers', 'show-registers'],
  \ 's': [':CocList -I symbols', 'list-symbols'],
  \ 'S': [':CocList sessions', 'list-sessions'],
  \ 'y': [':Clap yanks', 'show-yanks']
  \ }

let g:which_key_map.q = ['<C-w>q', 'close-window']

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

nmap <silent> <Leader>t <Plug>TranslateW
vmap <silent> <Leader>t <Plug>TranslateWV
let g:which_key_map.t = 'translate'

let g:which_key_map.v = {
  \ 'name': '+version-control',
  \ 'a': [':CocCommand git.chunkStage', 'add-chunk'],
  \ 'b': [':CocList --normal branches', 'git-branches'],
  \ 'd': ['<Plug>(coc-git-chunkinfo)', 'show-chunk-diff'],
  \ 'c': ['<Plug>(coc-git-commit)', 'show-commit-log'],
  \ 'f': [':Clap gfiles', 'list-git-files'],
  \ 'l': [':CocList --normal commits', 'git-log'],
  \ 'L': [':CocList --normal bcommits', 'file-commits'],
  \ 'i': [':CocList --normal issues', 'list-github-issues'],
  \ 'n': ['<Plug>(coc-git-nextchunk)', 'jump-next-chunk'],
  \ 'p': ['<Plug>(coc-git-prevchunk)', 'jump-previous-chunk'],
  \ 's': [':CocList --normal gstatus', 'git-status'],
  \ 'u': [':CocCommand git.chunkUndo', 'undo-chunk']
  \ }

let g:which_key_map.w = {
  \ 'name': '+window',
  \ 'p': ['<C-w>p', 'jump-previous-window'],
  \ 'h': ['<C-w>h', 'jump-left-window'],
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
  \ 's': ['<C-w>s', 'split-window'],
  \ '/': [':Clap windows', 'search-for-a-window'],
  \ }

vmap <Leader>x= <Plug>(coc-format-selected)
vmap <Leader>xa <Plug>(coc-codeaction-selected)
let g:which_key_map.x = {
  \ 'name': '+lsp',
  \ 'a': ['<Plug>(coc-codeaction-selected)', 'do-code-action-on-region'],
  \ 'A': ['<Plug>(coc-codeaction)', 'do-code-action-on-line'],
  \ 'r': ['<Plug>(coc-references)', 'find-references'],
  \ 'R': ['<Plug>(coc-rename)', 'rename-current-symbol'],
  \ 'f': ['CocAction("format")', 'format-buffer'],
  \ '=': ['<Plug>(coc-format-selected)', 'format-region'],
  \ 'k': ["CocAction('doHover')", 'show-documentation'],
  \ 'q': ['<Plug>(coc-fix-current)', 'fix-line'],
  \ 'l': {
  \     'name': '+lists',
  \     'a': [':CocList --normal actions', 'list-code-actions'],
  \     'e': [':CocList --normal diagnostics', 'list-errors']
  \ },
  \ }

silent! call which_key#register('K', 'g:which_key_map_K')
nnoremap <silent> K :<C-u>WhichKey 'K'<CR>
vnoremap <silent> K :<C-u>WhichKeyVisual 'K'<CR>

nnoremap KK :execute 'help ' . expand('<cword>')<CR>
nnoremap Km :execute 'Man ' . expand('<cword>')<CR>
nnoremap KR :Dasht<Space>
nnoremap KA :Dasht!<Space>
let g:which_key_map_K = {
  \ 'name': '+docsets',
  \ 'c': [":execute 'Cppman ' . expand('<cword>')", 'cppman']
  \ 'K': 'vim-help',
  \ 'm': 'man-page',
  \ 'R': 'search-related-docsets',
  \ 'a': [":call Dasht([expand('<cword>'), expand('<cWORD>')], '!')", 'search-all-docsets-for-cursor-word'],
  \ 'A': 'search-all-docsets',
  \ 'r': [":call Dasht([expand('<cword>'), expand('<cWORD>')])", 'search-related-docsets-for-cursor-word'],
  \ 's': ["y:<C-U>call Dasht(getreg(0))", 'search-related-docsets-for-selection'],
  \ 'd': ["y:<C-U>call Dasht(getreg(0), '!')", 'search-all-docsets-for-selection']
  \ }


" vim: sw=4 sts=4 ts=8 et
