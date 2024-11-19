//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : Get_resource
// Created 06/05/06 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($Name : Text; $Type : Text; $valuePtr : Pointer) : Boolean

var $Buffer; $Node; $Path; $Root : Text
var $OK : Boolean

$Path:=_o_Files_And_Folders("Add_Folder"; Get 4D folder:C485; "4DPop v11"; True:C214)
$Path:=_o_Files_And_Folders("Add_File"; $Path; "resources.xml")

$Root:=DOM Parse XML source:C719($Path)
$OK:=(OK=1)

If ($OK)
	
	$Node:=DOM Find XML element:C864($Root; "/M_4DPop/"+$Name)
	$OK:=(OK=1)
	
	If ($OK)
		
		DOM GET XML ELEMENT VALUE:C731($Node; $Buffer)
		$OK:=(OK=1)
		
	End if 
	
	DOM CLOSE XML:C722($Root)
	
	If ($OK)
		
		TEXT TO BLOB:C554($Buffer; $valuePtr; Mac text without length:K22:10)
		$OK:=(OK=1)
		
		If ($OK)
			
			BASE64 DECODE:C896($valuePtr)
			$OK:=(OK=1)
			
			If ($OK)
				
				Case of 
						
						//______________________________________________________
					: ($Type="PICT")
						
						BLOB TO PICTURE:C682($valuePtr; $valuePtr->)
						$OK:=(OK=1)
						
						//______________________________________________________
					Else 
						
						$OK:=False:C215
						
						//______________________________________________________
				End case 
			End if 
			
			SET BLOB SIZE:C606($valuePtr; 0)
			
		End if 
	End if 
End if 

return $OK