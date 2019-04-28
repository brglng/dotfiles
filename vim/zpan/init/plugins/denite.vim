call denite#custom#option('_', 'auto_accl', 1)
call denite#custom#option('_', 'auto_resize', 1)
call denite#custom#option('_', 'vertical_preview', 1)
" call denite#custom#option('_', 'auto_highlight', 0)
call denite#custom#option('_', 'highlight_matched_char', 'Underlined')
call denite#custom#var('file/rec', 'command', ['bfind'])
call denite#custom#source('file,' .
      \                   'file/rec,' .
      \                   'directory_rec',
      \                   'matchers', ['matcher_fuzzy', 'matcher_project_files'])
call denite#custom#source('file,' .
      \                   'file_rec,' .
      \                   'directory_rec',
      \                   'max_candidates', 10000)
" call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])
" let g:neomru#file_mru_ignore_pattern = '\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(\\\\\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)\|\%(^\%(fugitive\)://\)\|\%(^\%(term\)://\)'
" call denite#custom#var('file_mru', 'ignore_pattern', '\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(\\\\\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)\|\%(^\%(fugitive\)://\)\|\%(^\%(term\)://\)')
" let g:neomru#directory_mru_ignore_pattern = '\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(\\\\\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'
" call denite#custom#var('directory_mru', 'ignore_pattern', '\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(\\\\\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)')
if executable('rg')
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts', ['-S', '--vimgrep'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
elseif executable('ag')
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
elseif executable('ack')
  call denite#custom#var('grep', 'command', ['ack'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--ackrc', $HOME.'/.ackrc', '-H',
        \  '--nopager', '--nocolor', '--nogroup', '--column'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--match'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
elseif has('win32')
  call denite#custom#var('grep', 'command', ['findstr'])
  call denite#custom#var('grep', 'recursive_opts', ['/s'])
  call denite#custom#var('grep', 'default_opts', ['/n'])
endif

call denite#custom#map('insert', '<TAB>',       '<denite:move_to_next_line>',       'noremap')
call denite#custom#map('insert', '<S-TAB>',     '<denite:move_to_previous_line>',   'noremap')
call denite#custom#map('insert', '<Down>',      '<denite:move_to_next_line>',       'noremap')
call denite#custom#map('insert', '<Up>',        '<denite:move_to_previous_line>',   'noremap')
call denite#custom#map('insert', '<C-J>',       '<denite:move_to_next_line>',       'noremap')
call denite#custom#map('insert', '<C-K>',       '<denite:move_to_previous_line>',   'noremap')
call denite#custom#map('insert', '<PageDown>',  '<denite:scroll_page_forwards>',    'noremap')
call denite#custom#map('insert', '<PageUp>',    '<denite:scroll_page_backwards>',   'noremap')
call denite#custom#map('insert', '<C-Home>',    '<denite:move_to_first_line>',      'noremap')
call denite#custom#map('insert', '<C-End>',     '<denite:move_to_last_line>',       'noremap')
call denite#custom#map('normal', '<Down>',      '<denite:move_to_next_line>',       'noremap')
call denite#custom#map('normal', '<Up>',        '<denite:move_to_previous_line>',   'noremap')
call denite#custom#map('normal', '<C-J>',       '<denite:move_to_next_line>',       'noremap')
call denite#custom#map('normal', '<C-K>',       '<denite:move_to_previous_line>',   'noremap')
call denite#custom#map('normal', '<PageDown>',  '<denite:scroll_page_forwards>',    'noremap')
call denite#custom#map('normal', '<PageUp>',    '<denite:scroll_page_backwards>',   'noremap')
call denite#custom#map('normal', '<C-Home>',    '<denite:move_to_first_line>',      'noremap')
call denite#custom#map('normal', '<C-End>',     '<denite:move_to_last_line>',       'noremap')

nnoremap <silent> <Leader>df :cclose <BAR> lclose <BAR> Denite -buffer-name=file_rec              file/rec<CR>
nnoremap <silent> <Leader>dF :cclose <BAR> lclose <BAR> Denite -buffer-name=file_rec      -resume file/rec<CR>
nnoremap <silent> <Leader>dd :cclose <BAR> lclose <BAR> Denite -buffer-name=file                  file<CR>
nnoremap <silent> <Leader>dD :cclose <BAR> lclose <BAR> Denite -buffer-name=file          -resume file<CR>
nnoremap <silent> <Leader>db :cclose <BAR> lclose <BAR> Denite -buffer-name=buffer                buffer<CR>
nnoremap <silent> <Leader>dg :cclose <BAR> lclose <BAR> Denite -buffer-name=grep                  grep<CR>
nnoremap <silent> <Leader>dG :cclose <BAR> lclose <BAR> Denite -buffer-name=grep          -resume grep<CR>
nnoremap <silent> <Leader>dl :cclose <BAR> lclose <BAR> Denite -buffer-name=line_<C-r>%           line<CR>
nnoremap <silent> <Leader>dL :cclose <BAR> lclose <BAR> Denite -buffer-name=line_<C-r>%   -resume line<CR>
nnoremap <silent> <Leader>do :cclose <BAR> lclose <BAR> Denite -buffer-name=outline               outline<CR>
nnoremap <silent> <Leader>dr :cclose <BAR> lclose <BAR> Denite -buffer-name=file_mru              file_mru<CR>
nnoremap <silent> <Leader>dR :cclose <BAR> lclose <BAR> Denite -buffer-name=file_mru      -resume file_mru<CR>
