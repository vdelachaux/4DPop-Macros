If (Not:C34(Is compiled mode:C492))
	
	// Init
	EXECUTE METHOD:C1007("4DPopMacrosINIT")
	
	// Installing quickOpen
	ARRAY TEXT:C222($components; 0)
	COMPONENT LIST:C1001($components)
	
	If (Find in array:C230($components; "4DPop QuickOpen")>0)
		
		EXECUTE METHOD:C1007("quickOpenInit"; *; Formula:C1597(MODIFIERS); Formula:C1597(KEYCODE))
		ON EVENT CALL:C190("quickOpenEventHandler"; "$quickOpenListener")
		
	End if 
End if 