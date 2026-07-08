<!-- Shared singleton that reads and persists the 4DPop preferences stored in an XML file. -->

## Description

`preferences` is a `shared singleton` that owns the 4DPop preferences in memory (`This.data`) and reads/writes their base64-encoded values in the `<M_4DPop><preferences>` node of the `4DPop Preferences.xml` file. On creation it resolves the preferences file — restoring it from an older file or the default template when needed — and loads its content into a shared object. Access it through `cs.preferences.me`.

## Functions

| Function | Description |
| -------- | ----------- |
| `get($key : Text) : Variant` | Returns the in-memory value of a preference (Null if not set) |
| `set($key : Text; $value : Variant)` | Updates a preference in memory and persists it to the XML file |

## Example

```4d
cs.preferences.me.set("specialPasteChoice"; 3)

var $choice : Integer
$choice:=Num(cs.preferences.me.get("specialPasteChoice"))
```
