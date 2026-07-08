<!-- Entry point that opens the 4DPop Macros settings dialog on worker 1. -->

## Description

`4DPop_MACROS_SETTINGS` is a public entry point that requests the settings dialog by calling worker `1` with the `"SETTINGS"` action. The `$ptr` parameter is part of the standard 4DPop entry-point signature and is not used.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $ptr | Pointer | in | Unused (standard entry-point parameter) |

## Example

```4d
4DPop_MACROS_SETTINGS(->$dummy)
```
