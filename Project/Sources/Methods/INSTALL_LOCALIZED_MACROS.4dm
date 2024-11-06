//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method :  INSTALL_LOCALIZED_MACROS
// Created 12/05/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Tests if the language of the system and the language of the macros are the same.
// If not, installs a localized file if any
// ----------------------------------------------------
// Declarations
var $content; $language; $root : Text
var $i : Integer
var $file; $src : 4D:C1709.File

ARRAY TEXT:C222($nodes; 0)
ARRAY TEXT:C222($results; 0)
ARRAY LONGINT:C221($childTypes; 0)

$file:=File:C1566("/PACKAGE/Macros v2/4DPop_Macros.xml")

If ($file.original#Null:C1517)
	
	$file:=$file.original
	
End if 

If ($file.exists)
	
	$content:=$file.getText()
	$root:=DOM Parse XML variable:C720($content)
	
	If (OK=1)
		
		DOM GET XML CHILD NODES:C1081(DOM Get XML document ref:C1088($root); $childTypes; $nodes)
		
		Repeat 
			
			$i:=Find in array:C230($childTypes; XML comment:K45:8; $i+1)
			
			If ($i>0)
				
				If (_o_Rgx_ExtractText("\\[([^\\]]*)\\]"; $nodes{$i}; "1"; ->$results)=0)
					
					$language:=$results{1}
					break
					
				End if 
			End if 
		Until ($i=-1)
		
		DOM CLOSE XML:C722($root)
		
	End if 
End if 

If ($language#Get database localization:C1009(User system localization:K5:23))
	
	$src:=File:C1566(Localized document path:C1105("4DPop_Macros.xml"); fk platform path:K87:2)
	
	If (Bool:C1537($src.exists))
		
		$src.copyTo($file.parent; fk overwrite:K87:5)
		RELOAD PROJECT:C1739
		
	End if 
End if 