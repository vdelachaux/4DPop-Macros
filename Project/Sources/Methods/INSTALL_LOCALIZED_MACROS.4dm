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
C_LONGINT:C283($Lon_x)
C_TEXT:C284($Dom_document;$Dom_root;$File_macros;$Txt_localizedLanguage;$Txt_macrosLanguage;$Txt_pattern)

ARRAY LONGINT:C221($tLon_childTypes;0)
ARRAY TEXT:C222($tTxt_nodes;0)
ARRAY TEXT:C222($tTxt_result;0)

  // ----------------------------------------------------
$File_macros:=Get 4D folder:C485(Database folder:K5:14)+"Macros v2"+Folder separator:K24:12+"4DPop_Macros.xml"
RESOLVE ALIAS:C695($File_macros;$File_macros)

$Txt_localizedLanguage:=Get database localization:C1009(User system localization:K5:23)

  // ----------------------------------------------------
If (Test path name:C476($File_macros)=Is a document:K24:1)
	
	$Dom_root:=DOM Parse XML source:C719($File_macros)
	
	If (OK=1)
		
		$Dom_document:=DOM Get XML document ref:C1088($Dom_root)
		
		DOM GET XML CHILD NODES:C1081($Dom_document;$tLon_childTypes;$tTxt_nodes)
		
		Repeat 
			
			$Lon_x:=Find in array:C230($tLon_childTypes;XML comment:K45:8;$Lon_x+1)
			
			If ($Lon_x>0)
				
				$Txt_pattern:="\\[([^\\]]*)\\]"
				
				If (Rgx_ExtractText ($Txt_pattern;$tTxt_nodes{$Lon_x};"1";->$tTxt_result)=0)
					
					$Txt_macrosLanguage:=$tTxt_result{1}
					$Lon_x:=-1
					
				End if 
			End if 
		Until ($Lon_x=-1)
		
		DOM CLOSE XML:C722($Dom_root)
		
	End if 
End if 

If ($Txt_macrosLanguage#$Txt_localizedLanguage)
	
	  // Install the localized macros
	$File_macros:=Get localized document path:C1105("4DPop_Macros.xml")
	
	If (Test path name:C476($File_macros)=Is a document:K24:1)
		
		COPY DOCUMENT:C541($File_macros;$File_macros;*)
		
	End if 
End if 