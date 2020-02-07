//%attributes = {}
  // ----------------------------------------------------
  // Project method : macro
  // ID[E9112C04084E4605AEB7BC7D0FD3E53B]
  // Created 9-9-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($l;$ll)
C_TEXT:C284($t)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

ARRAY LONGINT:C221($tLon_lengths;0)
ARRAY LONGINT:C221($tLon_positions;0)

If (False:C215)
	C_OBJECT:C1216(macro ;$0)
	C_TEXT:C284(macro ;$1)
	C_OBJECT:C1216(macro ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)  // Constructor
	
	If (Count parameters:C259>0)
		
		$t:=String:C10($1)
		
	End if 
	
	$o:=New object:C1471(\
		"_is";"macro";\
		"name";$t;\
		"method";"";\
		"highlighted";"";\
		"success";True:C214;\
		"choose";Formula:C1597(macro ("choose"));\
		"color";Formula:C1597(macro ("color"));\
		"swapPasteboard";Formula:C1597(macro ("swapPasteboard"))\
		)
	
	GET MACRO PARAMETER:C997(Full method text:K5:17;$t)
	$o.method:=$t
	
	GET MACRO PARAMETER:C997(Highlighted method text:K5:18;$t)
	$o.highlighted:=$t
	
	PROCESS PROPERTIES:C336(Current process:C322;$t;$l;$l)
	
	$o.process:=($t="Macro_Call")
	
Else 
	
	$o:=This:C1470
	
	Case of 
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="swapPasteboard")
			
			$t:=Get text from pasteboard:C524  // Get the text content of the clipboard
			$o.success:=(Length:C16($t)>0)
			
			If ($o.success)
				
				  // Put the highlighted text on the clipboard… 
				CLEAR PASTEBOARD:C402
				SET TEXT TO PASTEBOARD:C523($o.highlighted)
				
				  // …and replace it with the previous one.
				SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$t)
				
			End if 
			
			  //______________________________________________________
		: ($1="color")
			
			$l:=Select RGB color:C956($l)
			
			If (OK=1)
				
				$t:=String:C10($l & 0x00FFFFFF;"&x")+kCaret
				
				SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$t)
				
			End if 
			
			  //______________________________________________________
		: (Length:C16($o.highlighted)=0)  // ALL THE MACROS BELOW NEED A SELECTION
			
			  //______________________________________________________
		: ($1="choose")
			
			$c:=Split string:C1554($o.highlighted;"\r";sk trim spaces:K86:2+sk ignore empty strings:K86:1)
			$o.success:=($c.length=5)
			
			If ($o.success)
				
				ARRAY LONGINT:C221($tLon_positions;0x0000)
				ARRAY LONGINT:C221($tLon_lengths;0x0000)
				
				If (Match regex:C1019(Choose:C955(Command name:C538(1)="Sum";"If";"Si")+"\\s*\\(([^\\)]*)\\).*";$c[0];1;$tLon_positions;$tLon_lengths))
					
					$l:=Position:C15(":=";$c[1])
					
					If ($l>0)
						
						$ll:=Position:C15(":=";$c[3])
						
						If ($ll>0)
							
							$t:=Substring:C12($c[1];1;$l-1)\
								+":="\
								+Command name:C538(955)\
								+"("\
								+Substring:C12($c[0];$tLon_positions{1};$tLon_lengths{1})\
								+";"\
								+Substring:C12($c[1];$l+2)\
								+";"\
								+Substring:C12($c[3];$ll+2)\
								+")"
							
							SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$t)
							
						End if 
					End if 
				End if 
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End