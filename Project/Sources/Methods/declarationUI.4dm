//%attributes = {}
var $0 : Object

$0:=New object:C1471
$0.cell:=New object:C1471
$0.cell.value:=New object:C1471

$0.cell.count:=New object:C1471
$0.cell.count.stroke:=Choose:C955(This:C1470.count=0;"orange";"grey")
$0.cell.count.textDecoration:="normal"

If (This:C1470.type=Null:C1517)
	
	$0.stroke:="red"
	
Else 
	
	$0.stroke:=Choose:C955(This:C1470.count=0;"orange";"black")
	$0.fontWeight:="bold"
	
	If (Bool:C1537(This:C1470.array))
		
		$0.textDecoration:="underline"
		
	End if 
End if 