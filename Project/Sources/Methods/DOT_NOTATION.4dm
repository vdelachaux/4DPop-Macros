//%attributes = {"invisible":true,"preemptive":"incapable"}
  // ----------------------------------------------------
  // Project method : DOT_NOTATION
  // Database: 4DPop Macros
  // ID[B4AD544DDA924C80A5A42792F9275088]
  // Created #15-3-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters;$Lon_x)
C_TEXT:C284($kTxt_patternWordCharacters;$Txt_code;$Txt_pattern)

ARRAY TEXT:C222($tTxt_extract;0)

If (False:C215)
	C_TEXT:C284(DOT_NOTATION ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_code:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$kTxt_patternWordCharacters:="(?mi-s)^(\\w|\\$)*$"
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

  // -----------------------------------------------------------------------------------------------
  //$Txt_buffer:=OB Get($Obj_;"test";Is text) -> $Txt_buffer:=$Obj_.test
  //$Txt_buffer:=OB Get($Obj_;"is-compilable";Is text) -> $Txt_buffer:=$Obj_["is-compilable"]
$Txt_pattern:="(?m-si)"+Command name:C538(1224)+"\\(([^;]*);\"([^\"]*)\";(.*)\\)"

Repeat 
	
	$Lon_x:=Rgx_ExtractText ($Txt_pattern;$Txt_code;"";->$tTxt_extract)
	
	If ($Lon_x=0)
		
		If (Rgx_MatchText ($kTxt_patternWordCharacters;$tTxt_extract{3})=0)
			
			$Txt_code:=Replace string:C233($Txt_code;$tTxt_extract{1};$tTxt_extract{2}+"."+$tTxt_extract{3};1)
			
		Else 
			
			  // Use brackets
			$Txt_code:=Replace string:C233($Txt_code;$tTxt_extract{1};$tTxt_extract{2}+"[\""+$tTxt_extract{3}+"\"]";1)
			
		End if 
	End if 
Until ($Lon_x=-1)

  // -----------------------------------------------------------------------------------------------
  //OB SET($Obj_;"$test";"hello") -> $Obj_.$test:="hello"
  //OB SET($Obj_;"is-compilable";False) -> Obj_["is-compilable"]:=False
$Txt_pattern:="(?m-si)"+Command name:C538(1220)+"\\(([^;]*);(?:\\\\\\s*)?(?:\"([^\"]*)\";([^;)]*))\\)"

Repeat 
	
	$Lon_x:=Rgx_ExtractText ($Txt_pattern;$Txt_code;"";->$tTxt_extract)
	
	If ($Lon_x=0)
		
		If (Rgx_MatchText ($kTxt_patternWordCharacters;$tTxt_extract{3})=0)
			
			$Txt_code:=Replace string:C233($Txt_code;$tTxt_extract{1};$tTxt_extract{2}+"."+$tTxt_extract{3}+":="+$tTxt_extract{4};1)
			
		Else 
			
			  // Use brackets
			$Txt_code:=Replace string:C233($Txt_code;$tTxt_extract{1};$tTxt_extract{2}+"[\""+$tTxt_extract{3}+"\"]:="+$tTxt_extract{4};1)
			
		End if 
	End if 
Until ($Lon_x=-1)

  // -----------------------------------------------------------------------------------------------
  //OB Is defined($Obj_;"compilable") -> $$Obj_.compilable#Null
  //OB Is defined($Obj_;"not-compilable") -> $Obj_["not-compilable"]#Null
$Txt_pattern:="(?m-si)"+Command name:C538(1231)+"\\(([^;]*);\"([^\"]*)\"\\)"

Repeat 
	
	$Lon_x:=Rgx_ExtractText ($Txt_pattern;$Txt_code;"";->$tTxt_extract)
	
	If ($Lon_x=0)
		
		If (Rgx_MatchText ($kTxt_patternWordCharacters;$tTxt_extract{3})=0)
			
			$Txt_code:=Replace string:C233($Txt_code;$tTxt_extract{1};$tTxt_extract{2}+"."+$tTxt_extract{3}+"#"+Command name:C538(1517);1)
			
		Else 
			
			  // Use brackets
			$Txt_code:=Replace string:C233($Txt_code;$tTxt_extract{1};$tTxt_extract{2}+"[\""+$tTxt_extract{3}+"\"]#"+Command name:C538(1517);1)
			
		End if 
	End if 
Until ($Lon_x=-1)

  // -----------------------------------------------------------------------------------------------
SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$Txt_code)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End