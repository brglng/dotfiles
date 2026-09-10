" Shared bracket-indent engine for Brglng dotfiles.
"
" Implements the same rules as the cmake indent file, generalized over
" bracket kinds and nesting depth ("multi-layer"):
"
" * A line whose deepest/latest still-unclosed bracket is followed by visible
"   text, and never closed on that line -> following lines hang-align at the
"   column right after that bracket.
" * The deepest unclosed bracket ending its line (nothing but whitespace
"   after) -> next lines use the default indent chain (+ 'shiftwidth').
"   Multi-layer rule: the DEEPEST/LATEST surviving bracket governs the mode.
" * Standalone closing-bracket line(s):
"     - previous line ends with an opener      -> same indent as previous line
"     - previous line hangs at a bracket column
"                                                -> aligned to that position
"     - otherwise                              -> one shiftwidth less
" * Everything else falls back to the language default expression (or -1 in
"   claim mode, letting the legacy cmake pipeline take over).
"
" Angle brackets are intentionally NOT scanned here (ambiguity of '<' '>').
" They are handled by the treesitter indent queries instead.

let s:max_walk = 500

let s:open_order = ['(', '[', '{']

let s:close_of = {
      \ '(': ')',
      \ '[': ']',
      \ '{': '}',
      \}

let s:open_of = {
      \ ')': '(',
      \ ']': '[',
      \ '}': '{',
      \}

function! s:NewState() abort
  return {'cm': 0, 'dq': 0, 'sq': 0}
endfunction

" Scan one physical line.  a:st is mutated; a:kinds e.g. ['(', '[', '{'].
" Returns {'events': [['o'|'c', col, char] ...], 'has_code': 0|1,
"          'last_code_col': col} -- both ignoring whitespace and content
" inside strings, character literals and block comments.
function! s:Scan(text, st, kinds) abort
  let l:events = []
  let l:n = strlen(a:text)
  let l:i = 0
  let l:has_code = 0
  let l:last = -1
  while l:i < l:n
    let l:ch = a:text[l:i]

    if a:st.cm
      if strpart(a:text, l:i, 2) ==# '*/'
        let a:st.cm = 0
        let l:i += 2
      else
        let l:i += 1
      endif
      continue
    elseif a:st.dq
      if l:ch ==# '\'
        let l:i += 2
      else
        if l:ch ==# '"'
          let a:st.dq = 0
        endif
        let l:i += 1
      endif
      continue
    elseif a:st.sq
      if l:ch ==# '\'
        let l:i += 2
      else
        if l:ch ==# "'"
          let a:st.sq = 0
        endif
        let l:i += 1
      endif
      continue
    endif

    if l:ch ==# ' ' || l:ch ==# "\t"
      let l:i += 1
      continue
    endif

    " non-space outside comment/string regions
    let l:has_code = 1
    let l:last = l:i

    if l:ch ==# '"'
      let a:st.dq = 1
      let l:i += 1
      continue
    elseif l:ch ==# "'"
      let a:st.sq = 1
      let l:i += 1
      continue
    elseif l:ch ==# '/' && l:i + 1 < l:n && a:text[l:i + 1] ==# '/'
      break
    elseif l:ch ==# '/' && l:i + 1 < l:n && a:text[l:i + 1] ==# '*'
      let a:st.cm = 1
      let l:i += 2
      continue
    endif

    if index(a:kinds, l:ch) >= 0
      call add(l:events, ['o', l:i, l:ch])
    elseif has_key(s:open_of, l:ch)
      call add(l:events, ['c', l:i, l:ch])
    endif
    let l:i += 1
  endwhile
  return {'events': l:events, 'has_code': l:has_code, 'last_code_col': l:last}
endfunction

" Turn events into per-kind leftover stacks plus unmatched-close counts.
" Returns {'stacks': {openChar: [col,...] ascending},
"          'leftover': [[col,char], ...] ascending by col,
"          'um': {closeChar: count}}.
function! s:Stackify(events) abort
  let l:stacks = {}
  for k in s:open_order
    let l:stacks[k] = []
  endfor
  let l:um = {}
  for e in a:events
    if e[0] ==# 'o'
      call add(l:stacks[e[2]], e[1])
    else
      let ok = s:open_of[e[2]]
      if len(get(l:stacks, ok)) > 0
        call remove(l:stacks[ok], -1)
      else
        let l:um[e[2]] = get(l:um, e[2]) + 1
      endif
    endif
  endfor
  let l:leftover = []
  for k in s:open_order
    for c in l:stacks[k]
      call add(l:leftover, [c, k])
    endfor
  endfor
  call sort(l:leftover, {x, y -> x[0] - y[0]})
  return {'stacks': l:stacks, 'leftover': l:leftover, 'um': l:um}
endfunction

