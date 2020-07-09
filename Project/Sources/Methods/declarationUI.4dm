//%attributes = {}
var $0 : Object


$0:=New object:C1471

$0.cell:=New object:C1471

$0.cell.count:=New object:C1471
$0.cell.count.textDecoration:="normal"
$0.cell.count.fontWeight:="normal"
$0.cell.count.fontStyle:="normal"

$0.cell.value:=New object:C1471

If (Bool:C1537(This:C1470.array))
	
	$0.cell.value.textDecoration:="underline"
	
End if 

If (FORM Event:C1606.isRowSelected)
	
	If (This:C1470.type=0)
		
		$0.stroke:="white"
		$0.fill:="red"
		
	Else 
		
		$0.fill:="royalblue"
		
		If (This:C1470.count=0)
			
			$0.stroke:="orange"
			
		End if 
	End if 
	
Else 
	
	If (This:C1470.type=0)
		
		$0.stroke:="red"
		
	Else 
		
		If (This:C1470.count=0)
			
			$0.stroke:="orange"
			
		Else 
			
			$0.fontWeight:="bold"
			
		End if 
	End if 
End if 

