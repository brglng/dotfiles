" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [q <Plug>(coc-diagnostic-prev)
nmap <silent> ]q <Plug>(coc-diagnostic-next)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * if !zpan#is_tool_window() | silent! call CocActionAsync('highlight') | endif

augroup zpan_coc
    autocmd!

    " Setup formatexpr specified filetype(s).
    autocmd FileType c,cpp,css,html,javascript,json,python,rust,typescript setl formatexpr=CocAction('formatSelected')

    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')
augroup end

" Add `:Format` command to format current buffer.
command! -nargs=0 CocFormat :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? CocFold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 CocOrgnizeImport   :call     CocAction('runCommand', 'editor.action.organizeImport')

autocmd VimEnter,ColorScheme,Syntax * highlight! link CocInlayHint Comment

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

let s:coc_extensions = [
  \ 'coc-cmake',
  \ 'coc-clangd',
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
  \ 'coc-omni',
  \ 'coc-powershell',
  \ 'coc-prettier',
  \ "coc-pyright",
  \ 'coc-rust-analyzer',
  \ 'coc-smartf',
  \ 'coc-snippets',
  \ 'coc-solargraph',
  \ 'coc-sql',
  \ 'coc-syntax',
  \ 'coc-tabnine',
  \ 'coc-tag',
  \ 'coc-tasks',
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

" silent! call mkdir($HOME . '/.cache/ccls', 'p')
" silent! call coc#config('languageserver.ccls.initializationOptions.cache.directory', expand('~/.cache/ccls'))

if executable('fd')
    call coc#config('list.source.files.command', 'fd')
    call coc#config('list.source.files.args', ['-I'])
elseif executable('bfind')
    call coc#config('list.source.files.command', 'bfind')
    call coc#config('list.source.files.args', [])
endif

if has('mac')
    call coc#config('clangd.path', '/usr/local/opt/llvm/bin/clangd')
endif

if exists('g:python3_host_prog') && g:python3_host_prog != ''
    call coc#config('python.pythonPath', g:python3_host_prog)
endif

" let g:coc_node_args = ['--nolazy', '--inspect-brk=6045']

" autocmd User CocOpenFloat silent! setlocal winblend=15

" vim: ts=8 sts=4 sw=4 et
