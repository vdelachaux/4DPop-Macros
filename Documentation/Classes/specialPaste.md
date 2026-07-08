<!-- Transforms the clipboard content (to string, comment, tokenized code, regex, path…) before pasting it. -->

## Description

`specialPaste` offers a dialog to transform the current clipboard content in various ways before pasting it into the code editor: 4D string literal, comment block, tokenized code, regex pattern, path name, HTML code/expression, JSON, UTF-8 conversion and more. It `extends macro`, inheriting access to the selection and the code helpers. The dialog is opened and driven from its constructor, and the chosen transform and options are stored in the preferences. Instantiate it with `cs.specialPaste.new()`.

## Functions

| Function | Description |
| -------- | ----------- |
| `refresh()` | Triggers a deferred refresh of the preview |
| `onLoad()` | Initializes the dialog from the clipboard and the stored preferences |
| `update()` | Recomputes the preview by applying the selected transform |
| `validate()` | Updates the preview and accepts the dialog |
| `string($text : Text) : Text` | Converts the text into a wrapped 4D string literal |
| `comments() : Text` | Converts the text into a comment block |
| `htmlCode() : Text` | Converts the text into a `$htmlCode` string assignment |
| `htmlExpression() : Text` | Converts the text into an escaped HTML expression literal |
| `patternRegex() : Text` | Escapes the text so it can be used as a literal regex pattern |
| `pathname() : Text` | Converts a pasted file/folder path into a 4D path name |
| `insertInText() : Text` | Wraps the text so it can be inserted into another string |
| `jsonCode() : Text` | Converts the text into JSON code |
| `tokenized() : Text` | Returns the tokenized form of the code |
| `toUTF8() : Text` | Converts the text to UTF-8 |
| `fromUTF8() : Text` | Converts the text from UTF-8 |

## Example

```4d
// Open the special-paste dialog for the current clipboard content
cs.specialPaste.new()
```
