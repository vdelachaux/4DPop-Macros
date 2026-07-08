property data : Object

// Control-flow keywords (shared singleton — cs.controlFlow.me).
// Loaded ONCE per 4D session from /RESOURCES/controlFlow.json (it never changes).

shared singleton Class constructor()
	
	This:C1470.data:=OB Copy:C1225(JSON Parse:C1218(File:C1566("/RESOURCES/controlFlow.json").getText()); ck shared:K85:29)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// The control-flow keywords in the current 4D language (US or localized)
Function get keywords() : Collection
	
	return Command name:C538(41)="ALERT" ? This:C1470.data.intl : This:C1470.data.fr
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Translates a US control-flow keyword to the current 4D language
Function localized($control : Text) : Text
	
	return Command name:C538(41)="ALERT" ? $control : This:C1470.data.fr[This:C1470.data.intl.indexOf($control)]
