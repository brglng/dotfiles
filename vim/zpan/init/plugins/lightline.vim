let g:tagbar_status_func = 'TagbarStatusFunc'
function! TagbarStatusFunc(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

function! LightlineMode()
  return &filetype ==# 'defx' ? 'Defx' :
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
  let filename = &filetype ==# 'defx' ? '' :
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
  if exists('*fugitive#head') && &filetype !~# '\v(defx|denite|help|man|qf|undotree)' && expand('%:t') !~ ('__Tagbar__\|__vista__')
    let branch = fugitive#head()
    return branch !=# '' ? ''. branch : ''
  endif
  return ''
endfunction

function LightlineCocGit() abort
  if exists('g:coc_git_status') && &filetype !~# '\v(defx|denite|help|man|qf|undotree)' && expand('%:t') !~ ('__Tagbar__\|__vista__')
    return g:coc_git_status
  else
    return ''
  endif
endfunction

function LightlineCocStatus() abort
  if exists('coc#status')
    return coc#status()
  else
    return ''
  endif
endfunction

function! LightlineFileFormat()
  return &filetype !=# 'defx' &&
        \ &filetype !=# 'denite' &&
        \ &filetype !=# 'gitv' &&
        \ &filetype !=# 'help' &&
        \ &filetype !=# 'man' &&
        \ &filetype !=# 'qf' &&
        \ &filetype !=# 'startify' &&
        \ &filetype != 'undotree' &&
        \ expand('%:t') !~ '__Tagbar__\|__vista__' &&
        \ winwidth(0) > 70
        \ ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return &filetype !=# 'defx' &&
        \ &filetype !=# 'denite' &&
        \ &filetype !=# 'gitv' &&
        \ &filetype !=# 'help' &&
        \ &filetype !=# 'man' &&
        \ &filetype !=# 'qf' &&
        \ &filetype !=# 'startify' &&
        \ &filetype !=# 'undotree' &&
        \ expand('%:t') !~ '__Tagbar__\|__vista__' &&
        \ winwidth(0) > 70
        \ ? &filetype !=# '' ? &filetype : 'no ft' : ''
endfunction

function! LightlineFileEncoding()
  return &filetype !=# 'defx' &&
        \ &filetype !=# 'denite' &&
        \ &filetype !=# 'gitv' &&
        \ &filetype !=# 'help' &&
        \ &filetype !=# 'man' &&
        \ &filetype !=# 'qf' &&
        \ &filetype !=# 'startify' &&
        \ &filetype !=# 'undotree' &&
        \ expand('%:t') !~ '__Tagbar__\|__vista__' &&
        \ winwidth(0) > 70
        \ ? &fileencoding : ''
endfunction

function! LightlineReadonly()
  return &readonly && &filetype !~# '\v(defx|denite|help|man|qf|startify)' && expand('%:t') !~ ('__Tagbar__\|__vista__') ? '' : ''
endfunction

function! LightlineTag()
  " return &filetype ==# 'tagbar' ? '' : tagbar#currenttag('%s', '')
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

augroup LightlineColorscheme
  autocmd!
  autocmd ColorScheme * silent! call s:lightline_update()
augroup END
function! s:lightline_update()
  if !exists('g:loaded_lightline')
    return
  endif
  try
    if g:colors_name =~# 'solarized'
      let g:lightline.colorscheme = 'solarized'
    elseif g:colors_name =~# 'soft-era'
      let g:lightline.colorscheme = 'softera_alter'
    else
      let g:lightline.colorscheme =
	    \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
    endif

    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
  catch
  endtry
endfunction

let g:lightline = {
      \ 'colorscheme': 'nord',
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
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
\ }

let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}

let g:lightline#bufferline#show_number  = 3
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#number_map = {
      \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
      \ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'
      \ }
let g:lightline#bufferline#unnamed = '[No Name]'
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#unicode_symbols = 1

let g:lightline_foobar_bold = 1
