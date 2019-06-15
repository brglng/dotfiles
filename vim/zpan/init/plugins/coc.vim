" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [q <Plug>(coc-diagnostic-prev)
nmap <silent> ]q <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gk <Plug>(coc-declaration)
nmap <silent> <Leader>gt <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gf <Plug>(coc-references)

nnoremap <silent> <Leader>jD :call CocLocations('ccls','$ccls/navigate',{'direction':'D'})<cr>
nnoremap <silent> <Leader>jL :call CocLocations('ccls','$ccls/navigate',{'direction':'L'})<cr>
nnoremap <silent> <Leader>jR :call CocLocations('ccls','$ccls/navigate',{'direction':'R'})<cr>
nnoremap <silent> <Leader>jU :call CocLocations('ccls','$ccls/navigate',{'direction':'U'})<cr>

" bases
nnoremap <silent> <Leader>xb :call CocLocations('ccls','$ccls/inheritance')<cr>
" bases of up to 3 levels
nnoremap <silent> <Leader>xb :call CocLocations('ccls','$ccls/inheritance',{'levels':3})<cr>
" derived
nnoremap <silent> <Leader>xd :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true})<cr>
" derived of up to 3 levels
nnoremap <silent> <Leader>xD :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true,'levels':3})<cr>

" caller
nnoremap <silent> <Leader>xc :call CocLocations('ccls','$ccls/call')<cr>
" callee
nnoremap <silent> <Leader>xC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>

" $ccls/member
" member variables / variables in a namespace
nnoremap <silent> <Leader>xm :call CocLocations('ccls','$ccls/member')<cr>
" member functions / functions in a namespace
nnoremap <silent> <Leader>xf :call CocLocations('ccls','$ccls/member',{'kind':3})<cr>
" nested classes / types in a namespace
nnoremap <silent> <Leader>xs :call CocLocations('ccls','$ccls/member',{'kind':2})<cr>

nnoremap <silent> <Leader>xv :call CocLocations('ccls','$ccls/vars')<cr>
nnoremap <silent> <Leader>xV :call CocLocations('ccls','$ccls/vars',{'kind':1})<cr>

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '. expand('<cword>')
  else
    if exists('*CocAction')
      call CocAction('doHover')
      execute 'h ' . expand('<cword>')
    endif
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * if index(['defx', 'denite', 'gitv', 'startify', 'undotree'], &filetype) < 0 && expand('%:t') !~ '__Tagbar\|__vista__' | silent! call CocActionAsync('highlight') | endif

" Remap for rename current word
nmap <Leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <Leader>=  <Plug>(coc-format-selected)
nmap <Leader>=  <Plug>(coc-format-selected)

autocmd User CocJumpPlaceholder silent! call CocActionAsync('showSignatureHelp')
autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')

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

silent! call coc#add_extension(
      \ 'coc-css',
      \ 'coc-git',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-pairs',
      \ 'coc-python',
      \ 'coc-rls',
      \ 'coc-snippets',
      \ 'coc-solargraph',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-yaml',
      \ )

let g:coc_snippet_next = '<tab>'

" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap <Leader>gD <Plug>(coc-git-chunkinfo)
" show commit ad current position
nmap <Leader>gB <Plug>(coc-git-commit)

nnoremap <silent> <Leader>f; :<C-u>CocList          vimcommands<CR>
nnoremap <silent> <Leader>fc :<C-u>CocList          commands<cr>
nnoremap <silent> <Leader>fe :<C-u>CocList          extensions<cr>
nnoremap <silent> <Leader>ff :<C-u>CocList          files<CR>
nnoremap <silent> <Leader>fg :<C-u>CocList          grep<CR>
nnoremap <silent> <Leader>fw :<C-u>CocList          words<CR>
nnoremap <silent> <Leader>fm :<C-u>CocList          marks<CR>
nnoremap <silent> <Leader>fb :<C-u>CocList          buffers<CR>
nnoremap <silent> <Leader>fr :<C-u>CocList          mru<CR>
nnoremap <silent> <Leader>fo :<C-u>CocList          outline<CR>
nnoremap <silent> <Leader>fh :<C-u>CocList          helptags<CR>
nnoremap <silent> <Leader>fq :<C-u>CocList          diagnostics<CR>
nnoremap <silent> <Leader>fC :<C-u>CocList --normal colors<CR>
nnoremap <silent> <Leader>fs :<C-u>CocList -I       symbols<CR>
nnoremap <silent> <Leader>fk :<C-u>CocList snippets<CR>
nnoremap <silent> <Leader>fp :<C-u>CocListResume<CR>

if executable('bfind')
  silent! call coc#config('list.source.files.command', 'bfind')
  silent! call coc#config('list.source.files.args', [])
endif

" let g:coc_node_args = ['--nolazy', '--inspect-brk=6045']
