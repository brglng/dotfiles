let g:asyncrun_open = 0
let g:asyncrun_auto = 'asyncrun'
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg', '.vim']
