//%attributes = {"invisible":true,"preemptive":"capable"}
//  ----------------------------------------------------
//  Méthode : str_isNumeric
//  Created 26/10/05 by Vincent de Lachaux
//  ----------------------------------------------------
//  Description
//  Checks if all characters are numerical characters
//  ----------------------------------------------------
var $0 : Boolean
var $1 : Text

If (False:C215)
	_O_C_BOOLEAN:C305(_o_isNumeric; $0)
	_O_C_TEXT:C284(_o_isNumeric; $1)
End if 

$0:=($1=String:C10(Num:C11(Replace string:C233($1; "e"; "")); "0"*Length:C16($1)))