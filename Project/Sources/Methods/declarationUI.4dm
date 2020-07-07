//%attributes = {}
var $0 : Object

$0:=New object:C1471
$0.cell:=New object:C1471(\
"value"; New object:C1471())

If (This:C1470.type=Null:C1517)
	
	$0.stroke:="red"
	
Else 
	
	$0.stroke:="black"
	$0.fontWeight:="bold"
	
	If (Bool:C1537(This:C1470.array))
		
		$0.textDecoration:="underline"
		
	End if 
End if 