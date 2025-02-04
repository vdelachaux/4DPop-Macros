property options : Object
property separators; controlFlow; closures : Collection
property numberOfSeparators : Integer
property specialComments : Text

property previousLine : Text:=""
property nextLine : Text:=""
property multiLines : Boolean:=False:C215
property loopAndBranching : Collection:=[]
property caseOfLevel : Integer:=-1

property _controls; _patterns : Object
property _splittableCommands : Collection

Class extends macro

Class constructor()
	
	var $t : Text
	var $c : Collection
	var $file : 4D:C1709.File
	
	Super:C1705()
	
	// MARK: Options
	Try
		
		$file:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
		$file:=$file.original ? $file.original : $file
		
		If ($file.exists)
			
			This:C1470.options:=JSON Parse:C1218($file.getText()).beautifier
			
		End if 
		
	Catch
		
		This:C1470.options:={}
		
	End try
	
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
		"splitTestss"; \
		"replaceComparisonsToAnEmptyStringByLengthTest"; \
		"replaceIfElseEndIfByChoose"; \
		"splitKeyValueLines"; \
		"formatComments"; \
		"useVar"; \
		"compoundAssignmentOperators"; \
		"splitLiterals"\
		])
		
		// This.options[$t]:=This.options[$t]#Null ? This.options[$t] : True
		This:C1470.options[$t]:=This:C1470.options[$t] || True:C214
		
	End for each 
	
	// MARK: Separators
	This:C1470.separators:=This:C1470.options.separators || Split string:C1554("____,┅┅,╌╌╌,╍╍╍,..,–––,⩫⩫,……,--,··,~~,..;::"; ",")
	This:C1470.numberOfSeparators:=This:C1470.separators.length-1
	
	// MARK: Control flow
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
	
	// MARK: Closures
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
	$t:="(?m-si)(?<!"+kCommentMark+")^(?:/\\*.*\\*/)?{control}\\b"
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
	
	// MARK: Closures
	This:C1470._patterns.closure:="(?<!"+kCommentMark+")(?:"+This:C1470.closures.join("|")+")\\b"
	
	// MARK: Localised closures
	$t:="(?mi-s)(?<!"+kCommentMark+")(?<!"+kCommentMark+"\\s)(?:/\\*.*\\*/)?({closure}[^\\R]*)(\\R)(\\R*)"
	This:C1470._patterns.closureInstructions:=[\
		Replace string:C233($t; "{closure}"; This:C1470._controls.endIf); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endCase); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endWhile); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endFor); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.until); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endUse); \
		Replace string:C233($t; "{closure}"; This:C1470._controls.endForEach)\
		]
	
	This:C1470._patterns.keywords:="(?mi-s)^(?:break|continue|return|Try|Catch|End try)"
	
	// MARK: Ternary operators
	This:C1470._patterns.ternaryOperator:="(?mi-s)"\
		+This:C1470._controls.if+"\\s\\(([^)]*)\\)\\W*(\\$.*?):=(.*)(?:\\s*"+kCommentMark+".*)?\\s*\\R"\
		+This:C1470._controls.else+".*\\R\\s*\\2:=(.*)(?:\\s*"+kCommentMark+".*)?\\s*\\R"\
		+This:C1470._controls.endIf
	
	// MARK: Choose
	This:C1470._patterns.choose:="(?i-ms)"+Command name:C538(955)+"\\(([^;]*?);\\s*([^;]*?);\\s*([^;]*?)\\)(\\s*"+kCommentMark+".*?)?\\R"
	
	// MARK: Comparisson with empty string
	This:C1470._patterns.emptyString:="(?mi-s)(?:\\(|;)([^)#=;]+)(?<!:)(#|=)\"\""
	
	// MARK: Commands whose parameters must be divided into key/value lines
	This:C1470._splittableCommands:=[\
		{name: Command name:C538(1471); id: 1471; pattern: "(?mi-s)(.*?:=)"+Command name:C538(1471)+"\\((.*?)\\)(.*?)$"; commentIndex: 4}; \
		{name: Command name:C538(1220); id: 1220; pattern: "(?mi-s)"+Command name:C538(1220)+"\\(([^;]*?);(.*?)\\)(\\s*"+kCommentMark+".*?)?$"; commentIndex: 4}; \
		{name: Command name:C538(1220); id: 1220; pattern: "(?mi-s)"+Command name:C538(1220)+"\\(([^;]*?);(.*?)\\)(\\s*"+kCommentMark+".*?)?$"; commentIndex: 4}; \
		{name: Command name:C538(1055); id: 1055; pattern: "(?mi-s)"+Command name:C538(1055)+"\\((.*?)\\)(\\s*"+kCommentMark+".*?)?$"; commentIndex: 3}; \
		{name: Command name:C538(865); id: 865; pattern: "(?mi-s)(.*?:=)"+Command name:C538(865)+"\\((.*?)\\)(\\s*/"+kCommentMark+".*?)?$"; commentIndex: 4}; \
		{name: Command name:C538(866); id: 866; pattern: "(?mi-s)"+Command name:C538(866)+"\\((.*?)\\)(\\s*"+kCommentMark+".*?)?$"; commentIndex: 3}; \
		{name: Command name:C538(1093); id: 1093; pattern: "(?mi-s)"+Command name:C538(1093)+"\\((.*?)\\)(\\s*"+kCommentMark+".*?)?$"; commentIndex: 3}\
		]
	
	// MARK: Splittable commands
	This:C1470._patterns.splittableCommands:="(?mi-s)^[^/]*{command}\\(.*\\)(?:\\s*"+kCommentMark+"[^$]*)?$"
	
	// Separator line is made with a comment mark and at least 5 times the same character
	This:C1470._patterns.commentLine:="(?m-si)^\\s*"+kCommentMark+"\\s*(.)\\1{4,}"
	
	This:C1470.specialComments:="%}])"  // Compilation modifier & …
	
	This:C1470.beautify()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function beautify()
	
	var $line; $raw : Text
	
	var $code : Text:=This:C1470.withSelection ? This:C1470.highlighted : This:C1470.method
	
	If (Length:C16($code)=0)
		
		BEEP:C151
		
		return 
		
	End if 
	
	This:C1470.method:=This:C1470.before($code)
	
	This:C1470.split(This:C1470.withSelection; 0)  // Get the raw content of lines
	
	For each ($raw; This:C1470.lines)
		
		$line:=This:C1470.rgx.setTarget($raw).setPattern("(?mi-s)^(\\s*)").substitute("")  // Trim leading spaces
		
		This:C1470.line:=$line
		
		//This.previousLine:=Try(This._ouput[This._ouput.length-1])
		Try
			
			This:C1470.previousLine:=This:C1470._ouput[This:C1470._ouput.length-1]
			
		Catch
			
			This:C1470.previousLine:=""
			
		End try
		
		//This.nextLine:=Try(This.lines[This.lineIndex+1])
		Try
			
			This:C1470.nextLine:=This:C1470.lines[This:C1470.lineIndex+1]
			
		Catch
			
			This:C1470.nextLine:=""
			
		End try
		
		This:C1470.rgx.target:=$line
		
		Case of 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isCommentBlock)
				
				This:C1470._ouput.push($raw)
				
				If (Position:C15("*/"; $line)>0)  // End of multiline comment
					
					This:C1470.isCommentBlock:=False:C215
					
				End if 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
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
					
					This:C1470._ouput.push("")
					
				End if 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (Position:C15("/*"; $raw)=1)
				
				This:C1470.isCommentBlock:=(Position:C15("*/"; $raw)=0)  // Start of multiline comment
				
				If (This:C1470.options.aLineOfCommentsMustBePrecededByALineBreak\
					 && (This:C1470.lineIndex>0)\
					 && This:C1470.isNotEmpty(This:C1470.previousLine)\
					 && This:C1470.isNotComment(This:C1470.previousLine)\
					 && This:C1470.isNotReservedComment($line))
					
					This:C1470._ouput.push("")
					
				End if 
				
				This:C1470._ouput.push($raw)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
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
					
					This:C1470._ouput.push("")
					
				End if 
				
				If (This:C1470.options.formatComments && This:C1470.isNotReservedComment($line))
					
					$line:=This:C1470.formatComment($line)
					
				End if 
				
				This:C1470._ouput.push($line)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.If).match())
				
				This:C1470.openLoopAndBranching(1)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Else).match())
				
				If (This:C1470.loopAndBranching.length>=1)\
					 && (Abs:C99(This:C1470.loopAndBranching[This:C1470.loopAndBranching.length-1])=4)  // Case of … Else
					
					This:C1470.beforeBranching(True:C214)
					This:C1470._ouput.push(This:C1470.options.formatComments ? This:C1470.formatComment($line) : $line)
					
				Else 
					
					This:C1470.openLoopAndBranching()
					
				End if 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndIf).match())
				
				This:C1470.closeLoopAndBranching(1)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Use).match())
				
				This:C1470.openLoopAndBranching(13)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndUse).match())
				
				This:C1470.closeLoopAndBranching(13)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.ForEach).match())
				
				This:C1470.openLoopAndBranching(14)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndForEach).match())
				
				This:C1470.closeLoopAndBranching(14)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.CaseOf).match())
				
				This:C1470.openLoopAndBranching(4)
				
				If (This:C1470.isNotEmpty(This:C1470.nextLine))
					
					This:C1470._ouput.push("")
					
				End if 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._controls.caseOfItem).match())
				
				This:C1470.beforeBranching(True:C214)
				
				$line:=This:C1470.options.splitTestss ? This:C1470.splitTests($line) : $line
				$line:=This:C1470.options.formatComments ? This:C1470.formatComment($line) : $line
				This:C1470._ouput.push($line)
				
				If (This:C1470.isNotMultiline($line)\
					 && This:C1470.isNotEmpty(This:C1470.nextLine))
					
					This:C1470._ouput.push("")
					
				End if 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndCase).match())
				
				This:C1470.closeLoopAndBranching(4; True:C214)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.While).match())
				
				This:C1470.openLoopAndBranching(6)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndWhile).match())
				
				This:C1470.closeLoopAndBranching(6)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.For).match())
				
				If (This:C1470.options.addTheIncrementForTheLoops)\
					 && (This:C1470.rgx.setPattern("(?mi-s)\\(([^;]*;[^;]*;[^;]*)(;.*?)?\\)").match())\
					 && (This:C1470.rgx.matches[2].length=0)
					
					This:C1470.line:=Replace string:C233($line; This:C1470.rgx.matches[1].data; This:C1470.rgx.matches[1].data+";1")
					
				End if 
				
				This:C1470.openLoopAndBranching(8)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndFor).match())
				
				This:C1470.closeLoopAndBranching(8)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Repeat).match())
				
				This:C1470.openLoopAndBranching(10)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.Until).match())
				
				This:C1470.closeLoopAndBranching(10)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.keywords).match())
				
				If ((This:C1470.lineIndex>0)\
					 && This:C1470.isNotEmpty(This:C1470.previousLine)\
					 && This:C1470.isNotComment(This:C1470.previousLine))
					
					This:C1470._ouput.push("")
					
				End if 
				
				This:C1470.line:=This:C1470.options.formatComments ? This:C1470.formatComment(This:C1470.line) : This:C1470.line
				This:C1470._ouput.push(This:C1470.line)
				
				If ((This:C1470.lineIndex>0)\
					 && This:C1470.isNotEmpty(This:C1470.nextLine)\
					 && This:C1470.isNotMultiline($line))
					
					This:C1470._ouput.push("")
					
				End if 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.BeginSQL).match())
				
				This:C1470.openLoopAndBranching()
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.rgx.setPattern(This:C1470._patterns.EndSQL).match())
				
				This:C1470.closeLoopAndBranching()
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			Else 
				
				$line:=This:C1470.options.formatComments ? This:C1470.formatComment($line) : $line
				$line:=This:C1470.options.splitKeyValueLines ? This:C1470.splitKeyValueLine($line) : $line
				$line:=This:C1470.options.splitLiterals ? This:C1470.splitObject($line) : $line
				$line:=This:C1470.options.splitLiterals ? This:C1470.splitCollection($line) : $line
				
				This:C1470._ouput.push($line)
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		End case 
		
		This:C1470.lineIndex+=1
		
	End for each 
	
	This:C1470.paste(This:C1470.after())
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function before($code : Text) : Text
	
	// Mark:Use var instead of (_o_)C_xxx
	If (This:C1470.options.useVar)
		
		var $pattern : Text:="(?-msi)(?<!"+kCommentMark+")(?<!"+kCommentMark+"\\s){C_}\\((?![\\w\\s]+;\\s*\\$\\{?\\d+\\}?)([^{\\)]*)\\)"
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
		
		$code:=This:C1470.rgx.setTarget($code).setPattern("(?mi-s)"+Command name:C538(955)+"\\(([^();]*?);([^();]*?);([^();]*?)\\)").substitute("\\1 ? \\2 : \\3")
		$code:=This:C1470.rgx.setTarget($code).setPattern("(?mi-s)"+Command name:C538(955)+"\\(([^();]*?);([^();]*?);([^();]*?)\\)").substitute("\\1 ? \\2 : \\3")  // Yes, twice ;-)
		
		Try
			
			var $t:=This:C1470.unusedCharacter($code)
			$code:=Replace string:C233($code; "\\"; $t*2)
			$code:=This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.ternaryOperator).substitute("\\2 := \\1 ? \\3 :\\4")
			$code:=Replace string:C233($code; $t*2; "\\")
			
		End try
		
		$code:=This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.choose).substitute("\\1 ? \\2 : \\3\\4\r")
		
	End if 
	
	// MARK: Optimize comparisons to an empty string
	If (This:C1470.options.replaceComparisonsToAnEmptyStringByLengthTest\
		 && This:C1470.rgx.setTarget($code).setPattern(This:C1470._patterns.emptyString).match())
		
		$code:=This:C1470.rgx.substitute("("+Command name:C538(16)+" (\\1) \\2 0 ")
		
	End if 
	
	// MARK: Miscellaneous
	// <THERE'S NOTHING LEFT TO DO AT THE MOMENT>
	
	return $code
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function after() : Text
	
	var $indx : Integer
	
	// MARK: Remove consecutive blank lines
	If (This:C1470.options.removeConsecutiveBlankLines)
		
		var $c:=[]
		var $t : Text
		
		For each ($t; This:C1470._ouput)
			
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
		
		This:C1470._ouput:=$c
		
	End if 
	
	// MARK: Delete empty lines at the beginning of the method
	If (This:C1470.options.removeEmptyLinesAtTheBeginOfMethod)\
		 && (This:C1470._ouput.length>0)
		
		While (This:C1470._ouput[0]="")
			
			This:C1470._ouput:=This:C1470._ouput.remove(0; 1)
			
		End while 
	End if 
	
	// MARK: Remove empty lines at the end of the method
	If (This:C1470.options.removeEmptyLinesAtTheEndOfMethod)\
		 && (This:C1470._ouput.length>0)
		
		$indx:=This:C1470._ouput.length-1
		
		If (This:C1470._ouput[$indx]="")
			
			This:C1470._ouput:=This:C1470._ouput.remove($indx; 1)
			
		End if 
	End if 
	
	return This:C1470._ouput.join("\r")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function formatComment($line : Text) : Text
	
	ARRAY LONGINT:C221($pos; 0x0000)
	ARRAY LONGINT:C221($len; 0x0000)
	
	var $start : Integer:=Position:C15(kCommentMark; $line)
	
	If ($start=0)
		
		return $line
		
	End if 
	
	// Marker comments in uppercase
	$line:=Replace string:C233($line; "mark:"; "MARK:")
	$line:=Replace string:C233($line; "todo:"; "TODO:")
	$line:=Replace string:C233($line; "fixme:"; "FIXME:")
	
	var $code; $comment : Text
	
	// Caution with urls or addresses such as “https://...", "file:///...”
	If (Match regex:C1019("(?mi-s)(.*?\".*?:/+.*?\")(?:\\s*//(.*?))?$"; $line; 1; $pos; $len))
		
		$code:=Substring:C12($line; $pos{1}; $len{1})
		$comment:=Substring:C12($line; $pos{2}; $len{2})
		
	Else 
		
		$code:=Substring:C12($line; 1; $start-1)
		$comment:=Delete string:C232($line; 1; $start-1+Length:C16(kCommentMark))
		
	End if 
	
	var $c : Collection:=Split string:C1554($comment; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
	If ($c.length=0)
		
		return $line
		
	End if 
	
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
			
			var $marker : Text:=Substring:C12($comment; $pos{1}; $len{1})
			
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
	
	var $t : Text
	
	If (This:C1470.isEmpty($line))
		
		return 
		
	End if 
	
	For each ($t; This:C1470.closures)
		
		If (Position:C15($t; $line)=1)
			
			return True:C214
			
		End if 
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNotClosure($line : Text) : Boolean
	
	return Not:C34(This:C1470.isClosure($line))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function openLoopAndBranching($id : Integer)
	
	This:C1470.beforeBranching()
	
	This:C1470.line:=This:C1470.options.splitTestss ? This:C1470.splitTests(This:C1470.line) : This:C1470.line
	This:C1470.line:=This:C1470.options.formatComments ? This:C1470.formatComment(This:C1470.line) : This:C1470.line
	
	This:C1470._ouput.push(This:C1470.line)
	
	This:C1470.afterBranching()
	
	If ($id>0)
		
		This:C1470.loopAndBranching.push($id)
		
		If ($id=4)  // Case of
			
			This:C1470.caseOfLevel+=1
			This:C1470.caseOfLevel:=This:C1470.caseOfLevel>This:C1470.numberOfSeparators ? -1 : This:C1470.caseOfLevel
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function closeLoopAndBranching($id : Integer; $caseOf : Boolean)
	
	This:C1470.beforeClosing($caseOf)
	
	This:C1470.line:=This:C1470.options.formatComments ? This:C1470.formatComment(This:C1470.line) : This:C1470.line
	This:C1470._ouput.push(This:C1470.line)
	
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
		
		This:C1470._ouput.push("")
		
	End if 
	
	If ($id>0)
		
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
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function beforeBranching($caseOf : Boolean)
	
	If (This:C1470.lineIndex=0)
		
		//
		
	End if 
	
	If ($caseOf)
		
		If (This:C1470.options.separationLineForCaseOf)\
			 && (This:C1470.isNotSeparatorLineComment(This:C1470.previousLine))
			
			If (This:C1470.isNotEmpty(This:C1470.previousLine))\
				 || (This:C1470.isComment(This:C1470.previousLine))
				
				This:C1470._ouput.push("")
				
			End if 
			
			If (This:C1470.caseOfLevel>=0)
				
				This:C1470._ouput.push(kCommentMark+(This:C1470.separators[This:C1470.caseOfLevel]*(20)))
				
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
		
		return 
		
	End if 
	
	If (This:C1470.isNotEmpty(This:C1470.previousLine)\
		 && This:C1470.isNotComment(This:C1470.previousLine))
		
		This:C1470._ouput.push("")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function afterBranching()
	
	If (This:C1470.isNotEmpty(This:C1470.nextLine)\
		 && This:C1470.isNotMultiline(This:C1470.line))
		
		This:C1470._ouput.push("")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function beforeClosing($caseOf : Boolean)
	
	If (This:C1470.lineIndex=0)
		
		return   // Not for the first line
		
	End if 
	
	If ($caseOf)
		
		If (This:C1470.options.separationLineForCaseOf)\
			 && (This:C1470.isNotSeparatorLineComment(This:C1470.previousLine))
			
			If (This:C1470.isNotEmpty(This:C1470.previousLine))\
				 || (This:C1470.isComment(This:C1470.previousLine))
				
				This:C1470._ouput.push("")
				
			End if 
			
			If (This:C1470.caseOfLevel>=0)
				
				This:C1470._ouput.push(kCommentMark+(This:C1470.separators[This:C1470.caseOfLevel]*(20)))
				
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
		
		This:C1470._ouput.push("")
		
		return 
		
	End if 
	
	If (Not:C34(This:C1470.options.groupingClosureInstructions)\
		 && This:C1470.isNotEmpty(This:C1470.previousLine)\
		 && This:C1470.isNotSeparatorLineComment(This:C1470.previousLine))
		
		This:C1470._ouput.push("")
		
		return 
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function splitTests($line : Text) : Text
	
	return This:C1470.rgx.setTarget($line).setPattern("(?mi-s)(\\)\\s*(&{1,2}|\\|{1,2})\\s*\\()").substitute(")\\\r\\\r\\2(")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function splitObject($line : Text) : Text
	
	return This:C1470._splitLiterals($line; "{}")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function splitCollection($line : Text) : Text
	
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
	
	$c:=Split string:C1554($c[1]; kCommentMark; sk trim spaces:K86:2)
	
	If ($c.length=2)
		
		$comment:=$c[1]
		
	End if 
	
	$c[0]:=Delete string:C232($c[0]; 1; 1)
	$c[0]:=Delete string:C232($c[0]; Length:C16($c[0]); 1)
	$c:=Split string:C1554($c[0]; ";"; sk trim spaces:K86:2)
	
	If ($c.length<=2)
		
		return $line
		
	End if 
	
	var $t : Text:=$c.pop()
	var $out : Collection:=$c.map(Formula:C1597($1.value+";\\"))
	$out.push($t)
	
	return $var+":="+$dlmt[[1]]+"\\\r"+$out.join("\r")+$dlmt[[2]]+(Length:C16($comment)>0 ? " "+kCommentMark+$comment : "")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function splitKeyValueLine($line : Text) : Text
	
	var $cmd : Object
	
	For each ($cmd; This:C1470._splittableCommands)
		
		If (Position:C15($cmd.name; $line)=0)
			
			continue
			
		End if 
		
		$line:=This:C1470._splitIntoKeyAndValue($line; $cmd)
		
	End for each 
	
	return $line
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _splitIntoKeyAndValue($code : Text; $cmd : Object) : Text
	
	var $i; $start : Integer
	var $c : Collection
	
	Case of 
			
			// MARK:-New object -> Use literal notation
		: ($cmd.id=1471)
			
			If (Not:C34(This:C1470.rgx.setPattern($cmd.pattern).match(True:C214)))
				
				return $code
				
			End if 
			
			$c:=Split string:C1554(This:C1470.rgx.matches[2].data; ";"; sk trim spaces:K86:2)
			
			$code:=This:C1470.rgx.matches[1].data+"{"
			
			For ($i; 0; $c.length-1; 2)
				
				$code+=Replace string:C233($c[$i]; "\""; "")+":"+$c[$i+1]
				
				If (($i+1)<($c.length-1))
					
					$code+=";"
					
				End if 
			End for 
			
			$code+="}"
			
			If (This:C1470.rgx.matches.length>=$cmd.commentIndex)
				
				$code+=This:C1470.rgx.matches[$cmd.commentIndex-1].data
				
			End if 
			
			return $code
			
			
			// MARK:-SVG SET ATTRIBUTE
		: ($cmd.id=1055)
			
			If (Not:C34(This:C1470.rgx.setPattern($cmd.pattern).match(True:C214)))
				
				return $code
				
			End if 
			
			$c:=Split string:C1554(This:C1470.rgx.matches[1].data; ";"; sk trim spaces:K86:2)
			
			If ($c[0]="*")  // *;name;id
				
				If ($c.length<6)\
					 || ((($c.length-1)%2)#0)
					
					return $code
					
				End if 
				
				$code:=$cmd.name+"("+$c[0]+";"+$c[1]+";"+$c[2]+";\\\r"
				$start:=3
				
			Else   // Var;id
				
				If ($c.length<=5)\
					 || (($c.length%2)#0)
					
					return $code
					
				End if 
				
				$code:=$cmd.name+"("+$c[0]+";"+$c[1]+";\\\r"
				$start:=2
				
			End if 
			
			// MARK:-OB SET
		: ($cmd.id=1220)
			
			If (Not:C34(This:C1470.rgx.setPattern($cmd.pattern).match(True:C214)))
				
				return $code
				
			End if 
			
			$c:=Split string:C1554(This:C1470.rgx.matches[2].data; ";"; sk trim spaces:K86:2)
			
			If ($c.length<5)\
				 || (($c.length%2)#0)
				
				return $code
				
			End if 
			
			$code:=$cmd.name+"("+This:C1470.rgx.matches[1].data+";\\\r"
			$start:=0
			
			// MARK:-DOM Create XML element
		: ($cmd.id=865)
			
			If (Not:C34(This:C1470.rgx.setPattern($cmd.pattern).match(True:C214)))
				
				return $code
				
			End if 
			
			$c:=Split string:C1554(This:C1470.rgx.matches[2].data; ";"; sk trim spaces:K86:2)
			
			If ($c.length<5)\
				 || (($c.length%2)#0)
				
				return $code
				
			End if 
			
			$code:=This:C1470.rgx.matches[1].data+$cmd.name+"("+$c[0]+";"+$c[1]+";\\\r"
			$start:=2
			
			// MARK:-DOM SET XML ATTRIBUTE
		: ($cmd.id=866)
			
			If (Not:C34(This:C1470.rgx.setPattern($cmd.pattern).match(True:C214)))
				
				return $code
				
			End if 
			
			$c:=Split string:C1554(This:C1470.rgx.matches[1].data; ";"; sk trim spaces:K86:2)
			
			If ($c.length<4)\
				 || ((($c.length-1)%2)#0)
				
				return $code
				
			End if 
			
			$code:=$cmd.name+"("+$c[0]+";\\\r"
			$start:=1
			
			// MARK:-ST SET ATTRIBUTES 
		: ($cmd.id=1093)
			
			If (Not:C34(This:C1470.rgx.setPattern($cmd.pattern).match(True:C214)))
				
				return $code
				
			End if 
			
			$c:=Split string:C1554(This:C1470.rgx.matches[1].data; ";"; sk trim spaces:K86:2)
			
			If ($c[0]="*")  // *;name;id
				
				If ($c.length<6)\
					 || (($c.length%2)#0)
					
					return $code
					
				End if 
				
				$code:=$cmd.name+"(*;"+$c[1]+";"+$c[2]+";"+$c[3]+";\\\r"
				$start:=4
				
			Else   // Var;id
				
				If ($c.length<=5)\
					 || ((($c.length-1)%2)#0)
					
					return $code
					
				End if 
				
				$code:=$cmd.name+"("+$c[0]+";"+$c[1]+";"+$c[2]+";\\\r"
				$start:=3
				
			End if 
			
			// MARK:-
		Else 
			
			// Oops
			return $code
			
			// MARK:-
	End case 
	
	For ($i; $start; $c.length-1; 2)
		
		$code+=$c[$i]+";"+$c[$i+1]
		
		If (($i+1)<($c.length-1))
			
			$code+=";\\\r"
			
		End if 
	End for 
	
	$code+=")"
	
	If (This:C1470.rgx.matches.length>=$cmd.commentIndex)
		
		$code+=This:C1470.rgx.matches[$cmd.commentIndex-1].data
		
	End if 
	
	return $code