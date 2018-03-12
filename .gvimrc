set mousehide
set lines=48
set columns=100
" if has('win32')
  " autocmd GUIEnter * simalt ~x
" endif

set guioptions+=aA
set guioptions-=T
" set guioptions-=r
" set guioptions-=L
set guioptions-=l
set guioptions-=b
if has('unix') && !has('mac') && !has('macunix')
  set guioptions-=m
endif

" Alt-Space is System menu
if has("gui_running")
  noremap <M-Space> :simalt ~<CR>
  inoremap <M-Space> <C-O>:simalt ~<CR>
  cnoremap <M-Space> <C-C>:simalt ~<CR>
endif

if has('win32') || has('win64')
  set guifont=Fira_Code:h11,Ubuntu_Mono_for_Powerline:h13,Consolas:h12,Lucida_Console:h12,Courier_New:h12
elseif has('mac') || has('macunix')
  set guifont=Fira_Code:h14,Ubuntu_Mono_for_Powerline:h13,Menlo:h12
elseif has('unix')
  if system('uname -s') == "Linux\n"
    " font height bug of GVim on Ubuntu
    let $LC_ALL='en_US.UTF-8'
  endif
  set guifont=Fira\ Code\ 11,Ubuntu\ Mono\ for\ Powerline\ 13,DejaVu\ Sans\ Mono\ 12
endif
if has('mac') || has('macunix')
  set guifontwide=Noto_Sans_CJK_SC:h12,Noto_Sans_CJK_TC:h12,Noto_Sans_CJK_JP:h12,Noto_Sans_CJK_KR:h12,Hiragino_Sans_GB:h12,STHeiti:h12
elseif has('unix')
  set guifontwide=Noto\ Sans\ CJK\ SC\ 12,Noto\ Sans\ CJK\ TC\ 12,Noto\ Sans\ CJK\ JP\ 12,Noto\ Sans\ CJK\ KR\ 12,WenQuanYi\ Zen\ Hei\ 12,WenQuanYi\ Micro\ Hei\ 12
endif

colorscheme solarized
