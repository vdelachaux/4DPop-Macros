//%attributes = {}
$src:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop v11/preferences.xml")

$o:=cs:C1710.xml.me.fileToObject($src.platformPath)
/*
var $src : 4D.File:=Folder(fk user preferences folder).file("4DPop v11/preferences.xml")

var $o : Object:=cs.xml.me.fileToObject($src.platformPath)
*/