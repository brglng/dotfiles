- All non-code text responses must be written in the same language as the language of the user's prompt.
- When there are quotes in non-code text, you must use quotes according to the context:
  - When the context is mainly English, use curly quotes like “”‘’.
  - When the context is mainly CJK (Chinese/Japanese/Korean), use angular quotes like 「」『』.
- When there are mixed English and CJK text, you must add a space between the two languages.

Code conventions are stored as skills and must be loaded only when relevant:

- Before writing or editing code in any language, read the `code-conventions` skill.
- Before writing or editing Python code, also read the `python-code-conventions` skill.
- Before writing a version control commit message (e.g. `git commit`), read the `commit-conventions` skill.
