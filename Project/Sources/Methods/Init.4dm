//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Nom utilisateur (OS) : Vincent de Lachaux
// Date et heure : 02/02/06, 10:11:40
// ----------------------------------------------------
// Méthode : M_4DPop_oBoo_INIT
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
	
	COMPILER_component
	
	INSTALL_LOCALIZED_MACROS
	
	If (_o_Preferences)
		
		If (Install_regex)
			
			return Install_resources
			
		End if 
	End if 
	
	Use (Storage:C1525.component)
		
		Storage:C1525.component.inited:=True:C214
		
	End use 
End if 