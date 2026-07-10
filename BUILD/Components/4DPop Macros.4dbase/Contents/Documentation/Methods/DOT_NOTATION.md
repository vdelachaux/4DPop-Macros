<!-- Macro that converts OB GET / OB SET / OB Is defined calls in the selected code into dot (or bracket) notation. -->

## Description

`DOT_NOTATION` scans the passed code with regular expressions and rewrites the legacy object commands: `OB GET` becomes property access, `OB SET` becomes an assignment, and `OB Is defined` becomes a `#Null` test. When the property name is a valid identifier it uses dot notation, otherwise it falls back to `["key"]` bracket notation. The result is written back through `SET MACRO PARAMETER`.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $code | Text | in | The source code to convert to dot notation |

## Example

```4d
// OB SET($o;"name";"John")  ->  $o.name:="John"
DOT_NOTATION($o.highlighted)
```
