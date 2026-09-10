" Vim-only fallback. Neovim installs the treesitter/Lua indentexpr from the
" treesitter plugin configuration instead of calling this Vimscript engine.
if has('nvim')
  finish
endif

setlocal indentexpr=brglng#indent_brackets#GetCpp(v:lnum)
let b:undo_indent = get(b:, 'undo_indent', '')
      \ . '| setlocal indentexpr=cindent(v:lnum)'
