<!-- Displays the 4DPop Macros settings dialog and loads/migrates the beautifier and declaration options. -->

## Description

`settings` displays the 4DPop Macros settings dialog (beautifier and declaration pages) and manages the `4DPop Macros.settings` JSON file, creating it from the legacy XML preferences or the default resource when needed. It `extends preferences`, inheriting its file-resolution and persistence logic. The dialog is opened and driven from its constructor, optionally on a given page. Instantiate it with `cs.settings.new()`.

## Functions

| Function | Description |
| -------- | ----------- |
| `loadSettings()` | Loads the settings file (migrating or creating it) and prepares the beautifier options |
| `convertXmlPrefToJson() : Object` | Converts the legacy XML preferences into the new JSON settings object |

## Example

```4d
// Open the settings dialog on the beautifier page
cs.settings.new("beautifier")
```
