//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : DOT_NOTATION
// Database: 4DPop Macros
// ID[B4AD544DDA924C80A5A42792F9275088]
// Created #15-3-2018 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($code : Text)

var $WORD_PATTERN; $PATTERN : Text
var $x : Integer

ARRAY TEXT:C222($_extract; 0)

$WORD_PATTERN:="(?mi-s)^(\\w|\\$)*$"

$PATTERN:="(?m-si)"+Command name:C538(1224)+"\\(([^;]*);\"([^\"]*)\";(.*)\\)"

Repeat 
	
	$x:=_o_Rgx_ExtractText($PATTERN; $code; ""; ->$_extract)
	
	If ($x=0)
		
		If (_o_Rgx_MatchText($WORD_PATTERN; $_extract{3})=0)
			
			$code:=Replace string:C233($code; $_extract{1}; $_extract{2}+"."+$_extract{3}; 1)
			
		Else 
			
			// Use brackets
			$code:=Replace string:C233($code; $_extract{1}; $_extract{2}+"[\""+$_extract{3}+"\"]"; 1)
			
		End if 
	End if 
Until ($x=-1)

// MARK:-
// OB SET($Obj_;"$test";"hello") -> $Obj_.$test:="hello"
// OB SET($Obj_;"is-compilable";False) -> Obj_["is-compilable"]:=False
$PATTERN:="(?m-si)"+Command name:C538(1220)+"\\(([^;]*);(?:\\\\\\s*)?(?:\"([^\"]*)\";([^;)]*))\\)"

Repeat 
	
	$x:=_o_Rgx_ExtractText($PATTERN; $code; ""; ->$_extract)
	
	If ($x=0)
		
		If (_o_Rgx_MatchText($WORD_PATTERN; $_extract{3})=0)
			
			$code:=Replace string:C233($code; $_extract{1}; $_extract{2}+"."+$_extract{3}+":="+$_extract{4}; 1)
			
		Else 
			
			// Use brackets
			$code:=Replace string:C233($code; $_extract{1}; $_extract{2}+"[\""+$_extract{3}+"\"]:="+$_extract{4}; 1)
			
		End if 
	End if 
Until ($x=-1)

// MARK:-
// OB Is defined($Obj_;"compilable") -> $$Obj_.compilable#Null
// OB Is defined($Obj_;"not-compilable") -> $Obj_["not-compilable"]#Null
$PATTERN:="(?m-si)"+Command name:C538(1231)+"\\(([^;]*);\"([^\"]*)\"\\)"

Repeat 
	
	$x:=_o_Rgx_ExtractText($PATTERN; $code; ""; ->$_extract)
	
	If ($x=0)
		
		If (_o_Rgx_MatchText($WORD_PATTERN; $_extract{3})=0)
			
			$code:=Replace string:C233($code; $_extract{1}; $_extract{2}+"."+$_extract{3}+"#"+Command name:C538(1517); 1)
			
		Else 
			
			// Use brackets
			$code:=Replace string:C233($code; $_extract{1}; $_extract{2}+"[\""+$_extract{3}+"\"]#"+Command name:C538(1517); 1)
			
		End if 
	End if 
Until ($x=-1)

SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $code)