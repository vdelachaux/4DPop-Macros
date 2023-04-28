//%attributes = {"invisible":true,"preemptive":"capable"}
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

C_LONGINT:C283($end;$i)
C_TEXT:C284($t_code;$t_name;$t_prefix;$t_syntax)

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
If (Asserted:C1132(Count parameters:C259>=2;"Missing parameter"))
	
	$t_code:=$1  // Code of the method to analyse
	$t_name:=$2  // Name of the method
	
	If (Count parameters:C259>=3)
		
		$t_prefix:=$3  // Prefix used at the beginning of each line
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Get types and labels
METHOD_ANALYSE_TO_ARRAYS ($t_code;->$tTxt_types;->$tTxt_labels;->$tTxt_comments)

  // Set style for method name
$t_name:="<span style=\"font-family:sans-serif;color:gray;font-weight:bold;font-style:italic\">"\
+$t_name\
+"</span>"

  // The first line is the call syntax…
$t_syntax:="<span style=\"font-family:sans-serif;color:gray;\">"\
+$t_prefix+Choose:C955(Length:C16($tTxt_types{0})>0;\
Choose:C955(Length:C16($tTxt_labels{0})=0;$tTxt_types{0};$tTxt_labels{0})\
+" := "+$t_name;$t_name)

$end:=Size of array:C274($tTxt_types)

For ($i;1;$end;1)
	
	  // Open parentheses or put a separator
	$t_syntax:=Choose:C955($i=1;$t_syntax+" ( ";$t_syntax+" ; ")
	$t_syntax:=$t_syntax+$tTxt_labels{$i}
	
	If ($i=$end)
		
		  // Close the parentheses
		$t_syntax:=$t_syntax+" )"
		
	End if 
End for 

  //…then describe the parameters…
For ($i;1;Size of array:C274($tTxt_types);1)
	
	$t_syntax:=$t_syntax+"\r"\
		+$t_prefix+" -&gt; "+$tTxt_labels{$i}+" ("+$tTxt_types{$i}+")"\
		+Choose:C955(Length:C16($tTxt_comments{$i})>0;" - "+$tTxt_comments{$i};"")
	
End for 

  //…and the return for a function.
If (Length:C16($tTxt_labels{0})>0)
	
	$t_syntax:=$t_syntax+"\r"+$t_prefix+" &lt;- "+$tTxt_labels{0}+" ("+$tTxt_types{0}+")"\
		+Choose:C955(Length:C16($tTxt_comments{0})>0;" - "+$tTxt_comments{0};"")
	
End if 

$t_syntax:=$t_syntax+"</span>"

$0:=$t_syntax  // Prototype

  // ----------------------------------------------------
  // End