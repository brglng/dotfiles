; Custom cmake indent for Brglng dotfiles (nvim treesitter side).
;
; Includes the stock nvim-treesitter rules plus these additions:
;
; * Open paren of a command call with visible text right after it, not closed
;   on the same line -> following lines hang-align at the column just right
;   of the '(':
;
;       foo(bar
;           baz)
;
; * Open paren with nothing but whitespace after it -> next lines use the
;   default indent (one shiftwidth deeper):
;
;       foo(
;         bar
;
;   One @indent.align capture provides both variants: the engine switches
;   dynamically based on whether the "(" ends its line ("hanging" branch)
;   or has trailing text ("aligned", absolute o_scol + increment).
; * A standalone ")" line: one level less than an ordinary previous line,
;   or aligned with the hanging column above -- through ")" @indent.branch
;   combined with the aligned command span.
;
; In this grammar "(" / ")" are direct children of normal_command (not
; argument_list), hence the capture sits on the parent node.  Metadata must be
; attached inside the same group (Neovim >= 0.12).

((normal_command) @indent.align
  (#set! "indent.open_delimiter" "("))

; Inner parens inside an argument list (multi-layer nesting) are direct
; children of argument_list in this grammar; align them so the deepest
; surviving bracket governs the continuation column.
((argument_list) @indent.align
  (#set! "indent.open_delimiter" "(")
  (#set! "indent.close_delimiter" ")"))

; ---- stock rules ----
[
  (if_condition)
  (foreach_loop)
  (while_loop)
  (function_def)
  (macro_def)
  (block_def)
] @indent.begin

[
  (elseif_command)
  (else_command)
  (endif_command)
  (endforeach_command)
  (endwhile_command)
  (endfunction_command)
  (endmacro_command)
  (endblock_command)
] @indent.branch

")" @indent.branch

")" @indent.end