" Walk upward from pnum down to floor, pairing unclosed brackets across rows
" (nearest-match).  Returns {} when no enclosing span survives, else:
"   {'lnum', 'col', 'kind', 'trailing'}
" where col points at the deepest surviving opener on the anchor line.
function! s:FindContext(scans, floor, pnum) abort
  let l:pend = {')': 0, ']': 0, '}': 0}
  let l:l = a:pnum
  while l:l >= a:floor
    if !a:scans[l:l].has_code
      let l:l -= 1
      continue
    endif
    let r = s:Stackify(a:scans[l:l].events)

    " pending closes from below consume this row's leftovers, latest cols first
    for k in keys(r.stacks)
      let pc = get(l:pend, s:close_of[k])
      if pc <= 0 || empty(r.stacks[k])
        continue
      endif
      let pops = min([pc, len(r.stacks[k])])
      for _ in range(pops)
        call remove(r.stacks[k], -1)
      endfor
      let l:pend[s:close_of[k]] -= pops
    endfor

    " recompute merged survivors (ascending col)
    let l:survivors = []
    for k in s:open_order
      for c in r.stacks[k]
        call add(l:survivors, [c, k])
      endfor
    endfor
    call sort(l:survivors, {x, y -> x[0] - y[0]})

    if !empty(l:survivors)
      let chosen = l:survivors[-1]
      return {
            \ 'lnum': l:l,
            \ 'col': chosen[0],
            \ 'kind': chosen[1],
            \ 'trailing': a:scans[l:l].last_code_col > chosen[0],
            \}
    endif

    " everything below closed against rows above; carry unmatched closes up
    for ch in keys(r.um)
      let l:pend[ch] += r.um[ch]
    endfor
    let l:l -= 1
  endwhile
  return {}
endfunction

" Scan rows floor..hi ascending, returning dict lnum->scan result.
" States assume clean start at floor (documented heuristic).
function! s:GatherScans(kinds, floor, hi) abort
  let l:scans = {}
  let st = s:NewState()
  let l = a:floor
  while l <= a:hi
    let l:scans[l] = s:Scan(getline(l), st, a:kinds)
    let l += 1
  endwhile
  return l:scans
endfunction

" Absolute indent value of the char right after the bracket at byte col.
function! s:HangCol(lnum, col) abort
  return virtcol([a:lnum, a:col + 2]) - 1
endfunction

" Core engine.  kinds: list of open chars.  In cmake mode an unclaimed
" situation returns -1 so the legacy statement-tier pipeline takes over;
" otherwise the language fallback expression is used.
function! brglng#indent_brackets#Get(lnum, kinds, lang) abort
  if a:lnum <= 0
    return 0
  endif

  let pnum = prevnonblank(a:lnum - 1)
  if pnum == 0
    return 0
  endif

  " C/C++ line splices disappear before bracket parsing; preserve the
  " physical indentation of the line immediately before the splice.
  if a:lang !=# 'cmake' && getline(pnum) =~# '\\\s*$'
    return indent(pnum)
  endif

  let floor = max([1, pnum - get(g:, 'brglng_indent_brackets_max_walk', s:max_walk)])
  let scans = s:GatherScans(a:kinds, floor, pnum)

  let cur_raw = getline(a:lnum)

  " ---- standalone closing brackets ----
  if cur_raw =~# '^\s*[\)\]}][\)\]},;\s]*\%(//.*\)\?$'
    let pr = s:Stackify(scans[pnum].events).leftover
    if !empty(pr) && scans[pnum].last_code_col == pr[-1][0]
      " previous line ends with an opener
      return indent(pnum)
    endif
    let ctx = s:FindContext(scans, floor, pnum)
    if !empty(ctx) && ctx.trailing
      " previous line hangs at a bracket column
      return s:HangCol(ctx.lnum, ctx.col)
    endif
    " C-family: brace scopes (incl. unbraced statements between) belong to
    " cindent; expression spans keep the simple dedent.
    if a:lang !=# 'cmake' && !empty(ctx) && ctx.kind ==# '{'
      return cindent(a:lnum)
    endif
    return max([indent(pnum) - shiftwidth(), 0])
  endif

  " ---- ordinary lines ----
  let psur = s:Stackify(scans[pnum].events).leftover
  if !empty(psur)
    let chosen = psur[-1]
    if scans[pnum].last_code_col == chosen[0]
      " deepest opener ends the line: default indent chain
      return indent(pnum) + shiftwidth()
    endif
    return s:HangCol(pnum, chosen[0])
  endif

  let ctx = s:FindContext(scans, floor, pnum)
  if !empty(ctx)
    if ctx.trailing
      return s:HangCol(ctx.lnum, ctx.col)
    endif
    " C-family: statements inside a bare brace block progress via cindent
    " (nested scopes, unbraced if bodies, ...). cmake keeps the constant
    " default-indent chain.
    if a:lang !=# 'cmake' && ctx.kind ==# '{'
      return cindent(a:lnum)
    endif
    " mid-chain under an empty-opener span: constant level
    return indent(ctx.lnum) + shiftwidth()
  endif

  " unclaimed
  if a:lang ==# 'cmake'
    return -1
  elseif exists('*cindent')
    return cindent(a:lnum)
  endif
  return -1
endfunction

function! brglng#indent_brackets#GetC(lnum) abort
  return brglng#indent_brackets#Get(a:lnum, ['(', '[', '{'], 'c')
endfunction

function! brglng#indent_brackets#GetCpp(lnum) abort
  return brglng#indent_brackets#Get(a:lnum, ['(', '[', '{'], 'cpp')
endfunction

" Used from the cmake indentexpr: claims bracket-driven spans only; -1 hands
" control back to the legacy statement-tier pipeline.
function! brglng#indent_brackets#GetCmakeClaim(lnum) abort
  return brglng#indent_brackets#Get(a:lnum, ['('], 'cmake')
endfunction
