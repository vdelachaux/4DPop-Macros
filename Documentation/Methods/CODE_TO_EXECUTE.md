<!-- Macro that rewrites the selected code, turning direct method calls into EXECUTE METHOD calls. -->

## Description

`CODE_TO_EXECUTE` is a macro that reads the highlighted method text, splits it into lines and, for every line that calls a project method (not a built-in command or control-flow keyword), rewrites it as an `EXECUTE METHOD` call preserving the result variable and parameters. The transformed code is written back with `SET MACRO PARAMETER`.

## Example

```4d
// Invoked by the code editor's macro engine on the current selection
CODE_TO_EXECUTE()
```
