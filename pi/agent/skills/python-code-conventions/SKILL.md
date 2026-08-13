---
name: python-code-conventions
description: Mandatory conventions for writing or editing Python code — modules, scripts, and Python snippets in responses. Import ordering, two blank lines between functions, no nested classes/functions, avoid default parameters, no imports inside functions, main() wrapper, type hints with built-in generics, numpy.typing.NDArray, shape assertions, NumPy-style docstrings. Read before producing Python code, in addition to code-conventions.
---

# Python Code Conventions

## When to Use

Apply these rules when writing or editing Python code, in addition to the `code-conventions` skill.

## Rules

- Import standard library packages first, followed by third-party packages, and finally local scripts, and each part must be strictly sorted alphabetically.
- Add two blank lines between each function or method.
- Nested classes and nested functions are prohibited (except when they are really useful or small, or being explicitly asked for), but lambda functions are allowed.
- Function default parameters should be avoided when they are not really necessary.
- Importing inside a function is strictly prohibited except when the import is only used in a function which is only executed during testing.
- Wrap the main program in a `main` function instead of write directly under a `if __name__ == "__main__:` block.
- Type hints are preferred where the types are not obvious and at function prototypes. The `None` return type must be omitted. Types should be imported to the global namespace if they do not conflict. Built-in type names such as `list`, `tuple`, and `dict` should be preferred over the counterparts in the `typing` package, such as `typing.List`, `typing.Tuple`, and `typing.Dict`.
- Prefer `numpy.typing.NDArray` over `np.ndarray`.
- Use type parameters.
- Add assertions at the beginning of functions for the shapes of `NDArray`s and `Tensor`s.
- If there is docstring, prefer NumPy style.
