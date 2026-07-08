property locales:=[]
property parameters:=[]
property classes:=[]
property types:=[]
property assigned:=[]
property variables : Collection

property gramSyntax : Object:=New object:C1471(\
String:C10(Is object:K8:27); []; \
String:C10(Is object:K8:27)+"_1"; []; \
String:C10(Is boolean:K8:9); []; \
String:C10(Is boolean:K8:9)+"_1"; []; \
String:C10(Is longint:K8:6); []; \
String:C10(Is longint:K8:6)+"_1"; []; \
String:C10(Is text:K8:3); []; \
String:C10(Is text:K8:3)+"_1"; []; \
String:C10(Is real:K8:4); []; \
String:C10(Is real:K8:4)+"_1"; []; \
String:C10(Is collection:K8:32); []; \
String:C10(Is collection:K8:32)+"_1"; []; \
String:C10(Is pointer:K8:14); []; \
String:C10(Is pointer:K8:14)+"_1"; []; \
String:C10(Is date:K8:7); []; \
String:C10(Is date:K8:7)+"_1"; []; \
String:C10(Is time:K8:8); []; \
String:C10(Is time:K8:8)+"_1"; []; \
String:C10(Is BLOB:K8:12)+"_1"; [])

property settings : Object

property localeNumber:=0
property parameterNumber:=0

property _patterns : Object
property _notforArray:=["collection"; "variant"]

property windowRef : Integer

// MARK: Regex patterns (raw, loaded from /RESOURCES/regex/declaration.txt)
property _dx : Object:=cs:C1710.patterns.me.group("declaration")

Class extends macro

Class constructor
	
	Super:C1705()
	
	// MARK: Settings
	Try
		
		var $file : 4D:C1709.File:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
		$file:=$file.original || $file
		
		If (Not:C34($file.exists))
			
			// Create the settings file from the default resource
			File:C1566("/RESOURCES/default.settings").copyTo($file.parent; "4DPop Macros.settings")
			
		End if 
		
		If ($file.exists)
			
			This:C1470.settings:=JSON Parse:C1218($file.getText()).declaration
			
		End if 
		
	Catch
		
		This:C1470.settings:={}
		
	End try
	
	This:C1470._notforArray:=["collection"; "variant"]
	
	var $pattern : Text:=This:C1470._dx.varType
	
	This:C1470._patterns:={\
		varInteger: Replace string:C233($pattern; "{type}"; "Integer"); \
		varText: Replace string:C233($pattern; "{type}"; "Text"); \
		varReal: Replace string:C233($pattern; "{type}"; "Real"); \
		varPicture: Replace string:C233($pattern; "{type}"; "Picture"); \
		varPointer: Replace string:C233($pattern; "{type}"; "Pointer"); \
		varBoolean: Replace string:C233($pattern; "{type}"; "Boolean"); \
		varTime: Replace string:C233($pattern; "{type}"; "Time"); \
		varDate: Replace string:C233($pattern; "{type}"; "Date"); \
		varBlob: Replace string:C233($pattern; "{type}"; "Blob"); \
		varObject: Replace string:C233($pattern; "{type}"; "Object"); \
		varClass: Replace string:C233($pattern; "{type}"; This:C1470._dx.classType); \
		varCollection: Replace string:C233($pattern; "{type}"; "Collection"); \
		varVariant: Replace string:C233($pattern; "{type}"; "Variant"); \
		varWithAssignment: This:C1470._dx.varWithAssignment\
		}
	
	This:C1470._loadIcons()
	This:C1470._loadGramSyntax()
	
	// A class without selection is processed function by function, otherwise the
	// current scope (whole method or selection) is processed as a single unit.
	If (This:C1470.class && Not:C34(This:C1470.withSelection))
		
		This:C1470._processClass()
		
	Else 
		
		This:C1470._processScope()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Parses, prompts and pastes a single scope (whole method or selection)
Function _processScope()
	
	This:C1470.parse()
	
	If (This:C1470.variables.length=0)
		
		ALERT:C41(Localized string:C991("noVariableToDeclare"))
		return 
		
	End if 
	
	If (This:C1470._needsDialog())
		
		// A declaration is missing or a variable is unused → let the user decide
		If (This:C1470._dialog())
			
			This:C1470.paste(This:C1470.method)
			
		End if 
		
	Else 
		
		// Everything is already declared and used → apply the rules silently
		This:C1470._apply()
		This:C1470.paste(This:C1470.method)
		ALERT:C41(This:C1470._verifiedMessage())
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Processes a whole class, one Function/Class constructor at a time
Function _processClass()
	
	var $source : Text:=This:C1470.method
	var $lines : Collection:=Split string:C1554($source; "\r")
	
	// Split the class into a preamble (properties, Class extends…) and function blocks
	var $preamble : Collection:=[]
	var $blocks : Collection:=[]
	var $block : Collection:=Null:C1517
	
	var $line : Text
	For each ($line; $lines)
		
		If (This:C1470.isFunction($line) || This:C1470.isConstructor($line))
			
			$block:=[$line]
			$blocks.push($block)
			
		Else 
			
			If ($block=Null:C1517)
				
				$preamble.push($line)
				
			Else 
				
				$block.push($line)
				
			End if 
		End if 
	End for each 
	
	var $result : Collection:=[]
	
	If ($preamble.length>0)
		
		$result.push($preamble.join("\r"))
		
	End if 
	
	var $processed : Integer:=0
	var $prompted : Boolean:=False:C215
	
	For each ($block; $blocks)
		
		var $code : Text:=$block.join("\r")
		
		This:C1470._reset()
		This:C1470.method:=$code
		This:C1470.parse()
		
		Case of 
				
				//______________________________________________________
			: (This:C1470.variables.length=0)
				
				// No variable in this function → keep it untouched
				$result.push($code)
				
				//______________________________________________________
			: (This:C1470._needsDialog())
				
				// A declaration is missing or a variable is unused → ask the user
				$processed+=1
				$prompted:=True:C214
				$result.push(This:C1470._dialog(This:C1470._scopeName()) ? This:C1470.method : $code)
				
				//______________________________________________________
			Else 
				
				// Everything already declared and used → apply the rules silently
				$processed+=1
				This:C1470._apply()
				$result.push(This:C1470.method)
				
				//______________________________________________________
		End case 
	End for each 
	
	If ($processed=0)
		
		// No function needed anything → nothing to paste
		ALERT:C41(This:C1470._verifiedMessage())
		return 
		
	End if 
	
	var $out : Text:=$result.join("\r")
	
	// Keep a single caret (the one from the first rewritten function)
	var $pos : Integer:=Position:C15(kCaret; $out)
	
	If ($pos>0)
		
		$out:=Replace string:C233($out; kCaret; "")
		$out:=Substring:C12($out; 1; $pos-1)+kCaret+Substring:C12($out; $pos)
		
	End if 
	
	This:C1470.paste($out)
	
	If (Not:C34($prompted))
		
		// Every function was already clean → confirm the check
		ALERT:C41(This:C1470._verifiedMessage())
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Resets the per-scope accumulators before parsing a new function block
Function _reset()
	
	This:C1470.locales:=[]
	This:C1470.parameters:=[]
	This:C1470.classes:=[]
	This:C1470.assigned:=[]
	This:C1470.variables:=[]
	This:C1470._output:=[]
	This:C1470.isCommentBlock:=False:C215
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Opens the declaration dialog and returns whether the user validated it.
	// $title (optional) is shown in the window title so the user knows which
	// function's variables are currently being defined.
