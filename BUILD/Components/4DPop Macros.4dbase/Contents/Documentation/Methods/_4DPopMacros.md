<!-- Builds and returns a 4D Function (formula) from a text expression. -->

## Description

`_4DPopMacros` compiles the text passed as first parameter into a formula with `Formula from string` and returns it wrapped as a `4D.Function`, ready to be called.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $1 | Text | in | The 4D expression to compile into a formula |
| Result | 4D.Function | out | The formula built from the expression |

## Example

```4d
var $f : 4D.Function
$f:=_4DPopMacros("1+1")
```
