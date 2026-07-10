<!-- Generates the 4D source code that rebuilds a given object. -->

## Description

`codeForObject` iterates over the properties of an object and returns a **Text** containing the 4D statements that would recreate it. Nested objects and collections are handled recursively, property names that are not valid identifiers use bracket notation, and each scalar value is emitted with its correct literal (text, number, boolean, date, null). The optional `$key` names the target variable in recursive calls.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $object | Object | in | The object to serialize into 4D code |
| $key | Text | in | Target variable name used in generated code (optional, defaults to `$o`) |
| Result | Text | out | The generated 4D source code |

## Example

```4d
var $code : Text
$code:=codeForObject(New object("name"; "John"; "age"; 42))
```
