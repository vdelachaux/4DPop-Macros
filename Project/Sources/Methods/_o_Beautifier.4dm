//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : Beautifier
// Database: 4DPop Macros
// ID[D4EDEA4D1ADF4DBC8B65758E297D89AB]
// Created 3-12-2012 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Format the method like I wish for easy readability ;-)
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_addLine; $Boo_closure; $Boo_comment; $Boo_emptyLine; $Boo_isClosure; $Boo_lineComment)
C_BOOLEAN:C305($Boo_macro; $Boo_return; $Boo_severalLines; $Boo_skipLineAfter; $Boo_testLineAfter; $Boo_testLineBefore)
C_BOOLEAN:C305($Boo_us)
C_LONGINT:C283($errorCode; $Lon_i; $level; $Lon_Lines; $Lon_options; $Lon_parameters)
C_TEXT:C284($kTxt_pattern; $Txt_buffer; $Txt_code; $Txt_lineCode; $Txt_pattern; $Txt_replacement)
C_TEXT:C284($Txt_tempo)

ARRAY LONGINT:C221($tLon_branchAndLoop; 0)
ARRAY TEXT:C222($tTxt_lines; 0)
ARRAY TEXT:C222($tTxt_controlFlow; 0)

If (False:C215)
	C_TEXT:C284(_o_Beautifier; $0)
	C_TEXT:C284(_o_Beautifier; $1)
	C_BOOLEAN:C305(_o_Beautifier; $2)
End if 

// ----------------------------------------------------
// Initialisations
var $beautifier : cs:C1710.beautifier
$beautifier:=cs:C1710.beautifier.new()

If (Count parameters:C259>=1)
	
	$Txt_code:=$1  // Text to format
	
	If (Count parameters:C259>=2)
		
		$Boo_macro:=$2  // Must be true if called from a macro method
		
	End if 
End if 


If ($Boo_macro\
 & (Length:C16($Txt_code)=0))
	
	//GET MACRO PARAMETER(Full method text; $Txt_code)
	$Txt_code:=$beautifier.method
	
End if 

_o_localizedControlFlow(""; ->$tTxt_controlFlow)

