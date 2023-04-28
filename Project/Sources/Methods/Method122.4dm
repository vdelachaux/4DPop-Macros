//%attributes = {"invisible":true,"preemptive":"capable"}
//%W-550.4
//%W-550.2
var $xmlStructure : Text
var $structure : Object
var $svg : cs:C1710.svg
var $xml : cs:C1710.xml

EXPORT STRUCTURE:C1311($xmlStructure)
$xml:=cs:C1710.xml.new($xmlStructure)

$structure:=$xml.toObject()

$svg:=cs:C1710.svg.new()

$xml.close()
//%W+550.2
//%W+550.4