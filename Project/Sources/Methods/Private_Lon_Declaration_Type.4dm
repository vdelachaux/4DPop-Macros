//%attributes = {"invisible":true,"preemptive":"incapable"}
//_____________________________________________________
// Méthode : private_Lon_Declaration_Type
// Created 1/03/05 par Vincent de Lachaux
//_____________________________________________________
// Modified by vdl (23/10/07)
// Syntaxe preferences implementation
//_____________________________________________________
var $0 : Integer
var $1 : Text
var $2 : Pointer

var $Txt_pattern; $Txt_target : Text
var $Lon_error; $Lon_i; $Lon_j; $Lon_type : Integer


ARRAY TEXT:C222($tTxt_values; 0)

$Txt_target:=$1

For ($Lon_i; 1; Size of array:C274(<>tTxt_2D_Declaration_Patterns); 1)
	
	For ($Lon_j; 1; Size of array:C274(<>tTxt_2D_Declaration_Patterns{$Lon_i}); 1)
		
		$Txt_pattern:=<>tTxt_2D_Declaration_Patterns{$Lon_i}{$Lon_j}
		
		If (Match regex:C1019($Txt_pattern; Substring:C12($Txt_target; 2); 1))
			
			$Lon_type:=<>tLon_Declaration_Types{$Lon_i}
			
			If (Count parameters:C259>=2)
				
				If ($Lon_type=1)\
					 | ($Lon_type=101)
					
					If (Position:C15("("; $Txt_pattern)>0)
						
						$Lon_error:=_o_Rgx_ExtractText($Txt_pattern; $Txt_target; "1"; ->$tTxt_values)
						
						If ($Lon_error=0)
							
							$2->:=Num:C11($tTxt_values{1})
							
						End if 
					End if 
				End if 
			End if 
			
			$Lon_j:=MAXINT:K35:1
			$Lon_i:=MAXINT:K35:1
			
		End if 
	End for 
End for 

$0:=$Lon_type