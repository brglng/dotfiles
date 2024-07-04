  " \ 'coc-explorer': {
  " \     'position': 'left',
  " \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'coc-explorer'},
  " \     'open': 'CocCommand explorer --no-toggle',
  " \     'close': 'CocCommand explorer --toggle'
  " \ },

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

let g:sidebars = {
  \ 'neo-tree-filesystem': {
  \     'position': 'left',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'filesystem'},
  \     'open': 'Neotree filesystem reveal',
  \     'close': 'Neotree close',
  \     'dont_close': 'neo-tree-.*'
  \ },
  \ 'neo-tree-buffers': {
  \     'position': 'left',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'buffers'},
  \     'open': 'Neotree buffers reveal',
  \     'close': 'Neotree close',
  \     'dont_close': 'neo-tree-.*'
  \ },
  \ 'neo-tree-git-status': {
  \     'position': 'left',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'git_status'},
  \     'open': 'Neotree git_status reveal',
  \     'close': 'Neotree close',
  \     'dont_close': 'neo-tree-.*'
  \ },
  \ 'neo-tree-document-symbols': {
  \     'position': 'left',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'document_symbols'},
  \     'open': 'Neotree document_symbols reveal',
  \     'close': 'Neotree close',
  \     'dont_close': 'neo-tree-.*'
  \ },
  \ 'trouble-quickfix': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'quickfix'},
  \     'open': 'Trouble quickfix',
  \     'close': 'TroubleClose'
  \ },
  \ 'trouble-loclist': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'loclist'},
  \     'open': 'Trouble loclist',
  \     'close': 'TroubleClose'
  \ },
  \ 'trouble-document-diagnostics': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'document_diagnostics'},
  \     'open': 'Trouble document_diagnostics',
  \     'close': 'TroubleClose'
  \ },
  \ 'trouble-workspace-diagnostics': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'workspace_diagnostics'},
  \     'open': 'Trouble workspace_diagnostics',
  \     'close': 'TroubleClose'
  \ },
  \ 'trouble-lsp-references': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'lsp_references'},
  \     'open': 'Trouble lsp_references',
  \     'close': 'TroubleClose'
  \ },
  \ 'trouble-lsp-definitions': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'lsp_definitions'},
  \     'open': 'Trouble lsp_definitions',
  \     'close': 'TroubleClose'
  \ },
  \ 'trouble-lsp-type-definitions': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'Trouble' && luaeval('require("trouble.config").options.mode') ==# 'lsp_type_definitions'},
  \     'open': 'Trouble lsp_type_definitions',
  \     'close': 'TroubleClose'
  \ },
  \ 'vista': {
  \     'position': 'left',
  \     'check_win': {nr -> bufname(winbufnr(nr)) =~ '__vista__'},
  \     'open': 'Vista',
  \     'close': 'Vista!'
  \ },
  \ 'undotree': {
  \     'position': 'left',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'undotree'},
  \     'open': 'UndotreeShow',
  \     'close': 'UndotreeHide'
  \ },
  \ 'quickfix': {
  \     'position': 'bottom',
  \     'check_win': {nr -> (getwinvar(nr, '&buftype') ==# 'quickfix') && !getwininfo(win_getid(nr))[0]['loclist']},
  \     'open': 'copen',
  \     'close': 'cclose'
  \ },
  \ 'loclist': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&buftype') ==# 'quickfix' && getwininfo(win_getid(nr))[0]['loclist']},
  \     'open': 'silent! lopen',
  \     'close': 'silent! lclose'
  \ },
  \ 'terminal': {
  \     'position': 'bottom',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'toggleterm'},
  \     'open': 'ToggleTerm',
  \     'close': 'ToggleTerm'
  \ },
  \ 'help': {
  \     'position': 'right',
  \     'check_win': {nr -> getwinvar(nr, '&buftype') ==# 'help'},
  \     'open': function("<SID>open_help", []),
  \     'close': 'helpclose'
  \ }
  \ }

" let g:sidebar_close_tab_on_closing_last_buffer = 1

autocmd QuickFixCmdPost asyncrun call sidebar#open('quickfix')

autocmd BufWinEnter * if &l:buftype ==# 'help' |
  \ execute "nnoremap <buffer> <silent> gO :call sidebar#close_side_except('bottom', 'loclist')<CR>" . maparg('gO', 'n') |
  \ endif

" vim: ts=8 sts=4 sw=4 et
