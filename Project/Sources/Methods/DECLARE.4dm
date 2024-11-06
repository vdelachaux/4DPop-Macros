//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($t : Text; $v) : Object

var $text : Text
var $i : Integer
var $o : Object

$text:=$t
$i:=20

$o:=New object:C1471
$o.text:=$text+String:C10($i)
$o.count:=$i
return ($o)