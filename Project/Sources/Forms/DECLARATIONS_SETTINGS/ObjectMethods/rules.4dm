C_TEXT:C284($t)

Form:C1466.rule:=New collection:C1472

For each ($t;Split string:C1554(Form:C1466.selected[0].value;";"))
	
	Form:C1466.rule.push(New object:C1471("value";$t))
	
End for each 

LISTBOX SELECT ROW:C912(*;"rule";1;lk replace selection:K53:1)
Form:C1466.ruleCurrent:=Form:C1466.rule[0]