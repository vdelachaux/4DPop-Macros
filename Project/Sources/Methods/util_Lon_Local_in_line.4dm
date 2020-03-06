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

C_BOOLEAN:C305($bAdd;$bEscape;$bIgnoreDeclarations;$bStart;$bStop)
C_LONGINT:C283($i;$Lon_error;$Lon_parameters;$Lon_x)
C_POINTER:C301($Ptr_targetArray)
C_TEXT:C284($tDelimitors;$t_line;$Txt_character;$Txt_pattern;$tVariable)

If (False:C215)
	C_LONGINT:C283(util_Lon_Local_in_line )
	C_TEXT:C284(util_Lon_Local_in_line )
	C_POINTER:C301(util_Lon_Local_in_line )
	C_POINTER:C301(util_Lon_Local_in_line )
	C_LONGINT:C283(util_Lon_Local_in_line )
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

$t_line:=$1
$Ptr_targetArray:=$2

If ($Lon_parameters>=4)
	
	$bIgnoreDeclarations:=Bool:C1537($4)
	
End if 

$Ptr_targetArray->:=0

  //#7-4-2017 - Add point for dot notation
$tDelimitors:="({[≤<:=-+#*/\\%&|^?;!§†>≥]})"+Char:C90(Space:K15:42)+Char:C90(44)+"."

If ($t_line[[1]]#"$")  // Alpha Size
	
	$Lon_x:=Position:C15(";";$t_line)
	
	If ($Lon_x>0)
		
		If (str_isNumeric (Substring:C12($t_line;1;$Lon_x-1)))
			
			$0:=Num:C11(Substring:C12($t_line;1;$Lon_x-1))
			$t_line:=Substring:C12($t_line;$Lon_x+1)
			
		End if 
	End if 
End if 

  // Remove Comments
$Txt_pattern:="(?mi-s)(?:\\s*//.*)|(?:\\s*/\\*.*\\*/\\s*)"
$Lon_error:=Rgx_SubstituteText ($Txt_pattern;"";->$t_line)

  // Remove textual values
$Txt_pattern:="(?m-si)(\"[^\"]*\")"
$Lon_error:=Rgx_SubstituteText ($Txt_pattern;"";->$t_line)

  // Remove property
$Txt_pattern:="(?mi-s)\\.[^-+*/\\\\%&|^?;!(){}[\\}<>:=]+"
$Lon_error:=Rgx_SubstituteText ($Txt_pattern;"";->$t_line)

  // ----------------------------------------------------
For ($i;1;Length:C16($t_line);1)
	
	$Txt_character:=$t_line[[$i]]
	
	Case of 
			
			  //  //______________________________________________________
			  //: ($Txt_buffer[[$Lon_i]]="/")\
				& (Not($bEscape))
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
			
			$bStart:=True:C214
			$Ptr_targetArray->{0}:=""
			
			  //______________________________________________________
		: ($Txt_character="{")\
			 & ($Ptr_targetArray->{0}="$")  //Start parameter indirection syntax
			
			  //______________________________________________________
		: ($Txt_character="}")\
			 & ($Ptr_targetArray->{0}="${@")  //Stop parameter indirection syntax
			
			  //______________________________________________________
		: ($bStart)
			
			$bStop:=(Position:C15($Txt_character;$tDelimitors)#0)
			
			  // #16-2-2018 - skeep the next character to allo Obj.$key
			$i:=$i+Num:C11($Txt_character=".")
			
			  //______________________________________________________
	End case 
	
	Case of 
			
			  //______________________________________________________
			  //: ($Boo_escape)
			
			  //______________________________________________________
		: ($bStop)
			
			$tVariable:=$Ptr_targetArray->{0}
			
			Case of 
					
					  //……………………………………
				: (Length:C16($tVariable)<2)
					
					  //……………………………………
				: (Find in array:C230($Ptr_targetArray->;$tVariable)>0)
					
					$Lon_x:=Find in array:C230($Ptr_targetArray->;$tVariable)
					
					  //……………………………………
				Else 
					
					If ($bIgnoreDeclarations)
						
						$tVariable:=Delete string:C232($tVariable;1;1)
						$tVariable:=Replace string:C233($tVariable;"{";"")
						$tVariable:=Replace string:C233($tVariable;"}";"")
						
						$bAdd:=str_isNumeric ($tVariable)
						
					Else 
						
						$bAdd:=True:C214
						
					End if 
					
					If ($bAdd)
						
						APPEND TO ARRAY:C911($Ptr_targetArray->;$Ptr_targetArray->{0})
						$Lon_x:=Size of array:C274($Ptr_targetArray->)
						
						If ($Lon_parameters>=3)
							
							If (Find in array:C230($3->;$tVariable)=-1)
								
								APPEND TO ARRAY:C911($3->;$Ptr_targetArray->{0})
								
							End if 
						End if 
					End if 
					
					  //……………………………………
			End case 
			
			$bStart:=False:C215
			$bStop:=False:C215
			
			If ($Ptr_targetArray->=0)
				
				$Ptr_targetArray->:=$Lon_x
				
			End if 
			
			$Ptr_targetArray->{0}:=""
			
			  //______________________________________________________
		: ($bStart)
			
			$Ptr_targetArray->{0}:=$Ptr_targetArray->{0}+$Txt_character
			
			  //______________________________________________________
	End case 
End for 

If ($bStart)
	
	$tVariable:=$Ptr_targetArray->{0}
	
	Case of 
			
			  //……………………………………
		: (Length:C16($tVariable)<2)
			
			  //……………………………………
		: (Find in array:C230($Ptr_targetArray->;$tVariable)>0)
			
			$Lon_x:=Find in array:C230($Ptr_targetArray->;$tVariable)
			
			  //……………………………………
		Else 
			
			If ($bIgnoreDeclarations)
				
				$tVariable:=Delete string:C232($tVariable;1;1)
				$tVariable:=Replace string:C233($tVariable;"{";"")
				$tVariable:=Replace string:C233($tVariable;"}";"")
				
				$bAdd:=str_isNumeric ($tVariable)
				
			Else 
				
				$bAdd:=True:C214
				
			End if 
			
			If ($bAdd)
				
				APPEND TO ARRAY:C911($Ptr_targetArray->;$Ptr_targetArray->{0})
				$Lon_x:=Size of array:C274($Ptr_targetArray->)
				
				If (Count parameters:C259>2)
					
					If (Find in array:C230($3->;$tVariable)=-1)
						
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