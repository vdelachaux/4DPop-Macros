/*

Active objects perform a database task or an interface function. Fields are
active objects. Other active objects — enterable objects (variables), combo
boxes, drop-down lists, picture buttons, and so on — store data temporarily in
memory or perform some action such as opening a dialog box, printing a report,
or starting a background process.

I prefer to call them widgets to make the difference with language objects

*/

/*═══════════════════*/
Class extends static
/*═══════════════════*/

Class constructor
	var $1 : Text
	var $2 : Text
	
	var $p : Pointer
	
	Super:C1705($1)
	
	$p:=OBJECT Get pointer:C1124(Object named:K67:5; This:C1470.name)
	This:C1470.assignable:=Not:C34(Is nil pointer:C315($p))
	
	If (This:C1470.assignable)
		
		This:C1470.pointer:=$p
		This:C1470.value:=$p->
		
	Else 
		
		If (Count parameters:C259>=2)
			
			This:C1470.dataSource:=$2
			This:C1470.value:=Formula from string:C1601($2).call()
			
		End if 
	End if 
	
	This:C1470.action:=OBJECT Get action:C1457(*; This:C1470.name)
	
	ARRAY LONGINT:C221($_; 0x0000)
	OBJECT GET EVENTS:C1238(*; This:C1470.name; $_)
	This:C1470.events:=New collection:C1472
	ARRAY TO COLLECTION:C1563(This:C1470.events; $_)
	
Function addEvents
	
	var ${1}; $i : Integer
	
	For ($i; 1; Count parameters:C259; 1)
		
		This:C1470.events.push(${$i})
		
	End for 
	
	//ARRAY LONGINT($_; 0x0000)
	//COLLECTION TO ARRAY(This.events; $_)
	//OBJECT SET EVENTS(*; This.name; $_; Enable events others unchanged)
	
/*══════════════════════════*/
Function getEnterable
	var $0 : Boolean
	
	$0:=OBJECT Get enterable:C1067(*; This:C1470.name)
	
/*══════════════════════════
.enterable()
.enterable(bool)
══════════════════════════*/
Function enterable
	var $0 : Object
	var $1 : Boolean
	
	If (Count parameters:C259>=1)
		
		OBJECT SET ENTERABLE:C238(*; This:C1470.name; $1)
		
	Else 
		
		OBJECT SET ENTERABLE:C238(*; This:C1470.name; True:C214)
		
	End if 
	
	$0:=This:C1470
	
/*══════════════════════════
.notEnterable() --> This
══════════════════════════*/
Function notEnterable
	var $0 : Object
	
	OBJECT SET ENTERABLE:C238(*; This:C1470.name; False:C215)
	
	$0:=This:C1470
	
/*══════════════════════════*/
Function getValue
	
	C_VARIANT:C1683($0)
	
	//If (This.assignable)
	//// Use pointer
	//$0:=(This.pointer)->
	//Else 
	//$0:=Formula from string(String(This.dataSource)).call()
	//End if
	
	$0:=OBJECT Get value:C1743(This:C1470.name)
	
/*══════════════════════════*/
Function setValue
	var $0 : Object
	var $1 : Variant
	
	//If (This.assignable)
	//(This.pointer)->:=$1
	//Else
	//If (This.dataSource#Null)
	//This.value:=$1
	//EXECUTE FORMULA(This.dataSource+":=This.value")
	//End if
	//End if
	
	OBJECT SET VALUE:C1742(This:C1470.name; $1)
	
	$0:=This:C1470
	
