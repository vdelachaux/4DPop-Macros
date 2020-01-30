//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : beautifier_Next_semicolon
  // Database: 4DPop Macros
  // ID[C958A9013881477F9E17E6A3FB51101B]
  // Created #29-5-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_closingParenthesis;$Lon_openParenthesis;$Lon_parameters;$Lon_semicolon;$Lon_x)
C_TEXT:C284($Txt_in)

If (False:C215)
	C_LONGINT:C283(beautifier_Next_semicolon ;$0)
	C_TEXT:C284(beautifier_Next_semicolon ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Txt_in:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  //first semicolon
$Lon_x:=Position:C15(";";$Txt_in)

  //second semicolon
$Lon_semicolon:=Position:C15(";";$Txt_in;$Lon_x+1)

  //open parenthesis
$Lon_openParenthesis:=Position:C15("(";$Txt_in)

If ($Lon_semicolon>0)\
 & ($Lon_openParenthesis>0)\
 & ($Lon_semicolon>$Lon_openParenthesis)
	
	Repeat 
		
		  //closing parenthesis
		$Lon_closingParenthesis:=Position:C15(")";$Txt_in;$Lon_openParenthesis+1)
		
		  //next semicolon
		$Lon_semicolon:=Position:C15(";";$Txt_in;$Lon_closingParenthesis+1)
		
		  //next opening parenthesis
		$Lon_openParenthesis:=Position:C15("(";$Txt_in;$Lon_closingParenthesis+1)
		
	Until ($Lon_openParenthesis>$Lon_semicolon)\
		 | ($Lon_openParenthesis=0)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Lon_semicolon

  // ----------------------------------------------------
  // End 