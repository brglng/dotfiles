if exists("b:current_syntax")
  finish
endif

syn case ignore
syn sync fromstart

syn match   qdsp5StageSuffix     display contained /\<\w\+\(_ID1\|_ID2\|_EX1\|_EX2\)\>/ms=e-3
syn match   qdsp5RegisterWithSuffix  display /\<\(A0\|A1\|A2\|A3\|AL0\|AL1\|AM0\|AM1\|AM2\|AM3\|AS0\|AS1\|B0\|B1\|B2\|B3\|BL0\|BL1\|BM0\|BM1\|BM2\|BM3\|BS0\|BS1\|C0\|C1\|C2\|C3\|CL\|CM0\|CM1\|CP0\|CP1\|CS\|D0\|D0HL\|D1\|D1HL\|D2\|D2HL\|D3\|D3HL\|FIL0\|FIL1\|L0\|L0H\|L0HL\|L0L\|L1\|L1H\|L1HL\|L1L\|L2\|L2H\|L2HL\|L2L\|L3\|L3H\|L3HL\|L3L\|LA\|LC\|PC\|R0\|R1\|R2\|R3\|R4\|R5\|R6\|R7\|SR\)_\(ID1\|ID2\|EX1\|EX2\)\>/ contains=qdsp5StageSuffix
syn keyword qdsp5Register        A0 A1 A2 A3 AL0 AL1 AM0 AM1 AM2 AM3 AS0 AS1 B0
            \   B1 B2 B3 BL0 BL1 BM0 BM1 BM2 BM3 BS0 BS1 C0 C1 C2 C3 CL CM0 CM1
            \   CP0 CP1 CS D0 D0HL D1 D1HL D2 D2HL D3 D3HL FIL0 FIL1 L0 L0H L0HL
            \   L0L L1 L1H L1HL L1L L2 L2H L2HL L2L L3 L3H L3HL L3L LA LC PC R0
            \   R1 R2 R3 R4 R5 R6 R7 SR
syn keyword qdsp5Boolean         EQ GE GT L0EQ L0GE L0GT L0HEQ L0LE L0LT L0NE
            \   L0OV L1EQ L1GE L1GT L1HEQ L1LE L1LT L1NE L1OV L2EQ L2GE L2GT
            \   L2HEQ L2LE L2LT L2NE L3HEQ LE LT NE OFF ON OV TR SALU_EQ SALU_NE
            \   SALU_GE SALU_GT SALU_LE SALU_LT SALU_OV SALU_TR
syn keyword qdsp5Instruction     ABS APPEND ASAT BIT BITREVERSE BREV
            \   DETNORM GDIS HAM HAMB INPORT MAX MIN
            \   NORM OUTPORT OUTPORTA OUTPORTB OURPORTC PAR
            \   POP PUSH RND RTF RTFD RTFD2 RTI SAT SET WAIT
syn keyword qdsp5NopInstr        NOP NOP2 NOP3 NOP4 NOP5
syn match   qdsp5CallJmpInstr    /\<\(CALL\|CALLD\|JUMP\|JUMPD\|JUMPD2\)\>/
syn keyword qdsp5Conditional     IF
syn match   qdsp5Repeat          /\<\(LOOP\|TLOOP\|TLOOP2\|UNTIL\)\>/
syn keyword qdsp5Trap            TRAP
syn keyword qdsp5OtherKeyword    CPS SALU SS SU UU
"unknown keywords: ADDR EXT16 EXT32

syn match qdsp5Label         display /^\s*\h\w*\s*:/
syn match qdsp5ContextLabel  display /\<\(CALL\|CALLD\|JUMP\|JUMPD\|JUMPD2\|TLOOP\|UNTIL\)\s\+\h\w*\>/ contains=qdsp5CallJmpInstr,qdsp5Repeat,qdsp5Register
syn match qdsp5ContextLabel  display /\<\(TLOOP2\)\s\+\h\w*\s\+\h\w*\>/ contains=qdsp5Repeat
syn match qdsp5MacroCall     display /\<\zs\h\w*\ze(.*)\s*;/

syn match qdsp5PreProc   display /^\s*#\(ERROR\|ECHO\)\>/
syn match qdsp5Include   display /^\s*#INCLUDE\>\s*["<]/ contains=qdsp5String,qdsp5AngleBrktStr
syn match qdsp5Define    display /^\s*#\(QPP_CONST\|DEFINE\|UNDEF\)\>/
syn match qdsp5Macro     display /^\s*#\(MACRO\|ENDMACRO\)\>/
syn match qdsp5PreCondit display /^\s*#\(IF\|ENDIF\|ELSE\|ENDIF\|IFDEF\|IFNDEF\|ELIF\)\>/

