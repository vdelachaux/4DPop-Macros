//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : METHOD_Syntax
// ID[D8D6EBA99147457E8AF91D1BE651AF8B]
// Created #4-2-2013 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($code : Text; $name : Text; $prefix : Text) : Text

var $end; $i : Integer
var $syntax : Text

ARRAY TEXT:C222($_comments; 0)
ARRAY TEXT:C222($_labels; 0)
ARRAY TEXT:C222($_types; 0)

// Get types and labels
METHOD_ANALYSE_TO_ARRAYS($code; ->$_types; ->$_labels; ->$_comments)

// Set style for method name
$name:="<span style=\"font-family:sans-serif;color:gray;font-weight:bold;font-style:italic\">"\
+$name\
+"</span>"

// The first line is the call syntax…
$syntax:="<span style=\"font-family:sans-serif;color:gray;\">"\
+$prefix+Choose:C955(Length:C16($_types{0})>0; \
Choose:C955(Length:C16($_labels{0})=0; $_types{0}; $_labels{0})\
+" := "+$name; $name)

$end:=Size of array:C274($_types)

For ($i; 1; $end; 1)
	
	// Open parentheses or put a separator
	$syntax:=Choose:C955($i=1; $syntax+" ( "; $syntax+" ; ")
	$syntax:=$syntax+$_labels{$i}
	
	If ($i=$end)
		
		// Close the parentheses
		$syntax:=$syntax+" )"
		
	End if 
End for 

//…then describe the parameters…
For ($i; 1; Size of array:C274($_types); 1)
	
	$syntax:=$syntax+"\r"\
		+$prefix+" -&gt; "+$_labels{$i}+" ("+$_types{$i}+")"\
		+Choose:C955(Length:C16($_comments{$i})>0; " - "+$_comments{$i}; "")
	
End for 

//…and the return for a function.
If (Length:C16($_labels{0})>0)
	
	$syntax:=$syntax+"\r"+$prefix+" &lt;- "+$_labels{0}+" ("+$_types{0}+")"\
		+Choose:C955(Length:C16($_comments{0})>0; " - "+$_comments{0}; "")
	
End if 

$syntax:=$syntax+"</span>"

return $syntax  // Prototype