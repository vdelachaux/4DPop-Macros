//%attributes = {"invisible":true,"preemptive":"capable"}
C_POINTER:C301($1)

If (False:C215)
	C_POINTER:C301(4DPop_MACROS_SETTINGS; $1)
End if 

CALL WORKER:C1389(1; "SETTINGS")
