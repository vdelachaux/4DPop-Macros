C_BOOLEAN:C305($bInit)
C_TEXT:C284($t)
C_OBJECT:C1216($event)

$event:=FORM Event:C1606

Case of 
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
		If (Is nil pointer:C315(OBJECT Get pointer:C1124(Object subform container:K67:4)))
			
			  // As dialog
			Form:C1466.file:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings").original
			Form:C1466.settings:=JSON Parse:C1218(Form:C1466.file.getText())
			Form:C1466.rules:=Form:C1466.settings.declaration.rules.orderBy("label desc")
			Form:C1466.options:=Form:C1466.settings.declaration.options
			
			$bInit:=True:C214
			
		End if 
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($event.code=On Activate:K2:9)\
		 | ($event.code=On Bound Variable Change:K2:52)
		
		$bInit:=(Form:C1466.selected=Null:C1517)
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		$bInit:=(Form:C1466.Form.ruleCurrent=Null:C1517)
		OBJECT SET ENABLED:C1123(*;"variableNumber@";Not:C34(Form:C1466.options.oneLinePerVariable))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //______________________________________________________
End case 

If ($bInit)
	
	LISTBOX SELECT ROW:C912(*;"rules";1;lk replace selection:K53:1)
	
	Form:C1466.rule:=New collection:C1472
	
	For each ($t;Split string:C1554(Form:C1466.rules[0].value;";"))
		
		Form:C1466.rule.push(New object:C1471(\
			"value";$t))
		
	End for each 
	
	LISTBOX SELECT ROW:C912(*;"rule";1;lk replace selection:K53:1)
	Form:C1466.ruleCurrent:=Form:C1466.rule[0]
	
	GOTO OBJECT:C206(*;"rules")
	
End if 