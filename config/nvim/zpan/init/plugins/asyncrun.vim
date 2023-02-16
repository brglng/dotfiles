let g:asyncrun_open = 15
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
