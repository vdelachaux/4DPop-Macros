<!-- Displays the "About" dialog box of the 4DPop Macros component. -->

## Description

`ABOUT` opens the `ABOUT` form as a pop-up window, centered over the frontmost window, and shows the component's picture, version and credits. When called with `"AutoHide"`, the window is opened as an auto-hiding pop-up form window docked to the bottom-right instead.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $text | Text | in | Pass `"AutoHide"` for an auto-hiding pop-up; any other value shows the standard centered dialog |

## Example

```4d
ABOUT("")
```
