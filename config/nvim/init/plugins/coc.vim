if !has('nvim') && !brglng#is_sudo()
    " Use `[c` and `]c` to navigate diagnostics
    nmap <silent> [q <Plug>(coc-diagnostic-prev)
    nmap <silent> ]q <Plug>(coc-diagnostic-next)

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * if !brglng#is_tool_window() | silent! call CocActionAsync('highlight') | endif

    augroup brglng_coc
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
    \   'coc-cmake',
    \   'coc-clangd',
    \   'coc-dictionary',
    \   'coc-git',
    \   'coc-highlight',
    \   'coc-json',
    \   'coc-lists',
    \   'coc-omni',
    \   'coc-prettier',
    \   "coc-pyright",
    \   'coc-rust-analyzer',
    \   'coc-snippets',
    \   'coc-syntax',
    \   'coc-tag'
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

    " inoremap <silent> <expr> <TAB>
    "   \ brglng#pumselected()
    "   \ ? coc#pum#confirm()
    "   \ : coc#expandableOrJumpable() ?
    "   \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
    "   \ : "\<TAB>"

    " function s:expand_ultimate_autopair_cr()
    "     return luaeval("require('ultimate-autopair.core').run(vim.api.nvim_replace_termcodes('<CR>', true, true, true))")
    " endfunction
    " inoremap <silent> <expr> <CR> brglng#pumselected() ? coc#pum#confirm() : "\<C-g>u" . <SID>expand_ultimate_autopair_cr() . "\<C-r>=coc#on_enter()\<CR>\<C-r>=EndwiseDiscretionary()<CR>"

    " inoremap <silent> <expr> <Esc> coc#pum#visible() ? "\<C-o>:call coc#pum#cancel()\<CR>\<Esc>" : "\<Esc>"

    " inoremap <silent> <expr> <Down> coc#pum#visible() ? coc#pum#next(1) : "\<C-o>gj"
    " inoremap <silent> <expr> <Up> coc#pum#visible() ? coc#pum#prev(1) : "\<C-o>gk"

    " inoremap <silent> <expr>    <C-e>       coc#pum#visible() ? coc#pum#cancel() : col('.') > strlen(getline('.')) ? "\<Lt>C-e>" : "\<Lt>End>"

    " inoremap <silent> <expr>    <C-n>       coc#pum#visible() ? coc#pum#next(1) : "\<Down>"
    " inoremap <silent> <expr>    <C-p>       coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"
endif

Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':silent! UpdateRemotePlugins'}

" vim: ts=8 sts=4 sw=4 et
