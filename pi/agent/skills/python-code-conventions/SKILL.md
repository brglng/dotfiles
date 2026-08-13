---
name: python-code-conventions
description: Mandatory conventions for writing or editing Python code — modules, scripts, and Python snippets in responses. Import ordering, two blank lines between functions, no nested classes/functions, avoid default parameters, no imports inside functions, main() wrapper, type hints with built-in generics, numpy.typing.NDArray, shape assertions, NumPy-style docstrings. Read before producing Python code, in addition to code-conventions.
---

# Python Code Conventions

## When to Use

Apply these rules when writing or editing Python code, in addition to the `code-conventions` skill.

## Rules

- Order imports as follows: standard library packages first, third-party packages next, and local scripts last; sort each group strictly alphabetically.
- Add two blank lines between every function or method.
- Nested classes and nested functions are prohibited unless they are genuinely useful, small, or explicitly requested; lambda functions are always allowed.
- Avoid function default parameters unless they are truly necessary.
- Do not import inside a function, except when the import is used solely by a function that runs only during testing.
- Wrap the main program in a `main` function instead of writing it directly under an `if __name__ == "__main__":` block.
- Prefer type hints where the types are not obvious and on function signatures. Omit the `None` return type. Import types in the global namespace when their names do not conflict. Prefer built-in types such as `list`, `tuple`, and `dict` over their `typing` counterparts such as `typing.List`, `typing.Tuple`, and `typing.Dict`.
- Prefer `numpy.typing.NDArray` over `np.ndarray`.
- Use type parameters (generics).
- Add shape assertions for `NDArray`s and `Tensor`s at the beginning of functions.
- Prefer NumPy style when writing docstrings.
