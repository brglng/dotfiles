function! NoIndentExternC()
  let cline_num = line('.')
  let pline_num = prevnonblank(cline_num - 1)
  let pline = getline(pline_num)
  let retv = cindent('.')
  while pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\|^\s*#\)'
    let pline_num = prevnonblank(pline_num - 1)
    let pline = getline(pline_num)
  endwhile
  if pline =~# '^\s*extern\s*"C".*'
    let retv = 0
  endif
  return retv
endfunction

" setlocal indentexpr=NoIndentExternC()
