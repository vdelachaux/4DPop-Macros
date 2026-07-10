<!-- Opens the preferences window, bringing it to the foreground if it is already open. -->

## Description

`options` scans the open windows for one titled with the localized "preferences" string. If found, it brings that window to the foreground by re-applying its rectangle; otherwise it asks worker `1` to run `_SETTINGS`, opening the preferences dialog.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $data | Object | in | Optional data object (unused by the current logic) |

## Example

```4d
options()
```
