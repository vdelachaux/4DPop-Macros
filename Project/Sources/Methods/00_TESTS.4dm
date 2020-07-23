//%attributes = {}
var $t; $tt; $ttt : Text
var $indx : Integer
var $c : Collection

$t:="$c:=Split string($t; \",\"; sk trim spaces).map(\"col_formula\"; Formula($1.result:=Num($1.value)))"

$indx:=Position:C15("Formula("; $t; 1; *)

If ($indx>0)
	
	$tt:=Substring:C12($t; $indx)
	$c:=Split string:C1554($tt; "(")
	$c[$c.length-1]:=Replace string:C233($c[$c.length-1]; ")"; ""; $c.length-2)
	$ttt:=$c.join("(")
	
	$t:=Replace string:C233($t; $ttt; "")
	
Else 
	
	// A "If" statement should never omit "Else"
	
End if 