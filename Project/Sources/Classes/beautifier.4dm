Class extends macro

property _controls; _patterns; settings : Object
property separators; controlFlow; closures : Collection
property numberOfSeparators : Integer
property specialComments : Text
property caseOfLevel : Integer:=0
property _splittableCommands : Collection

property lineBefore; lineCurrent; lineNext : Text
property _lines : Collection:=[]

Class constructor()
	
	var $t : Text
	var $c : Collection
	var $file : 4D:C1709.File
	
	Super:C1705()
	
	// Mark:Preferences
	$file:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
	$file:=$file.original ? $file.original : $file
	
	If ($file.exists)
		
		This:C1470.settings:=JSON Parse:C1218($file.getText()).beautifier
		
	End if 
	
	// Default values
	For each ($t; [\
		"replaceDeprecatedCommand"; \
		"removeConsecutiveBlankLines"; \
		"removeEmptyLinesAtTheBeginOfMethod"; \
		"removeEmptyLinesAtTheEndOfMethod"; \
		"lineBreakBeforeBranchingStructures"; \
		"lineBreakBeforeLoopingStructures"; \
		"lineBreakBeforeAndAfterSequentialStructuresIncluded"; \
		"separationLineForCaseOf"; \
		"aLineOfCommentsMustBePrecededByALineBreak"; \
		"groupingClosureInstructions"; \
		"addTheIncrementForTheLoops"; \
		"splitTestLines"; \
		"replaceComparisonsToAnEmptyStringByLengthTest"; \
		"replaceIfElseEndIfByChoose"; \
		"splitKeyValueLines"; \
		"formatComments"; \
		"useVar"; \
		"compoundAssignmentOperators"])
		
		This:C1470.settings[$t]:=This:C1470.settings[$t]#Null:C1517 ? This:C1470.settings[$t] : True:C214
		
	End for each 
	
	// Mark:Separators
	This:C1470.separators:=This:C1470.settings.separators || Split string:C1554("━━━,┅┅┅,╍╍╍,╌╌╌,__,––,⩫⩫,……,--,··,~~,..;::"; ",")
	This:C1470.numberOfSeparators:=This:C1470.separators.length-1
	
	// Mark:Control flow
	$c:=JSON Parse:C1218(File:C1566("/RESOURCES/controlFlow.json").getText())[Command name:C538(41)="ALERT" ? "intl" : "fr"]
	
	This:C1470._controls:={\
		if: $c[0]; \
		else: $c[1]; \
		endIf: $c[2]; \
		caseOf: $c[3]; \
		caseOfItem: "(?mi-s)^\\s*:\\s*\\("; \
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
	
	// Mark:Closures
	This:C1470.closures:=[\
		This:C1470._controls.endIf; \
		This:C1470._controls.endCase; \
		This:C1470._controls.endWhile; \
		This:C1470._controls.endFor; \
		This:C1470._controls.until; \
		This:C1470._controls.endUse; \
		This:C1470._controls.endForEach]
	
	// Mark:-[Patterns]
	// Mark:Localised flow controls
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
	
	// Mark:Closures
	This:C1470._patterns.closure:="(?<!"+kCommentMark+")(?:"+This:C1470.closures.join("|")+")\\b"
	
	// Mark:Localised closures
	// $t:="\\r*(\\r{closure}[^\\r]*\\r)\\r*"
	$t:="(?mi-s)(?<!//)(?<!//\\s)(?:/\\*.*\\*/)?({closure}[^\\R]*)(\\R)(\\R*)"
	This:C1470._patterns.closureInstructions:=[\
		Replace string:C233($t; "{closure}"; This:C1470._controls.endIf); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endCase); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endWhile); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endFor); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.until); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endUse); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endForEach)\
		]
	
	This:C1470._patterns.keywords:="(?mi-s)^(?:break|continue|return)"
	
	// Mark:ternary operators
	This:C1470._patterns.ternaryOperator:="(?mi-s)"\
		+This:C1470._controls.if+"\\s\\(([^)]*)\\)\\W*(\\$.*?):=(.*)(?:\\s*"+kCommentMark+".*)?\\s*\\R"\
		+This:C1470._controls.else+".*\\R\\s*\\2:=(.*)(?:\\s*"+kCommentMark+".*)?\\s*\\R"\
		+This:C1470._controls.endIf
	
	// Mark:Choose
	This:C1470._patterns.choose:="(?mi-s)"+Command name:C538(955)+"\\s*\\(([^;]*);\\s*([^;]*);\\s*([^;]*)\\)([^$]*)"
	
	// Mark:Empty string
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
	
	// Mark:Splittable commands
	This:C1470._patterns.splittableCommands:="(?mi-s)^[^/]*{command}\\(.*\\)(?:\\s*"+kCommentMark+"[^$]*)?$"
	
	// Separator line is made with a comment mark and at least 5 times the same character
	This:C1470._patterns.commentLine:="(?m-si)^\\s*"+kCommentMark+"\\s*(.)\\1{4,}"
	
	This:C1470.specialComments:="%}])"  // Compilation modifier & …
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function beautify()
	
	var $line; $pattern; $replacement; $t; $beforeLine; $nextLine : Text
	var $doAddLine; $doLineAfter; $doLineBefore; $doLineComment; $doReturn; $isClosure : Boolean
	var $inMultiLineComment; $isEmptyLine; $isEnd; $severalLines; $skipLineBefore; $skipLineAfter : Boolean
	var $i : Integer
	var $o : Object
	
	ARRAY LONGINT:C221($_branchAndLoop; 0)
	
	var $code : Text:=This:C1470.withSelection ? This:C1470.highlighted : This:C1470.method
	var $options : Object:=This:C1470.settings
	
	If (Length:C16($code)=0)
		
		BEEP:C151
		
		return 
		
	End if 
	
	This:C1470.method:=This:C1470._optionalBefore($code)
	
	This:C1470.split()
	
	var $lines : Collection:=[]
	
	CLEAR VARIABLE:C89($code)
	
	For each ($line; This:C1470.lines)
		
		$inMultiLineComment:=False:C215
		
		This:C1470.lineCurrent:=$line
		
		This:C1470.rgx.setTarget($line)
		
		Case of 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isEmpty($line))
				
				If ($options.groupingClosureInstructions)\
					 && ((This:C1470._isClosure(Try(This:C1470.lines[This:C1470.lineIndex+1]))) || (Length:C16(Try(This:C1470.lines[This:C1470.lineIndex+1]))=0))
					
					continue
					
				End if 
				
				This:C1470._lines.push("")
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isComment($line))
				
				If ($options.aLineOfCommentsMustBePrecededByALineBreak)\
					 && This:C1470.isNotEmpty(This:C1470.lineBefore)\
					 && (This:C1470.isNotClosingReservedComment($line))
					
					This:C1470._lines.push("")
					
				End if 
				
				If (This:C1470.isNotReservedComment($line))
					
					$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
					
				End if 
				
				This:C1470._lines.push($line)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.If).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.splitTestLines ? This:C1470._splitTestLine($line) : $line
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				
				This:C1470._lines.push($line)
				
				This:C1470._startOfLoopAndBranching(1; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Else).match())
				
				If ($_branchAndLoop{$_branchAndLoop}=4)  // Case of … Else
					
					This:C1470._lineBreakBeforeBranchingStructures(True:C214)
					
				Else 
					
					If ($options.lineBreakBeforeBranchingStructures)\
						 && This:C1470.isNotSeparatorLineComment(This:C1470.lineBefore)
						
						This:C1470._lines.push("")
						
					End if 
				End if 
				
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				If (Length:C16(Try(This:C1470.lines[This:C1470.lineIndex+1]))>1)
					
					This:C1470._lines.push("")
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndIf).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._lines.push("")
				
				This:C1470._endOfLoopAndBranching(1; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Use).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.splitTestLines ? This:C1470._splitTestLine($line) : $line
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._startOfLoopAndBranching(13; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndUse).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._lines.push("")
				
				This:C1470._endOfLoopAndBranching(13; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.ForEach).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._startOfLoopAndBranching(14; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndForEach).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._lines.push("")
				
				This:C1470._endOfLoopAndBranching(14; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.CaseOf).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.splitTestLines ? This:C1470._splitTestLine($line) : $line
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				
				If (This:C1470.isNotEmpty(This:C1470.lineNext))
					
					This:C1470._lines.push("")
					
				End if 
				
				This:C1470._startOfLoopAndBranching(4; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._controls.caseOfItem).match())
				
				This:C1470._lineBreakBeforeBranchingStructures(True:C214)
				
				$line:=$options.splitTestLines ? This:C1470._splitTestLine($line) : $line
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndCase).match())
				
				This:C1470._lineBreakBeforeBranchingStructures(True:C214)
				
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._lines.push("")
				
				This:C1470._endOfLoopAndBranching(4; ->$_branchAndLoop; -5)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.While).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.splitTestLines ? This:C1470._splitTestLine($line) : $line
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				
				This:C1470._lines.push($line)
				
				This:C1470._startOfLoopAndBranching(6; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndWhile).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._lines.push("")
				
				This:C1470._endOfLoopAndBranching(6; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.For).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				If ($options.addTheIncrementForTheLoops)
					
					If (This:C1470.rgx.setPattern("(?mi-s)\\(([^;]*;[^;]*;[^;]*)(;.*?)?\\)").match())
						
						If (This:C1470.rgx.matches[2].length=0)
							
							$line:=Replace string:C233($line; This:C1470.rgx.matches[1].data; This:C1470.rgx.matches[1].data+";1")
							
						End if 
					End if 
				End if 
				
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._startOfLoopAndBranching(8; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndFor).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._lines.push("")
				
				This:C1470._endOfLoopAndBranching(8; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Repeat).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._startOfLoopAndBranching(10; ->$_branchAndLoop)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Until).match())
				
				This:C1470._lineBreakBeforeBranchingStructures()
				
				$line:=$options.splitTestLines ? This:C1470._splitTestLine($line) : $line
				$line:=$options.formatComments ? This:C1470._formatComment($line) : $line
				This:C1470._lines.push($line)
				
				This:C1470._lines.push("")
				
				This:C1470._endOfLoopAndBranching(10; ->$_branchAndLoop)
				
