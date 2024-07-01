set timeout
set timeoutlen=300
let g:which_key_use_floating_win = 1
let g:which_key_disable_default_offset = 1
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

silent! call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <Leader> :<C-u>WhichKey '<Space>'<CR>
vnoremap <silent> <Leader> :<C-u>WhichKeyVisual '<Space>'<CR>

" autocmd! FileType which_key
" autocmd  FileType which_key silent! setlocal winblend=15

let g:which_key_map =  {}

let g:which_key_map.a = ['<Plug>(EasyAlign)', 'Easy-Align']

" if has('nvim')
"     let g:which_key_map.b = [':Telescope buffers', 'Buffers']
" else
    let g:which_key_map.b = [':LeaderfBuffer', 'Buffers']
" endif

let g:which_key_map.d = {
  \ 'name': '+Debug',
  \ 'b': [{-> luaeval('require("dap").toggle_breakpoint()')}, 'Toggle Breakpoint'],
  \ 'd': [{-> luaeval('require("dapui").toggle()')}, 'Toggle Debug UI'],
  \ 'h': [{-> luaeval('require("dap.ui.widgets").hover()')}, 'Debug Hover'],
  \ 'p': [{-> luaeval('require("dap.ui.widgets").preview()')}, 'Debug Preview'],
  \ }

if has('nvim')
    let g:which_key_map.e = [{-> luaeval('vim.diagnostic.open_float()')}, 'Show Diagnostics']
endif

" if has('nvim')
"     let g:which_key_map.f = {
"       \ 'name': '+Finder',
"       \ 'b': [':Telescope buffers', 'Buffers'],
"       \ 'c': [':Telescope commands', 'Commands'],
"       \ 'f': [':Telescope find_files', 'Files'],
"       \ 'g': [':Telescope live_grep', 'Grep'],
"       \ 'l': [':Telescope current_buffer_fuzzy_find', 'Lines'],
"       \ 'r': [':Telescope lsp_references', 'LSP References'],
"       \ 'o': [':Telescope lsp_document_symbols', 'LSP Symbols'],
"       \ }
" else
    let g:which_key_map.f = {
      \ 'name': '+Finder',
      \ 'b': [':Leaderf buffer', 'Buffers'],
      \ 'c': [':Leaderf command', 'Commands'],
      \ 'f': [':Leaderf file', 'Files'],
      \ 'g': [':Leaderf rg', 'Grep'],
      \ 'l': [':Leaderf line', 'Lines'],
      \ 'o': [':Leaderf bufTag', 'Tags']
      \ }
" endif

let g:which_key_map.g = {
  \ 'name': '+Git',
  \ 'b': [':Neogit kind=split branch', 'Branch'],
  \ 'c': [':Neogit kind=split commit', 'Commit'],
  \ 'd': [':DiffviewOpen', 'Diff'],
  \ 'g': [':Neogit', 'Neogit'],
  \ 'l': [':Neogit kind=split log', 'Log'],
  \ 'p': [':Neogit kind=split pull', 'Pull'],
  \ 'P': [':Neogit kind=split push', 'Push'],
  \ 's': [':Neogit kind=split', 'Neogit Split'],
  \ 't': [':Neogit kind=split stash', 'Stash'],
  \ }

let g:which_key_map.h = {
  \ 'name': '+Hunk',
  \ 's': [':Gitsigns stage_hunk', 'Stage Hunk'],
  \ 'r': [':Gitsigns reset_hunk', 'Reset Hunk'],
  \ 'u': [':Gitsigns reset_hunk', 'Undo Stage Hunk'],
  \ 'S': [':Gitsigns stage_buffer', 'Stage Buffer'],
  \ 'R': [':Gitsigns reset_buffer', 'Reset Buffer'],
  \ 'p': [':Gitsigns preview_hunk', 'Preview Hunk'],
  \ 'b': [':Gitsigns blame_line', 'Show Blame'],
  \ 'B': [':Gitsigns toggle_current_line_blame', 'Toggle Blames for Cursor Line'],
  \ 'd': [':Gitsigns toggle_deleted', 'Toggle Deleted']
  \ }

if has('nvim')
    let g:which_key_map['i'] = [{-> luaeval('require("ibl").setup_buffer(0, { enabled = not require("ibl.config").get_config(0).enabled })')}, 'Toggle Indent Lines']
