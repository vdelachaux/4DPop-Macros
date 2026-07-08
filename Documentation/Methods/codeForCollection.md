<!-- Generates the 4D source code that rebuilds a given collection. -->

## Description

`codeForCollection` walks a collection and returns a **Text** containing the 4D statements that would recreate it, handling nested objects and collections recursively and emitting the proper literal for each scalar type (text, number, boolean, date, null). The optional `$key` is used internally to name the target variable during recursive calls.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $c | Collection | in | The collection to serialize into 4D code |
| $key | Text | in | Target variable name used in generated code (optional, defaults to `$c`) |
| Result | Text | out | The generated 4D source code |

## Example

```4d
var $code : Text
$code:=codeForCollection(New collection(1; "two"; True))
```
