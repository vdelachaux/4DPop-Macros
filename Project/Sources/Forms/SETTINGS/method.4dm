  // ----------------------------------------------------
  // Form method : SETTINGS - (4DPop Macros)
  // ID[E2F45189436B404AB8C5D63F271B7B0F]
  // Created #2-12-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_POINTER:C301($ptr)
C_TEXT:C284($t)
C_OBJECT:C1216($event;$o)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
		Form:C1466.file:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
		
		If (Not:C34(Form:C1466.file.exists))
			
			  // Use default settings
			File:C1566("/RESOURCES/default.settings").copyTo(Form:C1466.file.parent;"4DPop Macros.settings")
			
		End if 
		
		Form:C1466.settings:=JSON Parse:C1218(Form:C1466.file.getText())
		
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5;"declarations")
		$ptr->:=New object:C1471(\
			"rules";Form:C1466.settings.declaration.rules.orderBy("label desc");\
			"options";Form:C1466.settings.declaration.options)
		
		Form:C1466.beautifier:=New collection:C1472
		
		For each ($t;Form:C1466.settings.beautifier)
			
			Form:C1466.beautifier.push(New object:C1471(\
				"key";$t;\
				"label";Get localized string:C991($t);\
				"on";Bool:C1537(Form:C1466.settings.beautifier[$t])))
			
		End for each 
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($event.code=On Unload:K2:2)
		
		For each ($o;Form:C1466.beautifier)
			
			Form:C1466.settings.beautifier[$o.key]:=$o.on
			
		End for each 
		
		Form:C1466.file.setText(JSON Stringify:C1217(Form:C1466.settings;*))
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5;"declarations")
		$ptr->:=$ptr->
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessary ("+$event.description+")")
		
		  //______________________________________________________
End case 