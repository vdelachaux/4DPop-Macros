//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : Rgx_match alias Rgx_MatchText
  // ID[4FCCB6B6140F4B4593ABA2FADDB4C3A8]
  // Created 5-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_match)
C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_size;$Lon_start)
C_TEXT:C284($Txt_errorMethod)
C_OBJECT:C1216($Obj_in;$Obj_out;$Obj_value)

ARRAY LONGINT:C221($tLon_lengths;0)
ARRAY LONGINT:C221($tLon_positions;0)

If (False:C215)
	C_OBJECT:C1216(Rgx_match ;$0)
	C_OBJECT:C1216(Rgx_match ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1  // { pattern , target }
	
	  // Default values
	$Obj_out:=New object:C1471("success";False:C215)
	
	$Lon_start:=1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Obj_in.pattern#Null:C1517) & ($Obj_in.target#Null:C1517)
	
	If ($Obj_in.start#Null:C1517)
		
		$Lon_start:=Num:C11($Obj_in.start)
		
	End if 
	
	$Txt_errorMethod:=Method called on error:C704
	ON ERR CALL:C155("rgx_NO_ERROR")
	
	Repeat 
		
		ERROR:=0
		
		$Boo_match:=Match regex:C1019($Obj_in.pattern;$Obj_in.target;$Lon_start;$tLon_positions;$tLon_lengths)
		
		If (ERROR=0)
			
			If ($Boo_match)
				
				$Obj_out.success:=True:C214
				
				$Lon_size:=Size of array:C274($tLon_positions)
				
				For ($Lon_i;0;$Lon_size;1)
					
					$Obj_value:=New object:C1471("data";Substring:C12($Obj_in.target;$tLon_positions{$Lon_i};$tLon_lengths{$Lon_i});"position";$tLon_positions{$Lon_i};"length";$tLon_lengths{$Lon_i})
					
					If ($tLon_lengths{$Lon_i}=0)
						
						$Boo_match:=($Lon_i>0)
						
						If ($Boo_match)
							
							$Boo_match:=($tLon_positions{$Lon_i}#$tLon_positions{$Lon_i-1})
							
						End if 
					End if 
					
					  //If ($Boo_match)
					If ($Obj_out.match=Null:C1517)
						
						$Obj_out.match:=New collection:C1472
						
					End if 
					
					$Obj_out.match.push($Obj_value)
					
					If ($tLon_positions{$Lon_i}>0)
						
						$Lon_start:=$tLon_positions{$Lon_i}+$tLon_lengths{$Lon_i}
						
					End if 
					
					  // Else
					  //$Lon_i:=$Lon_size+1
					  // End if
					
				End for 
				
				$Boo_match:=Bool:C1537($Obj_in.all)  // Stop after the first match ?
				
			End if 
			
		Else 
			
			$Obj_out.error:=ERROR
			
		End if 
	Until (Not:C34($Boo_match))
	
	ON ERR CALL:C155($Txt_errorMethod)
	
Else 
	
	ASSERT:C1129(False:C215;"Missing property")
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out  // { success , match: [ { data , position , length } , … ] }

  // ----------------------------------------------------
  // End