//%attributes = {}
/* Clairvoyance test — CLASS instances. Class-typed variables are declared with
their class name (File/Folder detected specifically; cs.xxx.new() records the user
class). Each is assigned → declaration merged with the assignment. */

$file:=File:C1566("/PACKAGE/data.json")  // 4D.File
$folder:=Folder:C1567(fk database folder:K87:14)  // 4D.Folder

$obj:=cs:C1710.myClass.new()  // cs.myClass

EXPORT STRUCTURE:C1311($xmlStructure)
$xml:=cs:C1710.svgx.xml.new($xmlStructure)
$structure:=$xml.toObject()
$svg:=cs:C1710.svgx.svg.new()
$xml.close()

/*
var $file : 4D.File:=File("/PACKAGE/data.json")  // 4D.File
var $folder : 4D.Folder:=Folder(fk database folder)  // 4D.Folder

var $obj : cs.myClass:=cs.myClass.new()  // cs.myClass

var $xmlStructure : Text
EXPORT STRUCTURE($xmlStructure)
var $xml : cs.svgx.xml:=cs.svgx.xml.new($xmlStructure)
var $structure : Object:=$xml.toObject()
var $svg : cs.svgx.svg:=cs.svgx.svg.new()
$xml.close()
*/

