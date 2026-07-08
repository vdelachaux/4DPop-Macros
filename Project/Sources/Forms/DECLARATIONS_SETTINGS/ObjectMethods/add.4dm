Form:C1466.ruleCurrent:={\
value: ""}

Form:C1466.rule.push(Form:C1466.ruleCurrent)
LISTBOX SELECT ROW:C912(*; "rule"; Form:C1466.rule.length; lk replace selection:K53:1)
GOTO OBJECT:C206(*; "input")
