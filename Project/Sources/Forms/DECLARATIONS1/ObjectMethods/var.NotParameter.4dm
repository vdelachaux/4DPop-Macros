C_LONGINT:C283($Lon_Type)

If (Self:C308->=1)
	
	GET LIST ITEM PARAMETER:C985((Form:C1466.list)->;*;"type";$Lon_Type)
	
	If ($Lon_Type>100)
		
		$Lon_Type:=$Lon_Type-100
		
	End if 
	
	SET LIST ITEM PARAMETER:C986((Form:C1466.list)->;*;"type";$Lon_Type)
	
	OBJECT SET ENABLED:C1123(*;"NotInArray_@";False:C215)
	OBJECT SET ENABLED:C1123(*;"type_integer";Not:C34(Storage:C1525.macros.preferences.options ?? 30))
	
	Form:C1466.refresh()
	
End if 

GOTO OBJECT:C206(*;"Liste_Variables")