//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : xml_encode
  // Database: 4D Mobile Express
  // Created #21-11-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:

  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_ref;$Txt_in;$Txt_out)

If (False:C215)
	C_TEXT:C284(xml_encode ;$0)
	C_TEXT:C284(xml_encode ;$1)
End if 


  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

If (Length:C16($Txt_in)=0)
	
	$Txt_out:=$Txt_in
	
Else 
	  // XXX maybe find a 4D method or better ways to xml encode
	
	  // Use DOM api to encode XML
	$Dom_ref:=DOM Create XML Ref:C861("RootElement")
	DOM SET XML ATTRIBUTE:C866($Dom_ref;"test";$Txt_in)
	DOM EXPORT TO VAR:C863($Dom_ref;$Txt_out)
	DOM CLOSE XML:C722($Dom_ref)
	
	  // Extract from result
	$Txt_out:=Substring:C12($Txt_out;Position:C15("test=\"";$Txt_out)+6)
	$Txt_out:=Substring:C12($Txt_out;1;Length:C16($Txt_out)-4)
	
End if 

$0:=$Txt_out