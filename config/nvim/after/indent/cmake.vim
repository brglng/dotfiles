" Custom CMake indent rules layered on top of Vim's stock cmake indent
" (runtime/indent/cmake.vim).  This file lives in after/indent/, so it runs
" right after the stock one and simply overrides 'indentexpr'.
"
" Vim-only fallback. Neovim installs the treesitter/Lua indentexpr from the
" treesitter plugin configuration instead of calling this Vimscript engine.
if has('nvim')
  finish
endif

" Extra rules handled here:
"
" * Open paren of a command/function/macro call with visible text right after
"   it and not closed on the same line -> following lines hang-align to the
"   column just right of the '('.
"
"       foo(bar
"           baz)
"
" * Open paren with nothing (but whitespace) after it -> next line uses the
"   stock/buffer default indent (indent + 'shiftwidth').
"
"       foo(
"         bar
"
" * A standalone ')' line:
"     - previous line ends with '('      -> same indent as previous line
"     - previous line hangs at an open-paren column
"                                        -> same position as previous line
"     - otherwise (previous line indented from the line start and does not end
"       with '(')                        -> one 'shiftwidth' less
"
" * After a multiline call/block closes, the next line resumes at the base
"   indent of the statement that opened it (blocks add one 'shiftwidth' for
"   their bodies; END/ELSE keywords sit at the block opener's own indent).
"
" Everything else falls back to the stock CMakeGetIndent() expression.

setlocal indentexpr=BrglngCMakeIndent(v:lnum)
let b:undo_indent = get(b:, 'undo_indent', '')
      \ . '| setlocal indentexpr=CMakeGetIndent(v:lnum)'

if exists('*BrglngCMakeIndent')
  finish
endif

let s:keepcpo = &cpo
set cpo&vim

" Guard against pathological walks.
let s:max_walk = 500

" Words that open/close/if-else a block (stock cmake indent treats these via
" regexes too; we need them for pairing while scanning upward).
let s:block_begin_kw = '\v^(block|if|foreach|macro|while|function)$'
" END/ELSE style words sit at their block opener's indent.
let s:block_close_kw = '\v^(endblock|endif|endforeach|endmacro|endwhile|endfunction|else|elseif)$'
" Only real terminators participate in begin/end pairing; ELSE/ELSEIF share
" the same opener as the IF() they extend and must not consume it.
let s:block_end_only_kw = '\v^(endblock|endif|endforeach|endmacro|endwhile|endfunction)$'
let s:block_middle_kw = '\v^(else|elseif)$'

function! s:StripComment(line) abort
  let l:i = 0
  let l:n = strlen(a:line)
  let l:in_string = 0
  while l:i < l:n
    let l:c = a:line[l:i]
    if l:in_string
      if l:c ==# '\'
        let l:i += 1
      elseif l:c ==# '"'
        let l:in_string = 0
      endif
    elseif l:c ==# '"'
      let l:in_string = 1
    elseif l:c ==# '#'
      return strpart(a:line, 0, l:i)
    endif
    let l:i += 1
  endwhile
  return a:line
endfunction

" Count parens in comment-stripped text, ignoring parens inside strings.
" Returns [opens, closes].
function! s:ParenDelta(clean) abort
  let l:opens = 0
  let l:closes = 0
  let l:i = 0
  let l:n = strlen(a:clean)
  let l:in_string = 0
  while l:i < l:n
    let l:c = a:clean[l:i]
    if l:in_string
      if l:c ==# '\'
        let l:i += 1
      elseif l:c ==# '"'
        let l:in_string = 0
      endif
    elseif l:c ==# '"'
      let l:in_string = 1
    elseif l:c ==# '\'
      let l:i += 1
    elseif l:c ==# '('
      let l:opens += 1
    elseif l:c ==# ')'
      let l:closes += 1
    endif
    let l:i += 1
  endwhile
  return [l:opens, l:closes]
