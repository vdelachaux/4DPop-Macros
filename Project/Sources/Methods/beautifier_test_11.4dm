//%attributes = {"invisible":true,"preemptive":"capable"}
//1220
var $pic : Picture
var $dom : Text
var $o : Object
var $v; $vv

$v:=""
$vv:=""

If ($v="")
	
End if 

OB SET:C1220($o; "property"; "value"; "property1"; "value1"; "property2"; "valu2"; "property3"; "value3")

OB SET:C1220($o; "property"; 12-(10*2); "property1"; "value1"; "property2"; "valu2"; "property3"; "value3")  //test2

OB SET:C1220($o; "property"; "value")

SVG SET ATTRIBUTE:C1055(*; "toto"; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")

SVG SET ATTRIBUTE:C1055($pic; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")

DOM SET XML ATTRIBUTE:C866($dom; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")