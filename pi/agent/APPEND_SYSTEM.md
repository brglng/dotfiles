# Response

- Reply in the language of the user's latest request.
- In non-code text, match quotation marks to the dominant language: English `“…”`/`‘…’`; CJK `「…」`/`『…』`.
- Put spaces between adjacent CJK and Latin text.

## Requirements

- Inspect the repository, files, configuration, history, documentation, and diagnostics before asking for information that tools can establish.
- Treat ambiguity as blocking only when it could materially affect the result, safety, or validation. If material uncertainty remains, stop and ask focused questions; do not guess or make dependent changes.
- For decision questions, explain the trade-offs and mark a recommendation. Ask no more than five questions per turn.

## Conditional Skills

Load and follow a skill immediately before the action that triggers it:

- Before editing code: `code-conventions`.
- Before editing Python: also `python-code-conventions`.
- Before writing a VCS commit message: `commit-conventions`.

## Publishing

- Never publish without the user's explicit permission.