endfunction

" Command word at line start followed by '(', '' when none.
function! s:CmdWord(clean) abort
  if a:clean =~# '^\s*[A-Za-z_][A-Za-z0-9_]*\s*('
    return matchstr(a:clean, '^\s*\zs[A-Za-z_][A-Za-z0-9_]*\ze\s*(')
  endif
  return ''
endfunction

" Walk upward from a:pnum (inclusive) and describe the enclosing statement.
"
" Returns a dict:
"   found      - 1 when an enclosing statement opener was identified
"   lnum       - line number of that opener
"   pcol       - byte index of its '(' (in the comment-stripped line)
"   rest       - text of the opener line right after '('
"   open       - 1 when the call paren is still unclosed through a:pnum
"   base       - indent of the opener line
"   is_block   - 1 when the opener is a block keyword (if/foreach/...)
"   last_begin - nearest block-begin seen while pairing block-end keywords,
"                used when nothing else decides the baseline indent
function! s:StatementContext(pnum) abort
  let l:res = {
        \ 'found': 0, 'lnum': 0, 'pcol': 0, 'rest': '', 'open': 0,
        \ 'base': 0, 'is_block': 0, 'last_begin': 0}
  let l:tail = 0
  let l:l = a:pnum
  let l:need_begin = 0
  while l:l > 0 && (a:pnum - l:l) < s:max_walk
    let l:clean = s:StripComment(getline(l:l))
    if l:clean =~# '^\s*$'
      let l:l -= 1
      continue
    endif
    let l:word = s:CmdWord(l:clean)
    if l:word !=# ''
      let l:popen = match(l:clean, '(')
      let l:rest = strpart(l:clean, l:popen + 1)
      let [l:o, l:c] = s:ParenDelta(l:rest)
      let l:full_delta = s:ParenDelta(l:clean)[0] - s:ParenDelta(l:clean)[1]
      if l:word =~? s:block_end_only_kw
        " Block end keywords pair with a begin further up; they never anchor.
        let l:need_begin += 1
      elseif l:word =~? s:block_middle_kw
        " ELSE/ELSEIF belong to the same block as the opener above them;
        " never an anchor, never a pairing consumer.
      elseif l:word =~? s:block_begin_kw && l:need_begin > 0
        " Paired begin of a block we are leaving; keep searching above.
        let l:need_begin -= 1
        let l:res.last_begin = l:l
        let l:tail += l:full_delta
        let l:l -= 1
        continue
      elseif l:need_begin > 0
        " Inside a finished block being skipped over.
        let l:tail += l:full_delta
        let l:l -= 1
        continue
      else
        " Genuine enclosing-statement candidate (plain command or open block).
        let l:res.found = 1
        let l:res.lnum = l:l
        let l:res.pcol = l:popen
        let l:res.rest = l:rest
        let l:res.base = indent(l:l)
        let l:res.open = (1 + l:o - l:c + l:tail) > 0
        let l:res.is_block = l:word =~? s:block_begin_kw ? 1 : 0
        return l:res
      endif
    endif
    let [l:o2, l:c2] = s:ParenDelta(l:clean)
    let l:tail += l:o2 - l:c2
    let l:l -= 1
  endwhile
  return l:res
endfunction

" Nearest block opener above, pairing block-end keywords (for ELSE/ENDIF
" style lines that follow plain multiline calls).
function! s:BlockBaseAbove(pnum) abort
  let l:l = a:pnum
  let l:need_begin = 0
  while l:l > 0 && (a:pnum - l:l) < s:max_walk
    let l:clean = s:StripComment(getline(l:l))
    if l:clean =~# '^\s*$'
      let l:l -= 1
      continue
    endif
    let l:word = s:CmdWord(l:clean)
    if l:word =~? s:block_end_only_kw
      let l:need_begin += 1
    elseif l:word =~? s:block_begin_kw
      if l:need_begin > 0
        let l:need_begin -= 1
      else
        return l:l
      endif
    endif
    let l:l -= 1
  endwhile
  return 0