/*══════════════════════════*/
Function clear
	var $0 : Object
	
	var $l : Integer
	
	If (This:C1470.assignable)
		
		CLEAR VARIABLE:C89((This:C1470.pointer)->)
		
	Else 
		
		If (This:C1470.dataSource#Null:C1517)
			
			$l:=Value type:C1509(This:C1470.getValue())
			
			Case of 
					
					//______________________________________________________
				: ($l=Is text:K8:3)
					
					EXECUTE FORMULA:C63(This:C1470.dataSource+":=\"\"")
					
					//______________________________________________________
				: ($l=Is real:K8:4)\
					 | ($l=Is longint:K8:6)
					
					EXECUTE FORMULA:C63(This:C1470.dataSource+":=0")
					
					//______________________________________________________
				: ($l=Is boolean:K8:9)
					
					EXECUTE FORMULA:C63(This:C1470.dataSource+":=:C215")
					
					//______________________________________________________
				: ($l=Is date:K8:7)
					
					EXECUTE FORMULA:C63(This:C1470.dataSource+":=:C102(\"\")")
					
					//______________________________________________________
				: ($l=Is time:K8:8)
					
					EXECUTE FORMULA:C63(This:C1470.dataSource+":=:C179(0)")
					
					//______________________________________________________
				: ($l=Is object:K8:27)
					
					EXECUTE FORMULA:C63(This:C1470.dataSource+":=null")
					
					//______________________________________________________
				: ($l=Is picture:K8:10)
					
					EXECUTE FORMULA:C63(This:C1470.dataSource+":="+This:C1470.dataSource+"*0")
					
					//______________________________________________________
				Else 
					
					EXECUTE FORMULA:C63(This:C1470.dataSource+":=null")
					
					//______________________________________________________
			End case 
		End if 
	End if 
	
	$0:=This:C1470
	
/*══════════════════════════*/
Function touch
	
	If (This:C1470.assignable)
		
		(This:C1470.pointer)->:=(This:C1470.pointer)->
		
	Else 
		
		EXECUTE FORMULA:C63(This:C1470.dataSource+":="+This:C1470.dataSource)
		
	End if 
	
/*══════════════════════════*/
Function catch
	var $0 : Boolean
	var $1 : Variant
	
	var $e : Object
	
	If (Asserted:C1132(This:C1470.type#-1; "Does not apply to a group"))
		
		If (Count parameters:C259=0)
			
			$e:=FORM Event:C1606
			$0:=(This:C1470.name=$e.objectName)
			
		Else 
			
			If (Value type:C1509($1)=Is object:K8:27)
				
				$e:=$1
				$0:=(This:C1470.name=String:C10($1.objectName))
				
			Else 
				
				$0:=(This:C1470.name=String:C10($1))
				
			End if 
		End if 
		
		//If ($0) & (This.events.length>0)
		//var $l : Integer
		//For each ($l; This.events) Until ($0)
		//$0:=$0 & ($e.code=$l)
		//End for each
		//End if
		
	End if 
	
/*══════════════════════════
.getHelpTip() -> text
══════════════════════════*/
Function getHelpTip
	var $0 : Text
	
	$0:=OBJECT Get help tip:C1182(*; This:C1470.name)
	
/*══════════════════════════
.setHelpTip(text) -> This
══════════════════════════*/
Function setHelpTip
	var $0 : Object
	var $1 : Text
	
	var $t : Text
	
	$t:=Get localized string:C991($1)
	$t:=Choose:C955(Length:C16($t)>0; $t; $1)  // Revert if no localization
	
	OBJECT SET HELP TIP:C1181(*; This:C1470.name; $t)
	
	$0:=This:C1470
	
/*════════════════════════════════════════════*/
Function getShortcut
	var $0 : Object
	
	var $t : Text
	var $l : Integer
	
	OBJECT GET SHORTCUT:C1186(*; This:C1470.name; $t; $l)
	
	$0:=New object:C1471(\
		"key"; $t; \
		"modifier"; $l)
	
/*════════════════════════════════════════════*/
Function setShortcut
	var $0 : Object
	var $1 : Text
	var $2 : Integer
	
	If (Count parameters:C259>=2)
		
		OBJECT SET SHORTCUT:C1185(*; This:C1470.name; $1; $2)
		
	Else 
		
		OBJECT SET SHORTCUT:C1185(*; This:C1470.name; $1)
		
	End if 
	
	$0:=This:C1470
	
/*════════════════════════════════════════════*/
Function focus
	var $0 : Object
	
	GOTO OBJECT:C206(*; This:C1470.name)
	
	$0:=This:C1470
	
/*════════════════════════════════════════════*/