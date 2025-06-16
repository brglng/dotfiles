autocmd QuickFixCmdPost [^l]* call sidebar#open('quickfix')
autocmd QuickFixCmdPost l*    call sidebar#open('loclist')

" let g:sidebar_close_tab_on_closing_last_buffer = 1

let g:sidebar = {}

let g:sidebar.neo_tree_filesystem = #{
\   position: 'left',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'filesystem'},
\   open: 'Neotree filesystem reveal',
\   close: 'Neotree close',
\   dont_close: 'neo_tree_.*',
\   opts: {
\       'foldenable': 0,
\       'foldcolumn': 0,
\   }
\ }

let g:sidebar.neo_tree_buffers = #{
\   position: 'left',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'buffers'},
\   open: 'Neotree buffers reveal',
\   close: 'Neotree close',
\   dont_close: 'neo_tree_.*',
\   opts: {
\       'foldenable': 0,
\       'foldcolumn': 0,
\   }
\ }

let g:sidebar.neo_tree_git_status = #{
\   position: 'left',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'git_status'},
\   open: 'Neotree git_status reveal',
\   close: 'Neotree close',
\   dont_close: 'neo_tree_.*',
\   opts: {
\       'foldenable': 0,
\       'foldcolumn': 0,
\   }
\ }

let g:sidebar.neo_tree_document_symbols = #{
\   position: 'left',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'neo-tree' && winbufnr(nr)->getbufvar('neo_tree_source') ==# 'document_symbols'},
\   open: 'Neotree document_symbols reveal',
\   close: 'Neotree close',
\   dont_close: 'neo_tree_.*',
\   opts: {
\       'foldenable': 0,
\       'foldcolumn': 0,
\   }
\ }

let g:sidebar.trouble_quickfix = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'quickfix'},
\   open: 'Trouble quickfix',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.trouble_loclist = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'loclist'},
\   open: 'Trouble loclist',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.trouble_diagnostics = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'diagnostics'},
\   open: 'Trouble diagnostics',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.trouble_declarations = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'lsp_declarations'},
\   open: 'Trouble lsp_declarations',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.trouble_lsp_definitions = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'lsp_definitions'},
\   open: 'Trouble lsp_definitions',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.trouble_lsp_implementations = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'lsp_implementations'},
\   open: 'Trouble lsp_implementations',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.trouble_lsp_incoming_calls = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'lsp_incoming_calls'},
\   open: 'Trouble lsp_incoming_calls',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.trouble_lsp_outgoing_calls = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'lsp_outgoing_calls'},
\   open: 'Trouble lsp_outgoing_calls',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.trouble_lsp_references = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'lsp_references'},
\   open: 'Trouble lsp_references',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.trouble_lsp_type_definitions = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'lsp_type_definitions'},
\   open: 'Trouble lsp_type_definitions',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.trouble_todo = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'trouble' && getwinvar(nr, 'trouble')['mode'] ==# 'todo'},
\   open: 'Trouble todo',
\   close: 'lua require("trouble").close()'
\ }

let g:sidebar.undotree = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'undotree'},
\   open: 'UndotreeShow',
\   close: 'UndotreeHide',
\   move: 0
\ }

let g:sidebar.quickfix = #{
\   position: 'bottom',
\   filter: {nr -> (getwinvar(nr, '&buftype') ==# 'quickfix') && !getwininfo(win_getid(nr))[0]['loclist']},
\   open: 'copen',
\   close: 'cclose'
\ }

let g:sidebar.loclist = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&buftype') ==# 'quickfix' && getwininfo(win_getid(nr))[0]['loclist']},
\   open: 'silent! lopen',
\   close: 'silent! lclose'
\ }

let g:sidebar.terminal = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'toggleterm'},
\   open: 'ToggleTerm',
\   close: 'ToggleTerm'
\ }

let g:sidebar.help = #{
\   position: 'right',
\   filter: {nr -> getwinvar(nr, '&buftype') ==# 'help'},
\   open: function("sidebar#open_last_help", ['botright']),
\   close: 'helpclose',
\   width: 0.5,
\ }

let g:sidebar.spectre = #{
\   position: 'bottom',
\   filter: {nr -> getwinvar(nr, '&filetype') ==# 'spectre_panel'},
\   open: 'Spectre'
\ }

" autocmd BufWinEnter * if &l:buftype ==# 'help' |
" \   execute "nnoremap <buffer> <silent> gO :call sidebar#close_side_except('bottom', 'loclist')<CR>" . maparg('gO', 'n') |
" \ endif

noremap <silent> <M-5> :call sidebar#toggle('undotree')<CR>
noremap <silent> <M-6> :call sidebar#toggle('quickfix')<CR>
noremap <silent> <M-7> :call sidebar#toggle('loclist')<CR>
noremap <silent> <M-]> :call sidebar#toggle('help')<CR>
inoremap <silent> <M-5> <C-o>:call sidebar#toggle('undotree')<CR>
inoremap <silent> <M-6> <C-o>:call sidebar#toggle('quickfix')<CR>
inoremap <silent> <M-7> <C-o>:call sidebar#toggle('loclist')<CR>
inoremap <silent> <M-]> <C-o>:call sidebar#toggle('help')<CR>
tnoremap <silent> <M-5> <C-\><C-o>:call sidebar#toggle('undotree')<CR>
tnoremap <silent> <M-6> <C-\><C-o>:call sidebar#toggle('quickfix')<CR>
tnoremap <silent> <M-7> <C-\><C-o>:call sidebar#toggle('loclist')<CR>
tnoremap <silent> <M-]> <C-\><C-o>:call sidebar#toggle('help')<CR>

Plug 'brglng/vim-sidebar-manager'

" vim: ts=8 sts=4 sw=4 et
