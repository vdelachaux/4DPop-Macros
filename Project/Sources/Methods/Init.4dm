//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// User name (OS): Vincent de Lachaux
// Date and time: 02/02/06, 10:11:40
// ----------------------------------------------------
// Method: M_4DPop_oBoo_INIT
// ----------------------------------------------------
// Modified by vdl (01/07/07)
// V11 compatibility
// ----------------------------------------------------
// Modified by Vincent de Lachaux (12/05/10)
// V12
// ----------------------------------------------------
#DECLARE() : Boolean

If (Storage:C1525.component=Null:C1517)
	
	Use (Storage:C1525)
		
		Storage:C1525.component:=New shared object:C1526("inited"; False:C215)
		
	End use 
End if 

If (Storage:C1525.component.inited)
	
	return True:C214
	
End if 

If (Count parameters:C259=0)\
 && (Not:C34(Storage:C1525.component.inited))
	

	If (Storage:C1525.macros=Null:C1517)  // Holds the dispatcher's lastUsed action
		
		Use (Storage:C1525)
			
			Storage:C1525.macros:=New shared object:C1526("lastUsed"; "")
			
		End use 
		
	End if 
	
	If (cs:C1710.preferences.me.loaded)
		
		return Install_resources
		
	End if 
	
	Use (Storage:C1525.component)
		
		Storage:C1525.component.inited:=True:C214
		
	End use 
End if 