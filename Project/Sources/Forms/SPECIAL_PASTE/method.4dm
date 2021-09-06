// ----------------------------------------------------
// Method : Méthode formulaire : SPECIAL_PASTE
// Created 30/06/08 by vdl
// ----------------------------------------------------
// Description
// Form method of the "Special paste" dialog
// ----------------------------------------------------
var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.onLoad()
		
		//______________________________________________________
	: ($e.code=On Selection Change:K2:29)
		
		Form:C1466.refresh()
		
		//______________________________________________________
	: ($e.code=On Double Clicked:K2:5)\
		 & (String:C10($e.objectName)="choice")
		
		Form:C1466.validate()
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		Form:C1466.update()
		
		//______________________________________________________
End case 