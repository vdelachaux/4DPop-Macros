OPTIONS_SET(\
(OBJECT Get pointer:C1124(Object named:K67:5; "alphaToText"))->; 30; \
(OBJECT Get pointer:C1124(Object named:K67:5; "trimEmptyLines"))->; 29; \
(OBJECT Get pointer:C1124(Object named:K67:5; "oneLinePerVariable"))->; 28; \
(OBJECT Get pointer:C1124(Object named:K67:5; "projectMethodDirective"))->; 27; \
(OBJECT Get pointer:C1124(Object named:K67:5; "generateComments"))->; 31)

_o_Preferences("Set_Value"; "ignoreDeclarations"; OBJECT Get pointer:C1124(Object named:K67:5; "ignoreDirectives"))
_o_Preferences("Set_Value"; "numberOfVariablePerLine"; OBJECT Get pointer:C1124(Object named:K67:5; "variableNumber"))

_o_DECLARATION("Set_Syntax_Preferences"; -><>tLon_Declaration_Types; -><>tTxt_Patterns)
_o_DECLARATION("Get_Syntax_Preferences")

(OBJECT Get pointer:C1124(Object named:K67:5; "spinner"))->:=1
OBJECT SET VISIBLE:C603(*; "spinner"; True:C214)

CALL FORM:C1391(Current form window:C827; "DECLARATION"; "INIT")