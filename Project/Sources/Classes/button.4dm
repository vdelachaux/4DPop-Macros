/*

Some specificity for button widgets

*/

/*═══════════════════*/
Class extends widget
/*═══════════════════*/

Class constructor
	
	C_VARIANT:C1683($1)
	
	Super:C1705($1)
	
/*════════════════════════════════════════════
Tryes to underline the first capital letter or, 
if not found the first letter, corresponding to 
the associated key shortcut
════════════════════════════════════════════*/
Function highlightShortcut
	
	C_LONGINT:C283($index;$lModifier)
	C_TEXT:C284($key;$t)
	
	OBJECT GET SHORTCUT:C1186(*;This:C1470.name;$key;$lModifier)
	
	If (Length:C16($key)>0)
		
		$t:=This:C1470.getTitle()
		
		$index:=Position:C15(Uppercase:C13($key);$t;*)
		
		If ($index=0)
			
			$index:=Position:C15($key;$t)
			
		End if 
		
		If ($index>0)
			
			This:C1470.setTitle(Substring:C12($t;1;$index)+Char:C90(0x0332)+Substring:C12($t;$index+1))
			
		End if 
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
A hack to force a button to be boolean type
	
⚠️ Obsolete in project mode because you can 
   choose the type for the checkboxes
════════════════════════════════════════════*/
Function asBoolean
	
	If (This:C1470.type=Object type checkbox:K79:26)
		If (This:C1470.assignable)
			
			EXECUTE FORMULA:C63(":C305((:C1124(:K67:5;This.name))->)")
			
		End if 
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470