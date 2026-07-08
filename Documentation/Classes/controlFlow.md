<!-- Shared singleton that caches and returns the localized 4D control-flow keywords. -->

## Description

`controlFlow` is a `shared singleton` that loads the 4D control-flow keywords once per session from the `/RESOURCES/controlFlow.json` resource and keeps them in a shared object. It exposes both the US and the localized keyword lists to the whole component. Because the keywords never change during a session, the data is read only once. Access it through `cs.controlFlow.me`.

## Functions

| Function | Description |
| -------- | ----------- |
| `get keywords() : Collection` | Returns the control-flow keywords for the current 4D language (US or localized) |
| `localized($control : Text) : Text` | Translates a US control-flow keyword to the current 4D language |

## Example

```4d
var $keywords : Collection
$keywords:=cs.controlFlow.me.keywords

var $endIf : Text
$endIf:=cs.controlFlow.me.localized("End if")
```
