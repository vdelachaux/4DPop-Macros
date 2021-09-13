//%attributes = {}
If (False:C215)
	
	//var $t; $tt; $ttt : Text
	//var $indx : Integer
	//var $c : Collection
	var $t : Text
	var $o; $z : Object
	var $toto : 4D:C1709.File
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
	$toto:=4D:C1709.File.new()
	$o:=New object:C1471
	$z:=New object:C1471
	
	$t:=String:C10(1)
	$t:=String:C10(1)
	
	
Else 
	
	//METHOD SET COMMENTS("4DPop_Macros"; "TEST"; *)
	
	
	//$file:=$x
	
	//$toto:=Substring($hello; 1; 1)
	//$world:=Num($toto)
	
	_O_C_STRING:C293(10; $alpha)
	
	//C_LONGINT($indx)
	//$indx:=Form.rule.indexOf(Form.ruleSelected[0])
	
End if 