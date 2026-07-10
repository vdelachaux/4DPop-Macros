<!-- Rewrites the selected code using the EXECUTE FORMULA command. -->

## Description

`CODE_TO_EXECUTE_FORMULA` parses the passed code (or the current selection when called with no parameter) line by line, keeping comments and control-flow structures intact while turning method/command calls into an `EXECUTE FORMULA`-based rewrite. When run as a macro it reads and writes the highlighted text through the macro parameters; otherwise it returns the rewritten code.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $code | Text | in | Source code to rewrite (optional; read from the selection in macro mode) |
| Result | Text | out | The rewritten source code |

## Example

```4d
var $rewritten : Text
$rewritten:=CODE_TO_EXECUTE_FORMULA("$n:=Records in table(->[People])")
```
