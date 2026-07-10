<!-- Generates the compiler declarations of the current method's parameters and local variables. -->

## Description

`declaration` parses the current method (or selection) to detect its parameters and local variables, guesses their types, and generates the corresponding compiler declarations. It `extends macro`, inheriting access to the method text, the selection and the code helpers. On creation it parses the code and, when variables are found, displays the `DECLARATION` dialog so the user can confirm before the declarations are pasted back into the method. Instantiate it with `cs.declaration.new()`.

## Functions

| Function | Description |
| -------- | ----------- |
| `split() : cs.declaration` | Splits the method into lines and returns the instance |
| `parse() : cs.declaration` | Parses the code to extract parameters and local variables, and returns the instance |

## Example

```4d
// Generate the compiler declarations for the current method
cs.declaration.new()
```
