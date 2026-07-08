<!-- Base class giving access to the current method's code and selection plus a rich set of code-analysis helpers. -->

## Description

`macro` is the base class from which all 4DPop Macros action classes (`beautifier`, `declaration`, `method`, `specialPaste`, `invertExpression`…) extend. In its constructor it identifies the current code-editor window (method name and type), retrieves the full method text and the highlighted selection through `GET MACRO PARAMETER`, and exposes them together with a large set of predicates and utilities to analyze and transform 4D code. It also acts as the entry point for the macro commands themselves (`Beautifier`, `Declarations`, `SpecialPaste`, `Choose`…). It is a regular class, instantiated with `cs.macro.new()`.

## Functions

| Function | Description |
| -------- | ----------- |
| `get isMacroProcess() : Boolean` | True when running inside the `Macro_Call` process |
| `setMethodText($text : Text)` | Sets the full method text macro parameter |
| `setHighlightedText($text : Text)` | Sets the highlighted (selected) text macro parameter |
| `paste($text : Text; $useSelection : Boolean)` | Pastes text into the selection or the whole method and re-tokenizes |
| `tokenize()` | Forces tokenization of the design process |
| `split($useSelection : Boolean; $options : Integer)` | Splits the target code into the `lines` collection |
| `localizedControlFlow($control : Text) : Text` | Returns the localized version of a US control-flow keyword |
| `noSelection() : Boolean` | Beeps and warns when no text is selected; returns True when there is none |
| `isEmpty(... : Text) : Boolean` | True when the concatenated arguments are empty |
| `isNotEmpty(... : Text) : Boolean` | True when the concatenated arguments are not empty |
| `isMultiline($line) : Boolean` | True when the line ends with a `\` continuation |
| `isNotMultiline($line) : Boolean` | Negation of `isMultiline` |
| `isComment($line : Text) : Boolean` | True when the line is a comment (`//`, `/*` or `*/`) |
| `isNotComment($line : Text) : Boolean` | Negation of `isComment` |
| `isReservedComment($line : Text) : Boolean` | True for compiler/reserved comment markers |
| `isNotReservedComment($line : Text) : Boolean` | Negation of `isReservedComment` |
| `isMarkerComment($line : Text) : Boolean` | True for `// MARK:`, `// TODO:` or `// FIXME:` comments |
| `isNotMarkerComment($line : Text) : Boolean` | Negation of `isMarkerComment` |
| `isSeparatorLineComment($line : Text) : Boolean` | True for separator/marker comment lines |
| `isNotSeparatorLineComment($line : Text) : Boolean` | Negation of `isSeparatorLineComment` |
| `isOpeningReservedComment($line : Text) : Boolean` | True for an opening reserved comment (e.g. `//%X-`) |
| `isNotOpeningReservedComment($line : Text) : Boolean` | Negation of `isOpeningReservedComment` |
| `isClosingReservedComment($line : Text) : Boolean` | True for a closing reserved comment (e.g. `//%X+`) |
| `isNotClosingReservedComment($line : Text) : Boolean` | Negation of `isClosingReservedComment` |
| `unusedCharacter($code : Text) : Text` | Returns a character not present in the code, for temporary replacements |
| `isNumeric($in : Text) : Boolean` | True when the text is a number |
| `isDECLARE($in : Text) : Boolean` | True when the line starts with `#DECLARE` |
| `isConstructor($in : Text) : Boolean` | True when the line declares a `Class constructor` |
| `isFunction($in : Text) : Boolean` | True when the line declares a `Function` |
| `constantValue($in : Text)` | Evaluates the selected constant and displays its value |
| `PasteColor()` | Picks an RGB color and pastes it as a hexadecimal literal |
| `Declarations()` | Runs the variable-declaration macro (`cs.declaration`) |
| `Beautifier()` | Runs the code beautifier macro (`cs.beautifier`) |
| `SpecialPaste()` | Runs the special-paste macro (`cs.specialPaste`) |
| `PasteAndKeepTarget()` | Pastes the clipboard while keeping the selection on the clipboard |
| `objectLiteral()` | Converts `New object`/`New collection` calls into literal syntax |
| `Choose()` | Converts an `If … Else … End if` assignment into a `Choose` expression |
| `CopyWithTokens()` | Copies the selection to the clipboard with tokens |
| `ConvertToCallWithToken()` | Replaces a quoted method name with a tokenized call |
| `convert_hexa()` | Converts the selected number to hexadecimal |
| `convert_decimal()` | Converts the selected hexadecimal value to decimal |
| `zipForShare()` | Zips the current method for sharing |
| `RemoveBlankLines()` | Removes blank lines from the selection |
| `comment()` | Toggles comments on the selection |
| `commentBlock()` | Wraps the selection in a `/* … */` block comment |
| `comment_current_level()` | Comments the boundary keywords of the outermost control structure |
| `duplicateAndComment()` | Duplicates the selection and comments the original |
| `edit_comment()` | Opens the comment editor and pastes the entered comment block |

## Example

```4d
var $macro : cs.macro
$macro:=cs.macro.new()

If (Not($macro.noSelection()))
	
	$macro.setHighlightedText($macro.highlighted)
	
End if 
```
