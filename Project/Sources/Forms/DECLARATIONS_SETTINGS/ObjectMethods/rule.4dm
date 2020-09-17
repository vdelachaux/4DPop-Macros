C_LONGINT:C283($indx)
C_OBJECT:C1216($event;$o)

$event:=FORM Event:C1606

Case of 
		
		  //______________________________________________________
	: ($event.code=On Selection Change:K2:29)
		
		If (Form:C1466.ruleSelected.length=1)
			
			Form:C1466.ruleCurrent:=Form:C1466.ruleSelected[0]
			
		Else 
			
			$o:=Form:C1466.rule.query("value=:1";Form:C1466.ruleCurrent.value).pop()
			$indx:=Form:C1466.rule.indexOf($o)
			LISTBOX SELECT ROW:C912(*;"rule";$indx+1;lk replace selection:K53:1)
			
		End if 
		
		  //______________________________________________________
	: ($event.code=On Double Clicked:K2:5)
		
		  // Add
		Form:C1466.ruleCurrent:=New object:C1471(\
			"value";"")
		Form:C1466.rule.push(Form:C1466.ruleCurrent)
		LISTBOX SELECT ROW:C912(*;"rule";Form:C1466.rule.length;lk replace selection:K53:1)
		GOTO OBJECT:C206(*;"input")
		
		  //______________________________________________________
	: ($event.code=On Delete Action:K2:56)
		
		  // Remove
		
		$indx:=Form:C1466.rule.indexOf(Form:C1466.ruleSelected[0])
		Form:C1466.rule.remove($indx)
		
		Form:C1466.selected[0].value:=Form:C1466.rule.extract("value").join(";";ck ignore null or empty:K85:5)
		
		If ($indx>Form:C1466.rule.length)
			
			$indx:=Form:C1466.rule.length
			
		End if 
		
		LISTBOX SELECT ROW:C912(*;"rule";$indx;lk replace selection:K53:1)
		Form:C1466.ruleCurrent:=Form:C1466.rule[0]
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessary ("+$event.description+")")
		
		  //______________________________________________________
End case 