<!-- Reformats 4D method code according to the user's beautifier settings. -->

## Description

`beautifier` reformats the code of the current method (or the highlighted selection) by applying the user's beautifier options: blank-line management, line breaks around control structures, comment formatting, splitting of tests and key/value lines, and more. It `extends macro`, from which it inherits access to the method text, the selection and the code-analysis helpers. The whole reformatting is triggered from its constructor, so simply instantiating it beautifies the current code. Instantiate it with `cs.beautifier.new()`.

## Functions

| Function | Description |
| -------- | ----------- |
| `beautify()` | Reformats the current method (or selection) and pastes the result |
| `before($code : Text) : Text` | Pre-processes the code before beautification |
| `after() : Text` | Post-processes the code after beautification |
| `commentPosition($line : Text) : Integer` | Returns the position of the trailing comment in a line |
| `formatComment($line : Text) : Text` | Formats a comment line |
| `maybeFormatComment($line : Text) : Text` | Formats a comment line only when the option is enabled |
| `isClosure($line : Text) : Boolean` | True when the line is a closing control-flow keyword |
| `isNotClosure($line : Text) : Boolean` | Negation of `isClosure` |
| `openLoopAndBranching($id : Integer)` | Handles the opening of a loop or branching structure |
| `closeLoopAndBranching($id : Integer; $caseOf : Boolean)` | Handles the closing of a loop or branching structure |
| `beforeBranching($caseOf : Boolean)` | Inserts the required line break before a branching item |
| `afterBranching()` | Inserts the required line break after a branching item |
| `beforeClosing($caseOf : Boolean)` | Inserts the required line break before a closing keyword |
| `splitTests($line : Text) : Text` | Splits a compound test into several lines |
| `splitObject($line : Text) : Text` | Splits an object literal into key/value lines |
| `splitCollection($line : Text) : Text` | Splits a collection literal into one element per line |
| `splitKeyValueLine($line : Text) : Text` | Splits a splittable command's parameters into key/value lines |

## Example

```4d
// Beautify the current method according to the user settings
cs.beautifier.new()
```
