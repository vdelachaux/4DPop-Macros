//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : getResource
// Created 06/05/06 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($name : Text; $type : Text) : Picture

var $file:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop v11/resources.xml")

var $root:=DOM Parse XML source:C719($file.platformPath)

If (Not:C34(Bool:C1537(OK)))
	
	return 
	
End if 

var $success : Boolean
var $node:=DOM Find XML element:C864($root; "/M_4DPop/"+$name)

If (Bool:C1537(OK))
	
	var $t : Text
	DOM GET XML ELEMENT VALUE:C731($node; $t)
	$success:=Bool:C1537(OK)
	
End if 

DOM CLOSE XML:C722($root)

If ($success)
	
	var $x : Blob
	TEXT TO BLOB:C554($t; $x; Mac text without length:K22:10)
	
	If (Bool:C1537(OK))
		
		BASE64 DECODE:C896($x)
		
		If (Bool:C1537(OK))
			
			Case of 
					
					// ______________________________________________________
				: ($type="PICT")
					
					var $pict : Picture
					BLOB TO PICTURE:C682($x; $pict)
					
					return $pict
					
					// ______________________________________________________
			End case 
		End if 
	End if 
End if 