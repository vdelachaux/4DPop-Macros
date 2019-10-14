//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : xml_attributes
  // Database: 4DPop XLIFF 2
  // ID[CA958A0431C849868A26DB018F13A02F]
  // Created #5-3-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return attibute object for the node $1
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Dom_node;$Txt_name;$Txt_value)
C_OBJECT:C1216($Obj_attributes)

If (False:C215)
	C_OBJECT:C1216(xml_attributes ;$0)
	C_TEXT:C284(xml_attributes ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Dom_node:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_attributes:=New object:C1471
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  //If (Asserted(xml_IsValidReference ($Dom_node)))

For ($Lon_i;1;DOM Count XML attributes:C727($Dom_node);1)
	
	DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_node;$Lon_i;$Txt_name;$Txt_value)
	
	$Obj_attributes[$Txt_name]:=$Txt_value
	
End for 
  //End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_attributes

  // ----------------------------------------------------
  // End