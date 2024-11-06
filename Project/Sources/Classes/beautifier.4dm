Class extends macro

property _controls; _patterns; options : Object
property separators; controlFlow; closures : Collection
property numberOfSeparators : Integer
property specialComments : Text
property caseOfLevel : Integer:=-1
property _splittableCommands : Collection

property previousLine : Text:=""
property nextLine : Text:=""

property isMultiLines : Boolean:=False:C215
property _lines : Collection:=[]
property loopAndBranching : Collection:=[]

Class constructor()
	
	var $t : Text
	var $c : Collection
	var $file : 4D:C1709.File
	
	Super:C1705()
	
	// Mark:Options
	$file:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
	$file:=$file.original ? $file.original : $file
	
	If ($file.exists)
		
		This:C1470.options:=JSON Parse:C1218($file.getText()).beautifier
		
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
		"compoundAssignmentOperators"; \
		"splitLiterals"\
		])
		
		This:C1470.options[$t]:=This:C1470.options[$t]#Null:C1517 ? This:C1470.options[$t] : True:C214
		
	End for each 
	
	// Mark:Separators
	This:C1470.separators:=This:C1470.options.separators || Split string:C1554("____,┅┅,╌╌╌,╍╍╍,..,–––,⩫⩫,……,--,··,~~,..;::"; ",")
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
	This:C1470._patterns.choose:="(?i-ms)"+Command name:C538(955)+"\\(([^;]*?);\\s*([^;]*?);\\s*([^;]*?)\\)(\\s*//.*?)?\\R"
	
	This:C1470._patterns.emptyString:="(?mi-s)(?:\\(|;)([^)#=;]*?)(#|=)\"\""  //"(?mi-s)(\\(|;)([^)#=;]*)(#|=)\"\"\\)([^$]*)"
	
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
	var $isEmptyLine; $isEnd; $severalLines; $skipLineBefore; $skipLineAfter : Boolean
	var $i : Integer
	var $o : Object
	
	ARRAY LONGINT:C221($_branchAndLoop; 0)
	
	var $code : Text:=This:C1470.withSelection ? This:C1470.highlighted : This:C1470.method
	
	If (Length:C16($code)=0)
		
		BEEP:C151
		
		return 
		
	End if 
	
	This:C1470.method:=This:C1470.before($code)
	
	This:C1470.split()
	
	For each ($line; This:C1470.lines)
		
		This:C1470.line:=$line
		//This.multiLines:=This.isMultiline($line)
		
		This:C1470.previousLine:=Try(This:C1470._lines[This:C1470._lines.length-1])
		This:C1470.nextLine:=Try(This:C1470.lines[This:C1470.lineIndex+1])
		
		This:C1470.rgx.target:=$line
		
		// TODO:Manage multiline comments
		
		//ASSERT($line#"End if   //10")
		//ASSERT(This.lineIndex#7)
		
		Case of 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isEmpty($line))
				
/*
An empty line is ignored if:
  - The option to prevent several empty lines in a row is activated, and the previous line is empty.
  - The close instruction grouping option is enabled, and the following line is one of them.
*/
				
				If (This:C1470.options.removeConsecutiveBlankLines && This:C1470.isEmpty(This:C1470.previousLine))\
					 || (This:C1470.options.groupingClosureInstructions && ((This:C1470.isClosure(This:C1470.nextLine) || This:C1470.isEmpty(This:C1470.nextLine))))
					
					This:C1470.lineIndex+=1
					continue
					
					
				Else 
					
					This:C1470._lines.push("")
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isComment($line))
				
