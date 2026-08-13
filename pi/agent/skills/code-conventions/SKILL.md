---
name: code-conventions
description: Mandatory conventions for writing or editing code in any programming language — scripts, dotfiles, configs, shell commands, and code snippets in responses. All code including comments must be in English (with exceptions for proper names), and blank lines must not contain whitespace. Read before producing any code; not needed for text-only responses.
---

# Code Conventions (All Languages)

## When to Use

Apply these rules whenever you write or edit code in any language. Read this file when the task involves producing code; it is not needed for text-only responses.

## Rules

- All code, including comments, must be written in English, regardless of the language of the user's request, except for names (see below).
- When editing an existing file, follow the code style already used in that file (indentation, quoting, naming, formatting conventions, etc.); do not reformat the whole file into a different style.
- Blank lines in code must not contain any spaces or tabs.

### Names

- For names written in the Latin or Cyrillic script (e.g. Western or Russian names) — people, places, streets, countries/states, etc. — keep them in their original language and do not translate them to English.
- For non-Latin (especially CJK) names — people, places, streets, countries/states, etc. — if the original language is not English, translate them to English and append the original name in parentheses after the translation. For example, translate "张三" to "San Zhang (张三)".
