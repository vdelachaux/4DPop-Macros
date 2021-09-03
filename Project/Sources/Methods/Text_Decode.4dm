//%attributes = {"invisible":true}
// ----------------------------------------------------
// Methode : Private_Decode_Text
// Created 24/02/06 par Vincent de Lachaux
// ----------------------------------------------------
// Description
// Decodes Text $1  encoded with encoding $2 (UTF-8 if $2 is missing)
// ----------------------------------------------------
// Modified by vdl (08/10/07)
// 2004 -> v11
// ----------------------------------------------------
var $0 : Text
var $1 : Text
var $2 : Text

If (False:C215)
	C_TEXT:C284(Text_Decode; $0)
	C_TEXT:C284(Text_Decode; $1)
	C_TEXT:C284(Text_Decode; $2)
End if 

var $charSet; $result; $target : Text
var $buffer : Blob

$target:=$1
$charSet:="UTF-8"

If (Count parameters:C259>=2)
	
	$charSet:=$2
	
End if 

If (Length:C16($target)>0)
	
	TEXT TO BLOB:C554($target; $buffer; Mac text without length:K22:10)
	$result:=Convert to text:C1012($buffer; $charSet)
	
End if 

$0:=$result