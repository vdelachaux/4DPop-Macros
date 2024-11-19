//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : Private_Txt_Get_Version
// Created 06/05/06 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($EntryPoint : Text) : Text

var $Node; $Root; $Buffer; $Result : Text
var $OK : Boolean

$EntryPoint:=Count parameters:C259=0 ? "full" : $EntryPoint  // Action

$Root:=DOM Parse XML source:C719(Storage:C1525.macros.preferences.platformPath)
$OK:=(OK=1)

If ($OK)
	
	$Node:=DOM Find XML element:C864($Root; "/M_4DPop/version/")
	$OK:=(OK=1)
	
	If ($OK & (($EntryPoint="major")\
		 | ($EntryPoint="full")))
		
		$Node:=DOM Find XML element:C864($Root; "/M_4DPop/version/major/")
		$OK:=(OK=1)
		
		If ($OK)
			
			DOM GET XML ELEMENT VALUE:C731($Node; $Buffer)
			$OK:=(OK=1)
			
			If ($OK)
				
				$Result:=$Buffer
				
			End if 
		End if 
	End if 
	
	If ($OK & (($EntryPoint="minor")\
		 | ($EntryPoint="full")))
		
		$Node:=DOM Find XML element:C864($Root; "/M_4DPop/version/minor/")
		$OK:=(OK=1)
		
		If ($OK)
			
			DOM GET XML ELEMENT VALUE:C731($Node; $Buffer)
			$OK:=(OK=1)
			
			If ($OK)
				
				If ($EntryPoint="Full")
					
					If (Num:C11($Buffer)#0)
						
						$Result+="."+$Buffer
						
					End if 
					
				Else 
					
					$Result:=$Buffer
					
				End if 
			End if 
		End if 
	End if 
	
	If ($OK & (($EntryPoint="release")\
		 | ($EntryPoint="full")))
		
		$Node:=DOM Find XML element:C864($Root; "/M_4DPop/version/release/")
		$OK:=(OK=1)
		
		If ($OK)
			
			DOM GET XML ELEMENT VALUE:C731($Node; $Buffer)
			$OK:=(OK=1)
			
			If ($OK)
				
				If ($EntryPoint="Full")
					
					If (Num:C11($Buffer)#0)
						
						$Result+="."+$Buffer
						
					End if 
					
				Else 
					
					$Result:=$Buffer
					
				End if 
			End if 
		End if 
	End if 
	
	If ($OK & ($EntryPoint="date"))
		
		$Node:=DOM Find XML element:C864($Root; "/M_4DPop/version/date/")
		$OK:=(OK=1)
		
		If ($OK)
			
			DOM GET XML ELEMENT VALUE:C731($Node; $Buffer)
			$OK:=(OK=1)
			
			If ($OK)
				
				$Result:=$Buffer
				
			End if 
		End if 
	End if 
	
	DOM CLOSE XML:C722($Root)
	
End if 

return $Result