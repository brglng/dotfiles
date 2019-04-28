let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1

"let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_key_invoke_completion = '<C-x><C-x>'
let g:ycm_key_detailed_diagnostics = '<Leader>ddd'

let g:ycm_global_ycm_extra_conf = $HOME . '/.vim/ycm_extra_conf_global.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_max_diagnostics_to_display = 10000
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings = 1

let g:ycm_rust_src_path = $HOME . '/.local/src/rust/src'

let g:ycm_error_symbol = '✗'
let g:ycm_warning_symbol = "\uf071"

" function! s:onCompleteDone()
"   if &filetype == 'c' || &filetype == 'cpp'
"     let abbr = v:completed_item.abbr
"   elseif &filetype == 'rust'
"     let abbr = v:completed_item.menu
"   endif
"   let startIdx = stridx(abbr, "(")
"   if startIdx < 0
"     return abbr
"   endif

"   let countParen = 1
"   let argsStr = strpart(abbr, startIdx + 1)
"   let argLen = 0
"   while argLen < strlen(argsStr)
"     if argsStr[argLen] == '('
"       let countParen += 1
"     elseif argsStr[argLen] == ')'
"       let countParen -= 1
"     endif
"     if countParen == 0
"       break
"     endif
"     let argLen += 1
"   endwhile

"   if countParen == 0
"     let argsStr = strpart(abbr, startIdx + 1, argLen)
"     "let argsList = split(argsStr, ",")

"     let argsList = []
"     let arg = ''
"     let countParen = 0
"     for i in range(strlen(argsStr))
"       if argsStr[i] == ',' && countParen == 0
"         call add(argsList, arg)
"         let arg = ''
"       elseif argsStr[i] == '('
"         let countParen += 1
"         let arg = arg . argsStr[i]
"       elseif argsStr[i] == ')'
"         let countParen -= 1
"         let arg = arg . argsStr[i]
"       else
"         let arg = arg . argsStr[i]
"       endif
"     endfor
"     if arg != '' && countParen == 0
"       call add(argsList, arg)
"     endif
"   else
"     let argsList = []
"   endif

"   let snippet = '('
"   let c = 1
"   for i in argsList
"     if c > 1
"       let snippet = snippet . ", "
"     endif
"     " strip space
"     let arg = substitute(i, '^\s*\(.\{-}\)\s*$', '\1', '')
"     let snippet = snippet . '${' . c . ":" . arg . '}'
"     let c += 1
"   endfor
"   let snippet = snippet . ')' . "$0"
"   return UltiSnips#Anon(snippet)
" endfunction
