" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [q <Plug>(coc-diagnostic-prev)
nmap <silent> ]q <Plug>(coc-diagnostic-next)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * if !zpan#is_tool_window() | silent! call CocActionAsync('highlight') | endif

autocmd User CocJumpPlaceholder silent! call CocActionAsync('showSignatureHelp')
autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')

" Use `:Fold` to fold current buffer
command! -nargs=? CocFold :call CocAction('fold', <f-args>)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

let s:coc_extensions = [
  \ 'coc-bookmark',
  \ 'coc-cmake',
  \ 'coc-css',
  \ 'coc-dictionary',
  \ 'coc-docker',
  \ 'coc-emoji',
  \ 'coc-eslint',
  \ 'coc-explorer',
  \ 'coc-git',
  \ 'coc-github',
  \ 'coc-gitignore',
  \ 'coc-gocode',
  \ 'coc-highlight',
  \ 'coc-html',
  \ 'coc-java',
  \ 'coc-json',
  \ 'coc-lists',
  \ 'coc-lua',
  \ 'coc-marketplace',
  \ 'coc-neosnippet',
  \ 'coc-omni',
  \ 'coc-pairs',
  \ 'coc-powershell',
  \ 'coc-prettier',
  \ 'coc-pyright',
  \ 'coc-rls',
  \ 'coc-smartf',
  \ 'coc-snippets',
  \ 'coc-solargraph',
  \ 'coc-sql',
  \ 'coc-syntax',
  \ 'coc-tabnine',
  \ 'coc-tag',
  \ 'coc-tasks',
  \ 'coc-translator',
  \ 'coc-tsserver',
  \ 'coc-vetur',
  \ 'coc-vimlsp',
  \ 'coc-word',
  \ 'coc-yaml',
  \ 'coc-yank',
  \ ]

function! s:uninstall_unused_coc_extensions() abort
    for e in keys(json_decode(join(readfile(expand('~/.config/coc/extensions/package.json')), "\n"))['dependencies'])
        if index(s:coc_extensions, e) < 0
            execute 'CocUninstall ' . e
        endif
    endfor
endfunction
autocmd User CocNvimInit call s:uninstall_unused_coc_extensions()

for e in s:coc_extensions
    silent! call coc#add_extension(e)
endfor

let g:coc_snippet_next = '<tab>'

silent! call mkdir($HOME . '/.cache/ccls', 'p')
silent! call coc#config('languageserver.ccls.initializationOptions.cache.directory', expand('~/.cache/ccls'))

if executable('fd')
    silent! call coc#config('list.source.files.command', 'fd')
    silent! call coc#config('list.source.files.args', ['-I'])
elseif executable('bfind')
    silent! call coc#config('list.source.files.command', 'bfind')
    silent! call coc#config('list.source.files.args', [])
endif

if exists('g:python3_host_prog') && g:python3_host_prog != ''
    silent! call coc#config('python.pythonPath', g:python3_host_prog)
endif

" let g:coc_node_args = ['--nolazy', '--inspect-brk=6045']

" autocmd User CocOpenFloat silent! setlocal winblend=15
" vim: ts=8 sts=4 sw=4 et
