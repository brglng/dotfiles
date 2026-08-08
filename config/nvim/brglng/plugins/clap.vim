let g:clap_layout = {'relative': 'editor'}
let g:clap_search_box_border_style = 'nil'
let g:clap_enable_icon = 1

autocmd FileType clap_input call s:setup_clap_input_win()
function! s:setup_clap_input_win()
    inoremap <silent> <buffer> <expr> <C-o> pumvisible() ? "\<C-e>\<Esc>" : "\<Esc>"
    inoremap <silent> <buffer> <Esc> <Esc>:call clap#handler#exit()<CR>
    nnoremap <silent> <buffer> q     :<C-u>call clap#handler#exit()<CR>
    nnoremap <silent> <buffer> <Esc> :call clap#handler#exit()<CR>
endfunction
