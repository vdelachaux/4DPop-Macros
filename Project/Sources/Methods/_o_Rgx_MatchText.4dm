//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : Rgx_MatchText
// Created 28/09/07 by Vincent
// ----------------------------------------------------
// Description
// Alias "QF_REMatchText"
// ----------------------------------------------------
// Paramètres
// $1 = Regular expression
// $2 = Target text
// $3 = {Array of matches (Pointer)}
// $4 = {Regular expression flags}
// $0 = Error result
// ----------------------------------------------------
_O_C_LONGINT:C283($0)
_O_C_TEXT:C284($1)
_O_C_TEXT:C284($2)
_O_C_POINTER:C301($3)
_O_C_LONGINT:C283($4)

_O_C_BOOLEAN:C305($Boo_OK)
_O_C_LONGINT:C283($Lon_i; $Lon_Options; $Lon_Parameters; $Lon_Size; $Lon_Start)
_O_C_POINTER:C301($Ptr_Array)
_O_C_TEXT:C284($Txt_Buffer; $Txt_Error_Method; $Txt_Pattern; $Txt_Target)

ARRAY LONGINT:C221($tLon_Lengths; 0)
ARRAY LONGINT:C221($tLon_Positions; 0)

If (False:C215)
	_O_C_LONGINT:C283(_o_Rgx_MatchText; $0)
	_O_C_TEXT:C284(_o_Rgx_MatchText; $1)
	_O_C_TEXT:C284(_o_Rgx_MatchText; $2)
	_O_C_POINTER:C301(_o_Rgx_MatchText; $3)
	_O_C_LONGINT:C283(_o_Rgx_MatchText; $4)
End if 

$Lon_Parameters:=Count parameters:C259

If ($Lon_Parameters<2)
	
	_o_rgxError:=-50  //Parameter error
	
Else 
	
	_o_rgxError:=-1
	
	If ($Lon_Parameters>=3)
		$Ptr_Array:=$3
		If ($Lon_Parameters>=4)
			$Lon_Options:=$4
		End if 
	End if 
	
	$Txt_Pattern:=_o_rgx_Options($Lon_Options)+$1
	$Txt_Target:=$2
	
	If (Not:C34(Is nil pointer:C315($Ptr_Array)))
		
		CLEAR VARIABLE:C89($Ptr_Array->)
		
	End if 
	
	$Txt_Error_Method:=Method called on error:C704
	ON ERR CALL:C155("rgx_NO_ERROR")
	
	$Lon_Start:=1
	
	Repeat 
		
		$Boo_OK:=Match regex:C1019($Txt_Pattern; $Txt_Target; $Lon_Start; $tLon_Positions; $tLon_Lengths)
		
		If ($Boo_OK)
			
			_o_rgxError:=0
			
			$Lon_Size:=Size of array:C274($tLon_Positions)
			
			For ($Lon_i; 0; $Lon_Size; 1)
				
				$Txt_Buffer:=Substring:C12($Txt_Target; $tLon_Positions{$Lon_i}; $tLon_Lengths{$Lon_i})
				
				If ($tLon_Lengths{$Lon_i}=0)
					
					$Boo_OK:=($Lon_i>0)
					
					If ($Boo_OK)
						
						$Boo_OK:=($tLon_Positions{$Lon_i}#$tLon_Positions{$Lon_i-1})
						
					End if 
					
				End if 
				
				If ($Boo_OK)
					
					If (Not:C34(Is nil pointer:C315($Ptr_Array)))
						
						If ($Lon_i=0)
							
							$Ptr_Array->{0}:=$Txt_Buffer
							
						Else 
							
							APPEND TO ARRAY:C911($Ptr_Array->; $Txt_Buffer)
							
						End if 
						
					End if 
					
					If ($tLon_Positions{$Lon_i}>0)
						$Lon_Start:=$tLon_Positions{$Lon_i}+$tLon_Lengths{$Lon_i}
					End if 
					
				Else 
					
					$Lon_i:=$Lon_Size+1
					
				End if 
				
			End for 
			
			$Boo_OK:=False:C215
			
		End if 
		
	Until (Not:C34($Boo_OK))
	
	ON ERR CALL:C155($Txt_Error_Method)
End if 

$0:=_o_rgxError

_o_rgxError:=0