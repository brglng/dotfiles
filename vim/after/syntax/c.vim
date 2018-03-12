finish

"========================================================
" Highlight All Function
"========================================================
"syn match   cFunction "\<[a-zA-Z_]\w*\>[^()]*)("me=e-2
syn match   cFunction "\<\h\w*\>\s*("me=e-1
"hi cFunction        gui=NONE guifg=#B5A1FF
hi def link cFunction Function
"========================================================
" Highlight All Math Operator
"========================================================
" C math operators
syn match       cMathOperator     display "[+\-\*%\=?:]"
" C pointer operators
syn match       cPointerOperator  display /\(->\|\.\)/
" C logical   operators - boolean results
syn match       cLogicalOperator  display "[!<>]=\="
syn match       cLogicalOperator  display "=="
" C bit operators
syn match       cBinaryOperator   display "\(&\||\|\^\|<<\|>>\)=\="
syn match       cBinaryOperator   display "\~"
syn match       cBinaryOperatorError display "\~="
" More C logical operators - highlight in preference to binary
syn match       cLogicalOperator  display "&&\|||"
syn match       cLogicalOperatorError display "\(&&\|||\)="

" Math Operator
hi  def link  cMathOperator             cOperator
hi  def link  cPointerOperator          cOperator
hi  def link  cLogicalOperator          cOperator
hi  def link  cBinaryOperator           cOperator
hi  def link  cLogicalOperator          cOperator
hi  def link  cOperator                 Operator
hi  def link  cBinaryOperatorError      Error
hi  def link  cLogicalOperatorError     Error
