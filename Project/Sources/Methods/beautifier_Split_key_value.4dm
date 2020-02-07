//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : beautifier_Split_key_value
  // Database: 4DPop Macros
  // ID[D5F4D977C4BC413CB993A46820F8DB09]
  // Created #27-5-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_LONGINT:C283($2)

C_LONGINT:C283($Lon_closingParenthesis;$Lon_command;$Lon_openParenthesis;$Lon_parameters;$Lon_semicolon;$Lon_x)
C_TEXT:C284($Txt_buffer;$Txt_in;$Txt_out;$Txt_prefix)

If (False:C215)
	C_TEXT:C284(beautifier_Split_key_value ;$0)
	C_TEXT:C284(beautifier_Split_key_value ;$1)
	C_LONGINT:C283(beautifier_Split_key_value ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Txt_in:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		$Lon_command:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
While ($Txt_in[[1]]="\r")
	
	$Txt_prefix:=$Txt_prefix+"\r"
	$Txt_in:=Delete string:C232($Txt_in;1;1)
	
End while 

Case of 
		
		  //#7-4-2017 ___________________________________________
	: ($Lon_command=1471)  //New Object
		
		  //$obj:=OB New (\r
		  //    property ; value ;\r
		  //    property2 ; value2 ;\r
		  //    ...
		  //    propertyN ; valueN )
		
		$Txt_buffer:=Command name:C538($Lon_command)
		
		$Lon_x:=Position:C15($Txt_buffer;$Txt_in)
		$Txt_out:=$Txt_prefix+Substring:C12($Txt_in;1;$Lon_x+Length:C16($Txt_buffer))
		$Txt_in:=Delete string:C232($Txt_in;1;Length:C16($Txt_out)-Length:C16($Txt_prefix))
		$Txt_out:=$Txt_out+"\\\r"
		
		$Lon_x:=Position:C15(";";$Txt_in)
		$Lon_openParenthesis:=Position:C15("(";$Txt_in)  //open parenthesis
		
		If ($Lon_openParenthesis>0)\
			 & ($Lon_openParenthesis<$Lon_x)
			
			$Lon_closingParenthesis:=Position:C15(")";$Txt_in;$Lon_openParenthesis+1)
			$Lon_x:=Position:C15(";";$Txt_in;$Lon_closingParenthesis+1)
			
		End if 
		
		  //go to the second semicolon
		$Lon_x:=Position:C15(";";$Txt_in;$Lon_x+1)
		
		If ($Lon_x>0)
			
			$Txt_out:=$Txt_out+Substring:C12($Txt_in;1;$Lon_x)+"\\\r"
			$Txt_in:=Substring:C12($Txt_in;$Lon_x+1)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_command=1055)  //SVG SET ATTRIBUTE
		
		  //SVG SET ATTRIBUTE ( {* ;} pictureObject ;element_ID ;\r
		  //  attribName ; attribValue ;\r
		  //  attribName2 ; attribValue2 ;\r
		  //  …
		  //  attribNameN ; attribValueN {; *})
		
		$Txt_out:=$Txt_prefix+Command name:C538($Lon_command)+"("
		$Txt_in:=Delete string:C232($Txt_in;1;Length:C16($Txt_out)-Length:C16($Txt_prefix))
		
		If ($Txt_in[[1]]="*")
			
			$Txt_out:=$Txt_out+"*;"
			$Txt_in:=Substring:C12($Txt_in;3)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_command=1220)  //OB SET
		
		  //OB SET ( object ;\r
		  //    property ; value ;\r
		  //    property2 ; value2 ;\r
		  //    ...
		  //    propertyN ; valueN )
		
		$Lon_x:=Position:C15(";";$Txt_in)
		
		If ($Lon_x>0)
			
			$Txt_out:=$Txt_prefix+Substring:C12($Txt_in;1;$Lon_x)+"\\\r"
			$Txt_in:=Substring:C12($Txt_in;$Lon_x+1)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_command=865)  //DOM Create XML element
		
		  //elementRef:=DOM Create XML element(elementRef;xPath;\r
		  //   attribName ; attrValue ;\r
		  //   attribName2 ; attrValue2 ;\r
		  //   ...
		  //   attribNameN ; attrValueN)
		
		$Txt_buffer:=Command name:C538($Lon_command)
		
		$Lon_x:=Position:C15($Txt_buffer;$Txt_in)
		$Txt_out:=$Txt_prefix+Substring:C12($Txt_in;1;$Lon_x+Length:C16($Txt_buffer))
		$Txt_in:=Delete string:C232($Txt_in;1;Length:C16($Txt_out)-Length:C16($Txt_prefix))
		
		$Lon_x:=Position:C15(";";$Txt_in)
		$Lon_openParenthesis:=Position:C15("(";$Txt_in)  //open parenthesis
		
		If ($Lon_openParenthesis>0)\
			 & ($Lon_openParenthesis<$Lon_x)
			
			$Lon_closingParenthesis:=Position:C15(")";$Txt_in;$Lon_openParenthesis+1)
			$Lon_x:=Position:C15(";";$Txt_in;$Lon_closingParenthesis+1)
			
		End if 
		
		  //go to the second semicolon
		$Lon_x:=Position:C15(";";$Txt_in;$Lon_x+1)
		
		If ($Lon_x>0)
			
			$Txt_out:=$Txt_out+Substring:C12($Txt_in;1;$Lon_x)+"\\\r"
			$Txt_in:=Substring:C12($Txt_in;$Lon_x+1)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_command=866)  //DOM SET XML ATTRIBUTE
		
		  //DOM SET XML ATTRIBUTE ( elementRef ;\r
		  //   attribName ; attrValue ;\r
		  //   attribName2 ; attrValue2 ;\r
		  //   ...
		  //   attribNameN ; attrValueN)
		
		$Txt_out:=Command name:C538($Lon_command)+"("
		
		$Txt_in:=Delete string:C232($Txt_in;1;Length:C16($Txt_out))
		
		$Lon_x:=Position:C15(";";$Txt_in)
		$Lon_openParenthesis:=Position:C15("(";$Txt_in)  //open parenthesis
		
		If ($Lon_openParenthesis>0)\
			 & ($Lon_openParenthesis<$Lon_x)
			
			$Lon_closingParenthesis:=Position:C15(")";$Txt_in;$Lon_openParenthesis+1)
			$Lon_x:=Position:C15(";";$Txt_in;$Lon_closingParenthesis+1)
			
		End if 
		
		If ($Lon_x>0)
			
			$Txt_out:=$Txt_prefix+$Txt_out+Substring:C12($Txt_in;1;$Lon_x)+"\\\r"
			$Txt_in:=Substring:C12($Txt_in;$Lon_x+1)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_command=1093)  //ST SET ATTRIBUTES 
		
		  //ST SET ATTRIBUTES ( {*;} object ; stratSel ; endSel ;\r
		  //   attribName ; attrValue ;\r
		  //   attribName2 ; attrValue2 ;\r
		  //   ...
		  //   attribNameN ; attrValueN)
		
		$Txt_out:=$Txt_prefix+Command name:C538($Lon_command)+"("
		$Txt_in:=Delete string:C232($Txt_in;1;Length:C16($Txt_out)-Length:C16($Txt_prefix))
		
		If ($Txt_in[[1]]="*")
			
			$Txt_out:=$Txt_out+"*;"
			$Txt_in:=Substring:C12($Txt_in;3)
			
		End if 
		
		  //object
		$Lon_x:=Position:C15(";";$Txt_in)
		
		$Txt_buffer:=Substring:C12($Txt_in;1;$Lon_x)
		$Txt_out:=$Txt_out+$Txt_buffer
		$Txt_in:=Delete string:C232($Txt_in;1;Length:C16($Txt_buffer))
		
		  //startSel
		$Lon_x:=Position:C15(";";$Txt_in)
		
		$Txt_buffer:=Substring:C12($Txt_in;1;$Lon_x)
		$Txt_out:=$Txt_out+$Txt_buffer
		$Txt_in:=Delete string:C232($Txt_in;1;Length:C16($Txt_buffer))
		
		  //endSel
		$Lon_x:=Position:C15(";";$Txt_in)
		
		$Txt_buffer:=Substring:C12($Txt_in;1;$Lon_x)
		$Txt_out:=$Txt_out+$Txt_buffer+"\\\r"
		$Txt_in:=Delete string:C232($Txt_in;1;Length:C16($Txt_buffer))
		
		  //______________________________________________________
	Else 
		
		  //NOTHING MORE TO DO
		
		  //______________________________________________________
End case 

  //go to the first semicolon
$Lon_x:=beautifier_Next_semicolon ($Txt_in)

If ($Lon_x>0)
	
	$Txt_out:=$Txt_out+Substring:C12($Txt_in;1;$Lon_x)+"\\\r"
	$Txt_in:=Substring:C12($Txt_in;$Lon_x+1)
	
	Repeat 
		
		  //go to the second semicolon
		$Lon_semicolon:=beautifier_Next_semicolon ($Txt_in)
		
		If ($Lon_semicolon>0)
			
			$Txt_out:=$Txt_out+Substring:C12($Txt_in;1;$Lon_semicolon)+"\\\r"
			$Txt_in:=Substring:C12($Txt_in;$Lon_semicolon+1)
			
		Else 
			
			$Txt_out:=$Txt_out+$Txt_in
			
		End if 
	Until ($Lon_x=0)\
		 | ($Lon_semicolon=0)
	
Else 
	
	$Txt_out:=$Txt_out+$Txt_in
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_out

  // ----------------------------------------------------
  // End