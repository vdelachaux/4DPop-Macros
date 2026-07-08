<!-- Method-related macro actions: extract a selection into a new method or toggle a method's attributes. -->

## Description

`method` groups the method-related macro actions and is a modern rewrite of the legacy `METHODS` dispatcher. It can extract the highlighted selection into a new project method (replacing it with the corresponding call) and toggle the attributes of the current project method through a pop-up menu. It `extends macro`, inheriting access to the method text, the selection and the code helpers. Instantiate it with `cs.method.new()`.

## Functions

| Function | Description |
| -------- | ----------- |
| `create()` | Extracts the selection into a new project method and replaces it with the method call |
| `attributes($target : Text)` | Displays a pop-up menu to toggle the attributes of the current method |

## Example

```4d
var $method : cs.method
$method:=cs.method.new()

// Extract the current selection into a new project method
$method.create()
```
