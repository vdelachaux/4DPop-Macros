
/*═══════════════════*/
Class extends widget
/*═══════════════════*/

Class constructor
	
	C_TEXT:C284($1)
	C_VARIANT:C1683($2)
	
	If (Count parameters:C259>=2)
		
		Super:C1705($1;$2)
		
	Else 
		
		Super:C1705($1)
		
	End if 
	
	ASSERT:C1129(New collection:C1472(\
		Object type subform:K79:40;\
		Object type listbox:K79:8;\
		Object type picture input:K79:5;\
		Object type hierarchical list:K79:7).indexOf(This:C1470.type)#-1)
	
/*════════════════════════════════════════════*/
Function getScrollPosition
	
	C_OBJECT:C1216($0)
	C_LONGINT:C283($lVertical;$lHorizontal)
	
	OBJECT GET SCROLL POSITION:C1114(*;This:C1470.name;$lVertical;$lHorizontal)
	
	If (This:C1470.type=Object type picture input:K79:5)\
		 | (This:C1470.type=Object type listbox:K79:8)
		
		This:C1470.scroll:=New object:C1471(\
			"vertical";$lVertical;\
			"horizontal";$lHorizontal)
		
	Else 
		
		This:C1470.scroll:=$lVertical
		
	End if 
	
	$0:=This:C1470.scroll
	
/*════════════════════════════════════════════*/
Function setScrollPosition
	
	C_LONGINT:C283($1;$2;$lVertical;$lHorizontal)
	
	OBJECT GET SCROLL POSITION:C1114(*;This:C1470.name;$lVertical;$lHorizontal)
	
	$lVertical:=$1
	
	If (Count parameters:C259>=2)\
		 & ((This:C1470.type=Object type picture input:K79:5) | (This:C1470.type=Object type listbox:K79:8))
		
		$lHorizontal:=$2
		
		OBJECT SET SCROLL POSITION:C906(*;This:C1470.name;$lVertical;$lHorizontal;*)
		
		This:C1470.scroll:=New object:C1471(\
			"vertical";$lVertical;\
			"horizontal";$lHorizontal)
		
	Else 
		
		OBJECT SET SCROLL POSITION:C906(*;This:C1470.name;$lVertical;*)
		
		This:C1470.scroll:=$lVertical
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	