<!-- Shared singleton that converts an XML file into a plain 4D object tree. -->

## Description

`xml` is a `shared singleton` that parses an XML file and returns its content as a plain 4D object, mapping elements, attributes and text nodes to object properties. It is used internally by the preferences and settings classes to read the 4DPop XML configuration files. Access it through `cs.xml.me`.

## Functions

| Function | Description |
| -------- | ----------- |
| `fileToObject($path : Text; $references : Boolean) : Object` | Parses the XML file at the given platform path and returns `{success; value}` |

## Example

```4d
var $result : Object
$result:=cs.xml.me.fileToObject($file.platformPath)

If ($result.success)
	
	var $root : Object:=$result.value
	
End if 
```
