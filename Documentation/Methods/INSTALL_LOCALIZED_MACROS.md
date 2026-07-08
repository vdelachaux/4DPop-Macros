<!-- Installs a localized macro file when the system language differs from the macros' language. -->

## Description

`INSTALL_LOCALIZED_MACROS` reads the language tag embedded in the package's `Macros v2/4DPop_Macros.xml` comment and compares it with the current system localization. If they differ and a localized `4DPop_Macros.xml` document is available, it copies that file over the existing one and reloads the project.

## Example

```4d
INSTALL_LOCALIZED_MACROS()
```
