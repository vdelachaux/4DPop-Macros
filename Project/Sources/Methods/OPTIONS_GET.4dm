//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : Private_GET_OPTIONS
// Created 02/05/06 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
_O_C_LONGINT:C283(${1})

//C_LONGINT(<>options)
//If (<>options=0)
//<>options:=<>options ?+ 0
//$Boo_OK:=Preferences ("init")
//End if
//If ($Boo_OK)
//$Boo_OK:=Preferences ("Get_Value";"options";-><>options)
//End if
//If (Not($Boo_OK))
//For ($Lon_i;1;Count parameters;1)
//<>options:=<>options ?+ ${$Lon_i}
//End for
//End if


If (Num:C11(Storage:C1525.macros.preferences.options)=0)
	
	_o_Preferences("init")
	
End if 

