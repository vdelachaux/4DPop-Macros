//%attributes = {}
/* Clairvoyance test — command PARAMETER types (variable used as an argument).
The type is taken from the position of the argument in the command definition.
These variables are not assigned, so they are declared BEFORE their first use,
GROUPED by type on a single line. */

If (Match regex:C1019($pattern; $subject; $start; $pos; $len))  // Text, Text, Integer, Integer, Integer
	
	ALERT:C41($message)  // Text
	
End if 

/*
var $len; $pos; $start : Integer
var $pattern; $subject : Text
If (Match regex($pattern; $subject; $start; $pos; $len))  // Text, Text, Integer, Integer, Integer

var $message : Text
ALERT($message)  // Text

End if 
*/