else
    let g:which_key_map['i'] = [':IndentLinesToggle', 'Toggle Indent Lines']
endif

let g:which_key_map.n = [':Navbuddy', 'Code Navigate']

let g:which_key_map.p = [{-> luaeval('require("nabla").toggle_virt { autogen = true, silent = true, align_center = true }')}, 'Toggle LaTeX Preview']

let g:which_key_map.q = ['<C-w>q', 'Close Window']

nnoremap <Leader>sr     :.,$s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>sg     :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>sR     :.,$s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>sG     :%s/\<<C-r><C-w>\>//g<Left><Left>
let g:which_key_map.s = {
  \ 'name': '+Search-Replace',
  \ 'r': 'Search & Replace (Current To End)',
  \ 'g': 'Search & Replace (Full)',
  \ 'R': 'Search & Replace (Current To End, No Prompt)',
  \ 'G': 'Search & Replace (Full, No Prompt)'
  \ }

let g:which_key_map.t = [':Leaderf task', 'Tasks']

let g:which_key_map.w = {
  \ 'name': '+Windows',
  \ 'd': [':Trouble lsp_definitions', 'Definitions'],
  \ 'i': [':Trouble lsp_implementations', 'Implementations'],
  \ 'r': [':Trouble lsp_references', 'References'],
  \ 't': [':Trouble lsp_type_definitions', 'Type Definitions'],
  \ 'T': [':TodoTrouble', 'TODOs']
  \ }

let g:which_key_map.x = {
  \ 'name': '+Sementic (LSP & Treesitter)',
  \ 'a': [':Lspsaga code_action', 'Code Actions'],
  \ 'c': [':Lspsaga incoming_calls', 'Callers'],
  \ 'C': [':Lspsaga outgoing_calls', 'Callees'],
  \ 'd': [':Lspsaga peek_definition', 'Peek Definition'],
  \ 'f': [':lua vim.lsp.buf.format { async = true }', 'Format'],
  \ 'h': [':Lspsaga hover_doc', 'Hover Doc'],
  \ 'i': [':Lspsaga finder imp', 'Find Implementations'],
  \ 'n': [':Lspsaga rename', 'Rename'],
  \ 'o': [':Lspsaga outline', 'Outline'],
  \ 'r': [':Lspsaga finder def+ref+imp', 'Find References'],
  \ 't': [':Lspsaga peek_type_definition', 'Peek Type Definition'],
  \ }

let g:which_key_map['='] = [':lua vim.lsp.buf.format { async = true }', 'Format']

" silent! call which_key#register('K', 'g:which_key_map_K')
" nnoremap <silent> K :<C-u>WhichKey 'K'<CR>
" vnoremap <silent> K :<C-u>WhichKeyVisual 'K'<CR>

" nnoremap Kc :execute 'Cppman ' . expand('<cword>')<CR>
" vnoremap Kc y:<C-u>execute 'Cppman ' . getreg(0)<CR>
" nnoremap KC :Cppman<Space>
" nnoremap KK :execute 'help ' . expand('<cword>')<CR>
" vnoremap KK y:<C-u>execute 'help ' . getreg(0)<CR>
" nnoremap Km :execute 'Man ' . expand('<cword>')<CR>
" nnoremap Km y:<C-u>execute 'Man ' . getreg(0)<CR>
" nnoremap KR :Dasht<Space>
" nnoremap KA :Dasht!<Space>
" let g:which_key_map_K = {
"   \ 'name': '+docsets',
"   \ 'c': 'search-cppman-for-cursor-word',
"   \ 'C': 'cppman',
"   \ 'K': 'vim-help',
"   \ 'm': 'man-page',
"   \ 'R': 'search-related-docsets',
"   \ 'a': [":call Dasht([expand('<cword>'), expand('<cWORD>')], '!')", 'search-all-docsets-for-cursor-word'],
"   \ 'A': 'search-all-docsets',
"   \ 'r': [":call Dasht([expand('<cword>'), expand('<cWORD>')])", 'search-related-docsets-for-cursor-word'],
"   \ 's': ["y:<C-U>call Dasht(getreg(0))", 'search-related-docsets-for-selection'],
"   \ 'd': ["y:<C-U>call Dasht(getreg(0), '!')", 'search-all-docsets-for-selection']
"   \ }


" vim: sw=4 sts=4 ts=8 et
