//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Vincent de Lachaux
  // Date et heure : 02/02/06, 10:11:40
  // ----------------------------------------------------
  // Méthode : M_4DPop_oBoo_INIT
  // ----------------------------------------------------
  // Modified by vdl (01/07/07)
  // v11 compatibility
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (12/05/10)
  // v12
  // ----------------------------------------------------
C_BOOLEAN:C305($0)
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_alert;$Txt_entryPoint)

If (False:C215)
	C_BOOLEAN:C305(Init ;$0)
	C_TEXT:C284(Init ;$1)
End if 

$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>=1)
	
	$Txt_entryPoint:=$1
	
End if 

C_BOOLEAN:C305(<>Private_inited)

Case of 
		
		  // -----------------------------------------------------
	: (<>Private_inited)\
		 & (Not:C34(Shift down:C543))
		
		$Boo_OK:=True:C214
		
		  // -----------------------------------------------------
	: ($Lon_parameters=0)\
		 & (Not:C34(<>Private_inited))
		
		COMPILER_component 
		
		<>Private_inited:=True:C214
		
		INSTALL_LOCALIZED_MACROS 
		
		If (Preferences )
			
			If (Install_regex )
				
				$Boo_OK:=Install_resources 
				
			End if 
		End if 
		
		  // -----------------------------------------------------
End case 

If (Not:C34($Boo_OK))\
 & (Length:C16($Txt_alert)>0)
	
	ALERT:C41($Txt_alert)
	
End if 

$0:=$Boo_OK