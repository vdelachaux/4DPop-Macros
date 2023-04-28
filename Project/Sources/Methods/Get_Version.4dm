//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Method : Private_Txt_Get_Version
  // Created 06/05/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_OK)
C_TEXT:C284($Txt_Buffer;$Txt_EntryPoint;$Txt_Result;$a16_Node;$a16_Root)

If (False:C215)
	C_TEXT:C284(Get_Version ;$0)
	C_TEXT:C284(Get_Version ;$1)
End if 

$Txt_EntryPoint:="full"

If (Count parameters:C259>0)
	
	$Txt_EntryPoint:=$1  //Action
	
End if 

$a16_Root:=DOM Parse XML source:C719(Storage:C1525.macros.preferences.platformPath)
$Boo_OK:=(OK=1)

If ($Boo_OK)
	
	$a16_Node:=DOM Find XML element:C864($a16_Root;"/M_4DPop/version/")
	$Boo_OK:=(OK=1)
	
	If ($Boo_OK & (($Txt_EntryPoint="major")\
		 | ($Txt_EntryPoint="full")))
		
		$a16_Node:=DOM Find XML element:C864($a16_Root;"/M_4DPop/version/major/")
		$Boo_OK:=(OK=1)
		
		If ($Boo_OK)
			
			DOM GET XML ELEMENT VALUE:C731($a16_Node;$Txt_Buffer)
			$Boo_OK:=(OK=1)
			
			If ($Boo_OK)
				
				$Txt_Result:=$Txt_Buffer
				
			End if 
		End if 
	End if 
	
	If ($Boo_OK & (($Txt_EntryPoint="minor")\
		 | ($Txt_EntryPoint="full")))
		
		$a16_Node:=DOM Find XML element:C864($a16_Root;"/M_4DPop/version/minor/")
		$Boo_OK:=(OK=1)
		
		If ($Boo_OK)
			
			DOM GET XML ELEMENT VALUE:C731($a16_Node;$Txt_Buffer)
			$Boo_OK:=(OK=1)
			
			If ($Boo_OK)
				
				If ($Txt_EntryPoint="Full")
					
					If (Num:C11($Txt_Buffer)#0)
						
						$Txt_Result:=$Txt_Result+"."+$Txt_Buffer
						
					End if 
					
				Else 
					
					$Txt_Result:=$Txt_Buffer
					
				End if 
			End if 
		End if 
	End if 
	
	If ($Boo_OK & (($Txt_EntryPoint="release")\
		 | ($Txt_EntryPoint="full")))
		
		$a16_Node:=DOM Find XML element:C864($a16_Root;"/M_4DPop/version/release/")
		$Boo_OK:=(OK=1)
		
		If ($Boo_OK)
			
			DOM GET XML ELEMENT VALUE:C731($a16_Node;$Txt_Buffer)
			$Boo_OK:=(OK=1)
			
			If ($Boo_OK)
				
				If ($Txt_EntryPoint="Full")
					
					If (Num:C11($Txt_Buffer)#0)
						
						$Txt_Result:=$Txt_Result+"."+$Txt_Buffer
						
					End if 
					
				Else 
					
					$Txt_Result:=$Txt_Buffer
					
				End if 
			End if 
		End if 
	End if 
	
	If ($Boo_OK & ($Txt_EntryPoint="date"))
		
		$a16_Node:=DOM Find XML element:C864($a16_Root;"/M_4DPop/version/date/")
		$Boo_OK:=(OK=1)
		
		If ($Boo_OK)
			
			DOM GET XML ELEMENT VALUE:C731($a16_Node;$Txt_Buffer)
			$Boo_OK:=(OK=1)
			
			If ($Boo_OK)
				
				$Txt_Result:=$Txt_Buffer
				
			End if 
		End if 
	End if 
	
	DOM CLOSE XML:C722($a16_Root)
	
End if 

$0:=$Txt_Result