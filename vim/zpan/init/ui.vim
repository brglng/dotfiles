set mouse=a

if exists('&termguicolors') && $TERM_PROGRAM != 'Apple_Terminal'
  if !has('nvim')
    " fix bug for vim
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
  endif
  set termguicolors
else
  set t_Co=256
  let g:solarized_use16 = 0
  let g:onedark_termcolors = 256
endif

if exists('g:GuiLoaded') || exists('g:nyaovim_version') || exists('g:gui_oni')
  call rpcnotify(1, 'Gui', 'Font', 'Fura Code Nerd Font:h11')
  call rpcnotify(1, 'Gui', 'Linespace', '0')
  " call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
endif

syntax on
set background=dark
" colorscheme solarized8
colorscheme nord
" colorscheme onedark

if exists('g:gui_oni') || exists('g:gui_gonvim')
  set laststatus=0
endif

if has('gui_running')
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
    set guifont=FuraCodeNerdFontC-Regular:h11,Ubuntu_Mono_for_Powerline:h13,Consolas:h12,Lucida_Console:h12,Courier_New:h12
  elseif has('mac') || has('macunix')
    set guifont=FuraCodeNerdFontC-Regular:h14,Ubuntu_Mono_for_Powerline:h13,Menlo:h12
  elseif has('unix')
    if system('uname -s') == "Linux\n"
      " font height bug of GVim on Ubuntu
      let $LC_ALL='en_US.UTF-8'
    endif
    set guifont=Fura\ Code\ Nerd\ Font\ 11,Ubuntu\ Mono\ for\ Powerline\ 13,DejaVu\ Sans\ Mono\ 12
  endif

  if has('mac') || has('macunix')
    set guifontwide=Noto_Sans_CJK_SC:h12,Noto_Sans_CJK_TC:h12,Noto_Sans_CJK_JP:h12,Noto_Sans_CJK_KR:h12,Hiragino_Sans_GB:h12,STHeiti:h12
  elseif has('unix')
    set guifontwide=Noto\ Sans\ CJK\ SC\ 12,Noto\ Sans\ CJK\ TC\ 12,Noto\ Sans\ CJK\ JP\ 12,Noto\ Sans\ CJK\ KR\ 12,WenQuanYi\ Zen\ Hei\ 12,WenQuanYi\ Micro\ Hei\ 12
  endif
endif

function! s:move_help_window()
  if winwidth('%') >= 160
    wincmd L
    vertical resize 85
  endif
endfunction
autocmd BufEnter * if &filetype == 'help' | call s:move_help_window() | endif

function! s:init_man_buffer()
  setlocal bufhidden
  if winwidth('%') >= 160
    wincmd L
    vertical resize 85
  endif
endfunction
autocmd BufEnter * if &buftype == 'man' | call s:init_man_buffer() | endif
