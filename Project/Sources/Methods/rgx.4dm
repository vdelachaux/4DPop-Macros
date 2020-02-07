//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : rgx
  // ID[091975F1C6DC4791A66BD7A5314B92CF]
  // Created 7-2-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($success)
C_LONGINT:C283($end;$i;$indx;$start)
C_TEXT:C284($t;$tMethodCalledOnError;$tPattern;$tReplacement;$tTarget;$Txt_Target)
C_OBJECT:C1216($rgx)

ARRAY LONGINT:C221($tLon_Lengths;0)
ARRAY LONGINT:C221($tLon_Positions;0)
ARRAY TEXT:C222($tTxt_Tempo;0)

If (False:C215)
	C_OBJECT:C1216(rgx ;$0)
	C_TEXT:C284(rgx ;$1)
	C_OBJECT:C1216(rgx ;$2)
End if 

C_LONGINT:C283(rgxError)

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	If (Count parameters:C259>=1)
		
		$t:=String:C10($1)
		
	End if 
	
	$rgx:=New object:C1471(\
		"";"rgx";\
		"text";$t;\
		"success";True:C214;\
		"result";"";\
		"errors";New collection:C1472;\
		"warnings";New collection:C1472;\
		"reset";Formula:C1597(rgx ("reset"));\
		"setText";Formula:C1597(rgx ("setText";New object:C1471("text";String:C10($1))));\
		"substitute";Formula:C1597(rgx ("substitute";New object:C1471("pattern";String:C10($1);"replacement";String:C10($2);"start";$3)))\
		)
	
Else 
	
	$rgx:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($rgx=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="reset")
			
			$rgx.success:=True:C214
			$rgx.text:=""
			$rgx.result:=""
			$rgx.errors:=New collection:C1472
			$rgx.warnings:=New collection:C1472
			
			CLEAR VARIABLE:C89(rgxError)
			
			  //______________________________________________________
		: ($1="setText")
			
			$rgx.reset()
			$rgx.text:=$2.text
			
			  //______________________________________________________
		: ($1="substitute")
			
			$tPattern:=$2.pattern
			$tReplacement:=$2.replacement
			$tTarget:=$rgx.text
			
			$rgx.result:=$tTarget
			
			If (Length:C16($tTarget)>0)
				
				$rgx.success:=False:C215
				
				$start:=Choose:C955($2.start#Null:C1517;Num:C11($2.start);1)
				
				ARRAY LONGINT:C221($tLon_Tempo_Index;0x0000)
				ARRAY LONGINT:C221($tLon_Tempo_Lengths;0x0000)
				ARRAY LONGINT:C221($tLon_Tempo_Positions;0x0000)
				
				$tMethodCalledOnError:=Method called on error:C704
				CLEAR VARIABLE:C89(rgxError)
				ON ERR CALL:C155("rgx_NO_ERROR")
				
				Repeat 
					
					$success:=Match regex:C1019($tPattern;$tTarget;$start;$tLon_Positions;$tLon_Lengths)
					
					If ($success)
						
						$rgx.success:=True:C214
						$indx:=0
						$end:=Size of array:C274($tLon_Positions)
						
						For ($i;0;$end;1)
							
							$t:=Substring:C12($Txt_Target;$tLon_Positions{$i};$tLon_Lengths{$i})
							
							If ($tLon_Positions{$i}>0)
								
								$start:=$tLon_Positions{$i}+$tLon_Lengths{$i}
								
							End if 
							
							If ($tLon_Lengths{$i}=0)
								
								$success:=($i>0)
								
								If ($success)
									
									$success:=($tLon_Positions{$i}#$tLon_Positions{$i-1})
									
								End if 
							End if 
							
							If ($success)
								
								APPEND TO ARRAY:C911($tTxt_Tempo;$t)
								
								APPEND TO ARRAY:C911($tLon_Tempo_Positions;$tLon_Positions{$i})
								APPEND TO ARRAY:C911($tLon_Tempo_Lengths;$tLon_Lengths{$i})
								APPEND TO ARRAY:C911($tLon_Tempo_Index;$indx)
								
								$indx:=$indx+1
								
							Else 
								
								$i:=$end+1
								
							End if 
						End for 
						
					Else 
						
						$rgx.success:=(rgxError=0)
						
						If (Not:C34($rgx.success))
							
							$rgx.errors.push("error: "+String:C10(rgxError))
							
						End if 
					End if 
				Until (Not:C34($success))
				
				ON ERR CALL:C155($tMethodCalledOnError)
				
				If ($rgx.success)
					
					$end:=Size of array:C274($tTxt_Tempo)
					
					If ($end>0)
						
						$indx:=$end
						
						Repeat 
							
							If ($tLon_Tempo_Index{$indx}#0)
								
								$t:="\\"+String:C10($tLon_Tempo_Index{$indx})
								
								If (Position:C15($t;$tReplacement)>0)
									
									$tReplacement:=Replace string:C233($tReplacement;$t;$tTxt_Tempo{$indx})
									
								End if 
								
							Else 
								
								$rgx.result:=Delete string:C232($rgx.result;$tLon_Tempo_Positions{$indx};$tLon_Tempo_Lengths{$indx})
								$rgx.result:=Insert string:C231($rgx.result;$tReplacement;$tLon_Tempo_Positions{$indx})
								
								$tReplacement:=$2.replacement
								
							End if 
							
							$indx:=$indx-1
							
						Until ($indx=0)
						
					Else 
						
						$rgx.success:=True:C214
						$rgx.warnings.push("No match for the pattern: \""+$tPattern+"\"")
						
					End if 
					
				Else 
					
					  // A "If" statement should never omit "Else"
					
				End if 
				
			Else 
				
				$rgx.warnings.push("The string in which substitution will be done is empty")
				
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$rgx

  // ----------------------------------------------------
  // End