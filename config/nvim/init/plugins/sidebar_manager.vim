function! s:setup_coc_explorer()
    wincmd H
endfunction
autocmd FileType,BufWinEnter * if &filetype ==# 'coc-explorer' | call s:setup_coc_explorer() | endif

" \   'coc-explorer': {
" \       'position': 'left',
" \       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'coc-explorer'},
" \       'open': 'CocCommand explorer --no-toggle',
" \       'close': 'CocCommand explorer --toggle'
" \   },

function s:open_help()
    let bufnr = 0
    let lastused = 0
    for nr in range(1, bufnr('$'))
        if getbufvar(nr, '&buftype') ==# 'help'
            if nr > bufnr || getbufinfo(nr)[0].lastused > lastused
                let bufnr = nr
                let lastused = getbufinfo(nr)[0].lastused
            endif
        endif
    endfor
    if bufnr > 0
        botright vsplit
        execute 'buffer ' . bufnr
        return
    else
        help
    endif
endfunction

function! s:setup_help_window()
    wincmd L
    execute string(float2nr(&columns * 0.4)) . 'wincmd |'
    setlocal foldcolumn=0 signcolumn=no colorcolumn= wrap
    nnoremap <silent> <buffer> q <C-w>q
    execute "nnoremap <buffer> <silent> gO :call sidebar#close_side_except('bottom', 'loclist')<CR>" . maparg('gO', 'n') |
endfunction

autocmd FileType,BufWinEnter * if &l:buftype ==# 'help' | call s:setup_help_window() | endif

function! s:setup_man_window()
    wincmd L
    execute string(float2nr(&columns * 0.4)) . 'wincmd |'
    setlocal foldcolumn=0 signcolumn=no colorcolumn= wrap bufhidden nobuflisted noswapfile
    nnoremap <silent> <buffer> q <C-w>q
endfunction

autocmd FileType,BufWinEnter * if &filetype ==# 'man' | call s:setup_man_window() | endif

autocmd FileType toggleterm normal i

function! s:setup_quickfix_window()
    wincmd J
    execute string(float2nr(&lines * 0.4)) . 'wincmd _'
    setlocal wrap foldcolumn=0 colorcolumn= signcolumn=no cursorline nobuflisted
    nnoremap <silent> <buffer> q <C-w>q
endfunction

autocmd FileType,BufWinEnter * if &filetype ==# 'qf' | call s:setup_quickfix_window() | endif

autocmd QuickFixCmdPost [^l]* call sidebar#open('quickfix')
autocmd QuickFixCmdPost l*    call sidebar#open('loclist')

