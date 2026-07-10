//%attributes = {}
/* Clairvoyance test — command RETURN types ($var := Command(…)).
Each variable is assigned on its own line, so the declaration is MERGED with the
assignment: "var $x : Type := …". Types come from the command definition. */


$d:=Current date:C33  // Date
$t:=Current time:C178  // Time
$ms:=Milliseconds:C459  // Integer
$up:=Uppercase:C13("hello")  // Text
$len:=Length:C16("hello")  // Integer
$r:=Num:C11("3.14")  // Real
$col:=Split string:C1554("a,b,c"; ",")  // Collection
$b:=Is macOS:C1572  // Boolean
$store:=Storage:C1525  // Object
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

