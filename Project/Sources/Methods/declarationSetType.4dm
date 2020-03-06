//%attributes = {}
C_LONGINT:C283($lRef;$lType)
C_POINTER:C301($ptr)
C_TEXT:C284($t)

$ptr:=This:C1470.list
GET LIST ITEM:C378($ptr->;*;$lRef;$t)

$lType:=Num:C11(OBJECT Get name:C1087(Object current:K67:2))\
+(100*(OBJECT Get pointer:C1124(Object named:K67:5;"array.NotParameter"))->)\
+(1000*Num:C11(Match regex:C1019("(?m-si)\\$(?:(?:\\d+)|(?:\\{\\d*\\})+)";$t;1)))

SET LIST ITEM PARAMETER:C986($ptr->;$lRef;"type";$lType)

If ($lType=1)\
 | ($lType=101)\
 | ($lType=1001)  // String [COMPATIBILITY]
	
	GET LIST ITEM PARAMETER:C985($ptr->;$lRef;"size";$t)
	(OBJECT Get pointer:C1124(Object named:K67:5;"Alpha_Length"))->:=$t
	
End if 

This:C1470.refresh()