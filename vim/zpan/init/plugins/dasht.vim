let g:dasht_filetype_docsets = {}
let g:dasht_filetype_docsets['c'] = ['^c$', 'man.*pages', 'glib', 'cmake', 'sqlite']
let g:dasht_filetype_docsets['cpp'] = ['^c$', 'C\+\+', 'boost', 'man.*pages', 'cmake', 'sqlite']
let g:dasht_filetype_docsets['python'] = ['python', '(num|sci)py', 'matplotlib', 'pandas', 'flask', 'sqlalchemy']
let g:dasht_filetype_docsets['html'] = ['css', 'javascript', 'html']
let g:dasht_filetype_docsets['rust'] = ['rust']

let g:dasht_results_window = 'botright vnew'
