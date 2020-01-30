//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : str_FindBalencingChar
  // Database: 4DPop Macros
  // ID[37C835CF5D5F4E0884F688A237CEA44D]
  // Created #7-10-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description: http://kb.4d.com/assetid=77146
  // Purpose: Find the balancing end char(s) to the opening char()
  // Example find balanced
  //   -- Parenthesis "(" to ")",
  //   -- Squar brackets "[" to "]",
  //   -- Curly brackets "{" to "}",
  //   -- Paired characters "[{" to "}]",
  //   -- or HTML/XML tags such as "<div>" to "</div>."
  //
  // $0 - C_LONGINT - Position of the closing
  // $1 - C_POINTER - Pointer to the text to scan
  // $2 - C_TEXT - Opening Char(s)
  // $3 - C_TEXT - Closing Char(s)
  // $4 - C_LONGINT - Offset into text starting point
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)
C_POINTER:C301($1)
C_TEXT:C284($2)
C_TEXT:C284($3)
C_LONGINT:C283($4)

C_LONGINT:C283($Lon_closingCharLength;$Lon_closingCount;$Lon_closingPosition;$Lon_offset;$Lon_openingCharLength;$Lon_openingCount;$Lon_openingPosition;$Lon_parameters)
C_LONGINT:C283($Lon_position;$Lon_startingPoint)
C_POINTER:C301($Ptr_text)
C_TEXT:C284($Txt_closingChar;$Txt_openingChar)

If (False:C215)
	C_LONGINT:C283(str_FindBalencingChar ;$0)
	C_POINTER:C301(str_FindBalencingChar ;$1)
	C_TEXT:C284(str_FindBalencingChar ;$2)
	C_TEXT:C284(str_FindBalencingChar ;$3)
	C_LONGINT:C283(str_FindBalencingChar ;$4)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	  //Required parameters
	$Ptr_text:=$1
	$Txt_openingChar:=$2
	$Txt_closingChar:=$3
	
	$Lon_openingCharLength:=Length:C16($Txt_openingChar)
	$Lon_closingCharLength:=Length:C16($Txt_closingChar)
	
	  //Optional parameters
	If ($Lon_parameters>=4)
		
		  // <NONE>
		$Lon_offset:=$4
		
	End if 
	
	$Lon_position:=Position:C15($Txt_openingChar;$Ptr_text->;$Lon_offset)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Length:C16($Ptr_text->)>=($Lon_position+$Lon_openingCharLength+$Lon_closingCharLength))
	
	$Lon_startingPoint:=$Lon_position
	
	$Lon_openingPosition:=Position:C15($Txt_openingChar;$Ptr_text->;$Lon_position)
	$Lon_openingCount:=$Lon_openingCount+1
	
	$Lon_closingPosition:=Position:C15($Txt_closingChar;$Ptr_text->;$Lon_position+1)
	
	Repeat 
		
		If ($Lon_openingPosition<$Lon_closingPosition)
			
			Repeat 
				
				$Lon_position:=Position:C15($Txt_openingChar;$Ptr_text->;$Lon_openingPosition+$Lon_openingCharLength)
				
				If (($Lon_position>0)\
					 & ($Lon_position<$Lon_closingPosition))
					
					$Lon_openingCount:=$Lon_openingCount+1
					$Lon_openingPosition:=$Lon_position
					
				End if 
			Until (($Lon_position>$Lon_closingPosition)\
				 | ($Lon_position<1))
			
		End if 
		
		$Lon_closingCount:=$Lon_closingCount+1
		
		If ($Lon_openingCount#$Lon_closingCount)
			
			$Lon_closingPosition:=Position:C15($Txt_closingChar;$Ptr_text->;$Lon_closingPosition+1)
			
			If ($Lon_position=0)
				
				$Lon_closingCount:=$Lon_closingCount+1
				$Lon_position:=$Lon_closingPosition
				
				While ($Lon_position>0)
					
					$Lon_position:=Position:C15($Txt_closingChar;$Ptr_text->;$Lon_closingPosition+1)
					
					If ($Lon_position>0)
						
						$Lon_closingCount:=$Lon_closingCount+1
						$Lon_closingPosition:=$Lon_position
						
					End if 
				End while 
			End if 
		End if 
	Until (($Lon_openingCount=$Lon_closingCount)\
		 | ($Lon_position<1))
	
	  // Include the closing char(s)
	$Lon_closingPosition:=$Lon_closingPosition+$Lon_closingCharLength
	
	If (Not:C34(Asserted:C1132($Lon_openingCount=$Lon_closingCount;$Txt_openingChar+" and "+$Txt_closingChar+" are unbalanced from starting point "+String:C10($Lon_startingPoint)+".")))
		
		$Lon_closingPosition:=0
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Lon_closingPosition

  // ----------------------------------------------------
  // End 