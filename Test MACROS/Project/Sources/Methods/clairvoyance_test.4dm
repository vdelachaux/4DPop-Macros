//%attributes = {}

For ($i; 1; $number; 1)
	
	$file:=File:C1566(Backup history file:K5:59)
	
End for 
/*
var $i; $number : Integer
For ($i; 1; $number; 1)

var $file : 4D.File:=File(Backup history file)
*/

If (Match regex:C1019($pattern; $line; 1; $pos; $len))
	
	$result:=Substring:C12($line; $pos; $len)
	
End if 
/*
var $len; $pos : Integer
var $line; $pattern : Text
If (Match regex($pattern; $line; 1; $pos; $len))

var $result : Text:=Substring($line; $pos; $len)

End if 
*/

For each ($row; $entry.Params)
	
	$label:=Lowercase:C14(String:C10($row[0]))
	
	If (($label="function result") || ($label="result") || ($label="résultat"))
		
		return This:C1470._const(String:C10($row[1]))
		
	End if 
End for each 
/*
var $entry : Object
var $row : Collection
For each ($row; $entry.Params)

var $label : Text:=Lowercase(String($row[0]))

If (($label="function result") || ($label="result") || ($label="résultat"))

return This._const(String($row[1]))

End if 
End for each
*/
