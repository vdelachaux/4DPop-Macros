C_LONGINT:C283($l)

$l:=Selected list items:C379(*; OBJECT Get name:C1087(Object current:K67:2); *)

If ($l#0)
	
	Form:C1466.subset:=Form:C1466.variables.query("type=:1"; $l)
	
Else 
	
	Form:C1466.subset:=Form:C1466.variables
	
End if 