/*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§*/: (True:C214)
/*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§*/This:C1470._lines.push($options.formatComments ? This:C1470._formatComment($line) : $line)
				
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
				
				//$isEmptyLine:=False
				//$doLineBefore:=$isClosure
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		End case 
		
		This:C1470.lineBefore:=$line
		This:C1470.lineNext:=Try(This:C1470.lines[This:C1470.lineIndex+2])
		This:C1470.lineIndex+=1
		
	End for each 
	
	This:C1470.paste(This:C1470._optionalAfter(This:C1470._lines.join("\r")))
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _optionalBefore($code : Text) : Text
	
	var $pattern; $t : Text
	var $i : Integer
	var $options : Object:=This:C1470.settings
	
	// Mark:Use var instead of (_o_)C_xxx
	If ($options.useVar)
		
		$pattern:="(?-msi)(?<!//)(?<!//\\s){C_}\\((?![\\w\\s]+;\\s*\\$\\{?\\d+\\}?)([^{\\)]*)\\)"
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(604))).substitute("var \\1 : Blob")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(305))).substitute("var \\1 : Boolean")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(1488))).substitute("var \\1 : Collection")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(307))).substitute("var \\1 : Date")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(283))).substitute("var \\1 : Integer")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(1216))).substitute("var \\1 : Object")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(286))).substitute("var \\1 : Picture")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(301))).substitute("var \\1 : Pointer")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(285))).substitute("var \\1 : Real")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(284))).substitute("var \\1 : Text")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(306))).substitute("var \\1 : Time")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{C_}"; Command name:C538(1683))).substitute("var \\1")
		
	End if 
	
	// Mark:Compound assignment operators
	If ($options.compoundAssignmentOperators)
		
		$pattern:="(?mi-s)^([^:]*):=\\1(?:\\\\R\\W*)?{op}(.*)?$"
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{op}"; "-")).substitute("\\1-=\\2")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{op}"; "\\+")).substitute("\\1+=\\2")
		
	End if 
	
	// Mark:Delete empty lines at the beginning of the method
	If ($options.removeEmptyLinesAtTheBeginOfMethod)
		
		$code:=This:C1470.rgx.setTarget($code).setPattern("^(\\r*)").substitute("")
		
	End if 
	
	//// Mark:Grouping of closing instructions
	//If ($options.groupingClosureInstructions)
	
	//For each ($t; This._patterns.closureInstructions)
	
	//$code:=This.rgx.setTarget($code).setPattern($t).substitute("\\1")
	
	//End for each 
	
	//$code:=This.rgx.setTarget($code).setPattern(This._patterns.CaseOfItem).substitute("\\1")
	
	//End if 
	
	// Mark:Use ternary operator
	If ($options.replaceIfElseEndIfByChoose)  // Use ternary operator
		
		// Search for an unused character for a temporary replacement 😉
		var $c : Collection:=[126; 167; 182; 248; 8225; 8226; 8734; 8776; 63743]
		
		Try
			
			Repeat 
				
				$t:=Char:C90($c[$i])
				
				If (Position:C15($t; $code)=0)
					
					break
					
				End if 
				
				$i+=1
				
			Until (False:C215)
			
			$code:=Replace string:C233($code; "\\"; $t*2)
			$code:=This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.ternaryOperator).substitute("\\2 := \\1 ? \\3 :\\4\r")
			$code:=Replace string:C233($code; $t*2; "\\")
			
		End try
		
		$code:=This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.choose).substitute("\\1 ? \\2 : \\3\\4")
		
	End if 
	
	// Mark:Optimize comparisons to an empty string
	If ($options.replaceComparisonsToAnEmptyStringByLengthTest)\
		 && (This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.emptyString).match(True:C214))
		
		For ($i; 0; This:C1470.rgx.matches.length-1; 5)
			
			$t:=This:C1470.rgx.matches[$i+1].data\
				+Command name:C538(16)\
				+"("+This:C1470.rgx.matches[$i+2].data+")"\
				+This:C1470.rgx.matches[$i+3].data+" 0)"\
				+This:C1470.rgx.matches[$i+4].data
			
			$code:=Replace string:C233($code; This:C1470.rgx.matches[$i].data; $t)
			
		End for 
	End if 
	
	// Mark:Miscellaneous
	//$code:=This.rgx.setTarget($code).setPattern("("+This._controls.if+"\\s*\\([^\\r]*\\r)\\r*").substitute("\\1")
	//$code:=This.rgx.setTarget($code).setPattern("("+This._controls.caseOf+"[^\\r]*\\r)\\r*").substitute("\\1")
	//$code:=This.rgx.setTarget($code).setPattern("("+This._controls.while+"\\s*\\([^\\r]*\\r)\\r*").substitute("\\1")
	//$code:=This.rgx.setTarget($code).setPattern("("+This._controls.for+"\\s*\\([^\\r]*\\r)\\r*").substitute("\\1")
	//$code:=This.rgx.setTarget($code).setPattern("("+This._controls.repeat+"[^\\r]*\\r)\\r*").substitute("\\1")
	//$code:=This.rgx.setTarget($code).setPattern("\\r*(\\r"+This._controls.else+"[^\\r]*\\r)\\r*").substitute("\\1")
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _optionalAfter($code : Text) : Text
	
	var $options : Object:=This:C1470.settings
	
	// Mark:Remove consecutive blank lines
	If ($options.removeConsecutiveBlankLines)
		
		$code:=This:C1470.rgx.setTarget($code).setPattern("(?mi-s)\\R{2,}").substitute("\r\r")
		
	End if 
	
	// Mark:Grouping of closing instructions
	If ($options.groupingClosureInstructions)
		
		For each ($t; This:C1470._patterns.closureInstructions)
			
			$code:=This:C1470.rgx.setTarget($code).setPattern($t).substitute("\\1")
			
		End for each 
		
		$code:=This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.CaseOfItem).substitute("\\1")
		
	End if 
	
	// Mark:Remove empty lines at the end of the method
	If ($options.removeEmptyLinesAtTheEndOfMethod)
		
		$code:=This:C1470.rgx.setTarget($code).setPattern("(?i-ms)(\\R*?)$").substitute("")
		
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _isClosure($line : Text) : Boolean
	
	If (This:C1470.isEmpty($line))
		
		return 
		
	End if 
	
	
	var $t : Text
	
	For each ($t; This:C1470.closures)
		
		If (Position:C15($t; $line)=1)
			
			return True:C214
			
		End if 
	End for each 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _isNotClosure($line : Text) : Boolean
	
	return Not:C34(This:C1470._isClosure($line))
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _lineBreakBeforeBranchingStructures($caseOf : Boolean)
	
	If ($caseOf)
		
		If (This:C1470.settings.separationLineForCaseOf)
			
			If (This:C1470.isNotSeparatorLineComment(This:C1470.lineBefore))
				
				If (This:C1470.isComment(This:C1470.lineBefore))
					
					This:C1470._lines.push("")
					
				End if 
				
				If (This:C1470.caseOfLevel<=1) & False:C215
					
					This:C1470._lines.push(kCommentMark+" Mark:-")
					
				Else 
					
					var $level : Integer:=This:C1470.caseOfLevel<=1 ? 1 : This:C1470.caseOfLevel-1
					This:C1470._lines.push(kCommentMark+(This:C1470.separators[$level]*(20-($level\2))))
					
				End if 
			End if 
		End if 
		
	Else 
		
		If (This:C1470.settings.lineBreakBeforeBranchingStructures)\
			 && (This:C1470.lineIndex>0)\
			 && This:C1470.isNotSeparatorLineComment(This:C1470.lineCurrent)\
			 && This:C1470._isNotClosure(This:C1470.lineCurrent)\
			 && This:C1470.isNotEmpty(This:C1470.lineBefore)
			
			This:C1470._lines.push("")
			
		End if 
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	//Function _groupingClosureInstructions
	//If (This.settings.groupingClosureInstructions)\
		&& This._isNotClosure(This.lineNext)
	//This._lines.push("")
	//End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _startOfLoopAndBranching($id : Integer; $ptr : Pointer)
	
	APPEND TO ARRAY:C911($ptr->; $id)
	
	//%W-533.3
	$ptr->:=Size of array:C274($ptr->)
	$ptr->{0}:=$ptr->{$ptr->}
	//%W+533.3
	
	If ($id=4)  //| True
		
		This:C1470.caseOfLevel+=1
		This:C1470.caseOfLevel:=This:C1470.caseOfLevel>This:C1470.numberOfSeparators ? This:C1470.numberOfSeparators : 1
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _endOfLoopAndBranching($id : Integer; $ptr : Pointer; $new : Integer)
	
	//%W-533.3
	If (Abs:C99($ptr->{$ptr->})=$id)
		
		DELETE FROM ARRAY:C228($ptr->; $ptr->; $id)
		
		$ptr->:=Size of array:C274($ptr->)
		$ptr->{0}:=$current=0 ? $ptr->{$ptr->} : $new
		
		If ($id=4)  //| True
			
			This:C1470.caseOfLevel-=1
			This:C1470.caseOfLevel:=This:C1470.caseOfLevel<1 ? 0 : This:C1470.caseOfLevel
			
		End if 
	End if 
	//%W+533.3
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _formatComment($line : Text) : Text
	
	var $start : Integer:=Position:C15(kCommentMark; $line)
	
	If ($start=0)\
		 || (Match regex:C1019("(?mi-s)\"[^:]*://"; $line; 1))
		
		return $line
		
	End if 
	
	// TODO: extract the comment, format it and add it
	// TODO: detect Mark:{-} & so on to format the firt letter of the command
	
	var $code : Text:=Substring:C12($line; 1; $start-1)
	var $comment:=Delete string:C232($line; 1; $start-1+Length:C16(kCommentMark))
	
	var $c : Collection:=Split string:C1554($comment; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
	If ($c.length=0)
		
		return kCommentMark
		
	End if 
	
	var $t : Text:=$c[0]
	$t[[1]]:=Uppercase:C13($t[[1]])
	$c[0]:=$t
	
	$c.insert(0; kCommentMark)
	
	If (Length:C16($code)>0)
		
		$c.insert(0; $code)
		
	End if 
	
	return $c.join(" ")
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _splitTestLine($line : Text) : Text
	
	return This:C1470.rgx.setTarget($line).setPattern("(?mi-s)(\\)\\s*(&{1,2}|\\|{1,2})\\s*\\()").substitute(")\\\r\\\r\\2(")
	
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