//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method :  util_Lon_Local_in_line
  // Created 28/12/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Extract locals variables from $1 an put them in $2 array
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (12/05/10)
  // v12 bug fix with character " in first position of a line
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)
C_TEXT:C284($1)
C_POINTER:C301($2)
C_POINTER:C301($3)
C_LONGINT:C283($4)

C_BOOLEAN:C305($Boo_add;$Boo_escape;$Boo_start;$Boo_stop)
C_LONGINT:C283($Lon_error;$Lon_i;$Lon_ignoreDeclarations;$Lon_parameters;$Lon_size;$Lon_x)
C_POINTER:C301($Ptr_targetArray)
C_TEXT:C284($kTxt_delimitors;$Txt_buffer;$Txt_character;$Txt_pattern;$Txt_variableName)

If (False:C215)
	C_LONGINT:C283(util_Lon_Local_in_line ;$0)
	C_TEXT:C284(util_Lon_Local_in_line ;$1)
	C_POINTER:C301(util_Lon_Local_in_line ;$2)
	C_POINTER:C301(util_Lon_Local_in_line ;$3)
	C_LONGINT:C283(util_Lon_Local_in_line ;$4)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

$Txt_buffer:=$1
$Ptr_targetArray:=$2

If ($Lon_parameters>=4)
	
	$Lon_ignoreDeclarations:=$4
	
End if 

$Ptr_targetArray->:=0

  //#7-4-2017 - ready for dot notation {
  //$kTxt_delimitors:="({[≤<:=-+#*/\\%&|^?;!§†>≥]})"+Char(Space)+Char(44)
$kTxt_delimitors:="({[≤<:=-+#*/\\%&|^?;!§†>≥]})"+Char:C90(Space:K15:42)+Char:C90(44)+"."
  //}

