<!-- Macro dispatcher: the single entry point that runs every 4DPop macro action. -->

## Description

`_runMacro` is the entry point of all macros. Its first parameter `$action` selects the macro to run: it is stored as the `lastUsed` action in the shared storage (unless it starts with `_`), then resolved through a large `Case of` structure. If the requested action matches a `cs.macro` function it is invoked directly; otherwise obsolete actions, paste actions and a series of named actions (creating methods, converting to dot notation, opening folders, showing the About box, etc.) are handled explicitly. Actions that require a method or a text selection are guarded accordingly.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $action | Text | in | Name of the macro action to run |
| $text | Text | in | Optional text argument passed to the selected action |
| $title | Text | in | Optional title argument passed to the selected action |
| ... | Pointer | in | Optional variadic pointer parameter(s) |

## Example

```4d
_runMacro("about"; "AutoHide")
```
