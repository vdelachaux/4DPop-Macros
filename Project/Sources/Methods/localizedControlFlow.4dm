//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : localizedControlFlow
  // ID[02A8ABB2DFC04C12B2514A4D2E7D0916]
  // Created 13/07/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // With the version 11 it's not possible to read the 4D Application STR# ID 42.
  // There is no command who returns a localized string for the control flow structure.
  // Give the english name of the the control flow to this function, the return will be the localized.
  // Give an array pointer, the array will be filled with the control flow structures.
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_POINTER:C301($2)
C_POINTER:C301($3)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($File_resources)
C_OBJECT:C1216($Obj_controlFlow)
ARRAY TEXT:C222($tTxt_FR;0)
ARRAY TEXT:C222($tTxt_tag;0)
ARRAY TEXT:C222($tTxt_US;0)

If (False:C215)
	C_TEXT:C284(localizedControlFlow ;$0)
	C_TEXT:C284(localizedControlFlow ;$1)
	C_POINTER:C301(localizedControlFlow ;$2)
	C_POINTER:C301(localizedControlFlow ;$3)
End if 

$Lon_parameters:=Count parameters:C259
$File_resources:=Get 4D folder:C485(Current resources folder:K5:16)+"controlFlow.json"

If (Asserted:C1132(Test path name:C476($File_resources)=Is a document:K24:1;"missing file: "+$File_resources))
	
	$Obj_controlFlow:=JSON Parse:C1218(Document to text:C1236($File_resources))
	
	  //%W-518.1 - Pointer in COPY ARRAY
	If (Command name:C538(41)="ALERT")  // US
		
		If ($Lon_parameters>=2)
			
			COLLECTION TO ARRAY:C1562($Obj_controlFlow.intl;$tTxt_US)
			COPY ARRAY:C226($tTxt_US;$2->)
			
		Else 
			
			$0:=$1
			
		End if 
		
	Else 
		
		If ($Lon_parameters>=2)
			
			COLLECTION TO ARRAY:C1562($Obj_controlFlow.fr;$tTxt_FR)
			COPY ARRAY:C226($tTxt_FR;$2->)
			
		Else 
			
			COLLECTION TO ARRAY:C1562($Obj_controlFlow.intl;$tTxt_US)
			$0:=$tTxt_FR{Find in array:C230($tTxt_US;$1)}
			
		End if 
	End if 
	
	If ($Lon_parameters>=3)
		
		COLLECTION TO ARRAY:C1562($Obj_controlFlow.tag;$tTxt_tag)
		COPY ARRAY:C226($tTxt_tag;$3->)
		
	End if 
	  //%W+518.1
	
End if 