endfunction

" Hanging column: virtual column (as indent value, 0-based) of the char
" right after the '(' of the statement opening at a:alnum.
function! s:HangCol(alnum, pcol) abort
  return virtcol([a:alnum, a:pcol + 2]) - 1
endfunction

function! BrglngCMakeIndent(lnum) abort
  if !exists('*CMakeGetIndent')
    return -1
  endif
  if a:lnum <= 0
    return 0
  endif

  " Bracket-driven spans (incl. multi-layer nesting): new engine first.
  if !get(g:, 'brglng_disable_custom_indent', 0)
    try
      let l:claimed = brglng#indent_brackets#GetCmakeClaim(a:lnum)
      if l:claimed >= 0
        return l:claimed
      endif
    catch
      " autoload unavailable; fall through to the legacy pipeline below.
    endtry
  endif

  let l:pnum = prevnonblank(a:lnum - 1)
  if l:pnum == 0
    return 0
  endif

  let l:cur_clean = s:StripComment(getline(a:lnum))
  let l:p_clean = s:StripComment(getline(l:pnum))

  " ---- standalone closing paren(s) ----
  if l:cur_clean =~# '^\s*)\+\s*\(#.*\)\?$'
    " Previous line ends with an open paren: stay at its indent.
    if l:p_clean =~# '(\s*$'
      return indent(l:pnum)
    endif
    let l:ctx = s:StatementContext(l:pnum)
    " Previous line hangs inside an alive call: align at the hanging column.
    if l:ctx.found && l:ctx.open && l:ctx.rest =~# '\S'
      return s:HangCol(l:ctx.lnum, l:ctx.pcol)
    endif
    return indent(l:pnum) - shiftwidth()
  endif

  " ---- ordinary lines ----
  " Previous line opens a fresh call whose paren stays open.
  if l:p_clean =~# '^\s*[A-Za-z_][A-Za-z0-9_]*\s*('
    let l:popen = match(l:p_clean, '(')
    let l:rest = strpart(l:p_clean, l:popen + 1)
    let [l:o, l:c] = s:ParenDelta(l:rest)
    if l:o >= l:c
      if l:rest =~# '\S'
        return s:HangCol(l:pnum, l:popen)
      endif
      " Nothing visible after '(': stock default indent.
      return CMakeGetIndent(a:lnum)
    endif
  endif

  let l:ctx = s:StatementContext(l:pnum)

  " Still inside a hanging call started further above.
  if l:ctx.found && l:ctx.open && l:ctx.rest =~# '\S'
    return s:HangCol(l:ctx.lnum, l:ctx.pcol)
  endif
  " Inside an empty-paren default-indent chain: stock behaviour.
  if l:ctx.found && l:ctx.open
    return CMakeGetIndent(a:lnum)
  endif

  let l:cur_word = s:CmdWord(l:cur_clean)
  if l:ctx.found
    if l:ctx.is_block
      let l:end_word = (l:cur_word !=# '' && l:cur_word =~? s:block_close_kw)
      return l:end_word ? l:ctx.base : l:ctx.base + shiftwidth()
    endif
    " Closed plain multiline call: resume at its own indent.  END/ELSE style
    " lines need the enclosing block instead.
    if l:cur_word !=# '' && l:cur_word =~? s:block_close_kw
      let l:bnum = s:BlockBaseAbove(l:pnum)
      if l:bnum > 0
        return indent(l:bnum)
      endif
      return CMakeGetIndent(a:lnum)
    endif
    return l:ctx.base
  endif

  if l:ctx.last_begin > 0
    " Walked past a closed block; statements after it resume its indent.
    return indent(l:ctx.last_begin)
  endif

  return CMakeGetIndent(a:lnum)
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
