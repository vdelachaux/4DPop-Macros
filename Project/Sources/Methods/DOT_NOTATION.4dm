//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : DOT_NOTATION
// Database: 4DPop Macros
// ID[B4AD544DDA924C80A5A42792F9275088]
// Created #15-3-2018 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($code : Text)

var $WORD_PATTERN; $PATTERN : Text
var $rgx : cs:C1710.rgx.regex

$WORD_PATTERN:="(?mi-s)^(\\w|\\$)*$"

$PATTERN:="(?m-si)"+Command name:C538(1224)+"\\(([^;]*);\"([^\"]*)\";(.*)\\)"
$rgx:=cs:C1710.rgx.regex.new(""; $PATTERN)

While ($rgx.setTarget($code).match())
	
	If (cs:C1710.rgx.regex.new($rgx.group(3); $WORD_PATTERN).match())
		
		$code:=Replace string:C233($code; $rgx.group(1); $rgx.group(2)+"."+$rgx.group(3); 1)
		
	Else 
		
		// Use brackets
		$code:=Replace string:C233($code; $rgx.group(1); $rgx.group(2)+"[\""+$rgx.group(3)+"\"]"; 1)
		
	End if 
End while 

// MARK:-
// OB SET($Obj_;"$test";"hello") -> $Obj_.$test:="hello"
// OB SET($Obj_;"is-compilable";False) -> Obj_["is-compilable"]:=False
$PATTERN:="(?m-si)"+Command name:C538(1220)+"\\(([^;]*);(?:\\\\\\s*)?(?:\"([^\"]*)\";([^;)]*))\\)"
$rgx:=cs:C1710.rgx.regex.new(""; $PATTERN)

While ($rgx.setTarget($code).match())
	
	If (cs:C1710.rgx.regex.new($rgx.group(3); $WORD_PATTERN).match())
		
		$code:=Replace string:C233($code; $rgx.group(1); $rgx.group(2)+"."+$rgx.group(3)+":="+$rgx.group(4); 1)
		
	Else 
		
		// Use brackets
		$code:=Replace string:C233($code; $rgx.group(1); $rgx.group(2)+"[\""+$rgx.group(3)+"\"]:="+$rgx.group(4); 1)
		
	End if 
End while 

// MARK:-
// OB Is defined($Obj_;"compilable") -> $$Obj_.compilable#Null
// OB Is defined($Obj_;"not-compilable") -> $Obj_["not-compilable"]#Null
$PATTERN:="(?m-si)"+Command name:C538(1231)+"\\(([^;]*);\"([^\"]*)\"\\)"
$rgx:=cs:C1710.rgx.regex.new(""; $PATTERN)

While ($rgx.setTarget($code).match())
	
	If (cs:C1710.rgx.regex.new($rgx.group(3); $WORD_PATTERN).match())
		
		$code:=Replace string:C233($code; $rgx.group(1); $rgx.group(2)+"."+$rgx.group(3)+"#"+Command name:C538(1517); 1)
		
	Else 
		
		// Use brackets
		$code:=Replace string:C233($code; $rgx.group(1); $rgx.group(2)+"[\""+$rgx.group(3)+"\"]#"+Command name:C538(1517); 1)
		
	End if 
End while 

SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $code)