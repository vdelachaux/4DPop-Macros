Class extends scrollable

Class constructor
	
	C_VARIANT:C1683($1)
	
	Super:C1705($1)
	
	ASSERT:C1129(This:C1470.type=Object type listbox:K79:8)
	
	If (This:C1470.events.length=0)
		
		This:C1470.events:=New collection:C1472(On Selection Change:K2:29)
		
	End if 