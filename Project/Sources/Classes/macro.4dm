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
	
	ARRAY LONGINT:C221($_pos; 0)
	ARRAY LONGINT:C221($_len; 0)
	
	If (Match regex:C1019("(?m-si)^([^:]*\\s*:\\s)([[:ascii:]]*)(\\.[[:ascii:]]*)?(?:\\s*\\*)?$"; This:C1470.title; 1; $_pos; $_len))
		
		$t:=Substring:C12(This:C1470.title; $_pos{1}; $_len{1})
		This:C1470.projectMethod:=($t=_4D Get 4D App localized string:C1578("common_method"))
		This:C1470.objectMethod:=($t=_4D Get 4D App localized string:C1578("common_objectMethod"))
		This:C1470.class:=($t="class:")
		This:C1470.form:=($t=_4D Get 4D App localized string:C1578("common_form"))
		This:C1470.trigger:=($t=_4D Get 4D App localized string:C1578("common_Trigger"))
		
		This:C1470.name:=Substring:C12(This:C1470.title; $_pos{2}; $_len{2})
		
		If ($_pos{3}>0)
			
			This:C1470.objectName:=Substring:C12(This:C1470.title; $_pos{3}; $_len{3})
			
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
	
	This:C1470.lineTexts:=New collection:C1472
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
	This:C1470.decimalSeparator:=$t
	
	//==============================================================
Function split
	
	var $1 : Boolean
	
	If ($1)
		
		// Selection
		This:C1470.lineTexts:=Split string:C1554(This:C1470.highlighted; "\r"; sk trim spaces:K86:2)
		
	Else 
		
		This:C1470.lineTexts:=Split string:C1554(This:C1470.method; "\r"; sk trim spaces:K86:2)
		
	End if 
	