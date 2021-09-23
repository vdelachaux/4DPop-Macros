//%attributes = {"invisible":true}
//  ----------------------------------------------------
//  Méthode : str_isNumeric
//  Created 26/10/05 by Vincent de Lachaux
//  ----------------------------------------------------
//  Description
//  Checks if all characters are numerical characters
//  ----------------------------------------------------
C_BOOLEAN:C305($0)
C_TEXT:C284($1)

If (False:C215)
	C_BOOLEAN:C305(_o_isNumeric; $0)
	C_TEXT:C284(_o_isNumeric; $1)
End if 

$0:=($1=String:C10(Num:C11(Replace string:C233($1; "e"; "")); "0"*Length:C16($1)))