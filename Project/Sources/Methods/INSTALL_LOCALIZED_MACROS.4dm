//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method :  INSTALL_LOCALIZED_MACROS
  // Created 12/05/10 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Tests if the language of the system and the language of the macros are the same.
  // If not, installs a localized file if any
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($i)
C_TEXT:C284($Dom_document;$Dom_root;$t;$Txt_macrosLanguage;$Txt_pattern)
C_OBJECT:C1216($file;$o)

ARRAY LONGINT:C221($tLon_childTypes;0)
ARRAY TEXT:C222($tTxt_nodes;0)
ARRAY TEXT:C222($tTxt_result;0)

  // ----------------------------------------------------
$file:=File:C1566("/PACKAGE/Macros v2/4DPop_Macros.xml").original

If ($file.exists)
	
	$t:=$file.getText()
	
	$Dom_root:=DOM Parse XML variable:C720($t)
	
	If (OK=1)
		
		$Dom_document:=DOM Get XML document ref:C1088($Dom_root)
		
		DOM GET XML CHILD NODES:C1081($Dom_document;$tLon_childTypes;$tTxt_nodes)
		
		Repeat 
			
			$i:=Find in array:C230($tLon_childTypes;XML comment:K45:8;$i+1)
			
			If ($i>0)
				
				If (Rgx_ExtractText ("\\[([^\\]]*)\\]";$tTxt_nodes{$i};"1";->$tTxt_result)=0)
					
					$Txt_macrosLanguage:=$tTxt_result{1}
					$i:=-1
					
				End if 
			End if 
		Until ($i=-1)
		
		DOM CLOSE XML:C722($Dom_root)
		
	End if 
End if 

If ($Txt_macrosLanguage#Get database localization:C1009(User system localization:K5:23))
	
	$o:=File:C1566(Get localized document path:C1105("4DPop_Macros.xml");fk platform path:K87:2)
	
	If (Bool:C1537($o.exists))
		
		$o.copyTo($file.parent;fk overwrite:K87:5)
		
	End if 
End if 