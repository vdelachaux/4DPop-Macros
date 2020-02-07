//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : xml_refToObject
  // Database: 4D Mobile Express
  // ID[422011C36CAB45BDB84131B8A31AC0D0]
  // Created #1-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns an XML tree reference as an object
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_references)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_rootReference;$Txt_name)
C_OBJECT:C1216($Obj_result)

If (False:C215)
	C_OBJECT:C1216(xml_refToObject ;$0)
	C_TEXT:C284(xml_refToObject ;$1)
	C_BOOLEAN:C305(xml_refToObject ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Dom_rootReference:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Boo_references:=$2
		
	End if 
	
	$Obj_result:=New object:C1471
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
DOM GET XML ELEMENT NAME:C730($Dom_rootReference;$Txt_name)
$Obj_result[$Txt_name]:=xml_elementToObject ($Dom_rootReference;$Boo_references)

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End