// ----------------------------------------------------
If (Length:C16($Txt_code)>0)
	
	If (Bool:C1537($beautifier.settings.removeConsecutiveBlankLines))
		
		$errorCode:=Rgx_SubstituteText("[\\r\\n]{2,}"; "\r\r"; ->$Txt_code)
		
	End if 
	
	If (Bool:C1537($beautifier.settings.removeEmptyLinesAtTheEndOfMethod))
		
		$errorCode:=Rgx_SubstituteText("(\\r*)$"; ""; ->$Txt_code)
		
	End if 
	
	If (Bool:C1537($beautifier.settings.removeEmptyLinesAtTheBeginOfMethod))
		
		$errorCode:=Rgx_SubstituteText("^(\\r*)"; ""; ->$Txt_code)
		
	End if 
	
	If (Bool:C1537($beautifier.settings.replaceComparisonsToAnEmptyStringByLengthTest))
		
		ARRAY TEXT:C222($tTxt_2D_result; 0x0000; 0x0000)
		
		$Txt_pattern:="(?mi-s)(\\(|;)([^)#=;]*)(#|=)\"\"\\)"
		
		If (Rgx_ExtractText($Txt_pattern; $Txt_code; "0 1 2 3"; ->$tTxt_2D_result; 0)=0)
			
			For ($Lon_i; 1; Size of array:C274($tTxt_2D_result); 1)
				
				$Txt_replacement:=$tTxt_2D_result{$Lon_i}{2}+Command name:C538(16)+"("+$tTxt_2D_result{$Lon_i}{3}+")"+$tTxt_2D_result{$Lon_i}{4}+"0)"
				$Txt_code:=Replace string:C233($Txt_code; $tTxt_2D_result{$Lon_i}{1}; $Txt_replacement)
				
			End for 
		End if 
	End if 
	
	If (Bool:C1537($beautifier.settings.replaceIfElseEndIfByChoose))
		
		$Boo_us:=(Command name:C538(1)="Sum")
		
		$Txt_pattern:="(?im)"\
			+Choose:C955($Boo_us; "If"; "Si")\
			+"\\s\\(([^\r]*\\)*)\\)(?://.*)*\\r\\s*(.*):=(?!.*\\$\\d)([^\r]*?)(//.*)*\\r\\s*"\
			+Choose:C955($Boo_us; "Else"; "Sinon")\
			+".*\\s*\\2:=([^\r]*?)(//.*)*\\r\\s*"\
			+Choose:C955($Boo_us; "End if"; "Fin de si")
		
		$Txt_replacement:="\\2:="+Command name:C538(955)+"(\\1;\\3;\\5) \\4 \\6"
		
		$Txt_code:=Replace string:C233($Txt_code; "\\"; "§§")
		$errorCode:=Rgx_SubstituteText($Txt_pattern; $Txt_replacement; ->$Txt_code; 0)
		$Txt_code:=Replace string:C233($Txt_code; "§§"; "\\")
		
	End if 
	
	If (Bool:C1537($beautifier.settings.replaceDeprecatedCommand))
		
		ARRAY TEXT:C222($tTxt_pattern; 0x0000)
		ARRAY TEXT:C222($tTxt_replacement; 0x0000)
		
		//_o_DISABLE BUTTON({*;}object) 
		APPEND TO ARRAY:C911($tTxt_pattern; "(?mi-s)("+Command name:C538(193)+"\\(([^\\)]*)\\))")
		APPEND TO ARRAY:C911($tTxt_replacement; "//\\1\r"+Command name:C538(1123)+"(\\2;"+Command name:C538(215)+")")
		
		//_o_ENABLE BUTTON({*;}object) 
		APPEND TO ARRAY:C911($tTxt_pattern; "(?mi-s)("+Command name:C538(192)+"\\(([^\\)]*)\\))")
		APPEND TO ARRAY:C911($tTxt_replacement; "//\\1\r"+Command name:C538(1123)+"(\\2;"+Command name:C538(214)+")")
		
		//_o_C_STRING ( {method ;} size ; variable {; variable2 ; ... ; variableN} )  
		APPEND TO ARRAY:C911($tTxt_pattern; "(?mi-s)("+Command name:C538(293)+"\\(((?:.*;)??)(?:(\\d+);){1}([^\\)]*)\\))")
		APPEND TO ARRAY:C911($tTxt_replacement; "//\\1\r"+Command name:C538(284)+"(\\2\\4)")
		
		//_o_C_INTEGER({method;}variable{;variable2;...;variableN})  
		APPEND TO ARRAY:C911($tTxt_pattern; "(?mi-s)("+Command name:C538(282)+"\\(([^\\)]*)\\))")
		APPEND TO ARRAY:C911($tTxt_replacement; "//\\1\r"+Command name:C538(283)+"(\\2)")
		
		//_o_ARRAY STRING ( strLen ; arrayName ; size {; size2} )    
		APPEND TO ARRAY:C911($tTxt_pattern; "(?mi-s)("+Command name:C538(218)+"\\(\\d*;([^\\)]*)\\))")
		APPEND TO ARRAY:C911($tTxt_replacement; "//\\1\r"+Command name:C538(222)+"(\\2)")
		
		For ($Lon_i; 1; Size of array:C274($tTxt_pattern); 1)
			
			ASSERT:C1129(Rgx_SubstituteText($tTxt_pattern{$Lon_i}; $tTxt_replacement{$Lon_i}; ->$Txt_code; 0)=0)
			
		End for 
	End if 
	
	$Txt_pattern:="("+$tTxt_controlFlow{1}+" \\([^\\r]*\\r)\\r*"  //If
	$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
	
	$Txt_pattern:="("+$tTxt_controlFlow{4}+"[^\\r]*\\r)\\r*"  //case of
	$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
	
	$Txt_pattern:="("+$tTxt_controlFlow{6}+" \\([^\\r]*\\r)\\r*"  //While
	$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
	
	$Txt_pattern:="("+$tTxt_controlFlow{8}+" \\([^\\r]*\\r)\\r*"  //For
	$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
	
	$Txt_pattern:="("+$tTxt_controlFlow{10}+"[^\\r]*\\r)\\r*"  //Repeat
	$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
	
	$Txt_pattern:="\\r*(\\r"+$tTxt_controlFlow{2}+"[^\\r]*\\r)\\r*"  //Else
	$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
	
	If (Bool:C1537($beautifier.settings.groupingClosureInstructions))
		
		$Txt_pattern:="\\r*(\\r"+$tTxt_controlFlow{3}+"[^\\r]*\\r)\\r*"  //End If
		$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
		
		$Txt_pattern:="\\r*(\\r"+$tTxt_controlFlow{5}+"[^\\r]*\\r)\\r*"  //End case
		$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
		
		$Txt_pattern:="\\r*(\\r"+$tTxt_controlFlow{7}+"[^\\r]*\\r)\\r*"  //End while
		$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
		
		$Txt_pattern:="\\r*(\\r"+$tTxt_controlFlow{9}+"[^\\r]*\\r)\\r*"  //End for
		$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
		
		$Txt_pattern:="\\r*(\\r"+$tTxt_controlFlow{11}+" \\([^\\r]*\\r)\\r*"  //Until
		$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
		
		$Txt_pattern:="\\r*(\\r: \\([^\\r]*\\r)\\r*"  //Case of test
		$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
		
		$Txt_pattern:="\\r*(\\r"+$tTxt_controlFlow{13}+"[^\\r]*\\r)\\r*"  //End use
		$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
		
		$Txt_pattern:="\\r*(\\r"+$tTxt_controlFlow{15}+"[^\\r]*\\r)\\r*"  //End for each
		$errorCode:=Rgx_SubstituteText($Txt_pattern; "\\1"; ->$Txt_code)
		
	End if 
	
	If (Rgx_SplitText("\\r\\n|\\r|\\n"; $Txt_code; ->$tTxt_lines; 0 ?+ 11)=0)
		
		$Lon_Lines:=Size of array:C274($tTxt_lines)
		
		For ($Lon_i; 1; $Lon_Lines; 1)
			
			$Txt_lineCode:=$tTxt_lines{$Lon_i}
			
			$tLon_branchAndLoop:=Size of array:C274($tLon_branchAndLoop)
			$tLon_branchAndLoop{0}:=$tLon_branchAndLoop{$tLon_branchAndLoop}
			
			$Txt_pattern:="(?<!//)(?:"\
				+$tTxt_controlFlow{3}\
				+"|"+$tTxt_controlFlow{5}\
				+"|"+$tTxt_controlFlow{7}\
				+"|"+$tTxt_controlFlow{9}\
				+"|"+$tTxt_controlFlow{11}\
				+"|"+$tTxt_controlFlow{13}\
				+"|"+$tTxt_controlFlow{15}\
				+")\\b"
			
			$Boo_isClosure:=(Rgx_MatchText($Txt_pattern; $Txt_lineCode)=0)
			
			$Boo_skipLineAfter:=Choose:C955(Not:C34($Boo_isClosure); False:C215; $Boo_skipLineAfter)
			
			If (Not:C34($Boo_skipLineAfter) & $Boo_testLineAfter)
				
				If ($Txt_lineCode=(kCommentMark+"}"))\
					 | ($Txt_lineCode=(kCommentMark+"]"))\
					 | ($Txt_lineCode=(kCommentMark+")"))
					
					$Boo_testLineAfter:=True:C214
					
				Else 
					
					$Boo_return:=(Length:C16($Txt_lineCode)>0)
					$Boo_testLineAfter:=False:C215
					
				End if 
			End if 
			
			Case of 
					
					//……………………………………………………………
				: (Length:C16($Txt_lineCode)=0)  //Line
					
					$Boo_emptyLine:=True:C214
					
					//……………………………………………………………
				: (Position:C15(kCommentMark; $Txt_lineCode)=1)  //Comment
					
					If (Not:C34($Boo_comment))  //multiline
						
						
						
						$Boo_testLineBefore:=Choose:C955($Lon_i>1; Bool:C1537($beautifier.settings.aLineOfCommentsMustBePrecededByALineBreak); False:C215)\
							 & ($Txt_lineCode#(kCommentMark+"}"))\
							 & ($Txt_lineCode#(kCommentMark+"]"))\
							 & ($Txt_lineCode#(kCommentMark+")"))
						
					End if 
					
					//Separator line is made with a comment mark and at least 5 times the same character
					$Boo_lineComment:=(Rgx_MatchText(kCommentMark+"(.)\\1{4,}"; $Txt_lineCode)=0)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{1}+"\\b"; $Txt_lineCode)=0)  //If
					
					$Boo_testLineBefore:=Bool:C1537($beautifier.settings.lineBreakBeforeBranchingStructures) & Not:C34($Boo_comment)
					
					If (Bool:C1537($beautifier.settings.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$Txt_lineCode)
						
					End if 
					
					If (Replace string:C233($Txt_lineCode; " "; "")=($tTxt_controlFlow{1}+"("+Command name:C538(215)+")@"))
						
						APPEND TO ARRAY:C911($tLon_branchAndLoop; -1)
						$Boo_testLineAfter:=False:C215
						$Boo_skipLineAfter:=True:C214
						
					Else 
						
						APPEND TO ARRAY:C911($tLon_branchAndLoop; 1)
						$Boo_testLineAfter:=Bool:C1537($beautifier.settings.lineBreakBeforeAndAfterSequentialStructuresIncluded)
						$Boo_skipLineAfter:=False:C215
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{2}+"\\b"; $Txt_lineCode)=0)  //Else
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=4)
						
						$Boo_addLine:=True:C214
						$Boo_testLineBefore:=Not:C34($Boo_comment)
						
					Else 
						
						$Boo_addLine:=False:C215
						$Boo_testLineBefore:=True:C214
						
					End if 
					
					$Boo_testLineAfter:=True:C214
					$Boo_skipLineAfter:=False:C215
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{3}+"\\b"; $Txt_lineCode)=0)  //End if
					
					$Boo_testLineBefore:=(Not:C34($Boo_skipLineAfter) | Not:C34($Boo_closure))\
						 & ($tLon_branchAndLoop{$tLon_branchAndLoop}#-1)
					$Boo_testLineAfter:=Not:C34($Boo_skipLineAfter)
					$Boo_skipLineAfter:=True:C214
					
					If (Abs:C99($tLon_branchAndLoop{$tLon_branchAndLoop})=1)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{12}+"\\b"; $Txt_lineCode)=0)  // Use
					
					
					If (Bool:C1537($beautifier.settings.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$Txt_lineCode)
						
					End if 
					
					$Boo_testLineBefore:=Bool:C1537($beautifier.settings.lineBreakBeforeBranchingStructures) & Not:C34($Boo_comment)
					$Boo_testLineAfter:=True:C214
					$Boo_skipLineAfter:=False:C215
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 13)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{13}+"\\b"; $Txt_lineCode)=0)  // End use
					
					$Boo_testLineBefore:=Not:C34($Boo_skipLineAfter) | Not:C34($Boo_closure)
					$Boo_testLineAfter:=Not:C34($Boo_skipLineAfter)
					$Boo_skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=13)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{14}+"\\b"; $Txt_lineCode)=0)  // For each
					
					If (Bool:C1537($beautifier.settings.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$Txt_lineCode)
						
					End if 
					
					$Boo_testLineBefore:=Bool:C1537($beautifier.settings.lineBreakBeforeBranchingStructures) & Not:C34($Boo_comment)
					$Boo_testLineAfter:=True:C214
					$Boo_skipLineAfter:=False:C215
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 14)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{15}+"\\b"; $Txt_lineCode)=0)  // End for each
					
					$Boo_testLineBefore:=Not:C34($Boo_skipLineAfter) | Not:C34($Boo_closure)
					$Boo_testLineAfter:=Not:C34($Boo_skipLineAfter)
					$Boo_skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=14)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{4}+"\\b"; $Txt_lineCode)=0)  //Case of
					
					$level:=$level+1
					
					$Boo_testLineBefore:=Not:C34($Boo_comment)
					$Boo_testLineAfter:=True:C214
					$Boo_skipLineAfter:=False:C215
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 4)
					
				: (Position:C15(": ("; $Txt_lineCode)=1)  //item in Case of
					
					If (Bool:C1537($beautifier.settings.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$Txt_lineCode)
						
					End if 
					
					$Boo_addLine:=Bool:C1537($beautifier.settings.separationLineForCaseOf)
					$Boo_testLineBefore:=Not:C34($Boo_comment)
					$Boo_testLineAfter:=True:C214
					$Boo_skipLineAfter:=False:C215
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{5}+"\\b"; $Txt_lineCode)=0)  //End case
					
					$Boo_addLine:=Bool:C1537($beautifier.settings.separationLineForCaseOf)
					$Boo_testLineBefore:=(Not:C34($Boo_comment) | Not:C34($Boo_closure))\
						 & Not:C34($Boo_lineComment)
					$Boo_testLineAfter:=Not:C34($Boo_skipLineAfter)
					$Boo_skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=4)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					$tLon_branchAndLoop{0}:=-5
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{6}+"\\b"; $Txt_lineCode)=0)  //While
					
					If (Bool:C1537($beautifier.settings.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$Txt_lineCode)
						
					End if 
					
					$Boo_testLineBefore:=True:C214
					$Boo_testLineAfter:=True:C214
					$Boo_skipLineAfter:=False:C215
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 6)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{7}+"\\b"; $Txt_lineCode)=0)  //End while
					
					$Boo_testLineBefore:=Not:C34($Boo_skipLineAfter) | Not:C34($Boo_closure)
					$Boo_testLineAfter:=Not:C34($Boo_skipLineAfter)
					$Boo_skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=6)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{8}+"\\b"; $Txt_lineCode)=0)  //For
					
					$Boo_testLineBefore:=Not:C34($Boo_comment)
					$Boo_testLineAfter:=True:C214
					$Boo_skipLineAfter:=False:C215
					
					If (Bool:C1537($beautifier.settings.addTheIncrementForTheLoops))
						
						$Txt_pattern:="\\(([^;]*;[^;]*;[^;]*)(;.*?)?\\)$"
						ARRAY TEXT:C222($tTxt_result; 0x0000)
						
						If (Rgx_MatchText($Txt_pattern; $Txt_lineCode; ->$tTxt_result)=0)
							
							If (Length:C16($tTxt_result{2})=0)
								
								$Txt_lineCode:=Replace string:C233($Txt_lineCode; $tTxt_result{1}; $tTxt_result{1}+";1")
								
							End if 
						End if 
					End if 
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 8)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{9}+"\\b"; $Txt_lineCode)=0)  //End for
					
					$Boo_testLineBefore:=Not:C34($Boo_skipLineAfter) | Not:C34($Boo_closure)
					$Boo_testLineAfter:=Not:C34($Boo_skipLineAfter)
					$Boo_skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=8)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{10}+"\\b"; $Txt_lineCode)=0)  //Repeat
					
					$Boo_testLineBefore:=True:C214
					$Boo_testLineAfter:=True:C214
					$Boo_skipLineAfter:=False:C215
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 10)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+$tTxt_controlFlow{11}+"\\b"; $Txt_lineCode)=0)  //Until
					
					If (Bool:C1537($beautifier.settings.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$Txt_lineCode)
						
					End if 
					
					$Boo_testLineBefore:=Not:C34($Boo_skipLineAfter) | Not:C34($Boo_closure)
					$Boo_testLineAfter:=Not:C34($Boo_skipLineAfter)
					$Boo_skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=10)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Position:C15(Command name:C538(948); $Txt_lineCode)=1)  //Begin SQL
					
					$Boo_testLineBefore:=True:C214
					$Boo_testLineAfter:=True:C214
					$Boo_skipLineAfter:=False:C215
					
					//……………………………………………………………
				: (Position:C15(Command name:C538(949); $Txt_lineCode)=1)  //End SQL
					
					$Boo_testLineBefore:=True:C214
					$Boo_testLineAfter:=True:C214
					$Boo_skipLineAfter:=False:C215
					
					//……………………………………………………………
				Else 
					
					$Boo_emptyLine:=False:C215
					$Boo_testLineBefore:=$Boo_closure
					
					//……………………………………………………………
			End case 
			
			// #18-8-2017
			If (Bool:C1537($beautifier.settings.formatComments))  // Add a space before the comment and capitalize the first letter
				
				If (Not:C34(Match regex:C1019("(?m-si)(.)\\1{4,}"; $Txt_lineCode; 1)))  // Not for a comment with at least 5 occurrences of the same character
					
					If (0=Rgx_ExtractText("(?m-si)^(.*)(?=//)//\\s*([^\"$]*)$"; $Txt_lineCode; "1 2"; ->$tTxt_2D_result))
						
						If (Length:C16($tTxt_2D_result{1}{1})=0)  // Comment line
							
							If ($tTxt_2D_result{1}{2}[[1]]#"%")  // Not for a compilation modifier
								
								$tTxt_2D_result{1}{2}[[1]]:=Uppercase:C13($tTxt_2D_result{1}{2}[[1]]; *)
								$Txt_lineCode:="// "+$tTxt_2D_result{1}{2}
								
							End if 
							
						Else 
							
							$tTxt_2D_result{1}{2}[[1]]:=Uppercase:C13($tTxt_2D_result{1}{2}[[1]]; *)
							$Txt_lineCode:=$tTxt_2D_result{1}{1}+"// "+$tTxt_2D_result{1}{2}
							
						End if 
					End if 
				End if 
			End if 
			
			$Boo_closure:=$Boo_isClosure
			$Boo_comment:=(Position:C15(kCommentMark; $Txt_lineCode)=1)
			
			If (Not:C34($Boo_severalLines))
				
				If ($Boo_addLine)
					
					If (Not:C34($Boo_lineComment))
						
						If ($level>$beautifier.numberOfSeparators)
							
							$level:=$beautifier.numberOfSeparators
							
						Else 
							
							If ($level<1)
								
								$level:=1
								
							End if 
						End if 
						
						$Txt_lineCode:=kCommentMark\
							+($beautifier.separators[$level]*(20-($level\2)))\
							+"\r"\
							+$Txt_lineCode
						
					End if 
					
					$level:=$level-Num:C11($tLon_branchAndLoop{0}=-5)
					
					$Boo_lineComment:=False:C215
					$Boo_addLine:=False:C215
					
				End if 
				
				If ($Boo_testLineBefore | $Boo_return)
					
					$Txt_lineCode:=Choose:C955($Boo_emptyLine | ($Lon_i=1); ""; "\r")+$Txt_lineCode
					$Boo_emptyLine:=False:C215
					$Boo_testLineBefore:=False:C215
					$Boo_return:=False:C215
					
				End if 
			End if 
			
			$Boo_severalLines:=($Txt_lineCode="@\\")
			
			// #25-7-2014
			$kTxt_pattern:="(?mi-s)^[^/]*{command}\\(.*\\)(?:\\s*//[^$]*)?$"
			
			Case of 
					
					//______________________________________________________
				: ($Boo_severalLines)\
					 | (Not:C34(Bool:C1537($beautifier.settings.splitKeyValueLines)))
					
					//#7-4-2017 ________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233($kTxt_pattern; "{command}"; Command name:C538(1471)); $Txt_lineCode)=0)  //New object
					
					$Txt_lineCode:=_o_beautifier_Split_key_value($Txt_lineCode; 1471)
					
					//__________________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233($kTxt_pattern; "{command}"; Command name:C538(1220)); $Txt_lineCode)=0)  //OB SET
					
					$Txt_lineCode:=_o_beautifier_Split_key_value($Txt_lineCode; 1220)
					
					//__________________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233($kTxt_pattern; "{command}"; Command name:C538(1055)); $Txt_lineCode)=0)  //SVG SET ATTRIBUTE
					
					$Txt_lineCode:=_o_beautifier_Split_key_value($Txt_lineCode; 1055)
					
					//__________________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233($kTxt_pattern; "{command}"; Command name:C538(865)); $Txt_lineCode)=0)  //DOM Create XML element
					
					$Txt_lineCode:=_o_beautifier_Split_key_value($Txt_lineCode; 865)
					
					//__________________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233($kTxt_pattern; "{command}"; Command name:C538(866)); $Txt_lineCode)=0)  //DOM SET XML ATTRIBUTE
					
					$Txt_lineCode:=_o_beautifier_Split_key_value($Txt_lineCode; 866)
					
					//__________________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233($kTxt_pattern; "{command}"; Command name:C538(1093)); $Txt_lineCode)=0)  //ST SET ATTRIBUTES 
					
					$Txt_lineCode:=_o_beautifier_Split_key_value($Txt_lineCode; 1093)
					
					//______________________________________________________
			End case 
			
			$tTxt_lines{$Lon_i}:=$Txt_lineCode
			
		End for 
		
		CLEAR VARIABLE:C89($Txt_code)
		
		For ($Lon_i; 1; $Lon_Lines; 1)
			
			$Txt_code:=$Txt_code+$tTxt_lines{$Lon_i}+("\r"*Num:C11($Lon_i#$Lon_Lines))
			
		End for 
	End if 
	
	If (Bool:C1537($beautifier.settings.removeConsecutiveBlankLines))
		
		$errorCode:=Rgx_SubstituteText("[\\r\\n]{2,}"; "\r\r"; ->$Txt_code)
		
	End if 
	
	// #14-1-2015 - remove the line feed, if any, before a compiler directive closure
	$Txt_pattern:="(?mi-s)\\r\\r.*(//%W\\+\\d{1,}\\.\\d{1,})\\r"
	$errorCode:=Rgx_SubstituteText($Txt_pattern; "\r\\1\r"; ->$Txt_code)
	
	If ($Boo_macro)
		
		SET MACRO PARAMETER:C998(Full method text:K5:17; $Txt_code+kCaret)
		
	Else 
		
		$0:=$Txt_code  //formated code
		
	End if 
End if 

// ----------------------------------------------------
// End