Function _dialog($title : Text) : Boolean
	
	This:C1470.windowRef:=Open form window:C675("DECLARATION"; Movable form dialog box:K39:8; Horizontally centered:K39:1; At the top:K39:5; *)
	
	If (Count parameters:C259>=1) && (Length:C16($title)>0)
		
		SET WINDOW TITLE:C213($title; This:C1470.windowRef)
		
	End if 
	
	DIALOG:C40("DECLARATION"; This:C1470)
	CLOSE WINDOW:C154(This:C1470.windowRef)
	
	return Bool:C1537(OK)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Human-readable name of the currently parsed function/constructor
Function _scopeName() : Text
	
	var $fn : Object:=This:C1470._output.query("type = :1 OR type = :2"; "Function"; "Class constructor").first()
	
	If ($fn=Null:C1517)
		
		return ""
		
	End if 
	
	If ($fn.type="Class constructor")
		
		return "Class constructor"
		
	End if 
	
	return "Function "+String:C10($fn.function)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// True when the scope needs user input: a declaration is missing (a used local
	// that was never declared) or a variable is unused (declared but never referenced).
Function _needsDialog() : Boolean
	
	// Missing declaration: a used local variable that was not declared in the source
	If (This:C1470.variables.query("parameter=null & count>0 & inDeclaration=null & assigned=null & array=null").length>0)
		
		return True:C214
		
	End if 
	
	// Unused variable (the function return is not expected to be referenced)
	If (This:C1470.variables.query("count=0 & (order#0 | order=null)").length>0)
		
		return True:C214
		
	End if 
	
	return False:C215
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Informative message shown when a scope/class needed no user input
Function _verifiedMessage() : Text
	
	return Localized string:C991("allDeclarationsVerified")+"\r"\
		+Localized string:C991("allVariablesDeclared")+"\r"\
		+Localized string:C991("noUnusedVariable")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function split() : cs:C1710.declaration
	
	Super:C1706.split(This:C1470.withSelection)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Parses the code to extract parameters and local variables
Function parse() : cs:C1710.declaration
	
	var $options : Object:=This:C1470.settings.options
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	This:C1470._removeDirective()
	This:C1470.split()
	
	var $text : Text
	For each ($text; This:C1470.lines)
		
		var $line:={code: $text}
		var $comment:=""
		
		This:C1470.rgx.setTarget($text)
		
		Case of 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isEmpty($text))
				
				$line.type:=This:C1470.isCommentBlock ? "comment" : "empty"
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isCommentBlock)
				
				$line.type:="comment"
				
				If (Position:C15("*/"; $text)>0)  // End of multiline comment
					
					This:C1470.isCommentBlock:=False:C215
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isDECLARE($line.code))
				
				$line.type:="#DECLARE"
				$line.skip:=True:C214
				This:C1470._parseParameters($line)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isConstructor($line.code))
				
				$line.type:="Class constructor"
				$line.skip:=True:C214
				This:C1470._parseParameters($line)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isFunction($line.code))
				
				$line.type:="Function"
				$line.skip:=True:C214
				This:C1470._parseParameters($line)
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (This:C1470.isComment($line.code))
				
				$line.type:="comment"
				
				If (Position:C15("/*"; $line.code)=1)
					
					This:C1470.isCommentBlock:=(Position:C15("*/"; $line.code)=0)  // Start of multiline comment
					
				End if 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			Else 
				
				// Remove textual values & comments
				$text:=This:C1470.rgx.setTarget($text).setPattern("(?m-si)(\"[^\"]*\")").substitute()
				$text:=This:C1470.rgx.setTarget($text).setPattern("(?m-si)(/(?:/|\\\\*).*?)$").substitute()
				
				// Mark:Searches parameters $0-N & ${N} into the line
/*------------------------------------------------------
declaration macro must omit the parameters of a formula
--> https://Github.com/vdelachaux/4DPop-Macros/issues/6
--------------------------------------------------------*/
				var $t:=$text
				var $l : Integer:=Position:C15(Parse formula:C1576("Formula:C1597")+"("; $text; 1; *)
				
				If ($l>0)
					
					var $c:=Split string:C1554(Substring:C12($text; $l); "(")
					$c[$c.length-1]:=Replace string:C233($c[$c.length-1]; ")"; ""; $c.length-2)
					$text:=Replace string:C233($text; $c.join("("); "")
					
				End if 
				
				var $rgx : cs:C1710.rgx.regex:=This:C1470.rgx.setTarget($text).setPattern("(?mi-s)(\\$\\{?\\d+\\}?)+(?!\\w)")
				
				$text:=$t