If ($Txt_buffer[[1]]#"$")  // Alpha Size
	
	$Lon_x:=Position:C15(";";$Txt_buffer)
	
	If ($Lon_x>0)
		
		If (str_isNumeric (Substring:C12($Txt_buffer;1;$Lon_x-1)))
			
			$0:=Num:C11(Substring:C12($Txt_buffer;1;$Lon_x-1))
			$Txt_buffer:=Substring:C12($Txt_buffer;$Lon_x+1)
			
		End if 
	End if 
End if 

  // Remove Comments
$Txt_pattern:="(?m-si)(//.*$)"
$Lon_error:=Rgx_SubstituteText ($Txt_pattern;"";->$Txt_buffer)

  // Remove textual values
$Txt_pattern:="(?m-si)(\"[^\"]*\")"
$Lon_error:=Rgx_SubstituteText ($Txt_pattern;"";->$Txt_buffer)

$Lon_size:=Length:C16($Txt_buffer)

  // ----------------------------------------------------
For ($Lon_i;1;$Lon_size;1)
	
	$Txt_character:=$Txt_buffer[[$Lon_i]]
	
	Case of 
			
			  //  //______________________________________________________
			  //: ($Txt_buffer[[$Lon_i]]="/")\
								& (Not($Boo_escape))
			  //If ($Txt_buffer[[$Lon_i+1]]="/")  // Comment
			  //$Boo_escape:=True
			  //$Lon_i:=$Lon_size+1
			  //Else
			  //  // Delimitor
			  //$Boo_stop:=True
			  //End if
			  //  //______________________________________________________
			  //: (Character code($Txt_character)=Double quote)
			  //If ($Lon_i=1)
			  //$Boo_escape:=Not($Boo_escape)
			  //$Txt_character:=""
			  //Else
			  //If ($Txt_buffer[[$Lon_i-1]]#"\\")
			  //$Boo_escape:=Not($Boo_escape)
			  //$Txt_character:=""
			  //End if
			  //End if
			
			  //______________________________________________________
		: (Character code:C91($Txt_character)=36)  //$
			
			$Boo_start:=True:C214
			$Ptr_targetArray->{0}:=""
			
			  //______________________________________________________
		: ($Txt_character="{")\
			 & ($Ptr_targetArray->{0}="$")  //Start parameter indirection syntax
			
			  //______________________________________________________
		: ($Txt_character="}")\
			 & ($Ptr_targetArray->{0}="${@")  //Stop parameter indirection syntax
			
			  //______________________________________________________
		: ($Boo_start)
			
			$Boo_stop:=(Position:C15($Txt_character;$kTxt_delimitors)#0)
			
			  // #16-2-2018 - skeep the next character to allo Obj.$key
			$Lon_i:=$Lon_i+Num:C11($Txt_character=".")
			
			  //______________________________________________________
	End case 
	
	Case of 
			
			  //______________________________________________________
			  //: ($Boo_escape)
			
			  //______________________________________________________
		: ($Boo_stop)
			
			$Txt_variableName:=$Ptr_targetArray->{0}
			
			Case of 
					
					  //……………………………………
				: (Length:C16($Txt_variableName)<2)
					
					  //……………………………………
				: (Find in array:C230($Ptr_targetArray->;$Txt_variableName)>0)
					
					$Lon_x:=Find in array:C230($Ptr_targetArray->;$Txt_variableName)
					
					  //……………………………………
				Else 
					
					If ($Lon_ignoreDeclarations=1)
						
						$Txt_variableName:=Delete string:C232($Txt_variableName;1;1)
						$Txt_variableName:=Replace string:C233($Txt_variableName;"{";"")
						$Txt_variableName:=Replace string:C233($Txt_variableName;"}";"")
						
						$Boo_add:=str_isNumeric ($Txt_variableName)
						
					Else 
						
						$Boo_add:=True:C214
						
					End if 
					
					If ($Boo_add)
						
						APPEND TO ARRAY:C911($Ptr_targetArray->;$Ptr_targetArray->{0})
						$Lon_x:=Size of array:C274($Ptr_targetArray->)
						
						If ($Lon_parameters>=3)
							
							If (Find in array:C230($3->;$Txt_variableName)=-1)
								
								APPEND TO ARRAY:C911($3->;$Ptr_targetArray->{0})
								
							End if 
						End if 
					End if 
					
					  //……………………………………
			End case 
			
			$Boo_start:=False:C215
			$Boo_stop:=False:C215
			
			If ($Ptr_targetArray->=0)
				
				$Ptr_targetArray->:=$Lon_x
				
			End if 
			
			$Ptr_targetArray->{0}:=""
			
			  //______________________________________________________
		: ($Boo_start)
			
			$Ptr_targetArray->{0}:=$Ptr_targetArray->{0}+$Txt_character
			
			  //______________________________________________________
	End case 
End for 

If ($Boo_start)
	
	$Txt_variableName:=$Ptr_targetArray->{0}
	
	Case of 
			
			  //……………………………………
		: (Length:C16($Txt_variableName)<2)
			
			  //……………………………………
		: (Find in array:C230($Ptr_targetArray->;$Txt_variableName)>0)
			
			$Lon_x:=Find in array:C230($Ptr_targetArray->;$Txt_variableName)
			
			  //……………………………………
		Else 
			
			If ($Lon_ignoreDeclarations=1)
				
				$Txt_variableName:=Delete string:C232($Txt_variableName;1;1)
				$Txt_variableName:=Replace string:C233($Txt_variableName;"{";"")
				$Txt_variableName:=Replace string:C233($Txt_variableName;"}";"")
				
				$Boo_add:=str_isNumeric ($Txt_variableName)
				
			Else 
				
				$Boo_add:=True:C214
				
			End if 
			
			If ($Boo_add)
				
				APPEND TO ARRAY:C911($Ptr_targetArray->;$Ptr_targetArray->{0})
				$Lon_x:=Size of array:C274($Ptr_targetArray->)
				
				If (Count parameters:C259>2)
					
					If (Find in array:C230($3->;$Txt_variableName)=-1)
						
						APPEND TO ARRAY:C911($3->;$Ptr_targetArray->{0})
						
					End if 
				End if 
			End if 
			
			  //……………………………………
	End case 
	
	If ($Ptr_targetArray->=0)
		
		$Ptr_targetArray->:=$Lon_x
		
	End if 
End if 

$Ptr_targetArray->{0}:=""