syn match qdsp5Directive display /^\s*#\(STDLIB\|SEED\)\>/
syn keyword qdsp5DirKW   SEG MOD PAD BITREV CIRC LIMIT RDONLY
syn match qdsp5Constant  display /\<\(MEMA\|MEMB\|MEMC\|QMEMA\|QMEMB\|QMEMC\|TEXT\)\>/

syn match qdsp5Type      display /^\s*#\(VAR\|SEGMENT\|CONST\)\>/
syn match qdsp5StorageClass  display /^\s*#\(EXTERN\|EXTERNMODULE\|GLOBAL\)\>/
syn match qdsp5Structure display /^\s*#\(MODULE\|ENDMOD\|UNION\|ENDUNION\|STRUCT\|ENDSTRUCT\)\>/

syn match qdsp5Operator  display '[&\*+\-\~/%><\^|=?]'
syn keyword qdsp5Operator    LENGTH BITREVERSE CONTACT FILL RAND SEGMENT_USAGE EXT_REF ABS_ADDR
syn match qdsp5Operator  display '\<MEM\(A\|B\|C\)('me=e-1
syn match qdsp5Delimiter display '[(),;{}]'

syn keyword qdsp5Todo        TODO FIXME NOTE

syn match qdsp5String        display /"[^"]*"/
syn match qdsp5AngleBrktStr  display contained /<[^>]*>/

syn match   qdsp5DecNum      display /\<\d\+\>/
syn match   qdsp5HexNum      display /\<0x\x\+\>/
syn match   qdsp5BinNum      display /\<0b[01]\+\>/
syn match   qdsp5OctNum      display /\<0o\o\+\>/
syn cluster qdsp5Number      contains=qdsp5DecNum,qdsp5HexNum,qdsp5BinNum,qdsp5OctNum
hi def link qdsp5DecNum  qdsp5Number
hi def link qdsp5HexNum  qdsp5Number
hi def link qdsp5BinNum  qdsp5Number
hi def link qdsp5OctNum  qdsp5Number

syn region  qdsp5BlockComment    start=/\[/ end=/]/ contains=qdsp5BlockComment,qdsp5CComment,qdsp5Todo,qdsp5CommentDesc
syn region  qdsp5CComment        start='/\*' end='\*/' contains=qdsp5CComment,qdsp5BlockComment,qdsp5Todo,qdsp5CommentDesc
syn match   qdsp5CppComment      display '//.*$' contains=qdsp5Todo,qdsp5CommentDesc
syn cluster qdsp5Comment         contains=qdsp5BlockComment,qdsp5CComment,qdsp5CppComment,qdsp5CommentDesc
syn match   qdsp5CommentDesc     display contained /\<\(\w \?\)\+:/
hi def link qdsp5BlockComment    qdsp5Comment
hi def link qdsp5CComment        qdsp5Comment
hi def link qdsp5CppComment      qdsp5Comment

"===============================================================================
hi def link qdsp5Register            Identifier
hi def link qdsp5StageSuffix         Special
hi def link qdsp5RegisterWithSuffix  Identifier

hi def link qdsp5Boolean             Boolean

hi def link qdsp5Instruction         Keyword
hi def link qdsp5NopInstr            Exception
hi def link qdsp5CallJmpInstr        Keyword
hi def link qdsp5Conditional         Conditional
hi def link qdsp5Repeat              Repeat
hi def link qdsp5Trap                Exception
hi def link qdsp5OtherKeyword        Keyword
hi def link qdsp5Label               Label
"hi def link qdsp5ContextLabel        Label

hi def link qdsp5MacroCall           Function

hi def link qdsp5PreProc             PreProc
hi def link qdsp5Include             Include
hi def link qdsp5Define              Define
hi def link qdsp5Macro               Macro
hi def link qdsp5PreCondit           PreCondit

hi def link qdsp5Directive           Keyword
hi def link qdsp5DirKW               Keyword
hi def link qdsp5Constant            Constant

hi def link qdsp5Type                Type
hi def link qdsp5StorageClass        StorageClass
hi def link qdsp5Structure           Structure

hi def link qdsp5Operator            Operator
hi def link qdsp5Delimiter           Delimiter

hi def link qdsp5Comment             Comment

hi def link qdsp5Number              Number
hi def link qdsp5String              String
hi def link qdsp5AngleBrktStr        String

hi def link qdsp5CommentDesc         SpecialComment

hi def link qdsp5Todo                Todo

let b:current_syntax = "qdsp55asm"
