let g:Lf_ShortcutF = ''
let g:Lf_ShortcutB = ''
let g:Lf_WindowPosition = 'bottom'
let g:Lf_WindowHeight = 0.3
let g:Lf_CursorBlink = 0
let g:Lf_FollowLinks = 1
let g:Lf_WildIgnore = {
        \ 'dir': ['.svn','.git','.hg'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
        \ }
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2" }
let g:Lf_CtagsFuncOpts = {
        \ 'c': '--c-kinds=fp',
        \ 'rust': '--rust-kinds=f',
        \ }
let g:Lf_PreviewCode = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0}
" let g:Lf_RememberLastSearch = 1
let g:Lf_UseCache = 0
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_CommandMap = {
            \ '<C-K>': ['<Up>', '<C-k>'],
            \ '<C-J>': ['<Down>', '<C-j>'],
            \ '<Up>': ['<C-p>'],
            \ '<Down>': ['<C-n>'],
            \ '<Home>': ['<Home>', '<C-a>'],
            \ '<End>': ['<End>', '<C-e>'],
            \ '<C-Up>': ['<C-Up>', '<PageUp>'],
            \ '<C-Down>': ['<C-Down>', '<PageDown>'],
            \ }
" let g:Lf_HideHelp = 1
let g:Lf_ShowHidden = 1
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_PreviewInPopup = 0
let g:Lf_MruEnableFrecency = 1
let g:Lf_PopupPreviewPosition = 'bottom'
let g:Lf_PopupShowBorder = 1
let g:Lf_PopupPalette = {
  \ 'light': {
  \     'Lf_hl_cursorline': {
  \         'gui': 'NONE',
  \         'font': 'NONE',
  \         'guifg': 'NONE',
  \         'guibg': 'NONE',
  \         'cterm': 'NONE',
  \         'ctermfg': 'NONE',
  \         'ctermbg': 'NONE'
  \     }
  \ },
  \ 'dark': {
  \     'Lf_hl_cursorline': {
  \         'gui': 'NONE',
  \         'font': 'NONE',
  \         'guifg': 'NONE',
  \         'guibg': 'NONE',
  \         'cterm': 'NONE',
  \         'ctermfg': 'NONE',
  \         'ctermbg': 'NONE'
  \     }
  \ }
  \ }
let g:Lf_PreviewResult = {
  \ 'File': 0,
  \ 'Buffer': 0,
  \ 'Mru': 0,
  \ 'Tag': 0,
  \ 'BufTag': 0,
  \ 'Function': 0,
  \ 'Line': 0,
  \ 'Colorscheme': 1,
  \ 'Rg': 0,
  \ 'Gtags': 0
  \ }

if executable('fd')
    let g:Lf_ExternalCommand = 'fd -t f "%s"'
elseif executable('find')
    let g:Lf_ExternalCommand = 'find "%s" -type f'
endif

autocmd FileType leaderf set signcolumn=no foldcolumn=0

function! s:lf_task_source(...)
    let rows = asynctasks#source(&columns * 48 / 100)
    let source = []
    for row in rows
	let name = row[0]
	let source += [name . '  ' . row[1] . '  : ' . row[2]]
    endfor
    return source
endfunction

function! s:lf_task_accept(line, arg)
    let pos = stridx(a:line, '<')
    if pos < 0
	return
    endif
    let name = strpart(a:line, 0, pos)
    let name = substitute(name, '^\s*\(.\{-}\)\s*$', '\1', '')
    if name != ''
	exec "AsyncTask " . name
    endif
endfunction

function! s:lf_task_digest(line, mode)
    let pos = stridx(a:line, '<')
    if pos < 0
	return [a:line, 0]
    endif
    let name = strpart(a:line, 0, pos)
    return [name, 0]
endfunction

function! s:lf_win_init(...)
    setlocal nonumber
    setlocal nowrap
endfunction

let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})
let g:Lf_Extensions.task = {
  \ 'source': string(function('s:lf_task_source'))[10:-3],
  \ 'accept': string(function('s:lf_task_accept'))[10:-3],
  \ 'get_digest': string(function('s:lf_task_digest'))[10:-3],
  \ 'highlights_def': {
  \     'Lf_hl_funcScope': '^\S\+',
  \     'Lf_hl_funcDirname': '^\S\+\s*\zs<.*>\ze\s*:',
  \ },
  \ 'help' : 'navigate available tasks from asynctasks.vim',
  \ }

" vim: ts=8 sts=4 sw=4 et
