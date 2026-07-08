<!-- Inverts 4D expressions in the current selection (swaps get/set commands and assignments). -->

## Description

`invertExpression` inverts the 4D expressions of the highlighted selection line by line, swapping paired commands (e.g. get/set variants) and simple assignments through a data-driven inversion table. It is a modern, non-recursive rewrite of the legacy `INVERT_EXPRESSION` method. It `extends macro`, inheriting access to the selection and the code helpers, and performs the inversion directly from its constructor. Instantiate it with `cs.invertExpression.new()`.

## Example

```4d
// Invert the 4D expressions of the current selection
cs.invertExpression.new()
```
