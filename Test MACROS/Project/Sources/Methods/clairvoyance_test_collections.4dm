//%attributes = {}
/* Clairvoyance test — FOR EACH.
The 2nd parameter of a For each is a Collection or an Object.
The 1st parameter (loop variable) is Text when the 2nd is an Object; otherwise its
type is inferred from how it is used inside the block (undefined if no hint). */

/* NOTE
the 2nd parameter type of a For each is a collection or an object
the 1st parameter type is Text for an object else depend of the usage into the block
*/

var $collection : Collection
var $item : Object
For each ($item; $collection)  // Object, Collection
	
	var $name : Text:=$item.name  // Not defined, but will be typed as Text below
	var $type : Real:=Num:C11($item.type)  // Integer
	
End for each 

var $key : Text
var $o : Object
For each ($key; $o)  // Text, Object
	
	$name:=$key  // Text
	
End for each 

var $num : Real
For each ($num; $collection)  // Real, Collection
	
	var $sum : Real
	$sum+=$num  // Real
	
End for each 

/*
var $collection : Collection
var $item : Object
For each ($item; $collection)  // Object, Collection
var $name : Text:=$item.name  // Not defined, but will be typed as Text below
var $type : Real:=Num($item.type)  // Integer
End for each 
var $key : Text
var $o : Object
For each ($key; $o)  // Text, Object
$name:=$key  // Text
End for each 
var $num : Real
For each ($num; $collection)  // Real, Collection
var $sum : Real
$sum+=$num  // Real
End for each 
*/