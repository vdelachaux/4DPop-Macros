//%attributes = {"invisible":true,"preemptive":"capable"}
If (Length:C16(($txt)=0)\
 | (Length:C16($txt)#0))\
 & (True:C214)  // SPLIT TEST LINES WITH & AND |
	
	$Txt:="titi"
	
End if 

/*
var $txt : Text
If (Length(($txt)=0)\
| (Length($txt)#0))\
& (True)  // SPLIT TEST LINES WITH & AND |

$Txt:="titi"

End if 
*/