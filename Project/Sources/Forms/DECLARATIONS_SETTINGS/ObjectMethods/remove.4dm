If (Form:C1466.rule.length>1)
	
	Form:C1466.rule.remove(Form:C1466.ruleIndex-1)
	Form:C1466.current.value:=Form:C1466.rule.extract("value").join(";"; ck ignore null or empty:K85:5)
	
	SET TIMER:C645(-1)
	
End if 