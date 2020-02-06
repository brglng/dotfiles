let g:which_key_map.k = {
  \ 'name': 'docsets',
  \ 'r': 'search-related-docsets',
  \ 'k': 'search-all-docsets',
  \ 'w': [":call Dasht([expand('<cword>'), expand('<cWORD>')])", 'search-related-docsets-for-cursor-word'],
  \ 'a': [":call Dasht([expand('<cword>'), expand('<cWORD>')], '!')", 'search-all-docsets-for-cursor-word'],
  \ 's': ["y:<C-U>call Dasht(getreg(0))", 'search-related-docsets-for-selection'],
  \ 'd': ["y:<C-U>call Dasht(getreg(0), '!')", 'search-all-docsets-for-selection']
  \ }

nnoremap <Leader>kr :Dasht<Space>
nnoremap <Leader>kk :Dasht!<Space>

let g:dasht_filetype_docsets = {}
let g:dasht_filetype_docsets['c'] = ['^c$', 'man.*pages', 'glib', 'cmake', 'sqlite']
let g:dasht_filetype_docsets['cpp'] = ['^c$', 'C\+\+', 'boost', 'man.*pages', 'cmake', 'sqlite']
let g:dasht_filetype_docsets['python'] = ['python', '(num|sci)py', 'matplotlib', 'pandas', 'flask', 'sqlalchemy']
let g:dasht_filetype_docsets['html'] = ['css', 'javascript', 'html']
let g:dasht_filetype_docsets['rust'] = ['rust']

let g:dasht_results_window = 'botright vnew'