/*
A comment line is preceded by an empty line if:
  - the option is enabled.
  - this is not the first line.
  - the preceding line is not already an empty line or a comment.
  - it is not a closing comment for the compiler type //%X+.
*/
				If (This:C1470.options.aLineOfCommentsMustBePrecededByALineBreak\
					 && (This:C1470.lineIndex>0)\
					 && This:C1470.isNotEmpty(This:C1470.previousLine)\
					 && This:C1470.isNotComment(This:C1470.previousLine)\
					 && This:C1470.isNotClosingReservedComment($line)\
					 && This:C1470.isNotSeparatorLineComment($line)\
					 && This:C1470.isNotReservedComment($line))
					
					This:C1470._lines.push("")
					
				End if 
				
				If (This:C1470.options.formatComments && This:C1470.isNotReservedComment($line))
					
					$line:=This:C1470.formatComment($line)
					
				End if 
				
				This:C1470._lines.push($line)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.If).match())
				
				This:C1470.openLoopAndBranching(1)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Else).match())
				
				If (This:C1470.loopAndBranching.length>=1)\
					 && (Abs:C99(This:C1470.loopAndBranching[This:C1470.loopAndBranching.length-1])=4)  // Case of … Else
					
					This:C1470.lineBeforeBranchingStructure(True:C214)
					This:C1470._lines.push(This:C1470.options.formatComments ? This:C1470.formatComment($line) : $line)
					
				Else 
					
					This:C1470.openLoopAndBranching()
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndIf).match())
				
				This:C1470.closeLoopAndBranching(1)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Use).match())
				
				This:C1470.openLoopAndBranching(13)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndUse).match())
				
				This:C1470.closeLoopAndBranching(13)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.ForEach).match())
				
				This:C1470.openLoopAndBranching(14)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndForEach).match())
				
				This:C1470.closeLoopAndBranching(14)
				
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.CaseOf).match())
				
				This:C1470.openLoopAndBranching(4)
				
				If (This:C1470.isNotEmpty(This:C1470.nextLine))
					
					This:C1470._lines.push("")
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._controls.caseOfItem).match())
				
				This:C1470.lineBeforeBranchingStructure(True:C214)
				
				$line:=This:C1470.options.splitTestLines ? This:C1470.splitTestLine($line) : $line
				$line:=This:C1470.options.formatComments ? This:C1470.formatComment($line) : $line
				This:C1470._lines.push($line)
				
				
				If (This:C1470.isNotMultiline($line)\
					 && This:C1470.isNotEmpty(This:C1470.nextLine))
					
					This:C1470._lines.push("")
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndCase).match())
				
				This:C1470.closeLoopAndBranching(4; True:C214)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.While).match())
				
				This:C1470.openLoopAndBranching(6)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndWhile).match())
				
				This:C1470.closeLoopAndBranching(6)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.For).match())
				
				If (This:C1470.options.addTheIncrementForTheLoops)\
					 && (This:C1470.rgx.setPattern("(?mi-s)\\(([^;]*;[^;]*;[^;]*)(;.*?)?\\)").match())\
					 && (This:C1470.rgx.matches[2].length=0)
					
					This:C1470.line:=Replace string:C233($line; This:C1470.rgx.matches[1].data; This:C1470.rgx.matches[1].data+";1")
					
				End if 
				
				This:C1470.openLoopAndBranching(8)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndFor).match())
				
				This:C1470.closeLoopAndBranching(8)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Repeat).match())
				
				This:C1470.openLoopAndBranching(10)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Until).match())
				
				This:C1470.closeLoopAndBranching(10)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.keywords).match())
				
				If ((This:C1470.lineIndex>0)\
					 && This:C1470.isNotEmpty(This:C1470.previousLine))
					
					This:C1470._lines.push("")
					
				End if 
				
				This:C1470.line:=This:C1470.options.formatComments ? This:C1470.formatComment(This:C1470.line) : This:C1470.line
				This:C1470._lines.push(This:C1470.line)
				
				If ((This:C1470.lineIndex>0)\
					 && This:C1470.isNotEmpty(This:C1470.nextLine))
					
					This:C1470._lines.push("")
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.BeginSQL).match())
				
				This:C1470.openLoopAndBranching()
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndSQL).match())
				
				This:C1470.closeLoopAndBranching()
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			Else 
				
				$line:=This:C1470.options.formatComments ? This:C1470.formatComment($line) : $line
				$line:=This:C1470.options.splitKeyValueLines ? This:C1470.splitKeyValueLine($line) : $line
				$line:=This:C1470.options.splitLiterals ? This:C1470.splitLiteralObject($line) : $line
				$line:=This:C1470.options.splitLiterals ? This:C1470.splitLiteralCollection($line) : $line
				
				This:C1470._lines.push($line)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		End case 
		
		This:C1470.lineIndex+=1
		
	End for each 
	
	This:C1470.paste(This:C1470.after())
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function before($code : Text) : Text
	
	var $pattern; $t : Text
	var $i : Integer
	
	// Mark:Use var instead of (_o_)C_xxx
	If (This:C1470.options.useVar)
		
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
	If (This:C1470.options.compoundAssignmentOperators)
		
		$pattern:="(?mi-s)^([^:]*):=\\1(?:\\\\R\\W*)?{op}(.*)?$"
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{op}"; "-")).substitute("\\1-=\\2")
		$code:=This:C1470.rgx.setTarget($code).setPattern(Replace string:C233($pattern; "{op}"; "\\+")).substitute("\\1+=\\2")
		
	End if 
	
	// Mark:Use ternary operator
	If (This:C1470.options.replaceIfElseEndIfByChoose)  // Use ternary operator
		
		Try
			
			$t:=This:C1470.unusedCharacter($code)
			$code:=Replace string:C233($code; "\\"; $t*2)
			$code:=This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.ternaryOperator).substitute("\\2 := \\1 ? \\3 :\\4")
			$code:=Replace string:C233($code; $t*2; "\\")
			
		End try
		
		$code:=This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.choose).substitute("\\1 ? \\2 : \\3\\4\r")
		
	End if 
	
	// Mark:Optimize comparisons to an empty string
