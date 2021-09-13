// ----------------------------------------------------
// Form method : SETTINGS - (4DPop Macros)
// ID[E2F45189436B404AB8C5D63F271B7B0F]
// Created #2-12-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_POINTER:C301($ptr)
C_TEXT:C284($t)
C_OBJECT:C1216($e; $o)

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		OBJECT SET VALUE:C1742("declarations"; New object:C1471(\
			"rules"; Form:C1466.settings.declaration.rules.orderBy("label desc"); \
			"options"; Form:C1466.settings.declaration.options))
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Unload:K2:2)
		
		For each ($o; Form:C1466.beautifier)
			
			Form:C1466.settings.beautifier[$o.key]:=$o.on
			
		End for each 
		
		Form:C1466.file.setText(JSON Stringify:C1217(Form:C1466.settings; *))
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		//$ptr:=OBJECT Get pointer(Object named; "declarations")
		//$ptr->:=$ptr->
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessary ("+$e.description+")")
		
		//______________________________________________________
End case 