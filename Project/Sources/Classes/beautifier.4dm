Class extends macro

property _controls; _patterns; settings : Object
property separators; controlFlow : Collection
property numberOfSeparators : Integer
property specialComments : Text

Class constructor()
	
	var $t : Text
	var $c : Collection
	var $file : 4D:C1709.File
	
	Super:C1705()
	
	// Preferences
	$file:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
	$file:=$file.original ? $file.original : $file
	
	If ($file.exists)
		
		This:C1470.settings:=JSON Parse:C1218($file.getText()).beautifier
		
	End if 
	
	// Format comments
	This:C1470.settings.formatComments:=This:C1470.settings.formatComments#Null:C1517 ? This:C1470.settings.formatComments : True:C214
	
	// Separators
	This:C1470.separators:=This:C1470.settings.separators || Split string:C1554("━━━,┅┅┅,╍╍╍,╌╌╌,__,––,⩫⩫,……,--,··,~~,..;::"; ",")
	This:C1470.numberOfSeparators:=This:C1470.separators.length-1
	
	$c:=JSON Parse:C1218(File:C1566("/RESOURCES/controlFlow.json").getText())[Command name:C538(41)="ALERT" ? "intl" : "fr"]
	
	This:C1470._controls:={\
		if: $c[0]; \
		else: $c[1]; \
		endIf: $c[2]; \
		caseOf: $c[3]; \
		caseOfItem: ":\\s*\\("; \
		endCase: $c[4]; \
		while: $c[5]; \
		endWhile: $c[6]; \
		for: $c[7]; \
		endFor: $c[8]; \
		repeat: $c[9]; \
		until: $c[10]; \
		use: $c[11]; \
		endUse: $c[12]; \
		forEach: $c[13]; \
		endForEach: $c[14]\
		}
	
	$t:="(?<!"+kCommentMark+")^(?:/\\*.*\\*/)?{control}\\b"
	This:C1470._patterns:={\
		If: Replace string:C233($t; "{control}"; This:C1470._controls.if); \
		Else: Replace string:C233($t; "{control}"; This:C1470._controls.else); \
		EndIf: Replace string:C233($t; "{control}"; This:C1470._controls.endIf); \
		CaseOf: Replace string:C233($t; "{control}"; This:C1470._controls.caseOf); \
		EndCase: Replace string:C233($t; "{control}"; This:C1470._controls.endCase); \
		While: Replace string:C233($t; "{control}"; This:C1470._controls.while); \
		EndWhile: Replace string:C233($t; "{control}"; This:C1470._controls.endWhile); \
		For: Replace string:C233($t; "{control}"; This:C1470._controls.for); \
		EndFor: Replace string:C233($t; "{control}"; This:C1470._controls.endFor); \
		Repeat: Replace string:C233($t; "{control}"; This:C1470._controls.repeat); \
		Until: Replace string:C233($t; "{control}"; This:C1470._controls.until); \
		Use: Replace string:C233($t; "{control}"; This:C1470._controls.use); \
		EndUse: Replace string:C233($t; "{control}"; This:C1470._controls.endUse); \
		ForEach: Replace string:C233($t; "{control}"; This:C1470._controls.forEach); \
		EndForEach: Replace string:C233($t; "{control}"; This:C1470._controls.endForEach); \
		CaseOfItem: "(?<!"+kCommentMark+")\\r*(\\r:\\s\\([^\\r]*\\r)\\r*"; \
		BeginSQL: "(?<!"+kCommentMark+")^(?:/\\*.*\\*/)?"+Command name:C538(948); \
		EndSQL: "(?<!"+kCommentMark+")^(?:/\\*.*\\*/)?"+Command name:C538(949); \
		varWithAssignment: "\"(?mi-s)^var\\\\s*(?:[^:]*:){2}=\""\
		}
	
	This:C1470._patterns.closure:="(?<!"+kCommentMark+")(?:"+[\
		This:C1470._controls.endIf; \
		This:C1470._controls.endCase; \
		This:C1470._controls.endWhile; \
		This:C1470._controls.endFor; \
		This:C1470._controls.until; \
		This:C1470._controls.endUse; \
		This:C1470._controls.endForEach].join("|")\
		+")\\b"
	
	$t:="\\r*(\\r{closure}[^\\r]*\\r)\\r*"
	This:C1470._patterns.closureInstructions:=[\
		Replace string:C233($t; "{closure}"; This:C1470._controls.endIf); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endCase); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endWhile); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endFor); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.until); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endUse); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endForEach)\
		]
	
	// Mark:New keywords
	This:C1470._patterns.keywords:="(?mi-s)^(?:break|continue|return)"
	
	// Mark:Optional code formatting
	This:C1470._patterns.ternaryOperator:="(?mi-s)"\
		+This:C1470._controls.if+"\\s\\(([^)]*)\\)\\W*(\\$.*?):=(.*)(?:\\s*"+kCommentMark+".*)?\\s*\\R"\
		+This:C1470._controls.else+".*\\R\\s*\\2:=(.*)(?:\\s*"+kCommentMark+".*)?\\s*\\R"\
		+This:C1470._controls.endIf
	
	This:C1470._patterns.choose:="(?mi-s)"+Command name:C538(955)+"\\s*\\(([^;]*);\\s*([^;]*);\\s*([^;]*)\\)([^$]*)"
	
	This:C1470._patterns.emptyString:="(?mi-s)(\\(|;)([^)#=;]*)(#|=)\"\"\\)([^$]*)"
	
	// Mark:Commands whose parameters must be divided into key/value lines
	This:C1470._splittableCommands:=[\
		{name: Command name:C538(1471); id: 1471}; \
		{name: Command name:C538(1220); id: 1220}; \
		{name: Command name:C538(1055); id: 1055}; \
		{name: Command name:C538(865); id: 865}; \
		{name: Command name:C538(866); id: 866}; \
		{name: Command name:C538(1093); id: 1093}\
		]
	
	This:C1470._patterns.splittableCommands:="(?mi-s)^[^/]*{command}\\(.*\\)(?:\\s*"+kCommentMark+"[^$]*)?$"
	
	// Separator line is made with a comment mark and at least 5 times the same character
	This:C1470._patterns.commentLine:="(?m-si)^\\s*"+kCommentMark+"\\s*(.)\\1{4,}"
	
	This:C1470.specialComments:="%}])"  // Compilation modifier & …
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function beautify()
	
	var $code; $line; $pattern; $replacement; $t : Text
	var $doAddLine; $doLineAfter; $doLineBefore; $doLineComment; $doReturn; $isClosure : Boolean
	var $isComment; $isEmptyLine; $isEnd; $severalLines; $skipLineAfter : Boolean
	var $i; $level : Integer
	var $o; $options : Object
	
	ARRAY LONGINT:C221($tLon_branchAndLoop; 0)
	
	$code:=Choose:C955(This:C1470.withSelection; This:C1470.highlighted; This:C1470.method)
	$options:=This:C1470.settings
	
	If (Length:C16($code)=0)
		
		BEEP:C151
		
		return 
		
	End if 
	
	// Mark:Delete empty lines at the beginning of the method
	If (Bool:C1537($options.removeEmptyLinesAtTheBeginOfMethod))
		
		$code:=This:C1470.rgx.setTarget($code).setPattern("^(\\r*)").substitute("")
		
	End if 
	
	// Mark:Grouping of closing instructions
	If (Bool:C1537(This:C1470.settings.groupingClosureInstructions))
		
		For each ($t; This:C1470._patterns.closureInstructions)
			
			$code:=This:C1470.rgx.setTarget($code).setPattern($t).substitute("\\1")
			
		End for each 
		
		$code:=This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.CaseOfItem).substitute("\\1")
		
	End if 
	
	// Mark:Use ternary operator
	If (Bool:C1537($options.replaceIfElseEndIfByChoose))  // Use ternary operator
		
		$code:=Replace string:C233($code; "\\"; "§§")
		$code:=This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.ternaryOperator).substitute("\\2 := \\1 ? \\3 :\\4\r")
		$code:=Replace string:C233($code; "§§"; "\\")
		
		$code:=This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.choose).substitute("\\1 ? \\2 : \\3\\4")
		
	End if 
	
	// Mark:Optimize comparisons to an empty string
	If (Bool:C1537($options.replaceComparisonsToAnEmptyStringByLengthTest))\
		 && (This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.emptyString).match(True:C214))
		
		For ($i; 0; This:C1470.rgx.matches.length-1; 5)
			
			$replacement:=This:C1470.rgx.matches[$i+1].data\
				+Command name:C538(16)\
				+"("+This:C1470.rgx.matches[$i+2].data+")"\
				+This:C1470.rgx.matches[$i+3].data+" 0)"\
				+This:C1470.rgx.matches[$i+4].data
			
			$code:=Replace string:C233($code; This:C1470.rgx.matches[$i].data; $replacement)
			
		End for 
	End if 
	
	$code:=This:C1470.rgx.setTarget($code).setPattern("("+This:C1470._controls.if+" \\([^\\r]*\\r)\\r*").substitute("\\1")
	$code:=This:C1470.rgx.setTarget($code).setPattern("("+This:C1470._controls.caseOf+"[^\\r]*\\r)\\r*").substitute("\\1")
	$code:=This:C1470.rgx.setTarget($code).setPattern("("+This:C1470._controls.while+" \\([^\\r]*\\r)\\r*").substitute("\\1")
	$code:=This:C1470.rgx.setTarget($code).setPattern("("+This:C1470._controls.for+" \\([^\\r]*\\r)\\r*").substitute("\\1")
	$code:=This:C1470.rgx.setTarget($code).setPattern("("+This:C1470._controls.repeat+"[^\\r]*\\r)\\r*").substitute("\\1")
	$code:=This:C1470.rgx.setTarget($code).setPattern("\\r*(\\r"+This:C1470._controls.else+"[^\\r]*\\r)\\r*").substitute("\\1")
	
	This:C1470.method:=$code
	
	This:C1470.split()
	
	CLEAR VARIABLE:C89($code)
	CLEAR VARIABLE:C89($i)
	
	For each ($line; This:C1470.lineTexts)
		
		$tLon_branchAndLoop:=Size of array:C274($tLon_branchAndLoop)
		$tLon_branchAndLoop{0}:=$tLon_branchAndLoop{$tLon_branchAndLoop}
		
		$skipLineAfter:=Not:C34($isEnd) ? False:C215 : $skipLineAfter
		$isEnd:=This:C1470.rgx.setTarget($line).setPattern(This:C1470._patterns.closure).match()
		
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
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (Length:C16($line)=0)  // Empty line
				
				$isEmptyLine:=True:C214
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (Position:C15(kCommentMark; $line)=1)  // Comment
				
				If (Not:C34($isComment))  // Multiline
					
					$doLineBefore:=($i>0 ? Bool:C1537($options.aLineOfCommentsMustBePrecededByALineBreak) : False:C215)\
						 & ($line#(kCommentMark+"}"))\
						 & ($line#(kCommentMark+"]"))\
						 & ($line#(kCommentMark+")"))\
						 & ($line#(kCommentMark+"%"))
					
				End if 
				
				$doLineComment:=This:C1470.rgx.setPattern(This:C1470._patterns.commentLine).match()
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.If).match())
				
				$doLineBefore:=Bool:C1537($options.lineBreakBeforeBranchingStructures) & Not:C34($isComment)
				
				If (Bool:C1537($options.splitTestLines))
					
					$line:=This:C1470._splitTestLine($line)
					
				End if 
				
				If (Replace string:C233($line; " "; "")=(This:C1470._controls.if+"("+Command name:C538(215)+")@"))
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; -1)
					$doLineAfter:=False:C215
					$skipLineAfter:=True:C214
					
				Else 
					
					APPEND TO ARRAY:C911($tLon_branchAndLoop; 1)
					$doLineAfter:=Bool:C1537($options.lineBreakBeforeAndAfterSequentialStructuresIncluded)
					$skipLineAfter:=False:C215
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Else).match())
				
				If ($tLon_branchAndLoop{$tLon_branchAndLoop}=4)
					
					$doAddLine:=True:C214
					$doLineBefore:=Not:C34($isComment)
					
				Else 
					
					$doAddLine:=False:C215
					$doLineBefore:=True:C214
					
				End if 
				
				$doLineAfter:=True:C214
				$skipLineAfter:=False:C215
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndIf).match())
				
				$doLineBefore:=(Not:C34($skipLineAfter) | Not:C34($isClosure))\
					 & ($tLon_branchAndLoop{$tLon_branchAndLoop}#-1)
				
				$doLineAfter:=Not:C34($skipLineAfter)
				$skipLineAfter:=True:C214
				
				If (Abs:C99($tLon_branchAndLoop{$tLon_branchAndLoop})=1)
					
					DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Use).match())
				
				If (Bool:C1537($options.splitTestLines))
					
					$line:=This:C1470._splitTestLine($line)
					
				End if 
				
				$doLineBefore:=Bool:C1537($options.lineBreakBeforeBranchingStructures) & Not:C34($isComment)
				$doLineAfter:=True:C214
				$skipLineAfter:=False:C215
				
				APPEND TO ARRAY:C911($tLon_branchAndLoop; 13)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndUse).match())
				
				$doLineBefore:=Not:C34($skipLineAfter) | Not:C34($isClosure)
				$doLineAfter:=Not:C34($skipLineAfter)
				$skipLineAfter:=True:C214
				
				If ($tLon_branchAndLoop{$tLon_branchAndLoop}=13)
					
					DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.ForEach).match())
				
				If (Bool:C1537($options.splitTestLines))
					
					$line:=This:C1470._splitTestLine($line)
					
				End if 
				
				$doLineBefore:=Bool:C1537($options.lineBreakBeforeBranchingStructures) & Not:C34($isComment)
				$doLineAfter:=True:C214
				$skipLineAfter:=False:C215
				
				APPEND TO ARRAY:C911($tLon_branchAndLoop; 14)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndForEach).match())
				
				$doLineBefore:=Not:C34($skipLineAfter) | Not:C34($isClosure)
				$doLineAfter:=Not:C34($skipLineAfter)
				$skipLineAfter:=True:C214
				
				If ($tLon_branchAndLoop{$tLon_branchAndLoop}=14)
					
					DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.CaseOf).match())
				
				$level+=1
				
				$doLineBefore:=Not:C34($isComment)
				$doLineAfter:=True:C214
				$skipLineAfter:=False:C215
				
				APPEND TO ARRAY:C911($tLon_branchAndLoop; 4)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._controls.caseOfItem).match())
				
				If (Bool:C1537($options.splitTestLines))
					
					$line:=This:C1470._splitTestLine($line)
					
				End if 
				
				$doAddLine:=Bool:C1537($options.separationLineForCaseOf)
				$doLineBefore:=Not:C34($isComment)
				$doLineAfter:=True:C214
				$skipLineAfter:=False:C215
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndCase).match())
				
				$doAddLine:=Bool:C1537($options.separationLineForCaseOf)
				$doLineBefore:=(Not:C34($isComment) | Not:C34($isClosure)) & Not:C34($doLineComment)
				$doLineAfter:=Not:C34($skipLineAfter)
				$skipLineAfter:=True:C214
				
				If ($tLon_branchAndLoop{$tLon_branchAndLoop}=4)
					
					DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
					
				End if 
				
				$tLon_branchAndLoop{0}:=-5
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.While).match())
				
				If (Bool:C1537($options.splitTestLines))
					
					$line:=This:C1470._splitTestLine($line)
					
				End if 
				
				$doLineBefore:=True:C214
				$doLineAfter:=True:C214
				$skipLineAfter:=False:C215
				
				APPEND TO ARRAY:C911($tLon_branchAndLoop; 6)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndWhile).match())
				
				$doLineBefore:=Not:C34($skipLineAfter) | Not:C34($isClosure)
				$doLineAfter:=Not:C34($skipLineAfter)
				$skipLineAfter:=True:C214
				
				If ($tLon_branchAndLoop{$tLon_branchAndLoop}=6)
					
					DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.For).match())
				
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
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndFor).match())
				
				$doLineBefore:=Not:C34($skipLineAfter) | Not:C34($isClosure)
				$doLineAfter:=Not:C34($skipLineAfter)
				$skipLineAfter:=True:C214
				
				If ($tLon_branchAndLoop{$tLon_branchAndLoop}=8)
					
					DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Repeat).match())
				
				$doLineBefore:=True:C214
				$doLineAfter:=True:C214
				$skipLineAfter:=False:C215
				
				APPEND TO ARRAY:C911($tLon_branchAndLoop; 10)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Until).match())
				
				If (Bool:C1537($options.splitTestLines))
					
					$line:=This:C1470._splitTestLine($line)
					
				End if 
				
				$doLineBefore:=Not:C34($skipLineAfter) | Not:C34($isClosure)
				$doLineAfter:=Not:C34($skipLineAfter)
				$skipLineAfter:=True:C214
				
				If ($tLon_branchAndLoop{$tLon_branchAndLoop}=10)
					
					DELETE FROM ARRAY:C228($tLon_branchAndLoop; $tLon_branchAndLoop; 1)
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.keywords).match())
				
				$doLineBefore:=True:C214
				$doLineAfter:=True:C214
				$skipLineAfter:=False:C215
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.BeginSQL).match())
				
				$doLineBefore:=True:C214
				$doLineAfter:=True:C214
				$skipLineAfter:=False:C215
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndSQL).match())
				
				$doLineBefore:=True:C214
				$doLineAfter:=True:C214
				$skipLineAfter:=False:C215
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			Else 
				
				$isEmptyLine:=False:C215
				$doLineBefore:=$isClosure
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		End case 
		
		// Mark:Add a space before the comment and capitalize the first letter
		If ($options.formatComments)\
			 && (Position:C15(kCommentMark; $line)#0)\
			 && /* not compiler directive */(Position:C15(kCommentMark+"%"; $line)=0)\
			 && /* not URI */Not:C34(This:C1470.rgx.setPattern("(?mi-s)\"[^:]*://").match())\
			 && /* not separator line */Not:C34(This:C1470.rgx.setPattern(This:C1470._patterns.commentLine).match())
			
			$line:=This:C1470._formatComment($line)
			
		End if 
		
		$isClosure:=$isEnd
		$isComment:=(Position:C15(kCommentMark; $line)>0) && (Position:C15(kCommentMark; $line)<=2)
		
		If (Not:C34($severalLines))
			
			If ($doAddLine)
				
				If (Not:C34($doLineComment))
					
					$level:=$level>This:C1470.numberOfSeparators\
						 ? This:C1470.numberOfSeparators\
						 : $level<1 ? 1 : $level
					
					$line:=kCommentMark\
						+(This:C1470.separators[$level]*(20-($level\2)))\
						+"\r"\
						+$line
					
				End if 
				
				$level-=Num:C11($tLon_branchAndLoop{0}=-5)
				
				$doLineComment:=False:C215
				$doAddLine:=False:C215
				
			End if 
			
			If ($doLineBefore | $doReturn)
				
				$line:=($isEmptyLine | ($i=0) ? "" : "\r")+$line
				$isEmptyLine:=False:C215
				$doLineBefore:=False:C215
				$doReturn:=False:C215
				
			End if 
		End if 
		
		$severalLines:=($line="@\\")
		
		If (Not:C34($severalLines))\
			 && Not:C34($isComment)\
			 && Bool:C1537($options.splitKeyValueLines)
			
			For each ($o; This:C1470._splittableCommands)
				
				If (This:C1470.rgx.setTarget($line).setPattern(Replace string:C233(This:C1470._patterns.splittableCommands; "{command}"; $o.name)).match())
					
					$line:=This:C1470._splitIntoKeyAndValue($line; $o)
					
				End if 
			End for each 
			
		End if 
		
		$code+=$line+"\r"
		$i+=1
		
	End for each 
	
	// Mark:Remove consecutive blank lines
	If (Bool:C1537($options.removeConsecutiveBlankLines))
		
		$code:=This:C1470.rgx.setTarget($code).setPattern("[\\r\\n]{2,}").substitute("\r\r")
		
	End if 
	
	// Mark:Remove empty lines at the end of the method
	If (Bool:C1537($options.removeEmptyLinesAtTheEndOfMethod))
		
		$code:=This:C1470.rgx.setTarget($code).setPattern("(\\r*)$").substitute("")
		
	End if 
	
	This:C1470._paste($code)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _formatComment($line : Text) : Text
	
	var $code; $t : Text
	var $start : Integer
	var $c : Collection
	
	$start:=Position:C15(kCommentMark; $line)
	$code:=Substring:C12($line; 1; $start-1)
	$line:=Delete string:C232($line; 1; $start-1+2)
	
	$c:=Split string:C1554($line; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
	If ($c.length>0)
		
		$t:=$c[0]
		$t[[1]]:=Uppercase:C13($t[[1]])
		$c[0]:=$t
		
	End if 
	
	$c.insert(0; kCommentMark)
	$c.insert(0; $code)
	
	return $c.join(" ")
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _splitTestLine($line : Text) : Text
	
	return This:C1470.rgx.setTarget($line).setPattern("(?mi-s)(\\)\\s*(&{1,2}|\\|{1,2})\\s*\\()").substitute(")\\\r\\2(")
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _splitIntoKeyAndValue($code : Text; $cmd : Object) : Text
	
	var $prefix; $splitted; $t : Text
	var $closingParenthesisPosition; $firstSemicolonPosition; $nextSemicolonPosition; $openingParenthesisPosition; $pos : Integer
	
	While ($code[[1]]="\r")
		
		$prefix+="\r"
		$code:=Delete string:C232($code; 1; 1)
		
	End while 
	
	Case of 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($cmd.id=1471)  // New Object
			
			$pos:=Position:C15($cmd.name; $code)
			$splitted:=$prefix+Substring:C12($code; 1; $pos+Length:C16($cmd.name))
			$code:=Delete string:C232($code; 1; Length:C16($splitted)-Length:C16($prefix))
			$splitted+="\\\r"
			
			$pos:=Position:C15(";"; $code)
			$openingParenthesisPosition:=Position:C15("("; $code)  // Open parenthesis
			
			If ($openingParenthesisPosition>0)\
				 && ($openingParenthesisPosition<$pos)
				
				$closingParenthesisPosition:=Position:C15(")"; $code; $openingParenthesisPosition+1)
				$pos:=Position:C15(";"; $code; $closingParenthesisPosition+1)
				
			End if 
			
			// Go to the second semicolon
			$pos:=Position:C15(";"; $code; $pos+1)
			
			If ($pos>0)
				
				$splitted+=Substring:C12($code; 1; $pos)+"\\\r"
				$code:=Substring:C12($code; $pos+1)
				
			End if 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($cmd.id=1055)  // SVG SET ATTRIBUTE
			
			$splitted:=$prefix+$cmd.name+"("
			$code:=Delete string:C232($code; 1; Length:C16($splitted)-Length:C16($prefix))
			
			If ($code[[1]]="*")
				
				$splitted+="*;"
				$code:=Substring:C12($code; 3)
				
			End if 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($cmd.id=1220)  // OB SET
			
			$pos:=Position:C15(";"; $code)
			
			If ($pos>0)
				
				$splitted:=$prefix+Substring:C12($code; 1; $pos)+"\\\r"
				$code:=Substring:C12($code; $pos+1)
				
			End if 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($cmd.id=865)  // DOM Create XML element
			
			$pos:=Position:C15($cmd.name; $code)
			$splitted:=$prefix+Substring:C12($code; 1; $pos+Length:C16($cmd.name))
			$code:=Delete string:C232($code; 1; Length:C16($splitted)-Length:C16($prefix))
			
			$pos:=Position:C15(";"; $code)
			$openingParenthesisPosition:=Position:C15("("; $code)  // Open parenthesis
			
			If ($openingParenthesisPosition>0)\
				 && ($openingParenthesisPosition<$pos)
				
				$closingParenthesisPosition:=Position:C15(")"; $code; $openingParenthesisPosition+1)
				$pos:=Position:C15(";"; $code; $closingParenthesisPosition+1)
				
			End if 
			
			// Go to the second semicolon
			$pos:=Position:C15(";"; $code; $pos+1)
			
			If ($pos>0)
				
				$splitted+=Substring:C12($code; 1; $pos)+"\\\r"
				$code:=Substring:C12($code; $pos+1)
				
			End if 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($cmd.id=866)  // DOM SET XML ATTRIBUTE
			
			$splitted:=$cmd.name+"("
			
			$code:=Delete string:C232($code; 1; Length:C16($splitted))
			
			$pos:=Position:C15(";"; $code)
			$openingParenthesisPosition:=Position:C15("("; $code)  // Open parenthesis
			
			If ($openingParenthesisPosition>0)\
				 && ($openingParenthesisPosition<$pos)
				
				$closingParenthesisPosition:=Position:C15(")"; $code; $openingParenthesisPosition+1)
				$pos:=Position:C15(";"; $code; $closingParenthesisPosition+1)
				
			End if 
			
			If ($pos>0)
				
				$splitted:=$prefix+$splitted+Substring:C12($code; 1; $pos)+"\\\r"
				$code:=Substring:C12($code; $pos+1)
				
			End if 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($cmd.id=1093)  // ST SET ATTRIBUTES 
			
			$splitted:=$prefix+$cmd.name+"("
			$code:=Delete string:C232($code; 1; Length:C16($splitted)-Length:C16($prefix))
			
			If ($code[[1]]="*")
				
				$splitted+="*;"
				$code:=Substring:C12($code; 3)
				
			End if 
			
			// Object
			$pos:=Position:C15(";"; $code)
			
			$t:=Substring:C12($code; 1; $pos)
			$splitted+=$t
			$code:=Delete string:C232($code; 1; Length:C16($t))
			
			// StartSel
			$pos:=Position:C15(";"; $code)
			
			$t:=Substring:C12($code; 1; $pos)
			$splitted+=$t
			$code:=Delete string:C232($code; 1; Length:C16($t))
			
			// EndSel
			$pos:=Position:C15(";"; $code)
			
			$t:=Substring:C12($code; 1; $pos)
			$splitted+=$t+"\\\r"
			$code:=Delete string:C232($code; 1; Length:C16($t))
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		Else 
			
			// Oops
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	End case 
	
	// Go to the first semicolon
	$firstSemicolonPosition:=This:C1470._nextSemicolon($code)
	
	If ($firstSemicolonPosition>0)
		
		$splitted+=Substring:C12($code; 1; $firstSemicolonPosition)+"\\\r"
		$code:=Substring:C12($code; $firstSemicolonPosition+1)
		
		Repeat 
			
			// Go to the second semicolon
			$nextSemicolonPosition:=This:C1470._nextSemicolon($code)
			
			If ($nextSemicolonPosition>0)
				
				$splitted+=Substring:C12($code; 1; $nextSemicolonPosition)+"\\\r"
				$code:=Substring:C12($code; $nextSemicolonPosition+1)
				
			Else 
				
				$splitted+=$code
				
			End if 
		Until ($firstSemicolonPosition=0)\
			 | ($nextSemicolonPosition=0)
		
	Else 
		
		$splitted+=$code
		
	End if 
	
	return $splitted
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _nextSemicolon($code : Text)->$position : Integer
	
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