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
" Show commands
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
endif

nnoremap <silent> <Leader>f; :<C-u>CocList      vimcommands<CR>
nnoremap <silent> <Leader>fc :<C-u>CocList      commands<cr>
nnoremap <silent> <Leader>fe :<C-u>CocList      extensions<cr>
nnoremap <silent> <Leader>ff :<C-u>CocList      files<CR>
nnoremap <silent> <Leader>fg :<C-u>CocList      grep<CR>
nnoremap <silent> <Leader>fw :<C-u>CocList      words<CR>
nnoremap <silent> <Leader>fm :<C-u>CocList      marks<CR>
nnoremap <silent> <Leader>fb :<C-u>CocList      buffers<CR>
nnoremap <silent> <Leader>fr :<C-u>CocList      mru<CR>
nnoremap <silent> <Leader>fo :<C-u>CocList      outline<CR>
nnoremap <silent> <Leader>fh :<C-u>CocList      helptags<CR>
nnoremap <silent> <Leader>fq :<C-u>CocList      diagnostics<CR>
nnoremap <silent> <Leader>fC :<C-u>CocList      colors<CR>
nnoremap <silent> <Leader>fs :<C-u>CocList -I   symbols<CR>
nnoremap <silent> <Leader>fp :<C-u>CocListResume<CR>

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
      \ 'coc-vimlsp',
      \ 'coc-solargraph',
      \ 'coc-lists'
      \ )

let g:coc_snippet_next = '<tab>'

if executable('bfind')
  call coc#config('list.source.files.command', 'bfind')
  call coc#config('list.source.files.args', [])
endif
