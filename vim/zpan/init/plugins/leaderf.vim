let g:Lf_ShortcutF = ''
let g:Lf_ShortcutB = ''
let g:Lf_WindowPosition = 'popup'
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
let g:Lf_PreviewInPopup = 1

" vim: ts=8 sts=4 sw=4 et
