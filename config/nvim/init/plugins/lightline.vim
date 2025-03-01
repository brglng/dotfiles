if !has('nvim')

    let g:tagbar_status_func = 'TagbarStatusFunc'
    function! TagbarStatusFunc(current, sort, fname, ...) abort
        let g:lightline.fname = a:fname
        return lightline#statusline(0)
    endfunction

    function! LightlineMode()
        return &filetype ==# 'coc-explorer' ? 'CocExplorer' :
        \ &filetype ==# 'neo-tree' ? 'Neotree' :
        \ &filetype ==# 'defx' ? 'Defx' :
        \ &filetype ==# 'denite' ? 'Denite' :
        \ &filetype ==# 'gitv' ? 'GitV' :
        \ &filetype ==# 'help' ? 'Help' :
        \ &filetype ==# 'man' ? 'Man' :
        \ &filetype ==# 'qf' && !getwininfo(win_getid(winnr()))[0]['loclist'] ? 'QuickFix' :
        \ &filetype ==# 'qf' && getwininfo(win_getid(winnr()))[0]['loclist'] ? 'Location List' :
        \ &filetype ==# 'startify' ? 'Startify' :
        \ &filetype ==# 'undotree' ? 'Undo Tree' :
        \ expand('%:t') =~ '__Tagbar__' ? 'Tagbar' :
        \ expand('%:t') =~ '__vista__' ? 'Vista' :
        \ lightline#mode()
    endfunction

    function! LightlineFilename()
        let filename = &filetype ==# 'coc-explorer' ? '' :
        \ &filetype ==# 'neo-tree' ? '' :
        \ &filetype ==# 'defx' ? '' :
        \ &filetype ==# 'denite' ? '' :
        \ &filetype ==# 'gitv' ? '' :
        \ &filetype ==# 'help' ? '' :
        \ &filetype ==# 'man' ? '' :
        \ &filetype ==# 'startify' ? '' :
        \ &filetype ==# 'undotree' ? '' :
        \ expand('%:t') =~ '__Tagbar__\|__vista__' ? '' :
        \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
        let gitstatus = exists('b:coc_git_status') ? b:coc_git_status : ''
        let modified = &modified ? ' ✎' : ''
        return filename . gitstatus . modified
    endfunction

    function! LightlineFugitive() abort
        if exists('*fugitive#head') && !brglng#is_tool_window()
            let branch = fugitive#head()
            return branch !=# '' ? ''. branch : ''
        endif
        return ''
    endfunction

    function! LightlineCocGit() abort
        if exists('g:coc_git_status') && !brglng#is_tool_window()
            return g:coc_git_status
        else
            return ''
        endif
    endfunction

    function! LightlineCocStatus() abort
        let info = get(b:, 'coc_diagnostic_info', {})
        if empty(info) | return '' | endif
        let msgs = []
        if get(info, 'error', 0)
	    call add(msgs, ' ' . info['error'])
        endif
        if get(info, 'warning', 0)
	    call add(msgs, ' ' . info['warning'])
        endif
        return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
    endfunction

    function! LightlineFileFormat()
        return !brglng#is_tool_window() && &filetype !=# 'startify' && winwidth(0) > 70 ? &fileformat : ''
    endfunction

    function! LightlineFiletype()
        return !brglng#is_tool_window() && &filetype !=# 'startify' && winwidth(0) > 70 ? &filetype !=# '' ? &filetype : 'no ft' : ''
    endfunction

    function! LightlineFileEncoding()
        return !brglng#is_tool_window() && &filetype !=# 'startify' && winwidth(0) > 70 ? &fileencoding : ''
    endfunction

    function! LightlineReadonly()
        return &readonly && !brglng#is_tool_window() ? '' : ''
    endfunction

    function! LightlineTag()
        " return &filetype ==# 'tagbar' ? '' : tagbar#currenttag('%s', '')
        return get(b:, 'vista_nearest_method_or_function', '')
    endfunction

    let g:lightline = {
    \ 'colorscheme': 'default',
    \ 'active': {
    \     'left': [
    \         ['mode', 'paste'],
    \         ['cocgit', 'readonly', 'filename', 'tag'] 
    \     ],
    \     'right': [
    \         ['lineinfo'],
    \         ['percent'],
    \         ['cocstatus', 'fileformat', 'fileencoding', 'filetype' ],
    \     ]
    \ },
    \ 'component': {
    \     'lineinfo': ' %4l,%-3v',
    \ },
    \ 'component_function': {
    \     'mode': 'LightlineMode',
    \     'fugitive': 'LightlineFugitive',
    \     'cocgit': 'LightlineCocGit',
    \     'cocstatus': 'LightlineCocStatus',
    \     'readonly': 'LightlineReadonly',
    \     'filename': 'LightlineFilename',
    \     'tag': 'LightlineTag',
    \     'fileformat': 'LightlineFileFormat',
    \     'fileencoding': 'LightlineFileEncoding',
    \     'filetype': 'LightlineFiletype'
    \ },
    \ 'enable': {
    \     'tabline': 0
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

    if !has('nvim')
        let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
        let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
        let g:lightline.component_type   = {'buffers': 'tabsel'}
        let g:lightline.component_raw    = {'buffers': 1}
        let g:lightline.enable.tabline = 1
    endif

    let g:lightline#bufferline#show_number = 4
    " let g:lightline#bufferline#shorten_path = 0
    let g:lightline#bufferline#number_separator = ') '
    let g:lightline#bufferline#ordinal_separator = '('
    let g:lightline#bufferline#unnamed = '[No Name]'
    let g:lightline#bufferline#enable_devicons = 1
    let g:lightline#bufferline#unicode_symbols = 1
    let g:lightline#bufferline#clickable = 1

    let g:lightline_foobar_bold = 1
endif

Plug 'itchyny/lightline.vim', VimOnly()
Plug 'mengelbrecht/lightline-bufferline', VimOnly()
Plug 'sainnhe/lightline_foobar.vim', VimOnly()
