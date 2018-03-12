" TI miniDSP assembly template syntax file

if exists("b:current_syntax")
  finish
endif

syn case        ignore
syn keyword     asmxNopKeyword  nop
syn keyword     asmxKeyword     input input_coeff input_data out_coeff_ram
            \                   out_data_ram out_ram out_acc write writef
            \                   acc_init acc writecoeff mult pgai pgaim init_abs
            \                   acc_abs ac_r_ac ac_f_ac compare jump call return
            \                   int set_addr_mode ac_rw_ac ac_fw_ac shift_fc
            \                   acc_2 multwl multwr acc_wl acc_wr stop repeat
            \                   wait wait_mn wait_eof wait_isr write_ar write_lr
            \                   write_af write_lf write_at write_lf write_msb
            \                   write_lsb write_dyn write_ar_dyn write_lr_dyn
            \                   write_af_dyn write_lf_dyn write_at_dyn
            \                   write_lt_dyn write_lsb_dyn write_dyninv
            \                   write_ar_dyninv write_lr_dyninv write_af_dyninv
            \                   write_lf_dyninv write_at_dyninv write_lt_dyninv
            \                   write_lsb_dyninv writecoeff_ar writecoeff_lr
            \                   writecoeff_af writecoeff_lf writecoeff_at
            \                   writecoeff_lt writecoeff_msb writecoeff_lsb
            \                   writecoeff_dyn writecoeff_ar_dyn
            \                   writecoeff_lf_dyn writecoeff_af_dyn
            \                   writecoeff_at_dyn writecoeff_lt_dyn
            \                   writecoeff_lsb_dyn writecoeff_dyninv
            \                   writecoeff_ar_dyninv writecoeff_lr_dyninv
            \                   writecoeff_af_dyninv writecoeff_lf_dyninv
            \                   writecoeff_at_dyninv writecoeff_lt_dyninv
            \                   writecoeff_lsb_dyninv jump_rom call_rom
            \                   return_rom stop_rom switch_cram shift_fcsc
            \                   switch_cram_1 shift_fc_1 shift_fcsc_1
            \                   switch_cram_2 shift_fc_2 shift_fcsc_2 lshift
            \                   ashift exp norm lshift_dyn ashift_dyn
            \                   lshift_dyninv ashift_dyninv and_data and_coeff
            \                   or_data or_coeff xor_data xor_coeff not
            \                   sqdata_init sqcoeff_init sqdata sqcoeff
            \                   acc_init_datapad acc_init_coeffpad acc_datapad
            \                   acc_coeffpad copy_datapad copy_coeffpad acc_sub
            \                   reg_ctrl reg regs_init idac iadc program_adc
            \                   program_dac program_minidsp_a program_minidsp_d

" ordinary directives
syn match       asmxDirective   "^\.port\>"
syn match       asmxDirective   "^\.data_adc\>"
syn match       asmxDirective   "^\.coeff_adc\>"
syn match       asmxDirective   "^\.data_%%prop("me=e-7
syn match       asmxDirective   "^\.coeff_%%prop("me=e-7
syn match       asmxDirective   "^\.common_data_"
syn match       asmxDirective   "^\.common_coeff_"
syn match       asmxDirective   "^\.data_miniDSP_A\>"
syn match       asmxDirective   "^\.coeff_miniDSP_A\>"
syn match       asmxDirective   "^\.data_miniDSP_D\>"
syn match       asmxDirective   "^\.coeff_miniDSP_D\>"
syn match       asmxDirective   "^\.common_data_adc\>"
syn match       asmxDirective   "^\.common_coeff_adc\>"
syn match       asmxDirective   "^\.common_data_dac\>"
syn match       asmxDirective   "^\.common_coeff_dac\>"
syn match       asmxDirective   "^\.common_data_miniDSP_A\>"
syn match       asmxDirective   "^\.common_coeff_miniDSP_A\>"
syn match       asmxDirective   "^\.common_data_miniDSP_D\>"
syn match       asmxDirective   "^\.common_coeff_miniDSP_D\>"
syn match       asmxDirective   "^\.include\>"

