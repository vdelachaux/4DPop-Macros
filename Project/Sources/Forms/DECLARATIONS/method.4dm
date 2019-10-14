  // ----------------------------------------------------
  // Méthode : Méthode formulaire : zPop_Declarations
  // Created 20/08/02 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (23/11/04)
  // 2004 Compatibility
  // Modified by Vincent de Lachaux (02/01/07)
  // New for v11: without Qfree
  // ----------------------------------------------------
C_LONGINT:C283($l;$Lon_event)
C_TEXT:C284($t)

$Lon_event:=Form event code:C388

Case of 
		
		  //____________________________________________________
	: ($Lon_event=On Load:K2:1)
		
		<>list:=New list:C375
		Form:C1466.list:=-><>list
		
		OBJECT SET DATA SOURCE:C1264(*;"list.hresize";Form:C1466.list)
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"spinner"))->:=1
		(OBJECT Get pointer:C1124(Object named:K67:5;"var.NotParameter"))->:=1
		
		Preferences ("Get_Value";"ignoreDeclarations";OBJECT Get pointer:C1124(Object named:K67:5;"ignoreDirectives"))
		Preferences ("Get_Value";"numberOfVariablePerLine";OBJECT Get pointer:C1124(Object named:K67:5;"variableNumber"))
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"projectMethodDirective"))->:=Num:C11(Storage:C1525.macros.preferences.options ?? 27)
		(OBJECT Get pointer:C1124(Object named:K67:5;"oneLinePerVariable"))->:=Num:C11(Storage:C1525.macros.preferences.options ?? 28)
		(OBJECT Get pointer:C1124(Object named:K67:5;"trimEmptyLines"))->:=Num:C11(Storage:C1525.macros.preferences.options ?? 29)
		(OBJECT Get pointer:C1124(Object named:K67:5;"alphaToText"))->:=Num:C11(Storage:C1525.macros.preferences.options ?? 30)
		(OBJECT Get pointer:C1124(Object named:K67:5;"generateComments"))->:=Num:C11(Storage:C1525.macros.preferences.options ?? 31)
		
		OBJECT SET ENABLED:C1123(*;"projectMethodDirective";Position:C15(Get localized string:C991("Method");Form:C1466.title)=1)  // Disabled if not a project method
		
		Obj_CENTERED ("spinner";"list.hresize";Horizontally centered:K39:1+Vertically centered:K39:4)
		
		CALL FORM:C1391(Current form window:C827;"DECLARATION";"INIT")
		
		  //____________________________________________________
	: ($Lon_event=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		  //____________________________________________________
	: ($Lon_event=On Menu Selected:K2:14)
		
		$t:=Get selected menu item parameter:C1005
		
		Case of 
				
				  //………………………………………………………………………………
			: ($t="closeWindow")
				
				CANCEL:C270
				
				  //………………………………………………………………………………
		End case 
		
		  //____________________________________________________
	: ($Lon_event=On Resize:K2:27)
		
		Obj_CENTERED ("spinner";"list.hresize")
		
		  //____________________________________________________
	: ($Lon_event=On Unload:K2:2)
		
		If (Is a list:C621((Form:C1466.list)->))
			
			CLEAR LIST:C377((Form:C1466.list)->;*)
			
		End if 
		
		  //____________________________________________________
End case 