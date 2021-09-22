//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : Private_CODE_TO_EXECUTE
// ID[AE63DE138BAC461AA60933E0CF35F72A]
// Created 08/10/12 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $Txt_input; $Txt_line; $Txt_method; $Txt_ouput; $Txt_params; $Txt_pattern : Text
var $Txt_result : Text
var $Boo_params; $Boo_result : Boolean
var $Lon_error; $Lon_i; $Lon_parameters : Integer

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	//NO PARAMETERS REQUIRED
	
	ARRAY TEXT:C222($tTxt_lines; 0x0000)
	ARRAY TEXT:C222($tTxt_controlFlow; 0x0000)
	ARRAY TEXT:C222($tTxt_extracted; 0x0000; 0x0000)
	
	//Commands array {
	ARRAY TEXT:C222($tTxt_commands; 0x0000)
	Repeat 
		
		$Lon_i:=$Lon_i+1
		$Txt_line:=Command name:C538($Lon_i)
		
		If (OK=1)
			
			APPEND TO ARRAY:C911($tTxt_commands; $Txt_line)
			
		End if 
		
	Until (OK=0)
	//}
	
	_o_localizedControlFlow(""; ->$tTxt_controlFlow)
	
	For ($Lon_i; 1; Size of array:C274($tTxt_controlFlow); 1)
		
		APPEND TO ARRAY:C911($tTxt_commands; $tTxt_controlFlow{$Lon_i})
		
	End for 
	
	GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $Txt_input)
	
	$Lon_error:=Rgx_SplitText("\\r"; $Txt_input; ->$tTxt_lines; 0 ?+ 11)
	
	$Txt_pattern:="^(?:(.*?):=)?(.*?)(?:\\s*\\(+(.*?)\\))?$"
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

For ($Lon_i; 1; Size of array:C274($tTxt_lines); 1)
	
	$Txt_line:=$tTxt_lines{$Lon_i}
	
	Case of 
			
			//______________________________________
		: (Length:C16($Txt_line)=0) | ($Txt_line="//@")
			
			$Txt_ouput:=$Txt_ouput\
				+$Txt_line
			
			//______________________________________
		Else 
			
			$Lon_error:=Rgx_ExtractText($Txt_pattern; $Txt_line; ""; ->$tTxt_extracted)
			
			If ($Lon_error=0)
				
				$Txt_method:=$tTxt_extracted{1}{2}
				
				If (Find in array:C230($tTxt_commands; $Txt_method)=-1)
					
					$Txt_result:=$tTxt_extracted{1}{1}
					$Boo_result:=(Length:C16($Txt_result)>0)
					
					$Txt_params:=$tTxt_extracted{1}{3}
					$Boo_params:=(Length:C16($Txt_params)>0)
					
					$Txt_ouput:=$Txt_ouput\
						+"//"+$Txt_line\
						+"\r"+$tTxt_commands{1007}\
						+"(\""+$Txt_method+"\""\
						+Choose:C955($Boo_result; ";"+$Txt_result\
						; Choose:C955($Boo_params; ";*"; ""))\
						+Choose:C955($Boo_params; ";"+$Txt_params; "")\
						+")"
					
				Else 
					
					$Txt_ouput:=$Txt_ouput\
						+$Txt_line
					
				End if 
				
			Else 
				
				$Txt_ouput:=$Txt_ouput\
					+$Txt_line
				
			End if 
			
			//______________________________________
	End case 
	
	$Txt_ouput:=$Txt_ouput+"\r"
	
End for 

SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $Txt_ouput)

// ----------------------------------------------------
// End