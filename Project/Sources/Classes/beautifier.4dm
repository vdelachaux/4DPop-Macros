Class extends macro

//==============================================================
Class constructor()
	
	var $file : 4D:C1709.File
	
	Super:C1705()
	
	// Preferences
	$file:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
	
	If ($file.original#Null:C1517)
		
		$file:=$file.original
		
	End if 
	
	If ($file.exists)
		
		This:C1470.settings:=JSON Parse:C1218($file.getText()).beautifier
		
	End if 
	
	// Format comments
	If (This:C1470.settings.formatComments=Null:C1517)
		
		This:C1470.settings.formatComments:=True:C214
		
	End if 
	
	// Obsolete
	OB REMOVE:C1226(This:C1470.settings; "replaceDeprecatedCommand")
	
	This:C1470.separators:=New collection:C1472
	This:C1470.separators.push("")
	This:C1470.separators.push("–––")
	This:C1470.separators.push("==")
	This:C1470.separators.push("……")
	This:C1470.separators.push("--")
	This:C1470.separators.push("··")
	This:C1470.separators.push("~~")
	This:C1470.separators.push("..")
	This:C1470.separators.push("::")
	
	This:C1470.numberOfSeparators:=This:C1470.separators.length-1
	
	$file:=File:C1566("/RESOURCES/controlFlow.json")
	
	If (Command name:C538(41)="ALERT")  // US
		
		This:C1470.controlFlow:=JSON Parse:C1218($file.getText()).intl
		
	Else 
		
		// Use French language
		This:C1470.controlFlow:=JSON Parse:C1218($file.getText()).fr
		
	End if 
	
	This:C1470.closurePattern:="(?<!//)(?:"+This:C1470.controlFlow[2]\
		+"|"+This:C1470.controlFlow[4]\
		+"|"+This:C1470.controlFlow[6]\
		+"|"+This:C1470.controlFlow[8]\
		+"|"+This:C1470.controlFlow[10]\
		+"|"+This:C1470.controlFlow[12]\
		+"|"+This:C1470.controlFlow[14]+")\\b"
	
	This:C1470.splittableCommandsPattern:="(?mi-s)^[^/]*{command}\\(.*\\)(?:\\s*//[^$]*)?$"
	
	This:C1470.specialComments:="%}])"  // Compilation modifier & …
	
	//==============================================================
Function beautify()
	
	var $code; $line; $pattern; $replacement : Text
	var $Boo_addLine; $Boo_lineComment; $doLineAfter; $doLineBefore; $doReturn; $intl; $isClosure : Boolean
	var $isComment; $isEmptyLine; $isEnd; $severalLines; $skipLineAfter : Boolean
	var $errorCode; $i; $level : Integer
	var $options : Object
	var $lines : Collection
	
	$code:=Choose:C955(This:C1470.withSelection; This:C1470.highlighted; This:C1470.method)
	$options:=This:C1470.settings
	
	If (Length:C16($code)>0)
		
		If (Bool:C1537($options.removeConsecutiveBlankLines))
			
			$errorCode:=Rgx_SubstituteText("[\\r\\n]{2,}"; "\r\r"; ->$code)
			
		End if 
		
		If (Bool:C1537($options.removeEmptyLinesAtTheEndOfMethod))
			
			$errorCode:=Rgx_SubstituteText("(\\r*)$"; ""; ->$code)
			
		End if 
		
		If (Bool:C1537($options.removeEmptyLinesAtTheBeginOfMethod))
			
			$errorCode:=Rgx_SubstituteText("^(\\r*)"; ""; ->$code)
			
		End if 
		
		If (Bool:C1537($options.replaceComparisonsToAnEmptyStringByLengthTest))
			
			ARRAY TEXT:C222($tTxt_2D_result; 0x0000; 0x0000)
			$pattern:="(?mi-s)(\\(|;)([^)#=;]*)(#|=)\"\"\\)"
			
			If (Rgx_ExtractText($pattern; $code; "0 1 2 3"; ->$tTxt_2D_result; 0)=0)
				
				For ($i; 1; Size of array:C274($tTxt_2D_result); 1)
					
					$replacement:=$tTxt_2D_result{$i}{2}+Command name:C538(16)+"("+$tTxt_2D_result{$i}{3}+")"+$tTxt_2D_result{$i}{4}+"0)"
					$code:=Replace string:C233($code; $tTxt_2D_result{$i}{1}; $replacement)
					
				End for 
			End if 
		End if 
		
		If (Bool:C1537($options.replaceIfElseEndIfByChoose))
			
			$intl:=(Command name:C538(1)="Sum")
			
			$pattern:="(?im)"\
				+Choose:C955($intl; "If"; "Si")\
				+"\\s\\(([^\r]*\\)*)\\)(?://.*)*\\r\\s*(.*):=(?!.*\\$\\d)([^\r]*?)(//.*)*\\r\\s*"\
				+Choose:C955($intl; "Else"; "Sinon")\
				+".*\\s*\\2:=([^\r]*?)(//.*)*\\r\\s*"\
				+Choose:C955($intl; "End if"; "Fin de si")
			
			$replacement:="\\2:="+Command name:C538(955)+"(\\1;\\3;\\5) \\4 \\6"
			
			$code:=Replace string:C233($code; "\\"; "§§")
			$errorCode:=Rgx_SubstituteText($pattern; $replacement; ->$code; 0)
			$code:=Replace string:C233($code; "§§"; "\\")
			
		End if 
		
		$pattern:="("+This:C1470.controlFlow[0]+" \\([^\\r]*\\r)\\r*"
		$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
		$pattern:="("+This:C1470.controlFlow[3]+"[^\\r]*\\r)\\r*"
		$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
		$pattern:="("+This:C1470.controlFlow[5]+" \\([^\\r]*\\r)\\r*"
		$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
		$pattern:="("+This:C1470.controlFlow[7]+" \\([^\\r]*\\r)\\r*"
		$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
		$pattern:="("+This:C1470.controlFlow[9]+"[^\\r]*\\r)\\r*"
		$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
		$pattern:="\\r*(\\r"+This:C1470.controlFlow[1]+"[^\\r]*\\r)\\r*"
		$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
		
		If (Bool:C1537(This:C1470.settings.groupingClosureInstructions))
			
			$pattern:="\\r*(\\r"+This:C1470.controlFlow[2]+"[^\\r]*\\r)\\r*"
			$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
			$pattern:="\\r*(\\r"+This:C1470.controlFlow[4]+"[^\\r]*\\r)\\r*"
			$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
			$pattern:="\\r*(\\r"+This:C1470.controlFlow[6]+"[^\\r]*\\r)\\r*"
			$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
			$pattern:="\\r*(\\r"+This:C1470.controlFlow[8]+"[^\\r]*\\r)\\r*"
			$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
			$pattern:="\\r*(\\r"+This:C1470.controlFlow[10]+" \\([^\\r]*\\r)\\r*"
			$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
			$pattern:="\\r*(\\r: \\([^\\r]*\\r)\\r*"
			$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
			$pattern:="\\r*(\\r"+This:C1470.controlFlow[12]+"[^\\r]*\\r)\\r*"
			$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
			$pattern:="\\r*(\\r"+This:C1470.controlFlow[14]+"[^\\r]*\\r)\\r*"
			$errorCode:=Rgx_SubstituteText($pattern; "\\1"; ->$code)
			
		End if 
		
		ARRAY LONGINT:C221($tLon_branchAndLoop; 0x0000)
		
		This:C1470.split()
		
		CLEAR VARIABLE:C89($code)
		
		For ($i; 0; This:C1470.lineTexts.length-1; 1)
			
			$line:=This:C1470.lineTexts[$i]
			
			$tLon_branchAndLoop:=Size of array:C274($tLon_branchAndLoop)
			$tLon_branchAndLoop{0}:=$tLon_branchAndLoop{$tLon_branchAndLoop}
			
			$isEnd:=(Rgx_MatchText(This:C1470.closurePattern; $line)=0)
			
			$skipLineAfter:=Choose:C955(Not:C34($isEnd); False:C215; $skipLineAfter)
			
			If (Not:C34($skipLineAfter) & $doLineAfter)
				
				If ($line=(kCommentMark+"}"))\
					 | ($line=(kCommentMark+"]"))\
					 | ($line=(kCommentMark+")"))
					
					$doLineAfter:=True:C214
					
				Else 
					
					$doReturn:=(Length:C16($line)>0)
					$doLineAfter:=False:C215
					
				End if 
			End if 
			
			Case of 
					
					//……………………………………………………………
				: (Length:C16($line)=0)  //Line
					
					$isEmptyLine:=True:C214
					
					//……………………………………………………………
				: (Position:C15(kCommentMark; $line)=1)  //Comment
					
					If (Not:C34($isComment))  //multiline
						
						$doLineBefore:=Choose:C955($i>0; Bool:C1537($options.aLineOfCommentsMustBePrecededByALineBreak); False:C215)\
							 & ($line#(kCommentMark+"}"))\
							 & ($line#(kCommentMark+"]"))\
							 & ($line#(kCommentMark+")"))
						
					End if 
					
					//Separator line is made with a comment mark and at least 5 times the same character
					$Boo_lineComment:=(Rgx_MatchText(kCommentMark+"(.)\\1{4,}"; $line)=0)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[0]+"\\b"; $line)=0)  //If
					
					$doLineBefore:=Bool:C1537($options.lineBreakBeforeBranchingStructures) & Not:C34($isComment)
					
					If (Bool:C1537($options.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$line)
						
					End if 
					
					If (Replace string:C233($line; " "; "")=(This:C1470.controlFlow[0]+"("+Command name:C538(215)+")@"))
						
						APPEND TO ARRAY:C911($tLon_branchAndLoop; -1)
						$doLineAfter:=False:C215
						$skipLineAfter:=True:C214
						
					Else 
						
						APPEND TO ARRAY:C911($tLon_branchAndLoop; 1)
						$doLineAfter:=Bool:C1537($options.lineBreakBeforeAndAfterSequentialStructuresIncluded)
						$skipLineAfter:=False:C215
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[1]+"\\b"; $line)=0)  //Else
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=4)
						
						$Boo_addLine:=True:C214
						$doLineBefore:=Not:C34($isComment)
						
					Else 
						
						$Boo_addLine:=False:C215
						$doLineBefore:=True:C214
						
					End if 
					
					$doLineAfter:=True:C214
					$skipLineAfter:=False:C215
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[2]+"\\b"; $line)=0)  //End if
					
					$doLineBefore:=(Not:C34($skipLineAfter) | Not:C34($isClosure))\
						 & ($tLon_branchAndLoop{$tLon_branchAndLoop}#-1)
					$doLineAfter:=Not:C34($skipLineAfter)
					$skipLineAfter:=True:C214
					
					If (Abs:C99($tLon_branchAndLoop{$tLon_branchAndLoop})=1)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[11]+"\\b"; $line)=0)  // Use
					
					If (Bool:C1537($options.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$line)
						
					End if 
					
					$doLineBefore:=Bool:C1537($options.lineBreakBeforeBranchingStructures) & Not:C34($isComment)
					$doLineAfter:=True:C214
					$skipLineAfter:=False:C215
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 13)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[12]+"\\b"; $line)=0)  // End use
					
					$doLineBefore:=Not:C34($skipLineAfter) | Not:C34($isClosure)
					$doLineAfter:=Not:C34($skipLineAfter)
					$skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=13)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[13]+"\\b"; $line)=0)  // For each
					
					If (Bool:C1537($options.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$line)
						
					End if 
					
					$doLineBefore:=Bool:C1537($options.lineBreakBeforeBranchingStructures) & Not:C34($isComment)
					$doLineAfter:=True:C214
					$skipLineAfter:=False:C215
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 14)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[14]+"\\b"; $line)=0)  // End for each
					
					$doLineBefore:=Not:C34($skipLineAfter) | Not:C34($isClosure)
					$doLineAfter:=Not:C34($skipLineAfter)
					$skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=14)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[3]+"\\b"; $line)=0)  //Case of
					
					$level:=$level+1
					
					$doLineBefore:=Not:C34($isComment)
					$doLineAfter:=True:C214
					$skipLineAfter:=False:C215
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 4)
					
				: (Position:C15(": ("; $line)=1)  //item in Case of
					
					If (Bool:C1537($options.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$line)
						
					End if 
					
					$Boo_addLine:=Bool:C1537($options.separationLineForCaseOf)
					$doLineBefore:=Not:C34($isComment)
					$doLineAfter:=True:C214
					$skipLineAfter:=False:C215
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[4]+"\\b"; $line)=0)  //End case
					
					$Boo_addLine:=Bool:C1537($options.separationLineForCaseOf)
					$doLineBefore:=(Not:C34($isComment) | Not:C34($isClosure))\
						 & Not:C34($Boo_lineComment)
					$doLineAfter:=Not:C34($skipLineAfter)
					$skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=4)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					$tLon_branchAndLoop{0}:=-5
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[5]+"\\b"; $line)=0)  //While
					
					If (Bool:C1537($options.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$line)
						
					End if 
					
					$doLineBefore:=True:C214
					$doLineAfter:=True:C214
					$skipLineAfter:=False:C215
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 6)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[6]+"\\b"; $line)=0)  //End while
					
					$doLineBefore:=Not:C34($skipLineAfter) | Not:C34($isClosure)
					$doLineAfter:=Not:C34($skipLineAfter)
					$skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=6)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[7]+"\\b"; $line)=0)  //For
					
					$doLineBefore:=Not:C34($isComment)
					$doLineAfter:=True:C214
					$skipLineAfter:=False:C215
					
					If (Bool:C1537($options.addTheIncrementForTheLoops))
						
						$pattern:="\\(([^;]*;[^;]*;[^;]*)(;.*?)?\\)$"
						ARRAY TEXT:C222($tTxt_result; 0x0000)
						
						If (Rgx_MatchText($pattern; $line; ->$tTxt_result)=0)
							
							If (Length:C16($tTxt_result{2})=0)
								
								$line:=Replace string:C233($line; $tTxt_result{1}; $tTxt_result{1}+";1")
								
							End if 
						End if 
					End if 
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 8)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[8]+"\\b"; $line)=0)  //End for
					
					$doLineBefore:=Not:C34($skipLineAfter) | Not:C34($isClosure)
					$doLineAfter:=Not:C34($skipLineAfter)
					$skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=8)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[9]+"\\b"; $line)=0)  //Repeat
					
					$doLineBefore:=True:C214
					$doLineAfter:=True:C214
					$skipLineAfter:=False:C215
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 10)
					
					//……………………………………………………………
				: (Rgx_MatchText("(?<!//)"+This:C1470.controlFlow[10]+"\\b"; $line)=0)  //Until
					
					If (Bool:C1537($options.splitTestLines))
						
						$errorCode:=Rgx_SubstituteText("(\\) (&|\\|) \\()"; ")\\\r\\2("; ->$line)
						
					End if 
					
					$doLineBefore:=Not:C34($skipLineAfter) | Not:C34($isClosure)
					$doLineAfter:=Not:C34($skipLineAfter)
					$skipLineAfter:=True:C214
					
					If ($tLon_branchAndLoop{$tLon_branchAndLoop}=10)
						
						DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
						
					End if 
					
					//……………………………………………………………
				: (Position:C15(Command name:C538(948); $line)=1)  //Begin SQL
					
					$doLineBefore:=True:C214
					$doLineAfter:=True:C214
					$skipLineAfter:=False:C215
					
					//……………………………………………………………
				: (Position:C15(Command name:C538(949); $line)=1)  //End SQL
					
					$doLineBefore:=True:C214
					$doLineAfter:=True:C214
					$skipLineAfter:=False:C215
					
					//……………………………………………………………
				Else 
					
					$isEmptyLine:=False:C215
					$doLineBefore:=$isClosure
					
					//……………………………………………………………
			End case 
			
			// #18-8-2017
			If (Bool:C1537($options.formatComments))  // Add a space before the comment and capitalize the first letter
				
				If (Not:C34(Match regex:C1019("(?m-si)(.)\\1{4,}"; $line; 1)))  // Not for a comment with at least 5 occurrences of the same character
					
					If (0=Rgx_ExtractText("(?ms-i)^(.*)(?=//)//\\s*([^\"$]*)$"; $line; "1 2"; ->$tTxt_2D_result))
						
						If (Length:C16($tTxt_2D_result{1}{2})>0)
							
							If (Length:C16($tTxt_2D_result{1}{1})=0)  // Comment line
								
								If (Position:C15($tTxt_2D_result{1}{2}[[1]]; This:C1470.specialComments)=0)
									
									$tTxt_2D_result{1}{2}[[1]]:=Uppercase:C13($tTxt_2D_result{1}{2}[[1]]; *)
									$line:="// "+$tTxt_2D_result{1}{2}
									
								End if 
								
							Else 
								
								$tTxt_2D_result{1}{2}[[1]]:=Uppercase:C13($tTxt_2D_result{1}{2}[[1]]; *)
								$line:=$tTxt_2D_result{1}{1}+"// "+$tTxt_2D_result{1}{2}
								
							End if 
						End if 
					End if 
				End if 
			End if 
			
			$isClosure:=$isEnd
			$isComment:=(Position:C15(kCommentMark; $line)=1)
			
			If (Not:C34($severalLines))
				
				If ($Boo_addLine)
					
					If (Not:C34($Boo_lineComment))
						
						If ($level>This:C1470.numberOfSeparators)
							
							$level:=This:C1470.numberOfSeparators
							
						Else 
							
							If ($level<1)
								
								$level:=1
								
							End if 
						End if 
						
						$line:=kCommentMark\
							+(This:C1470.separators[$level]*(20-($level\2)))\
							+"\r"\
							+$line
						
					End if 
					
					$level:=$level-Num:C11($tLon_branchAndLoop{0}=-5)
					
					$Boo_lineComment:=False:C215
					$Boo_addLine:=False:C215
					
				End if 
				
				If ($doLineBefore | $doReturn)
					
					$line:=Choose:C955($isEmptyLine | ($i=0); ""; "\r")+$line
					$isEmptyLine:=False:C215
					$doLineBefore:=False:C215
					$doReturn:=False:C215
					
				End if 
			End if 
			
			$severalLines:=($line="@\\")
			
			Case of 
					
					//______________________________________________________
				: ($severalLines)\
					 | (Not:C34(Bool:C1537($options.splitKeyValueLines)))
					
					//#7-4-2017 ________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233(This:C1470.splittableCommandsPattern; "{command}"; Command name:C538(1471)); $line)=0)  //New object
					
					$line:=This:C1470._splitIntoKeyAndValue($line; 1471)
					
					//__________________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233(This:C1470.splittableCommandsPattern; "{command}"; Command name:C538(1220)); $line)=0)  //OB SET
					
					$line:=This:C1470._splitIntoKeyAndValue($line; 1220)
					
					//__________________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233(This:C1470.splittableCommandsPattern; "{command}"; Command name:C538(1055)); $line)=0)  //SVG SET ATTRIBUTE
					
					$line:=This:C1470._splitIntoKeyAndValue($line; 1055)
					
					//__________________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233(This:C1470.splittableCommandsPattern; "{command}"; Command name:C538(865)); $line)=0)  //DOM Create XML element
					
					$line:=This:C1470._splitIntoKeyAndValue($line; 865)
					
					//__________________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233(This:C1470.splittableCommandsPattern; "{command}"; Command name:C538(866)); $line)=0)  //DOM SET XML ATTRIBUTE
					
					$line:=This:C1470._splitIntoKeyAndValue($line; 866)
					
					//__________________________________________________________________________________________
				: (Rgx_MatchText(Replace string:C233(This:C1470.splittableCommandsPattern; "{command}"; Command name:C538(1093)); $line)=0)  //ST SET ATTRIBUTES 
					
					$line:=This:C1470._splitIntoKeyAndValue($line; 1093)
					
					//______________________________________________________
			End case 
			
			$code:=$code+$line+"\r"
			
		End for 
		
		If (Bool:C1537($options.removeConsecutiveBlankLines))
			
			$errorCode:=Rgx_SubstituteText("[\\r\\n]{2,}"; "\r\r"; ->$code)
			
		End if 
		
		If (Bool:C1537($options.removeEmptyLinesAtTheEndOfMethod))
			
			$errorCode:=Rgx_SubstituteText("(\\r)$"; ""; ->$code)
			
		End if 
		
		This:C1470._paste($code)
		
	Else 
		
		BEEP:C151
		
	End if 
	
	//==============================================================
