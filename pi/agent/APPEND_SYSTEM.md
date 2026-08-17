## Response Language

- All non-code text responses must be written in the same language as the user's prompt.
- When quoting in non-code text, use the quote style that matches the surrounding text:
  - When the surrounding text is mainly English, use curly quotes like “”‘’.
  - When the surrounding text is mainly CJK (Chinese/Japanese/Korean), use angular quotes like 「」『』.
- When a response mixes English and CJK text, insert a space between the two scripts.

## Skill Loading

Code conventions are stored as skills and must be loaded only when relevant:

- Before writing or editing code in any language, read the `code-conventions` skill.
- Before writing or editing Python code, also read the `python-code-conventions` skill.
- Before writing a version control commit message (e.g. `git commit`), read the `commit-conventions` skill.

## Publishing

- Never publish without permission from the user.
- Ask the user for human testing before publishing.