/*--------------------------------------------------------*/
				
				If ($rgx.match(True:C214))
					
					// mark:-PARAMETER(S)
					For each ($t; $rgx.matches.extract("data").distinct())
						
						var $parameter : Object:=This:C1470.parameters.query("value=:1"; $t).first()
						
						If ($parameter=Null:C1517)
							
							$parameter:={\
								parameter: True:C214; \
								value: $t; \
								code: $line.code; \
								count: 0; \
								label: ($t="$0" ? "← " : "→ ")+$t; \
								order: Num:C11($t)}
							
							This:C1470.parameters.push($parameter)
							
						Else 
							
							$parameter.count:=$parameter.count+1
							
						End if 
						
						If ($parameter.type=Null:C1517)
							
							If (Match regex:C1019("(?mi-s)var\\s|C_"; $text; 1))  // Declaration line
								
								If (Match regex:C1019("(?mi-s)\\s*:\\s*(?:Object)"+\
									"|((?:cs\\.\\w+)"+\
									"|(?:4D\\.\\w+))"; $text; 1; $pos; $len))
									
									If ($pos{1}#-1)
										
										$parameter.class:=Substring:C12($text; $pos{1}; $len{1})
										
									End if 
									
									$parameter.type:=Is object:K8:27
									
								Else 
									
									$line.type:="declaration"
									$line.skip:=True:C214
									$parameter.type:=This:C1470._getTypeFromDeclaration($text)
									
								End if 
								
								If (Match regex:C1019("(?mi-s)"+kCommentMark+"(.*)$"; $line.code; 1; $pos; $len))
									
									$parameter.comment:=Substring:C12($line.code; $pos{1}; $len{1})
									
								End if 
								
							Else 
								
								// Let's take a guess
								$parameter.type:=This:C1470._clairvoyant($t; $line.code)
								
							End if 
						End if 
					End for each 
					
					This:C1470.parameters:=This:C1470.parameters.distinct(ck diacritical:K85:3)
					
				End if 
				
				Case of 
						
						// mark:-DECLARATION LINE
					: (Match regex:C1019("(?mi-s)^var\\s|^C_"; $text; 1))
						
						$line.type:="declaration"
						$line.skip:=True:C214
						
						$rgx:=This:C1470.rgx.setTarget($text).setPattern("(?m-si)(?<!\\.)(\\$\\w+)")
						
						If ($rgx.match(True:C214))
							
							For each ($t; $rgx.matches.extract("data").distinct())
								
								If (Match regex:C1019("(?mi-s)(\\$\\{?\\d+\\}?)+(?!\\w)"; $t; 1))  // Parameter
									
									$parameter:=This:C1470.parameters.query("value=:1"; $t).first()
									
									If ($parameter=Null:C1517)
										
										$parameter:={\
											parameter: True:C214; \
											value: $t; \
											code: $line.code; \
											count: 0; \
											labe: ($t="0" ? "← " : "→ ")+$t}
										
										This:C1470.parameters.push($parameter)
										
									Else 
										
										$parameter.count:=$parameter.count+1
										
									End if 
									
								Else 
									
									var $var : Object
									
									// A named parameter referenced inside a declaration line must be
									// credited to the existing parameter, not turned into a phantom
									// local — otherwise the real parameter keeps count 0 and is
									// reported as unused.
									$var:=This:C1470.parameters.query("value=:1"; $t).first()
									
									If ($var#Null:C1517)
										
										$var.count:=$var.count+1
										continue
										
									End if 
									
									$var:=This:C1470.locales.query("value=:1"; $t).first()
									
									If ($var=Null:C1517)
										
										$var:={\
											value: $t; \
											code: $line.code; \
											count: 0; \
											label: $t; \
											inDeclaration: True:C214\
											}
										
										If (Match regex:C1019(This:C1470._patterns.varWithAssignment; $var.code; 1))
											
											$var.assigned:=True:C214
											$var.count+=1
											This:C1470.assigned.push($var)
											
											$line.skip:=False:C215
											
										Else 
											
											This:C1470.locales.push($var)
											
										End if 
										
									Else 
										
										// Only increment: a token seen here may just be used in the
										// initializer (RHS) of another var, so it must NOT be flagged
										// as declared.
										$var.count+=1
										
									End if 
									
									If ($var.type#Null:C1517)
										
										continue
										
									End if 
									
									If (Match regex:C1019("(?mi-s)\\s*:\\s*(?:Object)"+\
										"|((?:cs\\.\\w+)"+\
										"|(?:4D\\.\\w+))"; $text; 1; $pos; $len))
										
										If ($pos{1}#-1)
											
											$var.class:=Substring:C12($text; $pos{1}; $len{1})
											
										End if 
										
										$var.type:=Is object:K8:27
										
									Else 
										
										$var.type:=$var.assigned ? This:C1470._getTypeFromDeclaration($var.code) : This:C1470._getTypeFromDeclaration($text)
										
									End if 
								End if 
							End for each 
						End if 
						
						// mark:-ARRAY DECLARATION
					: (Match regex:C1019("(?mi-s)^(?:^ARRAY|^TABLEAU)\\s*[^(]*\\(([^;]*);\\s*[\\dx]+(?:;\\s*([\\dx]+))?\\)"; $text; 1; $pos; $len))
						
						var $static : Boolean:=Match regex:C1019("(?mi-s)^(?:^ARRAY|^TABLEAU)\\s*[a-zA-Z]+\\([^;]*?;\\s*(?:0x|\\$)"; $text; 1)
						
						If (Not:C34($static))
							
							$line.type:="declaration"
							$line.skip:=True:C214
							
						End if 
						
						$t:=Substring:C12($line.code; $pos{1}; $len{1})
						$var:=This:C1470.locales.query("value=:1"; $t).first()
						
						If ($var=Null:C1517)
							
							$var:={\
								value: $t; \
								code: $line.code; \
								count: 0; \
								label: $t}
							
							This:C1470.locales.push($var)
							
						Else 
							
							$var.count:=$var.count+1
							
						End if 
						
						$var.array:=True:C214
						$var.dimension:=1+Num:C11(($pos{2}#-1))
						$var.static:=$static
						$var.type:=This:C1470._getTypeFromDeclaration($text)
						
						// mark:-EXTRACT LOCAL VARIABLES
					Else 
						
						$rgx:=This:C1470.rgx.setTarget($text).setPattern("(?m-si)(?<!\\.)(\\$\\w+)")
						
						If ($rgx.match(True:C214))
							
							For each ($t; $rgx.matches.extract("data").distinct())
								
								If (This:C1470.assigned.query("label = :1"; $t).first()#Null:C1517)
									
									continue
									
								End if 
								
								If (Not:C34(Match regex:C1019("(?mi-s)(\\$\\{?\\d+\\}?)+(?!\\w)"; $t; 1)))
									
									$var:=This:C1470.parameters.query("value=:1"; $t).first()
									
									If ($var=Null:C1517)
										
										$var:=This:C1470.locales.query("value=:1"; $t).first()
										
										If ($var=Null:C1517)
											
											$var:={\
												value: $t; \
												code: $line.code; \
												count: 1; \
												label: $t\
												}
											
											This:C1470.locales.push($var)
											
										Else 
											
											$var.count+=1
											
										End if 
										
										If ($var.type=Null:C1517)
											
											// Let's take a guess
											$var.type:=This:C1470._clairvoyant($t; $line.code)
											
											If ($var.type=0)
												
												$l:=This:C1470._getTypeFromRules($t)
												
												If ($l#0)  // Got a type from syntax parameters
													
													If ($l>100)
														
														$var.array:=True:C214
														$l:=$l-100
														
													End if 
													
													$var.type:=Choose:C955($l; \
														-1; \
														Is text:K8:3; \
														Is BLOB:K8:12; \
														Is boolean:K8:9; \
														Is date:K8:7; \
														Is longint:K8:6; \
														Is longint:K8:6; \
														-1; \
														Is time:K8:8; \
														Is picture:K8:10; \
														Is pointer:K8:14; \
														Is real:K8:4; \
														Is text:K8:3; \
														Is object:K8:27; \
														Is collection:K8:32; \
														Is variant:K8:33)
													
												Else 
													
													$var.type:=This:C1470._getTypeFromDeclaration($line.code)
													
													If ($var.type#0)
														
														If (Match regex:C1019("(?m-si)^(?:ARRAY|TABLEAU)\\s[^(]*\\([^;]*;[^;]*(?:;([^;]*))?\\)"; $line.code; 1))
															
															$var.array:=True:C214
															
														End if 
													End if 
												End if 
											End if 
										End if 
										
									Else 
										
										// Its a parameter
										$var.count:=$var.count+1
										
									End if 
								End if 
								
								If ($var#Null:C1517)
									
									If ($var.type=Is object:K8:27)
										
										var $class : Object:=This:C1470.classes.query("value = :1"; $var.value).first()
										
										Case of 
												
												//╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌
											: ($class#Null:C1517)
												
												$var.class:=$class.class
												
												//╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌
											: (Match regex:C1019("(?mi-s)\\"+$var.value+":="+Parse formula:C1576("File:C1566")+"\\([^)]*\\)(?!\\.)"; $line.code; 1; *))
												
												$var.class:="4D.File"
												
												//╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌
											: (Match regex:C1019("(?mi-s)\\"+$var.value+":="+Parse formula:C1576("Folder:C1567")+"\\([^)]*\\)(?!\\.)"; $line.code; 1; *))
												
												$var.class:="4D.Folder"
												
												//╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌
											: (Match regex:C1019("(?mi-s)\\"+$var.value+":="+Parse formula:C1576("Formula:C1597")+"\\([^)]*\\)(?!\\.)"; $line.code; 1; *))\
												 || (Match regex:C1019("(?mi-s)\\"+$var.value+":="+Parse formula:C1576("Formula from string:C1601")+"\\([^)]*\\)(?!\\.)"; $line.code; 1; *))
												
												$var.class:="4D.Function"
												
												//╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌
											: (Match regex:C1019("(?mi-s)\\.\\w*(?:\\([^\\)]*\\))$"; $line.code; 1; *))
												
												Case of 
														
														//____________________________________
													: (Bool:C1537($var.inDeclaration))
														
														// THE DECLARATION MUST WIN
														
														//____________________________________
													: ($var.class#Null:C1517)
														
														$var.type:=38
														
														//____________________________________
													: (False:C215)
														
														// TODO: Get from member fonction or attribute
														
														//____________________________________
													Else 
														
														$var.type:=0
														
														//____________________________________
												End case 
												
												//╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌
										End case 
									End if 
									
								Else 
									
									// Ie. : This.url:=$1
									
								End if 
							End for each 
						End if 
						
						//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
				End case 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		End case 
		
		This:C1470._output.push($line)
		
	End for each 
	
	This:C1470.localeNumber:=This:C1470.locales.length
	This:C1470.parameterNumber:=This:C1470.parameters.length
	
	This:C1470.locales:=This:C1470.locales.orderBy("value asc")
	This:C1470.parameters:=This:C1470.parameters.orderBy("value asc")
	
	// Place the variadic last
	var $o : Object:=This:C1470.parameters.query("value = :1"; "...").first()
	If ($o#Null:C1517)
		
		This:C1470.parameters.push($o)
		This:C1470.parameters.remove(This:C1470.parameters.indexOf($o))
		
	End if 
	
	// Finally do a flat list
	This:C1470.variables:=This:C1470.parameters.combine(This:C1470.locales)
	
	return This:C1470
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _parseParameters($line : Object)
	
	var $pattern; $t : Text
	var $index : Integer
	var $parameter : Object
	var $c : Collection
	
	var $rgx : cs:C1710.rgx.regex:=This:C1470.rgx.setTarget($line.code)
	
	Case of 
			
			//______________________________________________________
		: ($line.type="Class constructor")
			
			$rgx.setPattern("(?mi-s)^(?!"+kCommentMark+")(.*)"+$line.type+"\\s*()(?:\\(([^)]*)\\))?\\s*()?\\s*("+kCommentMark+"[^$]*)?$")
			
			//______________________________________________________
		: ($line.type="Function")
			
			$rgx.setPattern("(?m-si)^(?!"+kCommentMark+")(.*)"+$line.type+"\\s([^(]*)(?:\\s*\\(([^)]*)\\))?(?:\\s*(?:->\\s*)?([^/]*))?\\s*("+kCommentMark+"[^$]*)?$")
			
			//______________________________________________________
		: ($line.type="#DECLARE")
			
			$rgx.setPattern("(?m-si)^(?!"+kCommentMark+")()"+$line.type+"()(?:\\s*\\(([^)]*)\\))?(?:\\s*(?:->\\s*)?([^/]*))?\\s*("+kCommentMark+"[^$]*)?$")
			
			//______________________________________________________
	End case 
	
	If ($rgx.match(True:C214))
		
		//$1: keywords (ie. exposed)
		If ($rgx.matches[1].length>0)
			
			$line.prefix:=$rgx.matches[1].data
			
		End if 
		
		//$2: function name (ie. {get/set} myFunction)
		If ($rgx.matches[2].length>0)
			
			$line.function:=$rgx.matches[2].data
			
		End if 
		
		//$3: parameters
		If ($rgx.matches[3].length>0)
			
			For each ($t; Split string:C1554($rgx.matches[3].data; ";"))
				
				$index:=$index+1
				$c:=Split string:C1554($t; ":"; sk trim spaces:K86:2)
				
				$parameter:={\
					parameter: True:C214; \
					value: Split string:C1554($c[0]; " "; sk ignore empty strings:K86:1).join(""); \
					code: $line.code; \
					type: $c.length=1 ? Is variant:K8:33 : This:C1470._getTypeFromDeclaration($t); \
					count: 0; \
					order: $index}
				
				$parameter.inDeclaration:=($parameter.type#0)
				$parameter.label:="← "+$parameter.value
				
				If ($c.length=2)
					
					If (Match regex:C1019("(?m-si)^\\s*((?:4D|cs)\\.[^$/]*)(/[^$]*)?$"; $c[1]; 1))
						
						$parameter.class:=$c[1]
						
					End if 
				End if 
				
				This:C1470.parameters.push($parameter)
				
			End for each 
		End if 
		
		//$4: return
		If ($rgx.matches[4].length>0)
			
			$c:=Split string:C1554($rgx.matches[4].data; ":"; sk trim spaces:K86:2)
			
			$parameter:={\
				parameter: True:C214; \
				return: True:C214; \
				value: Split string:C1554($c[0]; " "; sk ignore empty strings:K86:1).join(""); \
				code: $line.code; \
				type: $c.length=1 ? Is variant:K8:33 : This:C1470._getTypeFromDeclaration($rgx.matches[4].data); \
				count: 0; \
				order: 0}
			
			$parameter.inDeclaration:=($parameter.type#0)
			
			If ($c.length=2)
				
				If (Match regex:C1019("(?m-si)^\\s*((?:4D|cs)\\.[^$/]*)(/[^$]*)?$"; $c[1]; 1))
					
					$parameter.class:=$c[1]
					
				End if 
			End if 
			
			$parameter.label:="→ "+(Length:C16($parameter.value)>0 ? $parameter.value : "return()")
			
			This:C1470.parameters.push($parameter)
			
		End if 
		
		//$5: comments
		If (Length:C16($rgx.matches[5].data)>0)
			
			$line.comment:=$rgx.matches[5].data
			
		End if 
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _getTypeFromDeclaration($text : Text) : Integer
	
	var $o : Object
	$o:=This:C1470._patterns
	
	Case of 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varInteger; $text; 1))\
			 || (Position:C15(Parse formula:C1576("ARRAY LONGINT:C221"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_INTEGER:C282"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_LONGINT:C283"); $text)=1)
			
			return Is longint:K8:6
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varText; $text; 1))\
			 || (Position:C15(Parse formula:C1576("ARRAY TEXT:C222"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_STRING:C293"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_TEXT:C284"); $text)=1)
			
			return Is text:K8:3
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varReal; $text; 1))\
			 || (Position:C15(Parse formula:C1576("ARRAY REAL:C219"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_REAL:C285"); $text)=1)
			
			return Is real:K8:4
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varPicture; $text; 1))\
			 || (Position:C15(Parse formula:C1576("ARRAY PICTURE:C279"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_PICTURE:C286"); $text)=1)
			
			return Is picture:K8:10
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varPointer; $text; 1))\
			 || (Position:C15(Parse formula:C1576("ARRAY POINTER:C280"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_POINTER:C301"); $text)=1)\
			
			return Is pointer:K8:14
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varBoolean; $text; 1))\
			 || (Position:C15(Parse formula:C1576("ARRAY BOOLEAN:C223"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_BOOLEAN:C305"); $text)=1)
			
			return Is boolean:K8:9
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varTime; $text; 1))\
			 || (Position:C15(Parse formula:C1576("ARRAY TIME:C1223"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_TIME:C306"); $text)=1)
			
			return Is time:K8:8
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varDate; $text; 1))\
			 || (Position:C15(Parse formula:C1576("ARRAY DATE:C224"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_DATE:C307"); $text)=1)
			
			return Is date:K8:7
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varBlob; $text; 1))\
			 || (Position:C15(Parse formula:C1576("C_BLOB:C604"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("ARRAY BLOB:C1222"); $text)=1)
			
			return Is BLOB:K8:12
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varObject; $text; 1))\
			 || Match regex:C1019($o.varClass; $text; 1; *)\
			 || (Position:C15(Parse formula:C1576("ARRAY OBJECT:C1221"); $text)=1)\
			 || (Position:C15(Parse formula:C1576("C_OBJECT:C1216"); $text)=1)
			
			return Is object:K8:27
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varCollection; $text; 1))\
			 || (Position:C15(Parse formula:C1576("C_COLLECTION:C1488"); $text)=1)
			
			return Is collection:K8:32
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019($o.varVariant; $text; 1))\
			 || (Position:C15(Parse formula:C1576("C_VARIANT:C1683"); $text)=1)\
			 || (Position:C15("var"; $text)=1)
			
			return Is variant:K8:33
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _getTypeFromRules($varName : Text)->$type : Integer
	
	var $pattern : Text
	var $o : Object
	
	For each ($o; This:C1470.settings.rules) While ($type=0)
		
		For each ($pattern; Split string:C1554($o.value; ";")) While ($type=0)
			
			If (Match regex:C1019($pattern; Delete string:C232($varName; 1; 1); 1))
				
				$type:=$o.type
				
			End if 
		End for each 
	End for each 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _setType($type : Integer; $target : Object)
	
	var $o : Object
	
	If (Count parameters:C259>=2)
		
		$o:=$target
		
	Else 
		
		// A "If" statement should never omit "Else"
		$o:=Form:C1466.current
		
	End if 
	
	$o.type:=$type
	$o.icon:=This:C1470.types[$o.type].icon
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _apply()
	
	var $method : Text
	var $options : Object:=This:C1470.settings.options
	
	// MARK:-PARAMETERS
	var $c:=This:C1470.variables.query("parameter=true")
	var $o : Object:=This:C1470._output.query("type = :1 OR type = :2"; "Function"; "Class constructor").first()
	
	If ($c.length>0)\
		 | ($o#Null:C1517)
		
		$c:=$c.orderBy("order")
		
		If (This:C1470.class)
			
			If ($o#Null:C1517)
				
				$method:=String:C10($o.prefix)+$o.type+" "+String:C10($o.function)+" ("
				
				For each ($o; $c.query("order > 0"))
					
					$method+=(Num:C11($o.order)>1 ? ";" : "")+$o.value
					$method+=(This:C1470.types[$o.type].value#Is variant:K8:33) ? ":"+(($o.class#Null:C1517) ? String:C10($o.class) : This:C1470.types[$o.type].name) : ""
					
				End for each 
				
				$method+=")"
				
				// * RETURN OF THE METHOD
				$o:=$c.query("order = 0").first()
				
				If ($o#Null:C1517)
					
					If (This:C1470.types[$o.type].value=Is variant:K8:33)
						
						If ($o.code="C_@")\
							 | ($o.code="var @")
							
							$method+="\rvar "+$o.value
							
						Else 
							
							$method+=(Length:C16($o.value)>0 ? "->"+$o.value : "")
							
						End if 
						
					Else 
						
						If ($o.code="C_@")\
							 | ($o.code="var @")
							
							$method+="\rvar "+$o.value+":"+This:C1470.types[$o.type].name
							
						Else 
							
							$method+=(Length:C16($o.value)>0 ? "->"+$o.value : "")+":"\
								+($o.class#Null:C1517 ? String:C10($o.class) : This:C1470.types[$o.type].name)
							
						End if 
					End if 
				End if 
				
				$method+=String:C10(This:C1470._output.query("type = :1 OR type = :2"; "Function"; "Class constructor").first().comment)
				$method+="\r"
				
			End if 
			
		Else 
			
			If (This:C1470._output.query("type = :1"; "#DECLARE").first()=Null:C1517)
				
				// #DECLARE does not accept $1 ... $N as a parameter name, so we use the var keyword for parameters.
				For each ($o; $c)
					
					If ($o.class#Null:C1517)
						
						$method+="var "+$o.value+":"+$o.class+"\r"
						
					Else 
						
						$method+="var "+$o.value+":"+This:C1470.types[$o.type].name+"\r"
						
					End if 
				End for each 
				
				$method:=Delete string:C232($method; Length:C16($method); 1)
				
			Else 
				
				$method:="#DECLARE("
				
				For each ($o; $c.query("order > 0"))
					
					$method+=(";"*Num:C11($o.order>1))+$o.value
					
					If ($o.class#Null:C1517)
						
						$method+=":"+$o.class
						
					Else 
						
						If ($o.type#Is variant:K8:33)
							
							$method+=":"+This:C1470.types[$o.type].name
							
						End if 
						
					End if 
				End for each 
				
				$method+=")"
				
				// * RETURN OF THE METHOD
				$o:=$c.query("order = 0").first()
				
				If ($o#Null:C1517)
					
					If ($o.code="C_@")
						
						$method+="\rvar "+$o.value+":"+This:C1470.types[$o.type].name+"\r"
						
					Else 
						
						$method+=(Length:C16($o.value)>0) ? "->"+$o.value+":" : ":"
						
						If ($o.class#Null:C1517)
							
							$method+=$o.class
							
						Else 
							
							$method+=This:C1470.types[$o.type].name
							
						End if 
					End if 
				End if 
				
				$method+=String:C10(This:C1470._output.query("type = :1"; "#DECLARE").first().comment)
				
			End if 
		End if 
	End if 
	
	$method:=This:C1470._addNewLine($method)
	
	// MARK:-LOCAL VARIABLES — declared close to their first use, not hoisted
	// $inline maps an _output line index (as text) to the declarations that must
	// be inserted right before that line ; $orphans holds declarations whose use
	// could not be located (kept at the top of the block, as a safety net).
	var $t : Text
	var $inline : Object:={}
	var $orphans : Collection:=[]
	
	$c:=This:C1470.variables.query("(parameter=null & count>0 & assigned=null & array=null) or (array=true & count>0 & static=false)")
	
	var $local : Object
	For each ($local; $c)
		
		var $declaration : Text:=This:C1470._buildDeclaration($local)
		
		If (Length:C16($declaration)=0)
			
			continue
			
		End if 
		
		var $at : Integer:=This:C1470._firstUseIndex($local)
		
		If ($at<0)
			
			$orphans.push($declaration)
			
		Else 
			
			var $key : Text:=String:C10($at)
			
			If ($inline[$key]=Null:C1517)
				
				$inline[$key]:=[]
				
			End if 
			
			$inline[$key].push($declaration)
			
		End if 
	End for each 
	
	// Declarations without a located use stay at the top of the block
	If ($orphans.length>0)
		
		$method+=$orphans.join("\r")+"\r"
		
	End if 
	
	$method:=This:C1470._addNewLine($method)
	
	If (Length:C16($method)>0)
		
		While ($method="@\r")
			
			$method:=Delete string:C232($method; Length:C16($method); 1)
			
		End while 
	End if 
	
	$method+="\r"
	
	If (This:C1470.class)
		
		$method+=kCaret
		
	Else 
		
		If (Match regex:C1019("(?m-si)[^\r]"; $method; 1))
			
			// Parameter declarations to hoist: place them after the leading comments
			// and set the caret there.
			var $buffer : Text
			For each ($o; This:C1470._output)
				
				$t:=String:C10($o.type)
				var $length:=Length:C16($method)
				
				Case of 
						
						// ___________________
					: ($t="comment")
						
						$buffer+=$o.code+"\r"
						var $l:=Length:C16($buffer)
						$o.skip:=True:C214
						
						// ___________________
					: ($t="empty")
						
						$method:=$buffer+Substring:C12($method; 1; $length-1)+"\r"+kCaret
						
						break
						
						// ___________________
					Else 
						
						If ($l<=0)
							
							// Insert before
							$method+=kCaret
							
						Else 
							
							$method:=$buffer+Substring:C12($method; 1; $length-1)+"\r"+kCaret
							
						End if 
						
						break
						
						// ___________________
				End case 
			End for each 
			
			$method:=This:C1470._addNewLine($method)
			
		Else 
			
			// Nothing to hoist (all locals are placed near their use): don't add
			// blank lines nor a caret at the top of the method.
			$method:=""
			
		End if 
		
	End if 
	
	// Restore the code, injecting each variable's declaration before its first use.
	// $removedDeclSeen/$codeSeen delimit the leading declaration zone: blank lines
	// that fall inside it (between the first hoisted-out declaration and the first
	// real code line) are dropped so no hole is left behind. Blanks before that
	// zone or after real code are preserved.
	var $index : Integer
	var $removedDeclSeen : Boolean:=False:C215
	var $codeSeen : Boolean:=False:C215
	For ($index; 0; This:C1470._output.length-1; 1)
		
		$o:=This:C1470._output[$index]
		$t:=String:C10($o.type)
		
		var $decls : Collection:=$inline[String:C10($index)]
		
		If ($decls#Null:C1517)
			
			$method+=$decls.join("\r")+"\r"
			
		End if 
		
		Case of 
				
				//___________________
			: (Bool:C1537($o.skip))
				
				// A removed declaration opens the leading declaration zone
				If ($t="declaration")
					
					$removedDeclSeen:=True:C214
					
				End if 
				
				//___________________
			: ($t="empty")
				
				Case of 
						
						//········································
					: ($removedDeclSeen && (Not:C34($codeSeen)))
						
						// Blank inside the emptied declaration zone → drop it
						
						//········································
					: ($method="@\r\r") || ($method=("@"+kCaret+"\r"))
						
						// Skip (avoid a duplicate blank)
						
						//········································
					Else 
						
						$method+="\r"
						
						//········································
				End case 
				
				//________________________________________
			Else 
				
				If ($t#"comment")
					
					$codeSeen:=True:C214
					
				End if 
				
				$method+=$o.code+"\r"
				
				//________________________________________
		End case 
	End for 
	
	// Remove the last carriage return
	$method:=Delete string:C232($method; Length:C16($method); 1)
	
	If (Bool:C1537($options.trimEmptyLines))
		
		$method:=This:C1470.rgx.setTarget($method).setPattern("\\r{2,}").substitute("\r\r")
		$method:=This:C1470.rgx.setTarget($method).setPattern("(\\r*)$").substitute("")
		
	End if 
	
	This:C1470.method:=$method
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Builds the declaration statement for a single local variable / array
Function _buildDeclaration($var : Object) : Text
	
	// MARK:-Array
	If (Bool:C1537($var.array)) && (Not:C34(Bool:C1537($var.static)))
		
		var $arrayType : Object:=This:C1470.types[Num:C11($var.type)]
		
		If ($arrayType#Null:C1517) && ($arrayType.arrayCommand#Null:C1517) && ($var.dimension#Null:C1517)
			
			return Parse formula:C1576("4d:C"+String:C10($arrayType.arrayCommand))+"("+$var.value+(";0"*$var.dimension)+")"
			
		End if 
		
		return ""
		
	End if 
	
	// MARK:-Class-typed variable
	var $class : Text:=String:C10($var.class)
	
	If (Length:C16($class)=0) && ($var.type=Is object:K8:27)
		
		var $known : Object:=This:C1470.classes.query("value=:1"; $var.value).first()
		
		If ($known#Null:C1517)
			
			$class:=String:C10($known.class)
			
		End if 
	End if 
	
	If (Length:C16($class)>0)
		
		return "var "+$var.value+" :"+$class
		
	End if 
	
	// MARK:-Scalar type (only when the type is known)
	var $type : Object:=This:C1470.types[Num:C11($var.type)]
	
	If ($type=Null:C1517) || ($type.value=Null:C1517)
		
		return ""
		
	End if 
	
	If ($type.value=Is variant:K8:33)
		
		return "var "+$var.value
		
	End if 
	
	return "var "+$var.value+" :"+$type.name
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Index in _output of the first genuine use of the variable (-1 if none found)
Function _firstUseIndex($var : Object) : Integer
	
	var $pattern : Text:="(?m-si)(?<!\\.)\\"+$var.value+"(?!\\w)"
	var $index : Integer
	
	For ($index; 0; This:C1470._output.length-1; 1)
		
		var $o : Object:=This:C1470._output[$index]
		
		If (Bool:C1537($o.skip))
			
			continue
			
		End if 
		
		var $type : Text:=String:C10($o.type)
		
		If ($type="empty") || ($type="comment")
			
			continue
			
		End if 
		
		If (Match regex:C1019($pattern; String:C10($o.code); 1))
			
			// Walk back to the first physical line of a \-continued statement so the
			// declaration is never inserted in the middle of a multi-line instruction.
			While ($index>0)
				
				var $previous : Object:=This:C1470._output[$index-1]
				var $previousType : Text:=String:C10($previous.type)
				
				If ($previousType="empty") || ($previousType="comment")
					
					break
					
				End if 
				
				If (Not:C34(This:C1470.isMultiline(String:C10($previous.code))))
					
					break
					
				End if 
				
				$index:=$index-1
				
			End while 
			
			return $index
			
		End if 
	End for 
	
	return -1
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _addNewLine($text : Text)->$result : Text
	
	$result:=$text
	
	If (Length:C16($result)>0)
		
		If ($result=("@"+kCaret))
			
			$result:=$result+"\r"
			
		Else 
			
			While ($result#"@\r\r")
				
				$result:=$result+"\r"
				
			End while 
		End if 
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _clairvoyant($text : Text; $line : Text) : Integer
	
	
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	var $t:=Replace string:C233(Replace string:C233($text; "{"; "\\{"); "}"; "\\}")
	
	// MARK:- Literal syntax
	Case of 
			
			//________________________________________________________________________________
		: (Match regex:C1019("(?mi-s).*:=\\{"; $line; 1; *))  // Object literal
			
			return Is object:K8:27
			
			//________________________________________________________________________________
		: (Match regex:C1019("(?mi-s).*:=\\["; $line; 1; *))  // Collection literal
			
			return Is collection:K8:32
			
			//________________________________________________________________________________
	End case 
	
	// MARK:- Not localized command
	Case of 
			
			//________________________________________________________________________________
		: (Match regex:C1019("(?mi-s).*:=Form"; $line; 1))
			
			return Is object:K8:27
			
			//________________________________________________________________________________
	End case 
	
	// mark:-
	Case of 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?mi-s)(\\$\\w+):=((?:cs|4d)\\.\\w+(?:\\.\\w+)?)+\\.new\\("; $line; 1; $pos; $len))  // Class
			
			// Keep class definition
			This:C1470.classes.push({\
				value: Substring:C12($line; $pos{1}; $len{1}); \
				class: Substring:C12($line; $pos{2}; $len{2})})
			
			return Is object:K8:27
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)\\"+$t+"[-+:]=\"[^\"]*\""+"|"+Command name:C538(16)+"\\(\\"+$t+"\\)"; $line; 1))
			
			return Is text:K8:3
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?mi-s)\\"+$t+"[-+/\\*:]=-*\\d+\\.\\d*"; $line; 1))\
			 || (Match regex:C1019("(?mi-s)\\"+$t+"[:><]?[=><]?\\d+\\.\\d*"; $line; 1))\
			 || (Match regex:C1019("[-+/\\*:]=\\s*"+Parse formula:C1576("Pi:K30:1"); $line; 1))\
			 || (Match regex:C1019("[-+/\\*:]==\\s*"+Parse formula:C1576("Degree:K30:2"); $line; 1))\
			 || (Match regex:C1019("[-+/\\*:]=\\s*"+Parse formula:C1576("Radian:K30:3"); $line; 1))\
			 || (Match regex:C1019("[-+/\\*:]=\\s*"+Parse formula:C1576("e number:K30:4"); $line; 1))
			
			return Is real:K8:4
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)\\"+$t+"[:><]?[=><]?\\d+"; $line; 1))\
			 || (Match regex:C1019("(?mi-s)\\"+$t+"\\s\\?[?+-]\\s\\d*"; $line; 1))\
			 || (Match regex:C1019(":=\\s*"+Parse formula:C1576("MAXINT:K35:1"); $line; 1))\
			 || (Match regex:C1019(":=\\s*"+Parse formula:C1576("MAXLONG:K35:2"); $line; 1))\
			 || (Match regex:C1019(":=\\s*"+Parse formula:C1576("MAXTEXTLENBEFOREV11:K35:3"); $line; 1))\
			 || (Match regex:C1019("[-+/\\*:]=-*\\d"; $line; 1))
			
			return Is longint:K8:6
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)\\"+$t+":=(?:"+Command name:C538(214)+"|"+Command name:C538(215)+")(?=$|\\(|(?:\\s*"+kCommentMark+")"+\
			"|(?:\\s*/\\*))"; $line; 1))
			
			return Is boolean:K8:9
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)\\"+$t+"\\."; $line; 1))\
			 || (Match regex:C1019("(?m-si):="+Parse formula:C1576("Form:C1466")+"[^.]"; $line; 1))
			
			return Is object:K8:27
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)\\"+$t+":=(?:!\\d+-\\d+-\\d+!)"; $line; 1))
			
			return Is date:K8:7
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)\\"+$t+":=(?:\\?\\d+:\\d+:\\d+\\?)"; $line; 1))
			
			return Is time:K8:8
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?mi-s)\\"+$t+":=->"; $line; 1))\
			 || (Match regex:C1019("(?mi-s)\\"+$t+"->"; $line; 1))
			
			return Is pointer:K8:14
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)(?:For|Boucle)\\s\\((?:[^;]*;\\s*){0,3}(\\"+$t+")"; $line; 1))
			
			return Is longint:K8:6
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)(?:If|Si|Not|Non)\\s*\\(\\"+$t+"\\)"; $line; 1))
			
			return Is boolean:K8:9
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		Else   // Use gram.syntax
			
			var $type : Text
			For each ($type; This:C1470.gramSyntax)
				
				var $indx:=Position:C15("_"; $type)
				
				If ($indx>0)
					
					var $pattern : Text
					For each ($pattern; This:C1470.gramSyntax[$type])
						
						If (Match regex:C1019(Replace string:C233($pattern; "%"; $t); $line; 1))
							
							return Num:C11(Substring:C12($type; 1; $indx-1))
							
						End if 
					End for each 
					
				Else 
					
					For each ($pattern; This:C1470.gramSyntax[$type])
						
						If (Match regex:C1019(Replace string:C233($pattern; "%"; $t)+"(?=$|\\(|(?:\\s*"+kCommentMark+")"+"|(?:\\s*/\\*))"+")"; $line; 1))
							
							return Num:C11($type)
							
						End if 
					End for each 
				End if 
			End for each 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _loadIcons()
	
	var $root : 4D:C1709.Folder:=Folder:C1567("/RESOURCES/Images/fieldIcons")
	var $suffix : Text:=(Get Application color scheme:C1763(*)="dark") ? "_dark.png" : ".png"
	var $icon : Picture
	
	READ PICTURE FILE:C678($root.file("field_00"+$suffix).platformPath; $icon)
	This:C1470.types[0]:={\
		name: "undefined"; \
		icon: $icon}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is object:K8:27; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is object:K8:27]:={\
		name: "object"; \
		icon: $icon; \
		value: Is object:K8:27; \
		arrayCommand: 1221; \
		directive: 1216}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is collection:K8:32; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is collection:K8:32]:={\
		name: "collection"; \
		icon: $icon; \
		value: Is collection:K8:32; \
		directive: 1488}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is longint:K8:6; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is longint:K8:6]:={\
		name: "integer"; \
		icon: $icon; \
		value: Is longint:K8:6; \
		arrayCommand: 221; \
		directive: 283}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is boolean:K8:9; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is boolean:K8:9]:={\
		name: "boolean"; \
		icon: $icon; \
		value: Is boolean:K8:9; \
		arrayCommand: 223; \
		directive: 305}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is text:K8:3; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is text:K8:3]:={\
		name: "text"; \
		icon: $icon; \
		value: Is text:K8:3; \
		arrayCommand: 222; \
		directive: 284}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is date:K8:7; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is date:K8:7]:={\
		name: "date"; \
		icon: $icon; \
		value: Is date:K8:7; \
		arrayCommand: 224; \
		directive: 307}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is time:K8:8; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is time:K8:8]:={\
		name: "time"; \
		icon: $icon; \
		value: Is time:K8:8; \
		arrayCommand: 1223; \
		directive: 306}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is picture:K8:10; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is picture:K8:10]:={\
		name: "picture"; \
		icon: $icon; \
		value: Is picture:K8:10; \
		arrayCommand: 279; \
		directive: 286}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is variant:K8:33; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is variant:K8:33]:={\
		name: "variant"; \
		icon: $icon; \
		value: Is variant:K8:33; \
		directive: 1683}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is pointer:K8:14; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is pointer:K8:14]:={\
		name: "pointer"; \
		icon: $icon; \
		value: Is pointer:K8:14; \
		arrayCommand: 280; \
		directive: 301}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is BLOB:K8:12; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is BLOB:K8:12]:={\
		name: "blob"; \
		icon: $icon; \
		value: Is BLOB:K8:12; \
		arrayCommand: 1222; \
		directive: 604}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is real:K8:4; "00")+$suffix).platformPath; $icon)
	This:C1470.types[Is real:K8:4]:={\
		name: "real"; \
		icon: $icon; \
		value: Is real:K8:4; \
		arrayCommand: 219; \
		directive: 285}
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _loadGramSyntax()
	
	var $file : 4D:C1709.File
	$file:=Is macOS:C1572\
		 ? Folder:C1567(Application file:C491; fk platform path:K87:2).file("Contents/Resources/gram.4dsyntax")\
		 : File:C1566(Application file:C491; fk platform path:K87:2).parent.file("Resources/gram.4dsyntax")
	
	If (Not:C34($file.exists))
		
		return 
		
	End if 
	
	var $patterns : Object
	$patterns:={\
		affectation: "(?m-is)\\%:=(?:(?:#)(?=$|\\(|(?:\\s*"+kCommentMark+")|(?:\\s*/\\*))"; \
		affectationSuite: "|(?:#)(?=$|\\(|(?:\\s*"+kCommentMark+")|(?:\\s*/\\*))"; \
		first: "(?m-is)#\\s*\\(\\%"\
		}
	
	var $t : Text
	var $first; $i; $return : Integer
	
	For each ($t; Split string:C1554($file.getText(); "\n"; sk trim spaces:K86:2))
		
		$i+=1
		$return:=-1
		$first:=-1
		
		If (Match regex:C1019("(?m-si)^\\t@"; $t; 1))
			
			continue  // The command entry is unused
			
		End if 
		
		var $pattern : Text:="(?m-si)^\\t{type}\\s<==\\s"
		
		Case of 
				
				//______________________________________________________
			: (Match regex:C1019(Replace string:C233($pattern; "{type}"; "o"); $t; 1))\
				 && ($i#3) && ($i#4)
				
				$return:=Is object:K8:27
				
				//______________________________________________________
			: (Match regex:C1019(Replace string:C233($pattern; "{type}"; "j"); $t; 1))
				
				$return:=Is collection:K8:32
				
				//______________________________________________________
			: (Match regex:C1019(Replace string:C233($pattern; "{type}"; "B"); $t; 1))
				
				$return:=Is boolean:K8:9
				
				//______________________________________________________
			: (Match regex:C1019(Replace string:C233($pattern; "{type}"; "L"); $t; 1))
				
				$return:=Is longint:K8:6
				
				//______________________________________________________
			: (Match regex:C1019(Replace string:C233($pattern; "{type}"; "S"); $t; 1))
				
				$return:=Is text:K8:3
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\ta\\d*\\s<==\\s"; $t; 1))
				
				$return:=Is text:K8:3
				
				//______________________________________________________
			: (Match regex:C1019(Replace string:C233($pattern; "{type}"; "R"); $t; 1))
				
				$return:=Is real:K8:4
				
				//______________________________________________________
			: (Match regex:C1019(Replace string:C233($pattern; "{type}"; "U"); $t; 1))
				
				$return:=Is pointer:K8:14
				
				//______________________________________________________
			: (Match regex:C1019(Replace string:C233($pattern; "{type}"; "D"); $t; 1))
				
				$return:=Is date:K8:7
				
				//______________________________________________________
			: (Match regex:C1019(Replace string:C233($pattern; "{type}"; "T"); $t; 1))
				
				$return:=Is time:K8:8
				
				//______________________________________________________
		End case 
		
		If ($return#-1)
			
			If (This:C1470.gramSyntax[String:C10($return)].length=0)
				
				This:C1470.gramSyntax[String:C10($return)].push(Replace string:C233($patterns.affectation; "#"; Parse formula:C1576("4d:C"+String:C10($i))))
				
			Else 
				
				This:C1470.gramSyntax[String:C10($return)][0]:=This:C1470.gramSyntax[String:C10($return)][0]\
					+Replace string:C233($patterns.affectationSuite; "#"; Parse formula:C1576("4d:C"+String:C10($i)))
				
			End if 
		End if 
		
		$pattern:="(?m-si)^[^:]+\\s:\\s\\d+\\s:\\s(?:[^;/]*)?"
		
		Case of 
				
				//______________________________________________________
			: (Match regex:C1019($pattern+"o"; $t; 1))
				
				$first:=Is object:K8:27
				
				//______________________________________________________
			: (Match regex:C1019($pattern+"j"; $t; 1))
				
				$first:=Is collection:K8:32
				
				//______________________________________________________
			: (Match regex:C1019($pattern+"a"; $t; 1))
				
				$first:=Is text:K8:3
				
				//______________________________________________________
			: (Match regex:C1019($pattern+"L"; $t; 1))
				
				$first:=Is longint:K8:6
				
				//______________________________________________________
			: (Match regex:C1019($pattern+"R"; $t; 1))
				
				$first:=Is real:K8:4
				
				//______________________________________________________
			: (Match regex:C1019($pattern+"D"; $t; 1))
				
				$first:=Is date:K8:7
				
				//______________________________________________________
			: (Match regex:C1019($pattern+"T"; $t; 1))
				
				$first:=Is time:K8:8
				
				//______________________________________________________
			: (Match regex:C1019($pattern+"B"; $t; 1))
				
				$first:=Is boolean:K8:9
				
				//______________________________________________________
			: (Match regex:C1019($pattern+"b"; $t; 1))
				
				$first:=Is BLOB:K8:12
				
				//________________________________________
		End case 
		
		If ($first#-1)
			
			This:C1470.gramSyntax[String:C10($first)+"_1"].push(Replace string:C233($patterns.first; "#"; Parse formula:C1576("4d:C"+String:C10($i))))
			
		End if 
	End for each 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Remove the compilation directives
Function _removeDirective
	
	var $len; $pos : Integer
	var $pattern : Text
	
	$pattern:="(?-msi)(\\R(?:If|Si)\\s*\\((?:False|Faux)\\)\\R(?:C_.*\\("+This:C1470.name+";.*\\)\\R)*(?:End if|Fin de si)\\s*\\R)"
	
	If (This:C1470.withSelection)
		
		If (Match regex:C1019($pattern; This:C1470.highlighted; 1; $pos; $len))
			
			This:C1470.highlighted:=Delete string:C232(This:C1470.highlighted; $pos; $len)
			
		End if 
		
	Else 
		
		If (Match regex:C1019($pattern; This:C1470.method; 1; $pos; $len))
			
			This:C1470.method:=Delete string:C232(This:C1470.method; $pos; $len)
			
		End if 
	End if 
	