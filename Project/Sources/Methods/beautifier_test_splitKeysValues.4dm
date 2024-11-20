//%attributes = {"invisible":true,"preemptive":"incapable"}
//1220
var $node; $root; $xpath; $txt : Text
var $pic : Picture

// mark:SPLIT LITERAL OBJECT WITH MORE THAN 2 MEMBERS
var $o : Object:={hello: "hello"; world: "World"}/* 2 PROPERTIES OR LESS = NOT SPLITTED */

$o:={property1: "value1"; property2: "value2"; property3: "value3"; property4: "value4"; property5: "value5"}

$o:=New object:C1471("alignement"; "horizontal"; "hAlignment"; Align right:K42:4; "space"; 13)  // USE OBJECT LITETERAL NOTATION 

// SAME FOR COLLECTIONS
var $c : Collection:=["hello"; "world"]/* 2 MEMBERS OR LESS = NOT SPLITTED */

$c:=[1; 2; "hello"; "world"]

// mark:Splittable commands
OB SET:C1220($o; "property"; 0; "property1"; 1; "property2"; 2; "property3"; 3)

OB SET:C1220($o; "property"; 12-(10*2); "property1"; "value1"; "property2"; "valu2"; "property3"; "value3")  // Test2

OB SET:C1220($o; "property"; "value"; "property1"; {test: "hello"; test2: "world"}; "property2"; "valu2"; "property3"; "value3")/* NOT YET MANAGED */

OB SET:C1220($o; "property"; "value"; "property"; "value")/* LESS THAN 3 KEY/VALUE PAIRS = NOT SPLITTED */

/* ERROR IN PARAMETER COUNT = NOT SPLITTED */
//OB SET($o; "property"; 0; "property1"; 1; "property2"; 2; "property3"; 3; "zz")

SVG SET ATTRIBUTE:C1055(*; "toto"; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")

SVG SET ATTRIBUTE:C1055($pic; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")

SVG SET ATTRIBUTE:C1055($pic; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment

SVG SET ATTRIBUTE:C1055(*; "toto"; "id"; "attribute"; "value"; "attribute1"; "value1")

SVG SET ATTRIBUTE:C1055(*; "toto"; "id"; "attribute"; "value")/* NOT SPLITTED */

SVG SET ATTRIBUTE:C1055($pic; "id"; "attribute"; "value")/* NOT SPLITTED */

DOM SET XML ATTRIBUTE:C866($node; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment

DOM SET XML ATTRIBUTE:C866($node; "attribute"; "value")/* NOT SPLITTED */

$node:=DOM Create XML element:C865($root; $xpath; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment

//ST SET ATTRIBUTES(*; "toto"; 10; 20; "attribute"; 0; "attribute1"; 1; "attribute2"; 2)  // Comment

//ST SET ATTRIBUTES($txt; ST Start text; ST End text; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment

