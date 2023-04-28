//%attributes = {"invisible":true,"preemptive":"capable"}
// Comment
// Declaration
var $t : Text
var $c : Collection

// Init

$c:=Split string:C1554($t; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))