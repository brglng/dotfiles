---
name: commit-conventions
description: "Mandatory conventions for writing version control commit messages (Git, Mercurial, etc.). Commit messages must always be written in English and follow the Conventional Commits specification, e.g. \"feat(nvim): enable termsync\". Read before committing code or writing any commit message; not needed for other tasks."
---

# Commit Conventions (Version Control)

## When to Use

Apply these rules whenever you write a version control commit message: `git commit`, `git commit --amend`, staged rebase/squash messages, or PR merge titles. Read this file before producing any commit message.

## When to Commit

Do not commit code changes automatically unless the user explicitly asks you to. When you have staged or completed changes that could be committed:

- Ask the user whether they want you to commit (and how), or
- Leave the changes uncommitted and let the user commit them manually.

Never run `git commit` on your own initiative. Let the user decide the timing and granularity of commits.

## Rules

- Commit messages must be written in English, regardless of the language of the user's prompt or the changes being committed.
- Follow the Conventional Commits specification: the message must start with `<type>(<optional scope>): <summary>`.
- Use one of the standard types:
  - `feat`: a new feature
  - `fix`: a bug fix
  - `docs`: documentation-only changes
  - `style`: changes that do not affect code behavior (formatting, whitespace, missing semicolons)
  - `refactor`: a code change that neither fixes a bug nor adds a feature
  - `perf`: a performance improvement
  - `test`: adding or correcting tests
  - `build`: changes to the build system or external dependencies
  - `ci`: changes to CI configuration files and scripts
  - `chore`: other changes that do not modify source or test files (e.g. maintenance)
  - `revert`: reverts a previous commit
- Scope is optional and lowercase, describing the affected area, e.g. `feat(nvim): ...`, `fix(install): ...`.
- Summary: imperative mood ("add", "fix", not "added"/"fixes"), capitalized first letter, no trailing period, keep it concise (under ~72 characters).
- Breaking changes: append `!` after the type/scope (e.g. `feat(api)!: drop legacy endpoints`), and/or add a `BREAKING CHANGE:` footer explaining the migration path.
- If more detail is needed, add a body and optional footers after a blank line, wrapped at 72 columns. Explain what changed and why, not the mechanics.
- Do not rewrite existing commit messages that already follow these rules (e.g. when rebasing or merging).

## Examples

- `feat(pi): add agent models and keybindings`
- `fix(nvim): correct Codeium plug mapping names`
- `refactor(clang-format): rename config and link via link.sh`
- `chore(install): prune fonts and add pi-coding-agent`
