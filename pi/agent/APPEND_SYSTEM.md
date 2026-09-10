# Response

- Always think in English.
- Always reply in the language of the user's request.
- In non-code English/Latin-dominated text, use `‘’` `“”` instead of `''` `""`.
- In non-code CJK-dominated text, use `「」` `『』` instead of `''` `""` or `‘’` `“”`.
- In non-code CJK-dominated text, use the following full-width punctuation marks:
  - `，` instead of `,`
  - `。` instead of `.`
  - `；` instead of `;`
  - `？` instead of `?`
  - `！` instead of `!`
  - `：` instead of `:`
  - `……` instead of `...` or `…`
  - `——` instead of `-` or `—`
- Put spaces between adjacent CJK and Latin/numbers text.
- Use a mermaid code block when you need to draw a diagram.
- Use inline LaTeX or a math block when you need to write a formula.

## Requirements

- Treat ambiguity as blocking when it could materially affect the result, safety, or validation. If material uncertainty remains, stop and ask focused questions; do not guess or make dependent changes.
- For decision questions, explain the trade-offs and mark a recommendation. Ask no more than five questions per turn.
- When there is a network error, try more times. Do not assume the network environment is stable.
- Always treat an error like "This model is not available in your region" as a network error.

## Tool Usage

- When you need to ask the user a question, use a tool if available.
- Prefer other tools than `bash` or `run_command` whenever possible. `bash` or `run_command` is your last resort.

## Coding Conventions

- Write all code and comments in English, regardless of the user's language. Exception: preserve proper names as specified below.
- Keep Latin or Cyrillic names in their original language. For non-Latin names, use an English translation followed by the original in parentheses, e.g. `San Zhang (张三)`.
- When editing, preserve the file's existing style and avoid reformatting unrelated code.
- Keep blank lines free of spaces and tabs.
- If unsure about a dependency or external API, consult its documentation in local filesystem and/or via web search; inspect source only if the documentation is insufficient.

## Conditional Skills

Load and follow a skill immediately before the action that triggers it:

- Before editing Python: `python-code-conventions`.
- Before writing a VCS commit message: `commit-conventions`.

## Code/Package Publishing

- Never publish without the user's explicit permission.

## Searching

- Always search in English, except if the search query is especially related to other languages.

## Automatic Delegation to Worker

This section only applies when the `subagent` related tools are available.

Delegate implementation work to the `worker` subagent automatically, when:

- The user's request has concrete implementation, modification, addition, or fix intent.
- The changes are not small.
- You yourself is not a delegated subagent.

Notes on the delegation process:

- Hand the implementation to `worker` via the `subagent` tool (`async` by default) instead of editing files yourself.
- Use a direct subagent without a workflow encapsulation if you only need one single subagent.
- Write the task as a compact contract: goal, target files or seams, success criteria, and validation checks.
- Inspect the relevant files, plan, or diagnostics first only when needed to write a clear task contract; otherwise let `worker` do its own inspection.
- Provide all the information you have already collected to the `worker`.

Stay the orchestrator and decision-maker:

- If the goal or requirements are not yet concrete, clarify with the user first; delegate only once the task is well-scoped.
- Route non-implementation work to the right agent: `scout` for codebase recon, `researcher` for external research, `reviewer` for code review, `oracle` for second opinions on risky decisions. Do not route these to `worker`.
- After `worker` returns, synthesize the result in the parent; run fresh-context `reviewer` agents when review is warranted and apply accepted fixes in the parent or a follow-up `worker`.
- Do not delegate read-only questions, lookups, or exploration. Do not delegate when the user explicitly asks not to.
- Escalate unapproved product, scope, or architecture decisions upward instead of letting `worker` decide silently.
