<!-- Moves the current form window down if it sits under the toolbar and returns its reference. -->

## Description

`win_NOT_UNDER_TOOLBAR` gets the current form window and, if its top edge is above the toolbar height, repositions it lower so it is no longer hidden under the toolbar. It returns the window reference in all cases.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| Result | Integer | out | Reference of the current form window |

## Example

```4d
var $window : Integer
$window:=win_NOT_UNDER_TOOLBAR()
```
