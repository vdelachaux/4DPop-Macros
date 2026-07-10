//%attributes = {}
/* Clairvoyance test — command RETURN types ($var := Command(…)).
Each variable is assigned on its own line, so the declaration is MERGED with the
assignment: "var $x : Type := …". Types come from the command definition. */

/*
$d:=Current date  // Date
$t:=Current time  // Time
$ms:=Milliseconds  // Integer
$up:=Uppercase("hello")  // Text
$len:=Length("hello")  // Integer
$r:=Num("3.14")  // Real
$col:=Split string("a,b,c"; ",")  // Collection
$b:=Is macOS  // Boolean
$store:=Storage  // Object
/*
var $d : Date:=Current date  // Date
var $t : Time:=Current time  // Time
var $ms : Integer:=Milliseconds  // Integer
var $up : Text:=Uppercase("hello")  // Text
var $len : Integer:=Length("hello")  // Integer
var $r : Real:=Num("3.14")  // Real
var $col : Collection:=Split string("a,b,c"; ",")  // Collection
var $b : Boolean:=Is macOS  // Boolean
var $store :object :=Storage  // Object
*/
*/

