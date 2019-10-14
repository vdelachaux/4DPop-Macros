//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : xml_fileToObject
  // Database: 4D Mobile Express
  // ID[0C9EE89768224AA19AEA2AFC14789A8E]
  // Created #2-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns an XML document as an object
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_references)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_root;$File_pathname)
C_OBJECT:C1216($Obj_result)

If (False:C215)
	C_OBJECT:C1216(xml_fileToObject ;$0)
	C_TEXT:C284(xml_fileToObject ;$1)
	C_BOOLEAN:C305(xml_fileToObject ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$File_pathname:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Boo_references:=$2
		
	End if 
	
	$Obj_result:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Test path name:C476($File_pathname)=Is a document:K24:1)
	
	$Dom_root:=DOM Parse XML source:C719($File_pathname)
	
	If (OK=1)
		
		$Obj_result:=New object:C1471(\
			"success";True:C214;\
			"value";xml_refToObject ($Dom_root;$Boo_references))
		
		DOM CLOSE XML:C722($Dom_root)
		
	Else 
		
		$Obj_result.errors:=New collection:C1472("Failed to parse")
		
	End if 
	
Else 
	
	$Obj_result.errors:=New collection:C1472("File "+$File_pathname+" is not a document")
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End