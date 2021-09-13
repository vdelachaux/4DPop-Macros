var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Double Clicked:K2:5)
		
		// Add
		Form:C1466.ruleCurrent:=New object:C1471("value"; "")
		Form:C1466.rule.push(Form:C1466.ruleCurrent)
		LISTBOX SELECT ROW:C912(*; "rule"; Form:C1466.rule.length; lk replace selection:K53:1)
		GOTO OBJECT:C206(*; "input")
		
		//______________________________________________________
	: ($e.code=On Delete Action:K2:56)
		
		Form:C1466.rule.remove(Form:C1466.ruleIndex-1)
		Form:C1466.current.value:=Form:C1466.rule.extract("value").join(";"; ck ignore null or empty:K85:5)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
End case 