//%attributes = {}
//var $t; $tt; $ttt : Text
//var $indx : Integer
//var $c : Collection
var $file; $o; $z : Object
var $button; $button2 : cs:C1710.button

//$t:="$c:=Split string($t; \",\"; sk trim spaces).map(\"col_formula\"; Formula($1.result:=Num($1.value)))"

//$indx:=Position("Formula("; $t; 1; *)

//If ($indx>0)

//$tt:=Substring($t; $indx)
//$c:=Split string($tt; "(")
//$c[$c.length-1]:=Replace string($c[$c.length-1]; ")"; ""; $c.length-2)
//$ttt:=$c.join("(")

//$t:=Replace string($t; $ttt; "")

//Else

//// A "If" statement should never omit "Else"

//End if

$button:=cs:C1710.button.new()
$button2:=cs:C1710.button.new()
$file:=4D:C1709.File.new()
$o:=New object:C1471
$z:=New object:C1471
