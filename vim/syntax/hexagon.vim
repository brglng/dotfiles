if exists('b:current_syntax')
    finish
endif

syn case ignore

syn region  HexagonInstrPkt     start='{' end='}' transparent fold contains=ALL
syn region  HexagonParen        start=/(/ end=/)/ transparent contains=ALL

syn match   HexagonOperator     display '[\=+\-!<>\^&|\~\*/%]'
syn match   HexagonDelimiter    display /[;,\[\](){}]/

syn match   HexagonDecNumber    display /\<\d\+\>/
syn match   HexagonHexNumber    display /\<0x\x\+\>/
syn match   HexagonBinNumber    display /\<0b[01]\+\>/
syn match   HexagonOctNumber    display /\<0[0-7]\+\>/
syn match   HexagonFloat        display /\<0e[+\-]\?\d*\(\.\d*\)\?\(e[+\-]\?\d\+\)\?\>/
syn cluster HexagonNumber       contains=HexagonDecNumber,HexagonHexNumber,HexagonBinNumber,HexagonOctNumber
hi  link    HexagonDecNumber    HexagonNumber
hi  link    HexagonHexNumber    HexagonNumber
hi  link    HexagonBinNumber    HexagonNumber
hi  link    HexagonOctNumber    HexagonNumber
syn match   HexagonConstant     display /#\|\<CONST32\>/

