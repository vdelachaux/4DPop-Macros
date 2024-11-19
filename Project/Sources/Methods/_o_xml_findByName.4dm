//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : xml_findByName
// Database: 4D Mobile App
// ID[0C9EE897E822EAA19AEA2AFC14789A8E]
// ----------------------------------------------------
// Description:
// Returns all dom elements with specific name
// ----------------------------------------------------
// Declarations
_O_C_COLLECTION:C1488($0)
_O_C_TEXT:C284($1)
_O_C_TEXT:C284($2)

_O_C_LONGINT:C283($Lon_parameters)
_O_C_TEXT:C284($Dom_child; $Dom_elementRef; $Txt_name; $Txt_nameToFind)
_O_C_COLLECTION:C1488($Col_result)

If (False:C215)
	_O_C_COLLECTION:C1488(_o_xml_findByName; $0)
	_O_C_TEXT:C284(_o_xml_findByName; $1)
	_O_C_TEXT:C284(_o_xml_findByName; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2; "Missing parameter"))
	
	$Dom_elementRef:=$1
	$Txt_nameToFind:=$2
	
	$Col_result:=New collection:C1472
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

// Childs if any {
$Dom_child:=DOM Get first child XML element:C723($Dom_elementRef; $Txt_name)

While (OK=1)
	
	If ($Txt_name=$Txt_nameToFind)
		
		$Col_result.push($Dom_child)
		
	End if 
	
	$Col_result:=$Col_result.combine(_o_xml_findByName($Dom_child; $Txt_nameToFind))  // <======= RECURSIVE
	
	// Next one, if any
	$Dom_child:=DOM Get next sibling XML element:C724($Dom_child; $Txt_name)
	
End while 

// ----------------------------------------------------
// Return
$0:=$Col_result

// ----------------------------------------------------
// End