Function _splitIntoKeyAndValue($code : Text; $commandNumber : Integer)->$splitted : Text
	
	var $buffer; $prefix : Text
	var $closingParenthesisPosition; $firstSemicolonPosition; $nextSemicolonPosition; $openingParenthesisPosition; $pos : Integer
	
	While ($code[[1]]="\r")
		
		$prefix:=$prefix+"\r"
		$code:=Delete string:C232($code; 1; 1)
		
	End while 
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($commandNumber=1471)  // New Object
			
			$buffer:=Command name:C538($commandNumber)
			
			$pos:=Position:C15($buffer; $code)
			$splitted:=$prefix+Substring:C12($code; 1; $pos+Length:C16($buffer))
			$code:=Delete string:C232($code; 1; Length:C16($splitted)-Length:C16($prefix))
			$splitted:=$splitted+"\\\r"
			
			$pos:=Position:C15(";"; $code)
			$openingParenthesisPosition:=Position:C15("("; $code)  // Open parenthesis
			
			If ($openingParenthesisPosition>0)\
				 & ($openingParenthesisPosition<$pos)
				
				$closingParenthesisPosition:=Position:C15(")"; $code; $openingParenthesisPosition+1)
				$pos:=Position:C15(";"; $code; $closingParenthesisPosition+1)
				
			End if 
			
			// Go to the second semicolon
			$pos:=Position:C15(";"; $code; $pos+1)
			
			If ($pos>0)
				
				$splitted:=$splitted+Substring:C12($code; 1; $pos)+"\\\r"
				$code:=Substring:C12($code; $pos+1)
				
			End if 
			
			//______________________________________________________
		: ($commandNumber=1055)  // SVG SET ATTRIBUTE
			
			$splitted:=$prefix+Command name:C538($commandNumber)+"("
			$code:=Delete string:C232($code; 1; Length:C16($splitted)-Length:C16($prefix))
			
			If ($code[[1]]="*")
				
				$splitted:=$splitted+"*;"
				$code:=Substring:C12($code; 3)
				
			End if 
			
			//______________________________________________________
		: ($commandNumber=1220)  // OB SET
			
			$pos:=Position:C15(";"; $code)
			
			If ($pos>0)
				
				$splitted:=$prefix+Substring:C12($code; 1; $pos)+"\\\r"
				$code:=Substring:C12($code; $pos+1)
				
			End if 
			
			//______________________________________________________
		: ($commandNumber=865)  // DOM Create XML element
			
			$buffer:=Command name:C538($commandNumber)
			
			$pos:=Position:C15($buffer; $code)
			$splitted:=$prefix+Substring:C12($code; 1; $pos+Length:C16($buffer))
			$code:=Delete string:C232($code; 1; Length:C16($splitted)-Length:C16($prefix))
			
			$pos:=Position:C15(";"; $code)
			$openingParenthesisPosition:=Position:C15("("; $code)  // Open parenthesis
			
			If ($openingParenthesisPosition>0)\
				 & ($openingParenthesisPosition<$pos)
				
				$closingParenthesisPosition:=Position:C15(")"; $code; $openingParenthesisPosition+1)
				$pos:=Position:C15(";"; $code; $closingParenthesisPosition+1)
				
			End if 
			
			// Go to the second semicolon
			$pos:=Position:C15(";"; $code; $pos+1)
			
			If ($pos>0)
				
				$splitted:=$splitted+Substring:C12($code; 1; $pos)+"\\\r"
				$code:=Substring:C12($code; $pos+1)
				
			End if 
			
			//______________________________________________________
		: ($commandNumber=866)  // DOM SET XML ATTRIBUTE
			
			$splitted:=Command name:C538($commandNumber)+"("
			
			$code:=Delete string:C232($code; 1; Length:C16($splitted))
			
			$pos:=Position:C15(";"; $code)
			$openingParenthesisPosition:=Position:C15("("; $code)  // Open parenthesis
			
			If ($openingParenthesisPosition>0)\
				 & ($openingParenthesisPosition<$pos)
				
				$closingParenthesisPosition:=Position:C15(")"; $code; $openingParenthesisPosition+1)
				$pos:=Position:C15(";"; $code; $closingParenthesisPosition+1)
				
			End if 
			
			If ($pos>0)
				
				$splitted:=$prefix+$splitted+Substring:C12($code; 1; $pos)+"\\\r"
				$code:=Substring:C12($code; $pos+1)
				
			End if 
			
			//______________________________________________________
		: ($commandNumber=1093)  // ST SET ATTRIBUTES 
			
			$splitted:=$prefix+Command name:C538($commandNumber)+"("
			$code:=Delete string:C232($code; 1; Length:C16($splitted)-Length:C16($prefix))
			
			If ($code[[1]]="*")
				
				$splitted:=$splitted+"*;"
				$code:=Substring:C12($code; 3)
				
			End if 
			
			// Object
			$pos:=Position:C15(";"; $code)
			
			$buffer:=Substring:C12($code; 1; $pos)
			$splitted:=$splitted+$buffer
			$code:=Delete string:C232($code; 1; Length:C16($buffer))
			
			// StartSel
			$pos:=Position:C15(";"; $code)
			
			$buffer:=Substring:C12($code; 1; $pos)
			$splitted:=$splitted+$buffer
			$code:=Delete string:C232($code; 1; Length:C16($buffer))
			
			// EndSel
			$pos:=Position:C15(";"; $code)
			
			$buffer:=Substring:C12($code; 1; $pos)
			$splitted:=$splitted+$buffer+"\\\r"
			$code:=Delete string:C232($code; 1; Length:C16($buffer))
			
			//______________________________________________________
		Else 
			
			// NOTHING MORE TO DO
			
			//______________________________________________________
	End case 
	
	// Go to the first semicolon
	$firstSemicolonPosition:=This:C1470.nextSemicolon($code)
	
	If ($firstSemicolonPosition>0)
		
		$splitted:=$splitted+Substring:C12($code; 1; $firstSemicolonPosition)+"\\\r"
		$code:=Substring:C12($code; $firstSemicolonPosition+1)
		
		Repeat 
			
			// Go to the second semicolon
			$nextSemicolonPosition:=This:C1470.nextSemicolon($code)
			
			If ($nextSemicolonPosition>0)
				
				$splitted:=$splitted+Substring:C12($code; 1; $nextSemicolonPosition)+"\\\r"
				$code:=Substring:C12($code; $nextSemicolonPosition+1)
				
			Else 
				
				$splitted:=$splitted+$code
				
			End if 
		Until ($firstSemicolonPosition=0)\
			 | ($nextSemicolonPosition=0)
		
	Else 
		
		$splitted:=$splitted+$code
		
	End if 
	
	//==============================================================
Function nextSemicolon($code : Text)->$position : Integer
	
	var $closingParenthesisPosition; $firstOne; $openParenthesisPosition : Integer
	
	// First semicolon
	$firstOne:=Position:C15(";"; $code)
	
	// Second semicolon
	$position:=Position:C15(";"; $code; $firstOne+1)
	
	// Open parenthesis
	$openParenthesisPosition:=Position:C15("("; $code)
	
	If ($position>0)\
		 & ($openParenthesisPosition>0)\
		 & ($position>$openParenthesisPosition)
		
		Repeat 
			
			// Closing parenthesis
			$closingParenthesisPosition:=Position:C15(")"; $code; $openParenthesisPosition+1)
			
			// Next semicolon
			$position:=Position:C15(";"; $code; $closingParenthesisPosition+1)
			
			// Next opening parenthesis
			$openParenthesisPosition:=Position:C15("("; $code; $closingParenthesisPosition+1)
			
		Until ($openParenthesisPosition>$position)\
			 | ($openParenthesisPosition=0)
		
	End if 