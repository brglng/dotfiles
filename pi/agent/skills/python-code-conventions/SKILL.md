---
name: python-code-conventions
description: Mandatory conventions for writing or editing Python code. Read with `code-conventions` before producing Python; not needed for text-only responses.
---

# Python Code Conventions

Apply these rules in addition to `code-conventions` when writing or editing Python code.

## Rules

- Order imports alphabetically in three groups: standard library, third-party packages, and local modules. Do not import inside functions except test-only imports.
- Import types globally unless names conflict.
- Put two blank lines between top-level functions and methods.
- Avoid nested classes/functions unless genuinely useful, small, or explicitly requested. Lambdas are allowed.
- Avoid default parameters unless necessary.
- Put executable logic in `main()` and call it from `if __name__ == "__main__":`.
- Add type hints where types are not obvious and on function signatures. Omit `None` return annotations.
- Prefer built-in generics (`list`, `tuple`, `dict`) over `typing` aliases; use type parameters.
- Prefer `numpy.typing.NDArray` to `np.ndarray`; add shape assertions for `NDArray` and `Tensor` inputs at function start.
- Prefer NumPy-style docstrings.
