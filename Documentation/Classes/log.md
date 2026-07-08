<!-- Shared singleton that writes leveled, timestamped messages to a log file. -->

## Description

`log` is a `shared singleton` used to append leveled, optionally timestamped messages to a text file stored in the component `/LOGS/` folder. Each level (critical, error, warning, event…) prefixes the message with a distinctive marker before writing it. The target file can be set through the `file` computed property, and elapsed time is measured from the singleton's creation. Access it through `cs.log.me`.

## Functions

| Function | Description |
| -------- | ----------- |
| `set file($target)` | Sets the target log file from a `4D.File` or a file name in `/LOGS/` and creates it |
| `echo($message : Text)` | Appends a raw (optionally timestamped) line to the log file |
| `critical($message : Text)` | Logs a message with the critical marker (💣) |
| `error($message : Text)` | Logs a message with the error marker (❌) |
| `warning($message : Text)` | Logs a message with the warning marker (⚠️) |
| `event($message : Text)` | Logs a message with the event marker (➡️) |
| `trace($message : Text)` | Logs a message with the trace marker (📌) |
| `verbose($message : Text)` | Logs a message with the verbose marker (👀) |
| `list($message : Text)` | Logs a message as a list item |
| `in($message : Text)` | Logs an incoming message (←) |
| `out($message : Text)` | Logs an outgoing message (→) |
| `delete($message : Text)` | Logs a deletion message (⌦) |
| `clear()` | Deletes the current log file |
| `startMethod($method : Text)` | Logs the start of a method and stores its name |
| `stopMethod($method : Text)` | Logs the end of a method |
| `get mode() : Text` | Returns `"Compiled"` or `"Interpreted"` for the current execution mode |

## Example

```4d
cs.log.me.file:="session.log"
cs.log.me.startMethod("importData")
cs.log.me.event("Import started")
cs.log.me.warning("Empty record skipped")
cs.log.me.stopMethod("importData")
```
