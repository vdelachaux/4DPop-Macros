//%attributes = {}
//C_TEXT($1)
//C_VARIANT($2)
//C_LONGINT($0)//comments
#DECLARE($t : Text; $v) : Object

If (False:C215)
	C_TEXT:C284(DECLARE; $1)
	C_VARIANT:C1683(DECLARE; $2)
	C_OBJECT:C1216(DECLARE; $0)
End if 

var $text : Text
var $i : Integer
var $o : Object

$text:=$t
//$variant:=$v
$i:=20

$o:=New object:C1471
$o.text:=$text+String:C10($i)
$o.count:=$i
return ($o)