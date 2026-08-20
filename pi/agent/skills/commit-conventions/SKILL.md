---
name: commit-conventions
description: Mandatory conventions for writing VCS commit messages. Read before writing a commit message; not needed for other tasks.
---

# Commit Conventions

Use this skill before writing a commit message for `git commit`, amend, rebase, squash, or a PR merge title.

## Rules

- Do not commit automatically. Ask the user whether to commit and how, or leave changes uncommitted.
- Only commit in the current project. Committing in another project requires explicit double permission.
- Split large commit into multiple atommic commits.
- Write messages in English and follow Conventional Commits: `<type>(<optional scope>): <summary>`.
- Use these types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- Use a lowercase scope for the affected area when useful, e.g. `feat(nvim): ...`.
- Use imperative mood, capitalize the summary, omit the final period, and keep it under about 72 characters.
- For breaking changes, append `!` after the type/scope and/or add a `BREAKING CHANGE:` footer with migration guidance.
- If needed, add a body and footers after a blank line, wrapping at 72 columns. Explain what changed and why, not mechanics.
- Do not rewrite existing compliant messages.

## Examples

- `feat(pi): add agent models and keybindings`
- `fix(nvim): correct Codeium plug mapping names`
- `refactor(clang-format): rename config and link via link.sh`
- `chore(install): prune fonts and add pi-coding-agent`
