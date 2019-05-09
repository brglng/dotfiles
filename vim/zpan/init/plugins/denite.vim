call denite#custom#option('_', 'auto_accl', 1)
call denite#custom#option('_', 'auto_resize', 1)
if exists('*nvim_open_win')
  call denite#custom#option('_', 'split', 'floating')
endif
call denite#custom#option('_', 'vertical_preview', 1)
call denite#custom#option('_', 'highlight_matched_char', 'Keyword')
call denite#custom#option('_', 'highlight_matched_range', 'String')
if executable('bfind')
  call denite#custom#var('file/rec', 'command', ['bfind'])
endif
call denite#custom#source('file,file/rec,directory_rec',
      \                   'matchers', ['matcher/fuzzy', 'matcher/project_files'])
call denite#custom#source('line', 'matchers', ['matcher/regexp'])
call denite#custom#source('command,outline', 'matchers', ['matcher/fuzzy'])
call denite#custom#source('file,file/rec,directory_rec,line', 'max_candidates', 100000)
call denite#custom#source('file_rec', 'sorters', ['sorter/rank'])
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

call denite#custom#map('insert', '<Down>',      '<denite:move_to_next_line>',       'noremap')
call denite#custom#map('insert', '<Up>',        '<denite:move_to_previous_line>',   'noremap')
call denite#custom#map('insert', '<C-j>',       '<denite:move_to_next_line>',       'noremap')
call denite#custom#map('insert', '<C-k>',       '<denite:move_to_previous_line>',   'noremap')
call denite#custom#map('insert', '<PageDown>',  '<denite:scroll_page_forwards>',    'noremap')
call denite#custom#map('insert', '<PageUp>',    '<denite:scroll_page_backwards>',   'noremap')
call denite#custom#map('insert', '<Home>',      '<denite:move_to_first_line>',      'noremap')
call denite#custom#map('insert', '<End>',       '<denite:move_to_last_line>',       'noremap')
call denite#custom#map('normal', '<Down>',      '<denite:move_to_next_line>',       'noremap')
call denite#custom#map('normal', '<Up>',        '<denite:move_to_previous_line>',   'noremap')
call denite#custom#map('normal', '<C-j>',       '<denite:move_to_next_line>',       'noremap')
call denite#custom#map('normal', '<C-k>',       '<denite:move_to_previous_line>',   'noremap')
call denite#custom#map('normal', '<PageDown>',  '<denite:scroll_page_forwards>',    'noremap')
call denite#custom#map('normal', '<PageUp>',    '<denite:scroll_page_backwards>',   'noremap')
call denite#custom#map('normal', '<Home>',      '<denite:move_to_first_line>',      'noremap')
call denite#custom#map('normal', '<End>',       '<denite:move_to_last_line>',       'noremap')

nnoremap <silent> <Leader>f;    :Denite -buffer-name=command        -resume command<CR>
nnoremap <silent> <Leader>f:    :Denite -buffer-name=command                command<CR>
nnoremap <silent> <Leader>ff    :Denite -buffer-name=file_rec       -resume file/rec<CR>
nnoremap <silent> <Leader>fF    :Denite -buffer-name=file_rec               file/rec<CR>
nnoremap <silent> <Leader>ft    :Denite -buffer-name=file           -resume file<CR>
nnoremap <silent> <Leader>fT    :Denite -buffer-name=file                   file<CR>
nnoremap <silent> <Leader>fg    :Denite -buffer-name=grep           -resume grep<CR>
nnoremap <silent> <Leader>fG    :Denite -buffer-name=grep                   grep<CR>
nnoremap <silent> <Leader>fl    :Denite -buffer-name=line_<C-r>%    -resume line<CR>
nnoremap <silent> <Leader>fL    :Denite -buffer-name=line_<C-r>%            line<CR>
nnoremap <silent> <Leader>fo    :Denite -buffer-name=outline                outline<CR>
nnoremap <silent> <Leader>fb    :Denite -buffer-name=buffer                 buffer<CR>
nnoremap <silent> <Leader>fr    :Denite -buffer-name=file_mru       -resume file_mru<CR>
nnoremap <silent> <Leader>fR    :Denite -buffer-name=file_mru               file_mru<CR>
nnoremap <silent> <Leader>fh    :Denite -buffer-name=help           -resume help<CR>
nnoremap <silent> <Leader>fH    :Denite -buffer-name=help                   help<CR>
nnoremap <silent> <Leader>fc    :Denite -buffer-name=colorscheme    -resume colorscheme<CR>
nnoremap <silent> <Leader>fC    :Denite -buffer-name=colorscheme            colorscheme<CR>
