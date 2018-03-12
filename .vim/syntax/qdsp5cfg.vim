if exists("b:current_syntax")
  finish
endif

syn sync fromstart

syn case ignore
syn keyword qdsp5CfgRegister        A0 A1 A2 A3 AL0 AL1 AM0 AM1 AM2 AM3 AS0 AS1 B0
            \   B1 B2 B3 BL0 BL1 BM0 BM1 BM2 BM3 BS0 BS1 C0 C1 C2 C3 CL CM0 CM1
            \   CP0 CP1 CS D0 D0HL D1 D1HL D2 D2HL D3 D3HL FIL0 FIL1 L0 L0H L0HL
            \   L0L L1 L1H L1HL L1L L2 L2H L2HL L2L L3 L3H L3HL L3L LA LC PC R0
            \   R1 R2 R3 R4 R5 R6 R7 SR

syn match qdsp5CfgPreProc   display /^\s*#\(ERROR\|ECHO\)\>/
syn match qdsp5CfgInclude   display /^\s*#INCLUDE\>\s*["<]/ contains=qdsp5CfgString,qdsp5CfgAngleBrktStr
syn match qdsp5CfgDefine    display /^\s*#\(QPP_CONST\|DEFINE\|UNDEF\)\>/
syn match qdsp5CfgMacro     display /^\s*#\(MACRO\|ENDMACRO\)\>/
syn match qdsp5CfgPreCondit display /^\s*#\(IF\|ENDIF\|ELSE\|ENDIF\|IFDEF\|IFNDEF\|ELIF\)\>/

syn match qdsp5CfgDirective display /^\s*#\(APP_INTERRUPT_MASK\|CACHE_ALIGN\|CLOCK_FREQUENCY\|COMMON_OVERLAY\|DEEP_SLEEP_WAKEUP_MASK\|DISABLE_DATA_CONSISTENCY_CHECK\|DISJOINT\|DM_PRIORITY\|DME_NODE_COUNT\|EXP_BASE_ADDR\|EXP_CGC_CNTRL_VAL\|EXP_TIMEOUT_ISR\|EXT_OVERLAP\|INIT_PROCESS\|INTER_PROCESS_COMMON_UNION\|KERNEL_DATA_EXT_MEM\|LOOP_STACK_SIZE\|LOW_POWER_SUBPROCESS\|MAX_NUM_BINS\|MINIMUM_BIN_SIZE\|OVERLAP\|PC_STACK_SIZE\|SCRATCH_DATA_EXT_MEM\|STATIC_UNIT\|SUBPROC_BASES_TABLE_IN_L2MEM\|TOOLS_VERSION\|HW_VOTING\|HW_AXI_CLK_STP_VT\|SW_AXI_CLK_STP_VT\|GLBL_EXP_HALT_EN_ADSP_A\|GLBL_XMEM_HALT_EN_ADSP_A\|GLBL_CLK_ENA_ADSP_A_EXP\|GLBL_CLK_ENA_ADSP_A_XMEM\|HW_MASK_VOTE_EXP_ENA\|HW_MASK_VOTE_EXP_HALT\|HW_MASK_VOTE_EXP_2_ENA\|HW_MASK_VOTE_EXP_2_HALT\|HW_MASK_VOTE_XMEM_ENA\|HW_MASK_VOTE_XMEM_HALT\|HW_MASK_VOTE_XMEM_2_ENA\|HW_MASK_VOTE_XMEM_2_HALT\|HW_MASK_VOTE_ADM_ON\|HW_MASK_VOTE_ADM_OFF\|USER_APP_VERSION\|XMEM_CGC_CNTRL_VAL\)\>/
syn keyword qdsp5CfgDirKW   START_AFTER kernel ALL AUTO RDONLY
            \   WRBACK MOD ALIGN_TO_START HIGH LOW
            \   WIDE 
            \   SAT ASAT BREV SHARE
            \   INIT_ADDR MICRO_ID DM_PRIORITY aARM_WRITE mARM_WRITE aARM_READ
            \   mARM_READ LOCAL SECURE LOCAL_GROUP QCC SYS_SWAP_BASE
            \   STATIC_UNIT_ACCESS STATIC_SWAP_UNIT_ACCESS
syn keyword qdsp5CfgConstant XMEMA XMEMB XMEMC MEMA MEMB MEMC TEXT DM MICRO0
            \   MICRO1 XDMA0 XDMA1 XDMA2 XDMA3 XDMA4 XDMA5 XDMA5 XDMA6 XDMA7
            \   dma_0 dma_1 dma_2 dma_3 dma_4 dma_5 dma_6 dma_7 EXTA EXTB
            \   EXTC EXTD EXTE EXTF EXTG EXTH MEMI XMEMI 
