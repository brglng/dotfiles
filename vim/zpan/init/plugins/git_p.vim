" enable virtual text to display blame and neovim support this
" default is: 1
" let g:gitp_blame_virtual_text = 0

" use custom highlight for blame virtual text
" change GitPBlameLineHi to your highlight group
highlight link GitPBlameLine GitPBlameLineHi

" format blame virtual text
" hash: commit hash
" account: commit account name
" date: YYYY-MM-DD
" time: HH:mm:ss
" ago: xxx ago
" zone: +xxxx
" commit: commit message
" lineNum: line number
let g:gitp_blame_format = '    %{account}, %{ago} * %{commit}'

" NOTE: use %{hash:8} or %{hash:0:8} to use the first 8 characters

" statusline integrated: b:gitp_blame, b:gitp_diff_state
"
" blame info:
" b:gitp_blame = {
"    hash: string
"    account: string
"    date: string
"    time: string
"    ago: string
"    zone: string
"    lineNum: string
"    lineString: string
"    commit: string
"    rawString: string
" }
"
" diff lines stat:
" b:gitp_diff_state = { delete: number, add: number, modify: number }
"
" will trigger GitPDiffAndBlameUpdate event after these variables updated

" use custom highlight for diff sign
" change the GitPAddHi GitPModifyHi GitPDeleteHi to your highlight group
highlight link GitPAdd                  GitPAddHi
highlight link GitPModify               GitPModifyHi
highlight link GitPDeleteTop            GitPDeleteHi
highlight link GitPDeleteBottom         GitPDeleteHi
highlight link GitPDeleteTopAndBottom   GitPDeleteHi

" use custom diff sign
let g:gitp_add_sign = '■'
let g:gitp_modify_sign = '▣'
let g:gitp_delete_top_sign = '▤'
let g:gitp_delete_bottom_sign = '▤'
let g:gitp_delete_top_and_bottom_sign = '▤'

" let your sign column background same as line number column
" highlight! link SignColumn LineNr

nmap <silent> <Leader>D <Plug>(git-p-diff-preview)
nmap <silent> <Leader>B <Plug>(git-p-show-blame)

" NOTE: if have diff preview window, it will focus to the diff preview window
" if current window is diff preview window, it will close diff preview window
" or use `q` to quit diff preview window

" use custom highlight for float diff preview window
" change Pmenu to your highlight group
highlight link GitPDiffFloat Pmenu
