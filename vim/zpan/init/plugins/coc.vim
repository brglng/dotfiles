" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [q <Plug>(coc-diagnostic-prev)
nmap <silent> ]q <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gk <Plug>(coc-declaration)
nmap <silent> <Leader>gt <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gf <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent if index(['defx', 'denite', 'gitv', 'startify', 'undotree'], &filetype) < 0 && expand('%:t') !~ '__Tagbar\|__vista__' | call CocActionAsync('highlight') | endif

" Remap for rename current word
nmap <Leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <Leader>=  <Plug>(coc-format-selected)
nmap <Leader>=  <Plug>(coc-format-selected)

autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <Leader>a  <Plug>(coc-codeaction-selected)
nmap <Leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <Leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <Leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 CocFormat :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? CocFold :call CocAction('fold', <f-args>)

" Using CocList
" Show all diagnostics
if 0
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
endif
nnoremap <silent> <Leader>fo :<C-u>CocList outline<CR>
nnoremap <silent> <Leader>fq :<C-u>CocList diagnostics<CR>
nnoremap <silent> <Leader>fs :<C-u>CocList -I symbols<CR>

call coc#add_extension(
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-java',
      \ 'coc-rls',
      \ 'coc-yaml',
      \ 'coc-python',
      \ 'coc-highlight',
      \ 'coc-snippets',
      \ 'coc-pairs',
      \ 'coc-vimlsp'
      \ )

let g:coc_snippet_next = '<tab>'
