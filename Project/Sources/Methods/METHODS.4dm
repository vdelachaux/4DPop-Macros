//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : Private_Methods - (4DPop Macros)
// ID[EA5BBFB3373B41AC87508A85117393FA]
// Créé le 30/10/12 par Super_Utilisateur
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($Boo_checked)
C_LONGINT:C283($Lon_choice; $Lon_i; $Lon_parameters; $Lon_type; $Lon_x)
C_POINTER:C301($Ptr_)
C_TEXT:C284($Mnu_main; $Mnu_module; $Txt_; $Txt_buffer; $Txt_entryPoint; $Txt_method)
C_TEXT:C284($Txt_tag; $Txt_target)

ARRAY TEXT:C222($tTxt_methods; 0x0000)

If (False:C215)
	C_TEXT:C284(METHODS; $1)
	C_TEXT:C284(METHODS; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_entryPoint:=$1  //Action
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//________________________________________
		//http://forums.4d.fr/Post/FR/13536439/1/13536440#13536440
		//________________________________________
	: ($Txt_entryPoint="new")\
		 & ($Lon_parameters>=2)  // #21-10-2013
		
		$Txt_target:=$2
		
		METHOD GET NAMES:C1166($tTxt_methods; *)
		
		$Txt_buffer:=Replace string:C233(Get localized string:C991("methodN"); "{count}"; String:C10(Size of array:C274($tTxt_methods)))
		
		Repeat 
			
			$Txt_buffer:=Request:C163(Get localized string:C991("methodName"); $Txt_buffer; Get localized string:C991("CommonCreate"))
			
			If (OK=1)
				
				If (Find in array:C230($tTxt_methods; $Txt_buffer)>0)
					
					ALERT:C41(Get localized string:C991("error_AlreadyMethodeWithThatName"))
					
					OK:=0  //GAME OVER…
					
				End if 
				
			Else 
				
				OK:=2  //STOP
				
			End if 
		Until (OK>=1)
		
		If (OK=1)
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $Txt_buffer)
			
			METHOD SET CODE:C1194($Txt_buffer; $Txt_target; *)
			METHOD OPEN PATH:C1213($Txt_buffer; *)
			
		End if 
		
		//________________________________________
	: ($Txt_entryPoint="attributes")\
		 & ($Lon_parameters>=2)
		
		$Txt_target:=$2
		
		$Mnu_main:=Create menu:C408
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Proc_info_invisible"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; String:C10(Attribute invisible:K72:6))
		SET MENU ITEM MARK:C208($Mnu_main; -1; \
			Choose:C955(METHOD Get attribute:C1169($Txt_target; Attribute invisible:K72:6; *); Char:C90(18); ""))
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Proc_info_availableThrough4dHtml"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; String:C10(Attribute published Web:K72:7))
		SET MENU ITEM MARK:C208($Mnu_main; -1; \
			Choose:C955(METHOD Get attribute:C1169($Txt_target; Attribute published Web:K72:7; *); Char:C90(18); ""))
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Proc_info_offeredAsAWebService"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; String:C10(Attribute published SOAP:K72:8))
		$Boo_checked:=METHOD Get attribute:C1169($Txt_target; Attribute published SOAP:K72:8; *)
		SET MENU ITEM MARK:C208($Mnu_main; -1; \
			Choose:C955($Boo_checked; Char:C90(18); ""))
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Proc_info_publishedInWsdl"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; String:C10(Attribute published WSDL:K72:9))
		SET MENU ITEM MARK:C208($Mnu_main; -1; \
			Choose:C955(METHOD Get attribute:C1169($Txt_target; Attribute published WSDL:K72:9; *); Char:C90(18); ""))
		
		If (Not:C34($Boo_checked))
			
			DISABLE MENU ITEM:C150($Mnu_main; -1)
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Proc_info_sharedByComponentsAndHostDatabase"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; String:C10(Attribute shared:K72:10))
		SET MENU ITEM MARK:C208($Mnu_main; -1; \
			Choose:C955(METHOD Get attribute:C1169($Txt_target; Attribute shared:K72:10; *); Char:C90(18); ""))
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Proc_info_availableThroughSql"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; String:C10(Attribute published SQL:K72:11))
		SET MENU ITEM MARK:C208($Mnu_main; -1; \
			Choose:C955(METHOD Get attribute:C1169($Txt_target; Attribute published SQL:K72:11; *); Char:C90(18); ""))
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Proc_info_executeOnServer"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; String:C10(Attribute executed on server:K72:12))
		SET MENU ITEM MARK:C208($Mnu_main; -1; \
			Choose:C955(METHOD Get attribute:C1169($Txt_target; Attribute executed on server:K72:12; *); Char:C90(18); ""))
		
		$Lon_choice:=Num:C11(Dynamic pop up menu:C1006($Mnu_main))
		
		If ($Lon_choice#0)
			
			METHOD SET ATTRIBUTE:C1192($Txt_target; $Lon_choice; \
				Not:C34(METHOD Get attribute:C1169($Txt_target; $Lon_choice; *)); *)
			
		End if 
		
		//________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry Point: \""+$Txt_entryPoint+"\"")
		
		//________________________________________
End case 

// ----------------------------------------------------
// End