let g:sidebars = {
\   'neo-tree-filesystem': {
\       'position': 'left',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'filesystem'},
\       'open': 'Neotree filesystem reveal',
\       'close': 'Neotree close',
\       'dont_close': 'neo-tree-.*'
\ },
\   'neo-tree-buffers': {
\       'position': 'left',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'buffers'},
\       'open': 'Neotree buffers reveal',
\       'close': 'Neotree close',
\       'dont_close': 'neo-tree-.*'
\   },
\   'neo-tree-git-status': {
\       'position': 'left',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'git_status'},
\       'open': 'Neotree git_status reveal',
\       'close': 'Neotree close',
\       'dont_close': 'neo-tree-.*'
\   },
\   'neo-tree-document-symbols': {
\       'position': 'left',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'document_symbols'},
\       'open': 'Neotree document_symbols reveal',
\       'close': 'Neotree close',
\       'dont_close': 'neo-tree-.*'
\   },
\   'trouble-quickfix': {
\       'position': 'bottom',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'quickfix'},
\       'open': 'Trouble quickfix',
\       'close': 'TroubleClose'
\   },
\   'trouble-loclist': {
\       'position': 'bottom',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'loclist'},
\       'open': 'Trouble loclist',
\       'close': 'TroubleClose'
\   },
\   'trouble-document-diagnostics': {
\       'position': 'bottom',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'diagnostics'},
\       'open': 'Trouble diagnostics',
\       'close': 'TroubleClose'
\   },
\   'trouble-lsp-references': {
\       'position': 'bottom',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'lsp_references'},
\       'open': 'Trouble lsp_references',
\       'close': 'TroubleClose'
\   },
\   'trouble-lsp-definitions': {
\       'position': 'bottom',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'lsp_definitions'},
\       'open': 'Trouble lsp_definitions',
\       'close': 'TroubleClose'
\   },
\   'trouble-lsp-type-definitions': {
\       'position': 'bottom',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'lsp_type_definitions'},
\       'open': 'Trouble lsp_type_definitions',
\       'close': 'TroubleClose'
\   },
\   'vista': {
\       'position': 'left',
\       'check_win': {nr -> bufname(winbufnr(nr)) =~ '__vista__'},
\       'open': 'Vista',
\       'close': 'Vista!'
\   },
\   'undotree': {
\       'position': 'left',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'undotree'},
\       'open': 'UndotreeShow',
\       'close': 'UndotreeHide'
\   },
\   'quickfix': {
\       'position': 'bottom',
\       'check_win': {nr -> (getwinvar(nr, '&buftype') ==# 'quickfix') && !getwininfo(win_getid(nr))[0]['loclist']},
\       'open': 'copen',
\       'close': 'cclose'
\   },
\   'loclist': {
\       'position': 'bottom',
\       'check_win': {nr -> getwinvar(nr, '&buftype') ==# 'quickfix' && getwininfo(win_getid(nr))[0]['loclist']},
\       'open': 'silent! lopen',
\       'close': 'silent! lclose'
\   },
\   'terminal': {
\       'position': 'bottom',
\       'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'toggleterm'},
\       'open': 'ToggleTerm',
\       'close': 'ToggleTerm'
\   },
\   'help': {
\       'position': 'right',
\       'check_win': {nr -> getwinvar(nr, '&buftype') ==# 'help'},
\       'open': function("<SID>open_help", []),
\       'close': 'helpclose'
\   }
\ }

" let g:sidebar_close_tab_on_closing_last_buffer = 1

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
noremap <silent> <M-=> :call sidebar#toggle('terminal')<CR>
noremap <silent> <M-]> :call sidebar#toggle('help')<CR>
if has('nvim')
    tnoremap <silent> <M-1> <C-\><C-n>:call sidebar#toggle('neo-tree-filesystem')<CR>
    tnoremap <silent> <M-2> <C-\><C-n>:call sidebar#toggle('neo-tree-document-symbols')<CR>
    tnoremap <silent> <M-3> <C-\><C-n>:call sidebar#toggle('neo-tree-buffers')<CR>
    tnoremap <silent> <M-4> <C-\><C-n>:call sidebar#toggle('neo-tree-git-status')<CR>
    tnoremap <silent> <M-5> <C-\><C-n>:call sidebar#toggle('undotree')<CR>
    tnoremap <silent> <M-6> <C-\><C-n>:call sidebar#toggle('quickfix')<CR>
    tnoremap <silent> <M-7> <C-\><C-n>:call sidebar#toggle('loclist')<CR>
    tnoremap <silent> <M-8> <C-\><C-n>:call sidebar#toggle('trouble-document-diagnostics')<CR>
    tnoremap <silent> <M-9> <C-\><C-n>:call sidebar#toggle('trouble-lsp-references')<CR>
    tnoremap <silent> <M-0> <C-\><C-n>:call sidebar#toggle('trouble-lsp-definitions')<CR>
    tnoremap <silent> <M--> <C-\><C-n>:call sidebar#toggle('trouble-lsp-type-definitions')<CR>
    tnoremap <silent> <M-=> <C-\><C-n>:call sidebar#toggle('terminal')<CR>
    tnoremap <silent> <M-]> <C-\><C-n>:call sidebar#toggle('help')<CR>
else
    tnoremap <silent> <M-2> <C-_>:call sidebar#toggle('vista')<CR>
    tnoremap <silent> <M-5> <C-_>:call sidebar#toggle('undotree')<CR>
    tnoremap <silent> <M-6> <C-_>:call sidebar#toggle('quickfix')<CR>
    tnoremap <silent> <M-7> <C-_>:call sidebar#toggle('loclist')<CR>
    tnoremap <silent> <M-=> <C-_>:call sidebar#toggle('terminal')<CR>
    tnoremap <silent> <M-]> <C-_>:call sidebar#toggle('help')<CR>
endif

Plug 'brglng/vim-sidebar-manager'

" vim: ts=8 sts=4 sw=4 et
