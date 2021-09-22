var $rule : Text
var $indx : Integer
var $e; $o : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		If (Is nil pointer:C315(OBJECT Get pointer:C1124(Object subform container:K67:4)))
			
			// As dialog
			Form:C1466.file:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
			
			If (Form:C1466.file.original#Null:C1517)
				
				Form:C1466.file:=Form:C1466.file.original
				
			End if 
			
			Form:C1466.settings:=JSON Parse:C1218(Form:C1466.file.getText())
			Form:C1466.rules:=Form:C1466.settings.declaration.rules.orderBy("label desc")
			Form:C1466.options:=Form:C1466.settings.declaration.options
			
		End if 
		
		OBJECT SET SCROLLBAR:C843(*; "rule"; 0; 2)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Activate:K2:9)\
		 | ($e.code=On Bound Variable Change:K2:52)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Selection Change:K2:29)
		
		Case of 
				
				//……………………………………………………………………………………
			: ($e.objectName="rules")
				
				Form:C1466.rule:=New collection:C1472
				
				For each ($rule; Split string:C1554(Form:C1466.current.value; ";"))
					
					Form:C1466.rule.push(New object:C1471(\
						"value"; $rule))
					
					LISTBOX SELECT ROW:C912(*; "rule"; 1; lk replace selection:K53:1)
					
				End for each 
				
				//……………………………………………………………………………………
			: ($e.objectName="rule")
				
				If (Form:C1466.ruleSelected.length=1)
					
					Form:C1466.ruleCurrent:=Form:C1466.ruleSelected[0]
					
				Else 
					
					$o:=Form:C1466.rule.query("value=:1"; Form:C1466.ruleCurrent.value).pop()
					$indx:=Form:C1466.rule.indexOf($o)
					LISTBOX SELECT ROW:C912(*; "rule"; $indx+1; lk replace selection:K53:1)
					
				End if 
				
				//……………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		Form:C1466.rule:=New collection:C1472
		
		If (Form:C1466.current=Null:C1517)
			
			LISTBOX SELECT ROW:C912(*; "rules"; 1; lk replace selection:K53:1)
			SET TIMER:C645(-1)
			
		Else 
			
			For each ($rule; Split string:C1554(Form:C1466.current.value; ";"))
				
				Form:C1466.rule.push(New object:C1471(\
					"value"; $rule))
				
			End for each 
			
			If (Form:C1466.ruleIndex#0)
				
				If (Form:C1466.ruleIndex>Form:C1466.rule.length)
					
					LISTBOX SELECT ROW:C912(*; "rule"; Form:C1466.rule.length; lk replace selection:K53:1)
					Form:C1466.ruleCurrent:=Form:C1466.rule[Form:C1466.rule.length-1]
					
				Else 
					
					LISTBOX SELECT ROW:C912(*; "rule"; Form:C1466.ruleIndex; lk replace selection:K53:1)
					Form:C1466.ruleCurrent:=Form:C1466.rule[Form:C1466.ruleIndex-1]
					
				End if 
				
			Else 
				
				LISTBOX SELECT ROW:C912(*; "rule"; 1; lk replace selection:K53:1)
				Form:C1466.ruleCurrent:=Form:C1466.rule[0]
				
			End if 
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 