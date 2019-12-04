C_LONGINT:C283($Lon_type)

If (Self:C308->=1)
	
	If ((<>b7+<>b8+<>b14+<>b15)=0)  //(<>b2=0) & (<>b7=0) & (<>b8=0)
		
		GET LIST ITEM PARAMETER:C985((Form:C1466.list)->;*;"type";$Lon_type)
		
		If ($Lon_type>0) & ($Lon_type<100)
			
			$Lon_type:=$Lon_type+100
			SET LIST ITEM PARAMETER:C986((Form:C1466.list)->;*;"type";$Lon_type)
			
		End if 
		
		OBJECT SET ENABLED:C1123(*;"NotInArray_@";False:C215)
		OBJECT SET ENABLED:C1123(*;"type_integer";True:C214)
		
		Form:C1466.refresh()
		
	Else 
		
		BEEP:C151
		(OBJECT Get pointer:C1124(Object named:K67:5;"var.NotParameter"))->:=1
		Self:C308->:=0
		
	End if 
	
Else 
	
	OBJECT SET ENABLED:C1123(*;"type_integer";Not:C34(Storage:C1525.macros.preferences.options ?? 30))
	
End if 

GOTO OBJECT:C206(*;"Liste_Variables")