syn match   HexagonChar         display /'./
syn match   HexagonString       display /"[^"]*"/ contains=HexagonEscapeChar
syn match   HexagonEscapeChar   display contained /\\\(b\|f\|n\|r\|t\|\o\o\o\|x\x\+\|\\\|"\)/

syn match   HexagonSectType     display /\.\(rodata\|bss\|sdata\|sbss\|ebi_code_cached\|tcm_code_cached\|smi_code_cached_\|ebi_data_cached\|tcm_data_cached\|smi_data_cached\|ebi_data_cached_wt\|tcm_data_cached_wt\|smi_data_cached_wt\|ebi_data_uncached\|tcm_data_uncached\|smi_data_uncached\)\>/
syn match   HexagonSection      display /\.\(section\|text\|data\)\>/
syn match   HexagonSymbol       display /\.\(section\|equ\|set\|equiv\|global\|globl\|common\|comm\|irp\|irpc\|lcommon\|lcomm\|symver\)\>/
syn match   HexagonSymbolAttr   display /\.\(size\|type\|desc\|hidden\|internal\|protected\)\>/
syn match   HexagonAlignment    display /\.\(org\|align\|balign[wl]\?\|p2align[wl]\?\|falign\)\>/
syn match   HexagonType         display /\.\(byte\|2byte\|3byte\|4byte\|word\|hword\|half\|short\|int\|long\|octa\|quad\|single\|double\|float\|ascii\|asciz\|fill\|space\|skip\|block\|string\)\>\|@\(progbits\|nobits\|function\|object\)\>/
syn match   HexagonPreCondit    display /\.\(if\|ifdef\|ifndef\|ifnotdef\|else\|elseif\|endif\)\>/
syn match   HexagonMacro        display /\.\(macro\|endm\|exitm\)\>/
syn match   HexagonInclude      display /\.include\>/
syn match   HexagonDebugDir     display /\.\(file\|loc\|stabd\|stabn\|stabs\|uleb128\|sleb128\)\>/
syn match   HexagonAsmCtrlDir   display /\.\(end\|abort\|err\|eject\|rept\|endr\)\>/
syn match   HexagonListDir      display /\.\(list\|nolist\|title\|sbttl\|psize\)\>/

syn match   HexagonSpecial      display /:\(endloop0\|endloop1\|endloop01\|t\|nt\|hi\|lo\|raw\|sat\|circ\|brev\|rnd\|<<16\)\>/

syn match   HexagonLabel        display /^\s*[A-Za-z0-9_\.\$]\+\s*:$/
syn match   HexagonLabel        display /^\s*[A-Za-z0-9_\.\$]\+\s*:\s/

syn match   HexagonRegister     display /\<[RC]\([12]\?[0-9]\|3[01]\)\(\.[HL]\)\?\>/
syn match   HexagonRegister     display /\<[RC]\([12]\?[0-9]\|3[01]\):\([12]\?[0-9]\|3[0-1]\)\>/
syn match   HexagonRegister     display /\<P[0-3]\(\.new\)\?\>/ contains=HexagonDelimiter
syn keyword HexagonRegister     SP FP LR LC0 SA0 LC1 SA1 PC USR M0 M1 UGP GP

syn match   HexagonCmpInstr     display /\<\(cmp\|vcmpb\|vcmph\|vcmpw\)\(\.eq\|\.ge\|\.geu\|\.gt\|\.gtu\|\.lt\|\.ltu\)\?\>/
syn keyword HexagonInstruction  add and nor or xor neg nop sub
            \   combine mux aslh asrh sxtb sxth zxtb zxth
            \   if
            \   vaddh vadduh vavgh vnavgh vsubh vsubuh
            \   all8 any8 loop0 loop1 sp1loop0 sp2loop0 sp3loop0
            \   callr jumpr call jump 
            \   memub memb memuh memh memubh memw memd allocframe deallocframe
            \   memw_locked dczeroa barrier brkpt dcfetch dccleana dccleaninva
            \   dcinva icinva isync pause syncht trap0 trap1
            \   abs max maxu min minu not sxtw vabsdiffh vabsdiffw cl0 cl1 clb
            \   normamt ct0 ct1 bitsclr bitsset bitsclr extractu insert
            \   deinterleave interleave lfs parity brev
            \   clrbit setbit togglebit tstbit
            \   cmpy cmpyi cmpyr vcmpy vcmpyr vcmpyi vconj vcrotate vrcmpys
            \   mpyi vmpyweh vmpywoh vmpyweuh vmpywouh mpy mpyu
            \   decbin sat satb sath satub satuh swiz valignb packhl vrndwh
            \   vsathb vsathub vsatwh vsatwuh
            \   shuffeb shuffeh shuffob shuffoh vsplatb vsplath vspliceb
            \   vsxtbh vsxthw vtrunehb vtrunohb vtrunewh vtrunowh
            \   vzxtbh vzxthw
            \   mask vitpack
            \   asl asr lsr addasl asrrnd lsl
            \   tableidxb tableidxd tableidxh tableidxw
            \   vaddub vavgub vmaxub vminub vsubub vraddub vrsadub vmux
            \   vabsh vaddh vadduh vavgh vavguh vnavgh vmaxh vmaxuh vminh
            \   vminuh vsubh vsubuh
            \   vdmpy vmpyeh vmpyh vradduh vrmpyh vaslh vasrh vlsrh vlslh
            \   vabsw vaddw vavguw vavgw vnavgw vmaxuw vmaxw vminuw vminw
            \   vsubw vaslw vasrw vlsrw vlslw

syn region  HexagonCppComment   display start='//' end='$' keepend
syn region  HexagonCComment     start='/\*' end='\*/' keepend
syn cluster HexagonComment      contains=HexagonCComment,HexagonCppComment
hi  link    HexagonCComment     HexagonComment
hi  link    HexagonCppComment   HexagonComment

hi def link HexagonOperator     Operator
hi def link HexagonDelimiter    Delimiter
hi def link HexagonNumber       Number
hi def link HexagonFloat        Float
hi def link HexagonConstant     Constant
hi def link HexagonChar         Charactor
hi def link HexagonEscapeChar   SpecialChar
hi def link HexagonString       String

hi def link HexagonSectType     StorageClass
hi def link HexagonSection      Structure
hi def link HexagonSymbol       Define
hi def link HexagonSymbolAttr   Define
hi def link HexagonAlignment    PreProc
hi def link HexagonType         Type
hi def link HexagonPreCondit    PreCondit
hi def link HexagonMacro        Macro
hi def link HexagonInclude      Include
hi def link HexagonDebugDir     PreProc
hi def link HexagonAsmCtrlDir   PreProc
hi def link HexagonListDir      PreProc

hi def link HexagonSpecial      Special
hi def link HexagonRegister     Identifier
hi def link HexagonLabel        Label
hi def link HexagonCmpInstr     Keyword
hi def link HexagonInstruction  Keyword
hi def link HexagonComment      Comment

setlocal foldmethod=syntax

let b:current_syntax = 'hexagon'