syn match   qdsp5CfgConstant display /\<XMEM\d\d\?\>/

syn match qdsp5CfgType      display /^\s*#\(CONST\|DMA_GROUP\|DMA_PIPE\|FAST_ISR\|ISR\|MEM\|PIPE\|QUEUE\|SEG\|SEMAPHORE\|STATIC_SWAP_UNIT\|TIMER\)\>/
syn match qdsp5CfgStructure display /^\s*#\(COMMON_UNION\|ENDCOMMON_UNION\|EXT_MAP\|ENDEXT_MAP\|INIT_REG\|ENDINIT_REG\|KERNEL\|ENDKERNEL\|PARTITION\|ENDPARTITION\|PROCESS\|ENDPROCESS\|STATIC_UNIT_MAP\|ENDSTATIC_UNIT_MAP\|STRUCT\|ENDSTRUCT\|SWAP_UNIT_MAP\|ENDSWAP_UNIT_MAP\|SUB_PROCESS\|ULTRA_FAST_ISR\)\>/

syn match qdsp5CfgOperator  display '[&\*+\-\~/%><\^|=?]'
syn match qdsp5CfgDelimiter display '[(),;:{}]'

syn keyword qdsp5CfgTodo        TODO FIXME NOTE

syn match qdsp5CfgString  display /"[^"]*"/
syn match qdsp5CfgAngleBrktStr  display contained /<[^>]*>/

syn match   qdsp5CfgDecNum      display /\<\d\+\>/
syn match   qdsp5CfgHexNum      display /\<0x\x\+\>/
syn match   qdsp5CfgBinNum      display /\<0b[01]\+\>/
syn match   qdsp5CfgOctNum      display /\<0o\o\+\>/
syn cluster qdsp5CfgNumber      contains=qdsp5CfgDecNum,qdsp5CfgHexNum,qdsp5CfgBinNum,qdsp5CfgOctNum
hi def link qdsp5CfgDecNum  qdsp5CfgNumber
hi def link qdsp5CfgHexNum  qdsp5CfgNumber
hi def link qdsp5CfgBinNum  qdsp5CfgNumber
hi def link qdsp5CfgOctNum  qdsp5CfgNumber

syn region  qdsp5CfgBlockComment    start=/\[/ end=/]/ contains=qdsp5CfgBlockComment,qdsp5CfgCComment,qdsp5CfgTodo,qdsp5CfgCommentDesc
syn region  qdsp5CfgCComment        start='/\*' end='\*/' contains=qdsp5CfgCComment,qdsp5CfgBlockComment,qdsp5CfgTodo,qdsp5CfgCommentDesc
syn match   qdsp5CfgCppComment      display '//.*$' contains=qdsp5CfgTodo,qdsp5CfgCommentDesc
syn cluster qdsp5CfgComment         contains=qdsp5CfgBlockComment,qdsp5CfgCComment,qdsp5CfgCppComment,qdsp5CfgCommentDesc
syn match   qdsp5CfgCommentDesc     display contained /\<\(\w \?\)\+:/
hi def link qdsp5CfgBlockComment    qdsp5CfgComment
hi def link qdsp5CfgCComment        qdsp5CfgComment
hi def link qdsp5CfgCppComment      qdsp5CfgComment

"==========================================================================
hi def link qdsp5CfgRegister         Identifier

hi def link qdsp5CfgPreProc          PreProc
hi def link qdsp5CfgInclude          Include
hi def link qdsp5CfgDefine           Define
hi def link qdsp5CfgMacro            Macro
hi def link qdsp5CfgPreCondit        PreCondit

hi def link qdsp5CfgDirective        Keyword
hi def link qdsp5CfgDirKW            Keyword
hi def link qdsp5CfgConstant         Constant

hi def link qdsp5CfgType             Type
hi def link qdsp5CfgStructure        Structure

hi def link qdsp5CfgOperator         Operator
hi def link qdsp5CfgDelimiter        Delimiter

hi def link qdsp5CfgComment          Comment

hi def link qdsp5CfgNumber           Number
hi def link qdsp5CfgString           String
hi def link qdsp5CfgAngleBrktStr     String

hi def link qdsp5CfgCommentDesc      SpecialComment

hi def link qdsp5CfgTodo             Todo

let b:current_syntax = "qdsp5cfg"
