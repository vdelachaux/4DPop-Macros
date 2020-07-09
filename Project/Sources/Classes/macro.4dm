Class constructor  // Comment
	
	var $t : Text
	
	This:C1470.title:=Get window title:C450(Frontmost window:C447)
	This:C1470.name:=""
	This:C1470.objectName:=""
	This:C1470.projectMethod:=False:C215
	This:C1470.objectMethod:=False:C215
	This:C1470.class:=False:C215
	This:C1470.form:=False:C215
	This:C1470.trigger:=False:C215
	
	This:C1470.selection:=False:C215
	
	ARRAY LONGINT:C221($_position; 0x0000)
	ARRAY LONGINT:C221($_length; 0x0000)
	
	If (Match regex:C1019("(?m-si)^([^:]*\\s*:\\s)([[:ascii:]]*)(\\.[[:ascii:]]*)?(?:\\s*\\*)?$"; This:C1470.title; 1; $_position; $_length))
		
		$t:=Substring:C12(This:C1470.title; $_position{1}; $_length{1})
		This:C1470.projectMethod:=($t=_4D Get 4D App localized string:C1578("common_method"))
		This:C1470.objectMethod:=($t=_4D Get 4D App localized string:C1578("common_objectMethod"))
		This:C1470.class:=($t="class:")
		This:C1470.form:=($t=_4D Get 4D App localized string:C1578("common_form"))
		This:C1470.trigger:=($t=_4D Get 4D App localized string:C1578("common_Trigger"))
		
		This:C1470.name:=Substring:C12(This:C1470.title; $_position{2}; $_length{2})
		
		If ($_position{3}>0)
			
			This:C1470.objectName:=Substring:C12(This:C1470.title; $_position{3}; $_length{3})
			
		End if 
	End if 
	
	If (This:C1470.form)
		
		//
		
	Else 
		
		// Code
		GET MACRO PARAMETER:C997(Full method text:K5:17; $t)
		This:C1470.method:=$t
		
		// Selection
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $t)
		This:C1470.highlighted:=$t
		This:C1470.selection:=Length:C16($t)>0
		
	End if 
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
	This:C1470.decimalSeparator:=$t