//%attributes = {"invisible":true,"preemptive":"incapable"}
//1220
var $dom; $node; $root; $xpath : Text
var $pic : Picture
var $o : Object

OB SET:C1220($o; "property"; 0; "property1"; 1; "property2"; 2; "property3"; 3)

OB SET:C1220($o; "property"; 12-(10*2); "property1"; "value1"; "property2"; "valu2"; "property3"; "value3")  // Test2

OB SET:C1220($o; "property"; "value"; "property1"; {test: "hello"; test2: "world"}; "property2"; "valu2"; "property3"; "value3")

OB SET:C1220($o; "property"; "value")

//OB SET($o; "property"; 0; "property1"; 1; "property2"; 2; "property3"; 3; "zz")/* ERROR IN PARAMETER COUNT */

SVG SET ATTRIBUTE:C1055(*; "toto"; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")

SVG SET ATTRIBUTE:C1055($pic; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")

SVG SET ATTRIBUTE:C1055($pic; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment

SVG SET ATTRIBUTE:C1055(*; "toto"; "id"; "attribute"; "value"; "attribute1"; "value1")

SVG SET ATTRIBUTE:C1055(*; "toto"; "id"; "attribute"; "value")

SVG SET ATTRIBUTE:C1055($pic; "id"; "attribute"; "value")  // Comment

DOM SET XML ATTRIBUTE:C866($dom; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment

DOM SET XML ATTRIBUTE:C866($dom; "attribute"; "value")  // Comment

$node:=DOM Create XML element:C865($root; $xpath; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment

//ST SET ATTRIBUTES(*; "toto"; 10; 20; "attribute"; 0; "attribute1"; 1; "attribute2"; 2)  // Comment

//ST SET ATTRIBUTES($txt; $startSel; $endSel; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment

