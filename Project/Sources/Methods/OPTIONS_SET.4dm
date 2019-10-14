//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : OPTIONS_SET
  // Created 02/05/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_LONGINT:C283(${1})

C_LONGINT:C283($Lon_i;$Lon_value)

If (False:C215)
	C_LONGINT:C283(OPTIONS_SET ;${1})
End if 

$Lon_value:=Num:C11(Storage:C1525.macros.preferences.options)

For ($Lon_i;1;Count parameters:C259;2)
	
	$Lon_value:=Choose:C955(${$Lon_i}=1;$Lon_value ?+ ${$Lon_i+1};$Lon_value ?- ${$Lon_i+1})
	
End for 

Preferences ("Set_Value";"options";->$Lon_value)