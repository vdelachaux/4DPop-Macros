<!-- Initializes the component's shared storage and installs its resources on first use. -->

## Description

`Init` sets up the component's shared `Storage`, creating the `component` shared object (with an `inited` flag) and the `macros` shared object (holding the dispatcher's `lastUsed` action). On first initialization it installs the resources when the preferences are loaded and marks the component as initialized. It returns `True` if the component is already initialized.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| Result | Boolean | out | `True` if the component is (already) initialized |

## Example

```4d
var $ok : Boolean
$ok:=Init()
```
