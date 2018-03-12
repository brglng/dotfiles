call rpcnotify(1, 'Gui', 'Font', 'Fira Code:h11')
call rpcnotify(1, 'Gui', 'Linespace', '0')
" call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)

set termguicolors

"let g:solarized_degrade = 1
if exists('g:gui_oni')
  colorscheme solarized8_dark
else
  colorscheme solarized
endif

if exists('g:gui_oni') || exists('g:gui_gonvim')
  set laststatus=0
endif