/*
If (This.options.replaceComparisonsToAnEmptyStringByLengthTest)\
&& (This.rgx.setTarget($code).setPattern(This._patterns.emptyString).match(True))
*/
	If (This:C1470.options.replaceComparisonsToAnEmptyStringByLengthTest\
		 && This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.emptyString).match())
		
		$code:=This:C1470.rgx.substitute("("+Command name:C538(16)+" (\\1) \\2 0 ")
		
	End if 
	
	// Mark:Miscellaneous
	//$code:=This.rgx.setTarget($code).setPattern("("+This._controls.if+"\\s*\\([^\\r]*\\r)\\r*").substitute("\\1")
	//$code:=This.rgx.setTarget($code).setPattern("("+This._controls.caseOf+"[^\\r]*\\r)\\r*").substitute("\\1")
	//$code:=This.rgx.setTarget($code).setPattern("("+This._controls.while+"\\s*\\([^\\r]*\\r)\\r*").substitute("\\1")
	//$code:=This.rgx.setTarget($code).setPattern("("+This._controls.for+"\\s*\\([^\\r]*\\r)\\r*").substitute("\\1")
	//$code:=This.rgx.setTarget($code).setPattern("("+This._controls.repeat+"[^\\r]*\\r)\\r*").substitute("\\1")
	//$code:=This.rgx.setTarget($code).setPattern("\\r*(\\r"+This._controls.else+"[^\\r]*\\r)\\r*").substitute("\\1")
	
	return $code
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function after() : Text
	
	var $t : Text
	var $indx : Integer
	
	// MARK: Remove consecutive blank lines
	If (This:C1470.options.removeConsecutiveBlankLines)
		
		var $c : Collection:=[]
		
		For each ($t; This:C1470._lines)
			
			If (Length:C16($t)=0)
				
				$indx+=1
				
				If ($indx>1)
					
					continue
					
				Else 
					
					$c.push($t)
					
				End if 
				
			Else 
				
				$indx:=0
				$c.push($t)
				
			End if 
		End for each 
		
		This:C1470._lines:=$c
		
	End if 
	
	// MARK: Delete empty lines at the beginning of the method
	If (This:C1470.options.removeEmptyLinesAtTheBeginOfMethod)
		
		While (This:C1470._lines[0]="")
			
			This:C1470._lines:=This:C1470._lines.remove(0; 1)
			
		End while 
	End if 
	
	// MARK: Remove empty lines at the end of the method
	If (This:C1470.options.removeEmptyLinesAtTheEndOfMethod)
		
		$indx:=This:C1470._lines.length-1
		
		If (This:C1470._lines[$indx]="")
			
			This:C1470._lines:=This:C1470._lines.remove($indx; 1)
			
		End if 
	End if 
	
	return This:C1470._lines.join("\r")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function formatComment($line : Text) : Text
	
	var $start : Integer:=Position:C15(kCommentMark; $line)
	
	If ($start=0)
		
		return $line
		
	End if 
	
	// Marker comments in uppercase
	$line:=Replace string:C233($line; "mark:"; "MARK:")
	$line:=Replace string:C233($line; "todo:"; "TODO:")
	$line:=Replace string:C233($line; "fixme:"; "FIXME:")
	
	var $code : Text:=Substring:C12($line; 1; $start-1)
	var $comment:=Delete string:C232($line; 1; $start-1+Length:C16(kCommentMark))
	var $c : Collection:=Split string:C1554($comment; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
	If ($c.length=0)
		
		return kCommentMark
		
	End if 
	
	ARRAY LONGINT:C221($pos; 0x0000)
	ARRAY LONGINT:C221($len; 0x0000)
	
	Case of 
			
			// ______________________________________________________
		: (Match regex:C1019("(?mi-s)\"[^:]*:"+kCommentMark+""; $comment; 1))  // Don't modify url like "https://…"
			
			If ($comment[[1]]#" ")
				
				$comment:=" "+$comment
				
			End if 
			
			$comment[[2]]:=Uppercase:C13($comment[[2]])
			
			return $code+kCommentMark+$comment
			
			// ______________________________________________________
		: (Match regex:C1019("(?mi-s)^\\s*((?:mark|todo|fixme):-*)(.*)$"; $comment; 1; $pos; $len; *))
			
			var $marker : Text
			$marker:=Substring:C12($comment; $pos{1}; $len{1})
			
			If ($marker[[1]]#" ")
				
				$marker:=" "+Uppercase:C13($marker)
				
			End if 
			
			$comment:=Substring:C12($comment; $pos{2}; $len{2})
			
			If (Length:C16($comment)=0)
				
				return kCommentMark+$marker
				
			End if 
			
			If ($comment[[1]]#" ")
				
				$comment:=" "+$comment
				
			End if 
			
			$comment[[2]]:=Uppercase:C13($comment[[2]])
			
			return kCommentMark+$marker+$comment
			
			// ______________________________________________________
		Else 
			
			var $t : Text:=$c[0]
			$t[[1]]:=Uppercase:C13($t[[1]])
			$c[0]:=$t
			
			$c.insert(0; kCommentMark)
			
			If (Length:C16($code)>0)
				
				$c.insert(0; $code)
				
			End if 
			
			return $c.join(" ")
			
			// ______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isClosure($line : Text) : Boolean
	
	If (This:C1470.isEmpty($line))
		
		return 
		
	End if 
	
	
	var $t : Text
	
	For each ($t; This:C1470.closures)
		
		If (Position:C15($t; $line)=1)
			
			return True:C214
			
		End if 
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNotClosure($line : Text) : Boolean
	
	return Not:C34(This:C1470.isClosure($line))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function appendLoopAndBranching($id : Integer)
	
	This:C1470.loopAndBranching.push($id)
	
	If ($id=4)  // Case of
		
		This:C1470.caseOfLevel+=1
		This:C1470.caseOfLevel:=This:C1470.caseOfLevel>This:C1470.numberOfSeparators ? -1 : This:C1470.caseOfLevel
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function removeLoopAndBranching($id : Integer; $new : Integer)
	
	If (This:C1470.loopAndBranching.length<1)
		
		return 
		
	End if 
	
	If (Abs:C99(This:C1470.loopAndBranching[This:C1470.loopAndBranching.length-1])=$id)
		
		This:C1470.loopAndBranching.pop()
		
		If ($id=4)  // Case of
			
			This:C1470.caseOfLevel-=1
			This:C1470.caseOfLevel:=This:C1470.caseOfLevel<0 ? 0 : This:C1470.caseOfLevel
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function openLoopAndBranching($id : Integer)
	
	This:C1470.lineBeforeBranchingStructure()
	
	This:C1470.line:=This:C1470.options.splitTestLines ? This:C1470.splitTestLine(This:C1470.line) : This:C1470.line
	This:C1470.line:=This:C1470.options.formatComments ? This:C1470.formatComment(This:C1470.line) : This:C1470.line
	
	This:C1470._lines.push(This:C1470.line)
	
	This:C1470.lineAfterBranchingStructure()
	
	If ($id>0)
		
		This:C1470.appendLoopAndBranching($id)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function lineAfterBranchingStructure()
	
	If (This:C1470.isNotEmpty(This:C1470.nextLine)\
		 && This:C1470.isNotMultiline(This:C1470.line))
		
		This:C1470._lines.push("")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function closeLoopAndBranching($id : Integer; $caseOf : Boolean)
	
	This:C1470.lineBeforeClosingStructure($caseOf)
	
	This:C1470.line:=This:C1470.options.formatComments ? This:C1470.formatComment(This:C1470.line) : This:C1470.line
	This:C1470._lines.push(This:C1470.line)
	
/*A line break after is mandatory:
- The grouping closing instruction is disabled
or
- The next line is not empty
- The next line is not a closure
*/
	If (Not:C34(This:C1470.options.groupingClosureInstructions))\
		 || (This:C1470.isNotClosure(This:C1470.nextLine)\
		 && (This:C1470.lineIndex>0)\
		 && This:C1470.isNotEmpty(This:C1470.nextLine)\
		 && This:C1470.isNotReservedComment(This:C1470.nextLine))
		
		This:C1470._lines.push("")
		
	End if 
	
	If ($id>0)
		
		This:C1470.removeLoopAndBranching($id)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function lineBeforeBranchingStructure($caseOf : Boolean)
	
	If (This:C1470.lineIndex=0)
		
		return   // Not for the first line
		
	End if 
	
	If ($caseOf)
		
		If (This:C1470.options.separationLineForCaseOf)\
			 && (This:C1470.isNotSeparatorLineComment(This:C1470.previousLine))
			
			If (This:C1470.isNotEmpty(This:C1470.previousLine))\
				 || (This:C1470.isComment(This:C1470.previousLine))
				
				This:C1470._lines.push("")
				
			End if 
			
			If (This:C1470.caseOfLevel>=0)
				
				This:C1470._lines.push(kCommentMark+(This:C1470.separators[This:C1470.caseOfLevel]*(20)))
				
			End if 
			
		End if 
		
		return 
		
	End if 
	
/*
A line break is mandatory before an opening instruction:
  - The option is enabled.
  - The previous line is not empty
  - The previous line is not a comment
*/
	If (Not:C34(This:C1470.options.lineBreakBeforeBranchingStructures))
		
		return   // The option is disabled
		
	End if 
	
	
	If (This:C1470.isNotEmpty(This:C1470.previousLine)\
		 && This:C1470.isNotComment(This:C1470.previousLine))
		
		This:C1470._lines.push("")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function lineBeforeClosingStructure($caseOf : Boolean)
	
	If (This:C1470.lineIndex=0)
		
		return   // Not for the first line
		
	End if 
	
	If ($caseOf)
		
		If (This:C1470.options.separationLineForCaseOf)\
			 && (This:C1470.isNotSeparatorLineComment(This:C1470.previousLine))
			
			If (This:C1470.isNotEmpty(This:C1470.previousLine))\
				 || (This:C1470.isComment(This:C1470.previousLine))
				
				This:C1470._lines.push("")
				
			End if 
			
			If (This:C1470.caseOfLevel>=0)
				
				This:C1470._lines.push(kCommentMark+(This:C1470.separators[This:C1470.caseOfLevel]*(20)))
				
			End if 
		End if 
		
		return 
		
	End if 
	
/*
A line break is mandatory before a closing instruction:
  - The option is enabled.
  - The previous line is not empty
  - The previous line is not a separator line comment like /mark:-xxx
  - The current line is not a closure, nor is the next line
or
  - The grouping closing instruction is disabled
or
  - The grouping closing instruction is enabled
  - The previous line is not a closure instruction
	
*/
	
	If (This:C1470.options.lineBreakBeforeBranchingStructures\
		 && This:C1470.isNotEmpty(This:C1470.previousLine)\
		 && This:C1470.isNotSeparatorLineComment(This:C1470.previousLine)\
		 && This:C1470.isNotClosure(This:C1470.previousLine))
		
		This:C1470._lines.push("")
		
		return 
		
	End if 
	
	If (Not:C34(This:C1470.options.groupingClosureInstructions)\
		 && This:C1470.isNotEmpty(This:C1470.previousLine)\
		 && This:C1470.isNotSeparatorLineComment(This:C1470.previousLine))
		
		This:C1470._lines.push("")
		
		return 
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function splitTestLine($line : Text) : Text
	
	return This:C1470.rgx.setTarget($line).setPattern("(?mi-s)(\\)\\s*(&{1,2}|\\|{1,2})\\s*\\()").substitute(")\\\r\\\r\\2(")
	
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function splitLiteralObject($line : Text) : Text
	
	return This:C1470._splitLiterals($line; "{}")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function splitLiteralCollection($line : Text) : Text
	
	return This:C1470._splitLiterals($line; "[]")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _splitLiterals($line : Text; $dlmt : Text) : Text
	
	var $comment : Text
	
	var $pattern : Text
	$pattern:="(?mi-s)^.*?:=\\{1}[^}]*?\\{2}\\s*(?:/[/*].*)?$"
	$pattern:=Replace string:C233($pattern; "{1}"; $dlmt[[1]])
	$pattern:=Replace string:C233($pattern; "{2}"; $dlmt[[2]])
	
	If (Not:C34(Match regex:C1019($pattern; $line; 1; *)))
		
		return $line
		
	End if 
	
	var $c : Collection:=Split string:C1554($line; ":=")
	
	If ($c.length#2)
		
		return $line
		
	End if 
	
	var $var : Text:=$c[0]
	
	$c:=Split string:C1554($c[1]; kCommentMark)
	
	If ($c.length=2)
		
		$comment:=$c[1]
		
	End if 
	
	$c[0]:=Delete string:C232($c[0]; 1; 1)
	$c[0]:=Delete string:C232($c[0]; Length:C16($c[0]); 1)
	$c:=Split string:C1554($c[0]; ";"; sk trim spaces:K86:2)
	
	var $t : Text:=$c.pop()
	var $out : Collection:=$c.map(Formula:C1597($1.value+";\\"))
	$out.push($t)
	
	return $var+":="+$dlmt[[1]]+"\\\r"+$out.join("\r")+"\\\r"+$dlmt[[2]]+(Length:C16($comment)>0 ? kCommentMark+$comment : "")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function splitKeyValueLine($line : Text) : Text
	
	var $o : Object
	
	For each ($o; This:C1470._splittableCommands)
		
		If (Position:C15(Command name:C538($o.id); $line)=0)
			
			continue
			
		End if 
		
		$line:=This:C1470._splitIntoKeyAndValue($line; $o)
		
	End for each 
	
	return $line
	
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
			
			If (Length:C16($code)>0)\
				 && ($code[[1]]="*")
				
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
			
			If (Length:C16($code)>0)\
				 && ($code[[1]]="*")
				
				
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
		Until ($nextSemicolonPosition=0)
		
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