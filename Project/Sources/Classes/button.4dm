/*

Some specificity for button widgets

*/

/*═══════════════════*/
Class extends widget
/*═══════════════════*/

Class constructor
	
	C_VARIANT:C1683($1)
	
	Super:C1705($1)
	
	If (This:C1470.events.length=0)
		
		This:C1470.events:=New collection:C1472(On Clicked:K2:4)
		
	End if 
	
/*════════════════════════════════════════════
Tryes to underline the first capital letter or, 
if not found the first letter, corresponding to 
the associated key shortcut
══════════════════════════*/
Function highlightShortcut()->$this : cs:C1710.button
	
	var $key; $t : Text
	var $index; $lModifier : Integer
	
	OBJECT GET SHORTCUT:C1186(*; This:C1470.name; $key; $lModifier)
	
	If (Length:C16($key)>0)
		
		$t:=This:C1470.getTitle()
		
		$index:=Position:C15(Uppercase:C13($key); $t; *)
		
		If ($index=0)
			
			$index:=Position:C15($key; $t)
			
		End if 
		
		If ($index>0)
			
			This:C1470.setTitle(Substring:C12($t; 1; $index)+Char:C90(0x0332)+Substring:C12($t; $index+1))
			
		End if 
	End if 
	
	$this:=This:C1470
	
/*════════════════════════════════════════════
A hack to force a button to be boolean type
	
⚠️ Obsolete in project mode because you can
choose the type for the checkboxes
══════════════════════════*/
Function asBoolean()
	var $0 : Object
	
	If (This:C1470.type=Object type checkbox:K79:26)
		If (This:C1470.assignable)
			
			EXECUTE FORMULA:C63("C_BOOLEAN:C305((OBJECT Get pointer:C1124(Object named:K67:5;This.name))->)")
			
		End if 
	End if 
	
	$0:=This:C1470