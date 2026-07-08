<!-- UI helper for the declaration form: computes list box cell styling and handles the refresh and filter entry points. -->

## Description

`declaration_UI` drives the "declaration" form. Called with no parameter it returns a meta object describing the styling (stroke, fill, font weight) of the current list box row based on the variable's type, count and selection state. Called with `"refresh"` it updates the form controls from the current record (or `$data`), and with `"filter"` it builds and pops up the filter menu, updating the displayed subset accordingly.

## Parameters

| Parameter | Type | in/out | Description |
| --------- | ---- | ------ | ----------- |
| $entryPoint | Text | in | `"refresh"` to update the UI, `"filter"` to show the filter menu; omit for list box cell meta |
| $data | Object | in | Optional record used by the `"refresh"` entry point |
| Result | Object | out | The list box cell meta object (no-parameter call only) |

## Example

```4d
// As a list box meta expression
$meta:=declaration_UI()

// Refresh the form UI
declaration_UI("refresh")
```
