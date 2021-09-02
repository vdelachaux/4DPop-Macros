Class constructor
	var $t : Text
	var $ƒ : Object
	
	ARRAY LONGINT:C221($_len; 0)
	ARRAY LONGINT:C221($_pos; 0)
	
	This:C1470.title:=Get window title:C450(Frontmost window:C447)
	
	// Identify the name & the type of the current method
	This:C1470.name:=""
	This:C1470.objectName:=""
	This:C1470.projectMethod:=False:C215
	This:C1470.objectMethod:=False:C215
	This:C1470.class:=False:C215
	This:C1470.form:=False:C215
	This:C1470.trigger:=False:C215
	
	If (Match regex:C1019("(?m-si)^([^:]*\\s*:\\s)([[:ascii:]]*)(\\.[[:ascii:]]*)?(?:\\s*\\*)?$"; This:C1470.title; 1; $_pos; $_len))
		
		$t:=Substring:C12(This:C1470.title; $_pos{1}; $_len{1})
		$ƒ:=Formula from string:C1601(Parse formula:C1576(":C1578($1)"))
		This:C1470.projectMethod:=($t=$ƒ.call(Null:C1517; "common_method"))
		This:C1470.objectMethod:=($t=$ƒ.call(Null:C1517; "common_objectMethod"))
		This:C1470.class:=($t="Class: ")
		This:C1470.form:=($t=$ƒ.call(Null:C1517; "common_form"))
		This:C1470.trigger:=($t=$ƒ.call(Null:C1517; "common_Trigger"))
		
		This:C1470.name:=Substring:C12(This:C1470.title; $_pos{2}; $_len{2})
		
		If ($_pos{3}>0)
			
			This:C1470.objectName:=Substring:C12(This:C1470.title; $_pos{3}; $_len{3})
			
		End if 
		
	Else 
		
		// 👀 What is it?
		
	End if 
	
	//
	This:C1470.method:=""
	This:C1470.highlighted:=""
	This:C1470.withSelection:=False:C215
	
	If (This:C1470.form)
		
		// #TO_DO 🚧
		
	Else 
		
		// The full code
		GET MACRO PARAMETER:C997(Full method text:K5:17; $t)
		This:C1470.method:=$t
		
		// The selection
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $t)
		This:C1470.highlighted:=$t
		This:C1470.withSelection:=Length:C16($t)>0
		
	End if 
	
	This:C1470.lineTexts:=New collection:C1472
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
	This:C1470.decimalSeparator:=$t
	
	//==============================================================
Function split($useSelection : Boolean)
	
	If ($useSelection)
		
		// Selection
		This:C1470.lineTexts:=Split string:C1554(This:C1470.highlighted; "\r"; sk trim spaces:K86:2)
		
	Else 
		
		This:C1470.lineTexts:=Split string:C1554(This:C1470.method; "\r"; sk trim spaces:K86:2)
		
	End if 
	
	//==============================================================
Function localized($en : Text)->$localized : Text
	
	If (This:C1470._controlFlow=Null:C1517)  // First call
		
		This:C1470._controlFlow:=JSON Parse:C1218(File:C1566("/RESOURCES/controlFlow.json").getText())
		
	End if 
	
	If (Command name:C538(41)="ALERT")  // US
		
		$localized:=$en
		
	Else 
		
		var $index : Integer
		$index:=This:C1470._controlFlow.intl.indexOf($en)
		$localized:=This:C1470._controlFlow.fr($index)
		
	End if 