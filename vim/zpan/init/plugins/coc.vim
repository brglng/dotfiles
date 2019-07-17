" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [q <Plug>(coc-diagnostic-prev)
nmap <silent> ]q <Plug>(coc-diagnostic-next)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * if !zpan#is_tool_window() | silent! call CocActionAsync('highlight') | endif

autocmd User CocJumpPlaceholder silent! call CocActionAsync('showSignatureHelp')
autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')

" Use `:Fold` to fold current buffer
command! -nargs=? CocFold :call CocAction('fold', <f-args>)

silent! call coc#add_extension(
      \ 'coc-css',
      \ 'coc-dictionary',
      \ 'coc-docker',
      \ 'coc-emoji',
      \ 'coc-git',
      \ 'coc-gocode',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-imselect',
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-lists'
      \ )

silent! call coc#add_extension(
      \ 'coc-omni',
      \ 'coc-pairs',
      \ 'coc-python',
      \ 'coc-rls',
      \ 'coc-snippets',
      \ 'coc-solargraph',
      \ 'coc-syntax',
      \ 'coc-tabnine',
      \ 'coc-tag',
      \ 'coc-translator',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-word',
      \ 'coc-yaml',
      \ )

let g:coc_snippet_next = '<tab>'

call mkdir($HOME . '/.cache/ccls', 'p')
silent! call coc#config('languageserver.ccls.initializationOptions.cache.directory', $HOME . '/.cache/ccls')

if executable('bfind')
  silent! call coc#config('list.source.files.command', 'bfind')
  silent! call coc#config('list.source.files.args', [])
endif

" let g:coc_node_args = ['--nolazy', '--inspect-brk=6045']

autocmd User CocOpenFloat silent! setlocal winblend=15
