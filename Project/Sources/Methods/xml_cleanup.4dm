//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_cleanup
  // Database: 4DPop Macros
  // ID[3CD250E652004FC2A198FAE87ABCA0C1]
  // Created #20-2-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Clean Up an indented XML file
  // Removes the extra lines feeds and the carriage returns
  // added by 4D when we perform removing/adding elements
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_LONGINT:C283($2)

C_LONGINT:C283($Lon_indent;$Lon_parameters)
C_TEXT:C284($Dom_root;$Txt_buffer)

If (False:C215)
	C_TEXT:C284(xml_cleanup ;$0)
	C_TEXT:C284(xml_cleanup ;$1)
	C_LONGINT:C283(xml_cleanup ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Dom_root:=$1  //reference of the xml to format
	
	$Lon_indent:=XML with indentation:K45:35
	
	If ($Lon_parameters>=2)
		
		$Lon_indent:=$2  //{indentation} XML with indentation (default), XML No indentation
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
XML SET OPTIONS:C1090($Dom_root;XML indentation:K45:34;$Lon_indent)

DOM EXPORT TO VAR:C863($Dom_root;$Txt_buffer)
DOM CLOSE XML:C722($Dom_root)

$Txt_buffer:=Replace string:C233($Txt_buffer;"\r\n";"")
$Txt_buffer:=Replace string:C233($Txt_buffer;"\n";"")
$Txt_buffer:=Replace string:C233($Txt_buffer;"\r";"")
$Txt_buffer:=Replace string:C233($Txt_buffer;"\t";"")

While (Position:C15("  ";$Txt_buffer)>0)
	
	$Txt_buffer:=Replace string:C233($Txt_buffer;"  ";" ")
	
End while 

$Txt_buffer:=Replace string:C233($Txt_buffer;"> <";"><")

$Dom_root:=DOM Parse XML variable:C720($Txt_buffer)

$0:=$Dom_root  //Warning: A new reference for the clean XML

  // ----------------------------------------------------
  // End 