" blocks
syn match       asmxDirective   "^\.region\>"
syn match       asmxDirective   "^\.endregion\>"
syn match       asmxDirective   "^\.codeblock\>"
syn match       asmxDirective   "^\.endcodeblock\>"
syn match       asmxDirective   "^\.datablock\>"
syn match       asmxDirective   "^\.enddatablock\>"
syn match       asmxDirective   "^\.coeffblock\>"
syn match       asmxDirective   "^\.endcoeffblock\>"
syn region      asmxRegion      start="^\.region\>" end="^\.endregion\>" contains=ALL transparent fold keepend
syn region      asmxCodeBlock   start="^\.codeblock\>" end="^\.endcodeblock\>" contains=ALL transparent fold keepend
syn region      asmxDataBlock   start="^\.datablock\>" end="^\.enddatablock\>" contains=ALL transparent fold keepend
syn region      asmxCoeffBlock  start="^\.coeffblock\>" end="^\.endcoeffblock\>" contains=ALL transparent fold keepend
"syn sync        fromstart

" macros
syn case        match
syn match       asmxInclude     "%%include\s*("me=e-1
syn match       asmxDefine      "%%define\s*("me=e-1
"syn region      asmxMacro       start="%%prop(" end=")" contains=asmxDotOperator
syn match       asmxMacro       "%%prop\s*("me=e-1
syn match       asmxMacro       "%%eval\s*("me=e-1
syn match       asmxPreCondit   "%%if\s*("me=e-1
syn match       asmxPreCondit   "%%else\>"
syn match       asmxPreCondit   "%%endif\>"
syn match       asmxPreCondit   "%%defined\s*("me=e-1
syn case        ignore

" operators
syn match       asmxOperator    display "[\-+\*/@\!\=(),<>]"
"syn match       asmxDotOperator display "\." contained

" constants
syn case        match
syn keyword     asmxConstant    left_in left_out right_in right_out aux_left_in
            \                   aux_left_out aux_right_in aux_right_out log_out
            \                   hold_out_left hold_out_right coeff_addr_in
            \                   data_addr_in log_in hold_in_left hold_in_right
            \                   drc_left drc_right coeff_addr_in data_addr_in
syn keyword     asmxConstant    One_M1 One_M2 data_one MinusOne_Int MinusOne_M1
            \                   Zero
syn keyword     asmxConstant    jmp jmp_eqz jmp_eq jmp_g jmp_l jmp_sz jmp_s
            \                   jmp_lairz jmp_lair jmp_rair jmp_faz jmp_fa
            \                   jmp_fbz jmp_fb jmp_drclz jmp_drcrz jmp_laorz
            \                   jmp_laor jmp_raorz jmp_raor
syn case        ignore

" numbers
syn match       asmxNumber      "\<[0-9]\+\>"
syn match       asmxNumber      "\<0x[0-9]\+\>"
syn match       asmxFloat       "\<[0-9]\+\.[0-9]\+\>"
syn match       asmxFloat       "\<[0-9]\+\.[0-9]\+F\>"
syn match       asmxFloat       "\<[0-9]\+\.[0-9]\+M[0-9]\>"
syn match       asmxFloat       "\<[0-9]\+\.[0-9]\+M[12][0-9]\>"
syn match       asmxFloat       "\<[0-9]\+\.[0-9]\+M3[012]\>"
syn match       asmxFloat       "\<[0-0]\+\.[0-9]\+M%%prop("me=e-7

syn match       asmxLabel       "^.\+:$" contains=asmxMacro,asmxOperator

" comments
syn region      asmxComment     start=/;/ end=/\n/
syn region      asmxComment     start=/##/ end=/\n/
syn region      asmxComment     start=/\/\// end=/\n/

" variable attributes
syn match       asmxAttribute   "\$export\>"
syn match       asmxAttribute   "\$common\>"

" links
hi  def link    asmxNopKeyword  Keyword
hi  def link    asmxKeyword     Keyword
hi  def link    asmxAttribute   Delimiter
hi  def link    asmxOperator    Operator
hi  def link    asmxDotOperator Operator
hi  def link    asmxDirective   Special
hi  def link    asmxInclude     Include
hi  def link    asmxDefine      Define
hi  def link    asmxMacro       Macro
hi  def link    asmxPreCondit   PreCondit
hi  def link    asmxLabel       Function
hi  def link    asmxNumber      Number
hi  def link    asmxFloat       Float
hi  def link    asmxConstant    Constant
hi  def link    asmxComment     Comment

let b:current_syntax = "aicasmx"
