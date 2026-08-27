; Custom C++ indent for Brglng dotfiles.
;
; = Custom C indent rules + C++ extras:
;
; * template_parameter_list / template_argument_list alignment on the "<" /
;   ">" angle brackets (angle brackets are treesitter-only by design: judging
;   '<' '>' in a text scanner is ambiguous):
;
;       std::map<int,
;                std::string>
;
; * everything else matches the C rules (call/param lists hang-align after
;   "(", braces handled structurally, etc.); files are merged because
;   nvim-treesitter's runtime/queries directory is not on 'runtimepath'
;   under lazy.nvim.

; ==================== C++ extras ====================

(condition_clause) @indent.begin

((field_initializer_list) @indent.begin
  (#set! indent.start_at_same_line 1))

((template_parameter_list) @indent.align
  (#set! indent.open_delimiter "<")
  (#set! indent.close_delimiter ">"))

((template_argument_list) @indent.align
  (#set! indent.open_delimiter "<")
  (#set! indent.close_delimiter ">"))

(access_specifier) @indent.branch

; ==================== C base ====================

[
  (compound_statement)
  (field_declaration_list)
  (case_statement)
  (enumerator_list)
  (compound_literal_expression)
  (init_declarator)
] @indent.begin

((initializer_list) @indent.align
  (#set! indent.open_delimiter "{")
  (#set! indent.close_delimiter "}"))

(expression_statement
  (_) @indent.begin
  ";" @indent.end)

(ERROR
  "for"
  "(" @indent.begin
  ";"
  ";"
  ")" @indent.end)

((for_statement
  body: (_) @_body) @indent.begin
  (#not-kind-eq? @_body "compound_statement"))

(while_statement
  condition: (_) @indent.begin)

((while_statement
  body: (_) @_body) @indent.begin
  (#not-kind-eq? @_body "compound_statement"))

((if_statement)
  .
  (ERROR
    "else" @indent.begin))

(if_statement
  condition: (_) @indent.begin)

(if_statement
  consequence: (_
    ";" @indent.end) @_consequence
  (#not-kind-eq? @_consequence "compound_statement")
  alternative: (else_clause
    "else" @indent.branch
    [
      (if_statement
        (compound_statement) @indent.dedent)? @indent.dedent
      (compound_statement)? @indent.dedent
      (_)? @indent.dedent
    ])?) @indent.begin

(else_clause
  (_
    .
    "{" @indent.branch))

(compound_statement
  "}" @indent.end)

[
  ")"
  "}"
  (statement_identifier)
] @indent.branch

[
  "#define"
  "#ifdef"
  "#ifndef"
  "#elif"
  "#if"
  "#else"
  "#endif"
] @indent.zero

[
  (preproc_arg)
  (string_literal)
] @indent.ignore

((ERROR
  (parameter_declaration)) @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))

([
  (argument_list)
  (parameter_list)
] @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))

(comment) @indent.auto
