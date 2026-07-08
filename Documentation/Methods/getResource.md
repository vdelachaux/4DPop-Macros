<!-- Reads a named resource from the user's "4DPop v11/resources.xml" file and returns it as a Picture. -->

## Description

`getResource` looks up an element named `$name` under `/M_4DPop/` in the user preferences file `4DPop v11/resources.xml`, decodes its Base64 value and returns the corresponding **Picture**. It returns an empty picture if the file or element cannot be found.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $name | Text | in | Name of the resource element under `/M_4DPop/` |
| $type | Text | in | Resource type (for example `"PICT"`) |
| Result | Picture | out | The decoded resource, or an empty picture |

## Example

```4d
var $logo : Picture
$logo:=getResource("scomber"; "PICT")
```
