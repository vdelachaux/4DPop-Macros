<!-- Writes the component's "resources.xml" file into the user preferences folder if it is missing. -->

## Description

`Install_resources` checks for the `4DPop/resources.xml` file in the user preferences folder. If it does not exist, it creates it with the embedded Base64-encoded picture resources (`scomber`, `scombrus`). It returns `True` when the file already exists or was written successfully.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| Result | Boolean | out | `True` if the resources file exists or was installed successfully |

## Example

```4d
var $ok : Boolean
$ok:=Install_resources()
```
