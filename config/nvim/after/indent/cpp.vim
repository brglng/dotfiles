" Bracket-driven C++ indentation (shared engine in autoload/brglng/indent_brackets.vim).
setlocal indentexpr=brglng#indent_brackets#GetCpp(v:lnum)
let b:undo_indent = get(b:, 'undo_indent', '')
      \ . '| setlocal indentexpr=cindent(v:lnum)'
