//%attributes = {}
/* Clairvoyance test — CLASS instances. Class-typed variables are declared with
their class name (File/Folder detected specifically; cs.xxx.new() records the user
class). Each is assigned → declaration merged with the assignment. */

/*
$file:=File("/PACKAGE/data.json")  // 4D.File
$folder:=Folder(fk database folder)  // 4D.Folder
$obj:=cs.myClass.new()  // cs.myClass
/*
var $file : 4D.File:=File("/PACKAGE/data.json")  // 4D.File
var $folder : 4D.Folder:=Folder(fk database folder)  // 4D.Folder
var $obj :cs.myClass :=cs.myClass.new()  // cs.myClass
*/
*/

