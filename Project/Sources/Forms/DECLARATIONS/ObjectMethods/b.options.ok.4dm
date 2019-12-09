OPTIONS_SET (\
(OBJECT Get pointer:C1124(Object named:K67:5;"alphaToText"))->;30;\
(OBJECT Get pointer:C1124(Object named:K67:5;"trimEmptyLines"))->;29;\
(OBJECT Get pointer:C1124(Object named:K67:5;"oneLinePerVariable"))->;28;\
(OBJECT Get pointer:C1124(Object named:K67:5;"projectMethodDirective"))->;27;\
(OBJECT Get pointer:C1124(Object named:K67:5;"generateComments"))->;31)

Preferences ("Set_Value";"ignoreDeclarations";OBJECT Get pointer:C1124(Object named:K67:5;"ignoreDirectives"))
Preferences ("Set_Value";"numberOfVariablePerLine";OBJECT Get pointer:C1124(Object named:K67:5;"variableNumber"))

DECLARATION ("Set_Syntax_Preferences";-><>tLon_Declaration_Types;-><>tTxt_Patterns)
DECLARATION ("Get_Syntax_Preferences")

(OBJECT Get pointer:C1124(Object named:K67:5;"spinner"))->:=1
OBJECT SET VISIBLE:C603(*;"spinner";True:C214)

Form:C1466.refresh()