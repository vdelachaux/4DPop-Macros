<!-- Shared singleton that loads the project's regular expressions from raw text resource files. -->

## Description

`patterns` is a `shared singleton` (accessed through `cs.patterns.me`) that reads the regular expressions used across the component from the `/RESOURCES/regex/` folder. Each `*.txt` file becomes a *group* named after the file, and every line is a `<key><TAB><raw regex>` pair. Because the patterns are stored as plain text, they are written **without 4D string escaping** (`\d` instead of `\\d`), which makes them far more readable and easier to maintain. The parsed patterns are cached once per 4D session as a shared object.

## Functions

| Function | Description |
| -------- | ----------- |
| `group($name : Text) : Object` | Returns the `{key: pattern}` object of a group (for example `"macro"`) |

## Example

```4d
// Get the regex patterns of the macro group
var $rx : Object:=cs.patterns.me.group("macro")

If (Match regex($rx.lineContinuation; $line; 1; *))
	
	// the line ends with a continuation backslash
	
End if 
```
