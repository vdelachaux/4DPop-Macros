//%attributes = {}
/* Clairvoyance test — MEMBER functions / attributes ($var.member → return type),
plus RECEIVER class inference from the accessed member names.
The receiver class is derived from the member (e.g. .getText → 4D.File, .length →
Collection, .file → 4D.Folder). Members that belong to too many classes (.size,
.name) are too generic → the receiver stays Object. A variable assigned from a
member call gets that member's return class when it is unambiguous (.file → 4D.File).
The heuristic is priority-based, so an ambiguous member may be guessed on the most
common class (e.g. .extension → 4D.File even on a Folder); review in the dialog. */

/*
$txt:=$file.getText()  // Text        ($file → 4D.File)
$ext:=$file.extension  // Text
$n:=$col.length  // Integer        ($col → Collection)
$child:=$folder.file("data.json")  // 4D.File        ($folder → 4D.Folder)
$size:=$blob.size  // Undefined (Integer/Real across classes) — ($blob → Object, .size too generic)
$item:=$col.at(1)  // Undefined (any / Entity)
/*
var $file : 4D.File
var $txt : Text:=$file.getText()  // Text        ($file → 4D.File)
var $ext : Text:=$file.extension  // Text
var $col : Collection
var $n : Integer:=$col.length  // Integer        ($col → Collection)
var $folder : 4D.Folder
var $child : 4D.File:=$folder.file("data.json")  // 4D.File        ($folder → 4D.Folder)
var $blob : Object
$size:=$blob.size  // Undefined (Integer/Real across classes) — ($blob → Object, .size too generic)
$item:=$col.at(1)  // Undefined (any / Entity)
*/
*/

