C_LONGINT:C283($indx)

If (Form:C1466.rule.length>1)
	
	$indx:=Form:C1466.rule.indexOf(Form:C1466.ruleSelected[0])
	Form:C1466.rule.remove($indx)
	
	Form:C1466.selected[0].value:=Form:C1466.rule.extract("value").join(";";ck ignore null or empty:K85:5)
	
	If ($indx>Form:C1466.rule.length)
		
		$indx:=Form:C1466.rule.length
		
	End if 
	
	LISTBOX SELECT ROW:C912(*;"rule";$indx;lk replace selection:K53:1)
	Form:C1466.ruleCurrent:=Form:C1466.rule[0]
	
End if 