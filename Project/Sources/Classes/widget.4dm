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
	
	C_TEXT:C284($1;$2)
	
	Super:C1705($1)
	
	C_POINTER:C301($p)
	$p:=OBJECT Get pointer:C1124(Object named:K67:5;This:C1470.name)
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
	
	This:C1470.action:=OBJECT Get action:C1457(*;This:C1470.name)
	
/*══════════════════════════*/
Function getEnterable
	
	C_BOOLEAN:C305($0)
	
	$0:=OBJECT Get enterable:C1067(*;This:C1470.name)
	
/*══════════════════════════
.enterable()
.enterable(bool)
══════════════════════════*/
Function enterable
	
	C_BOOLEAN:C305($1)
	
	If (Count parameters:C259>=1)
		
		OBJECT SET ENTERABLE:C238(*;This:C1470.name;$1)
		
	Else 
		
		OBJECT SET ENTERABLE:C238(*;This:C1470.name;True:C214)
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*══════════════════════════
.notEnterable() --> This
══════════════════════════*/
Function notEnterable
	
	OBJECT SET ENTERABLE:C238(*;This:C1470.name;False:C215)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*══════════════════════════*/
Function getValue
	
	C_VARIANT:C1683($0)
	
	If (This:C1470.assignable)
		
		  // Use pointer
		$0:=(This:C1470.pointer)->
		
	Else 
		
		$0:=Formula from string:C1601(String:C10(This:C1470.dataSource)).call()
		
	End if 
	
/*══════════════════════════*/
Function setValue
	
	C_VARIANT:C1683($1)
	
	If (This:C1470.assignable)
		
		(This:C1470.pointer)->:=$1
		
	Else 
		
		If (This:C1470.dataSource#Null:C1517)
			
			This:C1470.value:=$1
			EXECUTE FORMULA:C63(This:C1470.dataSource+":=This.value")
			
		End if 
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*══════════════════════════*/
Function clear
	
	If (This:C1470.assignable)
		
		CLEAR VARIABLE:C89((This:C1470.pointer)->)
		
	Else 
		
		If (This:C1470.dataSource#Null:C1517)
			
			C_LONGINT:C283($l)
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
	
	C_OBJECT:C1216($0)
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
	
	C_BOOLEAN:C305($0)
	C_VARIANT:C1683($1)
	
	If (Asserted:C1132(This:C1470.type#-1;"Does not apply to a group"))
		
		If (Count parameters:C259=0)
			
			$0:=(This:C1470.name=FORM Event:C1606.objectName)
			
		Else 
			
			If (Value type:C1509($1)=Is object:K8:27)
				
				$0:=(This:C1470.name=String:C10($1.objectName))
				
			Else 
				
				$0:=(This:C1470.name=String:C10($1))
				
			End if 
		End if 
	End if 
	
/*══════════════════════════
.getHelpTip() -> text
══════════════════════════*/
Function getHelpTip
	
	C_TEXT:C284($0)
	
	$0:=OBJECT Get help tip:C1182(*;This:C1470.name)
	
/*══════════════════════════
.setHelpTip(text) -> This
══════════════════════════*/
Function setHelpTip
	
	C_TEXT:C284($1)  // Text or resname
	C_TEXT:C284($t)
	
	$t:=Get localized string:C991($1)
	$t:=Choose:C955(Length:C16($t)>0;$t;$1)  // Revert if no localization
	
	OBJECT SET HELP TIP:C1181(*;This:C1470.name;$t)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════*/
Function getShortcut
	
	C_OBJECT:C1216($0)
	C_TEXT:C284($t)
	C_LONGINT:C283($l)
	
	OBJECT GET SHORTCUT:C1186(*;This:C1470.name;$t;$l)
	
	$0:=New object:C1471(\
		"key";$t;\
		"modifier";$l)
	
/*════════════════════════════════════════════*/
Function setShortcut
	
	C_TEXT:C284($1)  // key
	C_LONGINT:C283($2)  // modifier
	
	If (Count parameters:C259>=2)
		
		OBJECT SET SHORTCUT:C1185(*;This:C1470.name;$1;$2)
		
	Else 
		
		OBJECT SET SHORTCUT:C1185(*;This:C1470.name;$1)
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════*/
Function focus
	
	GOTO OBJECT:C206(*;This:C1470.name)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════*/