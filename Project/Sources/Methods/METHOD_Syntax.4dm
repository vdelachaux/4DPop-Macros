//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : METHOD_Syntax
  // ID[D8D6EBA99147457E8AF91D1BE651AF8B]
  // Created #4-2-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($kTxt_commentPrefix;$Txt_method;$Txt_methodName;$Txt_result)

ARRAY TEXT:C222($tTxt_comments;0)
ARRAY TEXT:C222($tTxt_labels;0)
ARRAY TEXT:C222($tTxt_types;0)

If (False:C215)
	C_TEXT:C284(METHOD_Syntax ;$0)
	C_TEXT:C284(METHOD_Syntax ;$1)
	C_TEXT:C284(METHOD_Syntax ;$2)
	C_TEXT:C284(METHOD_Syntax ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	$Txt_method:=$1  //Code of the method to analyse
	$Txt_methodName:=$2  //Name of the method
	
	If ($Lon_parameters>=3)
		
		$kTxt_commentPrefix:=$3  //Prefix used at the beginning of each line
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  //get types and labels
METHOD_ANALYSE_TO_ARRAYS ($Txt_method;->$tTxt_types;->$tTxt_labels;->$tTxt_comments)

  //Set style for method name
$Txt_methodName:="<span style=\"font-family:sans-serif;color:gray;font-weight:bold;font-style:italic\">"\
+$Txt_methodName\
+"</span>"

  //The first line is the call syntax…
$Txt_result:="<span style=\"font-family:sans-serif;color:gray;\">"\
+$kTxt_commentPrefix+Choose:C955(Length:C16($tTxt_types{0})>0;\
Choose:C955(Length:C16($tTxt_labels{0})=0;$tTxt_types{0};$tTxt_labels{0})\
+" := "+$Txt_methodName;$Txt_methodName)

For ($Lon_i;1;Size of array:C274($tTxt_types);1)
	
	  //open parentheses or put a separator
	$Txt_result:=Choose:C955($Lon_i=1;$Txt_result+" ( ";$Txt_result+" ; ")
	
	$Txt_result:=$Txt_result+$tTxt_labels{$Lon_i}
	
	If ($Lon_i=Size of array:C274($tTxt_types))
		
		  //close the parentheses
		$Txt_result:=$Txt_result+" )"
		
	End if 
End for 

  //…then describe the parameters…
For ($Lon_i;1;Size of array:C274($tTxt_types);1)
	
	$Txt_result:=$Txt_result+"\r"\
		+$kTxt_commentPrefix+" -&gt; "+$tTxt_labels{$Lon_i}+" ("+$tTxt_types{$Lon_i}+")"\
		+Choose:C955(Length:C16($tTxt_comments{$Lon_i})>0;" - "+$tTxt_comments{$Lon_i};"")
	
End for 

  //…and the return for a function.
If (Length:C16($tTxt_labels{0})>0)
	
	$Txt_result:=$Txt_result+"\r"+$kTxt_commentPrefix+" &lt;- "+$tTxt_labels{0}+" ("+$tTxt_types{0}+")"\
		+Choose:C955(Length:C16($tTxt_comments{0})>0;" - "+$tTxt_comments{0};"")
	
End if 

$0:=$Txt_result+"</span>"

  // ----------------------------------------------------
  // End 