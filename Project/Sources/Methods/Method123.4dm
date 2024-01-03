//%attributes = {"invisible":true,"preemptive":"capable"}
//// A "If" statement should never omit "Else"
//#DECLARE($a : Text)
//If (False)
//C_TEXT(Method123; $1)
//End if
//var $x : Blob
//var $o : Object
//$o:=New object
//SET BLOB SIZE($x; 0)
//If (True)
//Else
//// A "If" statement should never omit "Else"
//End if
var $Dom_note; $Dom_source; $Dom_target; $Dom_unit; $File_xlf; $Txt_source : Text
var $Txt_state; $Txt_target; $Txt_value : Text

$Dom_note:=""
$Dom_source:=""
$Dom_target:=""
$Dom_unit:=""
$File_xlf:=""
$Txt_source:=""
$Txt_state:=""
$Txt_target:=""
$Txt_value:=""


// The declaration must win
//%W-550.4
var $pi : Real
var $toto : Integer
var $x : Object
var $y : Collection
//var $catalog; $datastore : cs.catalog

//$datastore:=cs.catalog.new()
//$catalog:=cs.catalog.new()

//$y:=cs.catalog.new().buildExposedCatalog()
$toto:=1
$pi:=3.14116

//$x:=cs.catalog.new().buildExposedDatastore()
//%W+550.4