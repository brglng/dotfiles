---
name: code-conventions
description: Mandatory conventions for writing or editing code in any programming language — scripts, dotfiles, configs, shell commands, and code snippets in responses. All code including comments must be in English (with exceptions for proper names), and blank lines must not contain whitespace. Read before producing any code; not needed for text-only responses.
---

# Code Conventions (All Languages)

## When to Use

Apply these rules whenever you write or edit code in any language. Read this file when the task involves producing code; skip it only for pure text responses.

## Rules

- All code including comments must be written in English regardless of the language of the user's request, except for the following cases:
  - Keep any latin/western/Russian people names, place/street names, country/state names, etc. in their original language and do not translate them to English.
  - For non-latin (especially CJK) people names, place/street names, country/state names, etc., if the original language is not English, translate them to English, and add a pair of parentheses after the English translation containing the original name in its original language. For example, if the original name is "张三", translate it to "San Zhang (张三)".
- Strip leading spaces or tabs in blank lines in the code.
