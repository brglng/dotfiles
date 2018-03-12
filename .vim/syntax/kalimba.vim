if exists("b:current_syntax")
    finish
endif

syn case ignore
syn sync fromstart

syn keyword kalimbaTodo         TODO FIXME NOTE
syn keyword kalimbaRegion       PM_REGION PM_CACHE_REGION DM1_REGION
            \ DM2_REGION PMFLASH_REGION DMFLASHWIN1_REGION DMFLASHWIN2_REGION
            \ DMFLASHWIN3_REGION DMFLASH_WIN1_LARGE_REGION
            \ DMFLASH_WIN2_LARGE_REGION DMFLASH_WIN3_LARGE_REGION
syn match   kalimbaOverlay      display /\<flash\.\(code\|data16\|data24\|windowed_data16\)\>/
syn keyword kalimbaSegment      DM1 DM1CIRC DM2 DM2CIRC DM DMCIRC DMCONST16
            \ DMCONST DMCONST_WINDOWED16 PM_RST PM_ISR PM_RAM PM PM_FLASH
syn keyword kalimbaRegister     Null r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 rFlags
            \ rIntLink rLink rMAC rMAC0 rMAC1 rMAC12 rMAC2 rMACB rMACB0 rMACB1
            \ rMACB12 rMACB12 I0 I1 I2 I3 I4 I5 I6 I7 M0 M1 M2 M3 L0 L1 L4 L5
            \ DoLoopStart DoLoopEnd Div DivResult DivRemainder
            \ B0 B1 B4 B5 FP SP

syn keyword kalimbaFlag         INT_UM_FLAG INT_BR_FLAG INT_SV_FLAG
            \ INT_SV_FLAG INT_UD_FLAG INT_V_FLAG INT_C_FLAG INT_Z_FLAG
            \ INT_N_FLAG UM_FLAG BR_FLAG SV_FLAG UD_FLAG V_FLAG C_FLAG Z_FLAG
            \ N_FLAG
syn keyword kalimbaCondition    Z EQ NZ NE C NB NC B NEG POS V NV HI LS GE LT
            \ GT LE USERDEF

syn keyword kalimbaInstruction  Carry Borrow LSHIFT ASHIFT int sat frac
            \ SE ZP AND OR XOR LO MI HI SS SU US UU SIGNDET BLKSIGNDET push
            \ pop pushm popm jump call rts rti ABS MIN MAX ONEBITCOUNT
            \ TWOBITCOUNT MOD24 MOD3 nop
syn keyword kalimbaCondInstr    if
syn keyword kalimbaLoopInstr    do

syn match   kalimbaInstruction  /\<56bit\>/
syn match   kalimbaInstruction  /\<M\[/ contains=kalimbaDelimiter

syn keyword kalimbaUnknownKW    A AL B BREAK NONUL SE16 SE8 SLEEP STRING THEN
            \ C KALCODE PACK16 PACK24 PLOOK

syn match   kalimbaPreProc      display /^\s*#\(warning\|error\|line\)\>/
syn match   kalimbaInclude      display /^\s*#\(include\)\>/
syn match   kalimbaDefine       display /^\s*#\(define\|undef\)\>/
syn keyword kalimbaDefine       defined
syn match   kalimbaPreCondit    display /^\s*#\(if\|elif\|else\|endif\|ifdef\|ifndef\)\>/

syn match   kalimbaDirective    display /^\s*.\(MODULE\|ENDMODULE\|CODESEGMENT\|DATASEGMENT\|VAR\|BLOCK\|ENDBLOCK\|CONST\|PRIVATE\|PUBLIC\)\>/
syn keyword kalimbaDirective    string pack16 pack24 nonnul

syn match   kalimbaOperator     display /[+\-\*/%><!=\^|\~?&\[\]]/
syn keyword kalimbaOperator     float ceil floor trunc round sin cos sqrt log10 log2 if then else length min max abs

syn match   kalimbaDelimiter    display /[(),;]/

syn match   kalimbaString       display /"[^"]*"/

syn match   kalimbaLabel        display /^\s*[A-Za-z_\$][A-Za-z_0-9\.]*:/
syn match   kalimbaGlobalLabel  display /^\s*\$[A-Za-z_0-9\.]*:/

syn match   kalimbaBinNum       display /\<0b[01]\+\(\.[01]*\)\?\>/
syn match   kalimbaDecNum       display /\<\d\+\(\.\d*\(e[+\-]\?\d\+\)\?\)\?\>/
syn match   kalimbaHexNum       display /\<0x\x\+\(\.\x*\)\?\>/
syn cluster kalimbaNumber       contains=kalimbaBinNum,kalimbaDecNum,kalimbaHexNum
hi def link kalimbaBinNum       kalimbaNumber
hi def link kalimbaDecNum       kalimbaNumber
hi def link kalimbaHexNum       kalimbaNumber

syn region  kalimbaCComment     start='/\*' end='\*/' contains=kalimbaTodo
syn match   kalimbaCppComment   '//.*$' contains=kalimbaTodo
syn cluster kalimbaComment      contains=kalimbaCComment,kalimbaCppComment
hi def link kalimbaCComment     kalimbaComment
hi def link kalimbaCppComment   kalimbaComment

"=============================================================================

hi def link kalimbaTodo         Todo
hi def link kalimbaRegion       Identifier
hi def link kalimbaOverlay      Identifier
hi def link kalimbaSegment      Identifier
hi def link kalimbaRegister     Identifier

hi def link kalimbaFlag         Constant
hi def link kalimbaCondition    Boolean

hi def link kalimbaPreProc      PreProc
hi def link kalimbaInclude      Include
hi def link kalimbaDefine       Define
hi def link kalimbaPreCondit    PreCondit

hi def link kalimbaInstruction  Keyword
hi def link kalimbaCondInstr    Conditional
hi def link kalimbaLoopInstr    Repeat
hi def link kalimbaDirective    Keyword

hi def link kalimbaOperator     Operator
hi def link kalimbaDelimiter    Delimiter

hi def link kalimbaLabel        Label
hi def link kalimbaGlobalLabel  Function

hi def link kalimbaString       String
hi def link kalimbaNumber       Number

hi def link kalimbaComment      Comment

let b:current_syntax = "kalimba"
