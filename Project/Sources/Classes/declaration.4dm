Class extends macro

property locales:=[]
property parameters:=[]
property classes:=[]
property types:=[]
property assigned:=[]
property variables : Collection
property classIcon : Picture  // icon for object variables that carry a class (4D.x / cs.x)

// Session syntax store (shared singleton): return / first-parameter types of
// commands and the return type of class members, parsed once per session from the
// 4D syntax file (Resources/en.lproj/syntaxEN.json).
property _syntax : cs:C1710.syntax:=cs:C1710.syntax.me

property settings : Object

property localeNumber:=0
property parameterNumber:=0

property _patterns : Object
property _notforArray:=["collection"; "variant"]

// Current scope source with comments stripped (used by the clairvoyance scope scans)
property _scopeCode : Text

property windowRef : Integer

// MARK: Regex patterns (raw, loaded from /RESOURCES/regex/declaration.txt)
property _dx : Object:=cs:C1710.patterns.me.group("declaration")

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
		ALERT:C41(Localized string:C991("allDeclarationsVerified"))
		
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
		ALERT:C41(Localized string:C991("allDeclarationsVerified"))
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
		ALERT:C41(Localized string:C991("allDeclarationsVerified"))
		
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
	This:C1470._scopeCode:=This:C1470._cleanCode(This:C1470.method)
	
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
										
										// Already seen from a usage line: mark it as now declared
										$var.count+=1
										$var.inDeclaration:=True:C214
										
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
												
												var $retClass : Text:=This:C1470._returnClassOf($line.code)
												
												Case of 
														
														//____________________________________
													: (Bool:C1537($var.inDeclaration))
														
														// THE DECLARATION MUST WIN
														
														//____________________________________
													: ($var.class#Null:C1517)
														
														$var.type:=38
														
														//____________________________________
													: ($retClass#"")
														
														$var.class:=$retClass  // return class of the member (e.g. .file → 4D.File)
														
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
	$o.icon:=This:C1470._iconFor($o)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Icon shown for a variable in the dialog list: the dedicated "class" icon when the
	// variable is an object carrying a class (4D.x / cs.x), otherwise its plain type icon
Function _iconFor($var : Object) : Picture
	
	If ($var.type=Is object:K8:27) && (Length:C16(String:C10($var.class))>0) && (This:C1470.classIcon#Null:C1517)
		
		return This:C1470.classIcon
		
	End if 
	
	return This:C1470.types[Num:C11($var.type)].icon
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
	var $inlineAssign : Object:={}
	var $orphans : Collection:=[]
	
	$c:=This:C1470.variables.query("(parameter=null & count>0 & assigned=null & array=null) or (array=true & count>0 & static=false)")
	
	var $local : Object
	For each ($local; $c)
		
		// Skip variables whose type could not be determined (not declarable)
		If (Length:C16(This:C1470._buildDeclaration($local))=0)
			
			continue
			
		End if 
		
		var $at : Integer:=This:C1470._firstUseIndex($local)
		
		Case of 
				
				//___________________
			: ($at<0)
				
				$orphans.push($local)
				
				//___________________
			: (Not:C34(Bool:C1537($local.array)) && (Match regex:C1019("(?m-si)^\\s*\\"+$local.value+"\\s*:="; String:C10(This:C1470._output[$at].code); 1)))
				
				// The first use assigns the variable itself → declare and assign together
				$inlineAssign[String:C10($at)]:=$local
				
				//___________________
			Else 
				
				var $key : Text:=String:C10($at)
				
				If ($inline[$key]=Null:C1517)
					
					$inline[$key]:=[]
					
				End if 
				
				$inline[$key].push($local)
				
				//___________________
			End case 
	End for each 
	
	// Declarations without a located use stay at the top of the block, grouped by type
	If ($orphans.length>0)
		
		$method+=This:C1470._groupDeclarations($orphans).join("\r")+"\r"
		
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
		
		// Look for the first empty or declaration line
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
					
					$method:=$buffer+Substring:C12($method; 1; $length-1)
					
					break
					
					// ___________________
				Else 
					
					If ($l>0)
						
						$method:=$buffer+Substring:C12($method; 1; $length-1)
						
					End if 
					
					break
					
					// ___________________
			End case 
		End for each 
		
		$method:=This:C1470._addNewLine($method)
		
	End if 
	
	// Restore the code, injecting each variable's declaration before its first use
	var $index : Integer
	For ($index; 0; This:C1470._output.length-1; 1)
		
		$o:=This:C1470._output[$index]
		$t:=String:C10($o.type)
		
		var $decls : Collection:=$inline[String:C10($index)]
		
		If ($decls#Null:C1517)
			
			$method+=This:C1470._groupDeclarations($decls).join("\r")+"\r"
			
		End if 
		
		Case of 
				
				//___________________
			: (Bool:C1537($o.skip))
				
				// <NOTHING MORE TO DO>
				
				//___________________
			: ($t="empty")
				
				If ($method="@\r\r")\
					 | ($method=("@"+kCaret+"\r"))
					
					// Skip
					
				Else 
					
					$method+="\r"
					
				End if 
				
				//________________________________________
			Else 
				
				var $assign : Object:=$inlineAssign[String:C10($index)]
				
				If ($assign#Null:C1517)
					
					// Merge the declaration with its assignment on a single line
					$method+=This:C1470._buildDeclaration($assign)+" "+Substring:C12($o.code; Position:C15(":="; $o.code))+"\r"
					
				Else 
					
					$method+=$o.code+"\r"
					
				End if 
				
				//________________________________________
		End case 
	End for 
	
	// Remove the last carriage return
	$method:=Delete string:C232($method; Length:C16($method); 1)
	
	// Strip spurious leading blank lines. (The declarations are now inserted inline,
	// so the caret no longer marks a hoisting point.)
	If (Not:C34(This:C1470.class))
		
		While (Position:C15("\r"; $method)=1)
			
			$method:=Substring:C12($method; 2)
			
		End while 
		
	End if 
	
	If (Bool:C1537($options.trimEmptyLines))
		
		$method:=This:C1470.rgx.setTarget($method).setPattern("\\r{2,}").substitute("\r\r")
		$method:=This:C1470.rgx.setTarget($method).setPattern("(\\r*)$").substitute("")
		
	End if 
	
	// The caret goes at the very end for project methods (placing it mid-method left
	// stray blank lines, and gluing it before "var" made 4D drop the following space).
	If (Not:C34(This:C1470.class))
		
		$method+=kCaret
		
	End if 
	
	This:C1470.method:=$method
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Sorted list of class names offered in the declaration dialog: the 4D classes
	// (4D.x) from the syntax file, "Object" (plain object / no class), plus the cs.*
	// and 4D.* classes actually referenced in the parsed code. Native types such as
	// Collection are excluded (they are picked through their own radio button).
Function _classChoices() : Collection
	
	var $set : Object:={}
	
	var $name : Text
	For each ($name; This:C1470._syntax.classNames())
		
		If (Position:C15("."; $name)>0)  // real classes only (4D.x); skip native types (Collection)
			
			$set[$name]:=True:C214
			
		End if 
	End for each 
	
	var $known : Object
	For each ($known; This:C1470.classes)
		
		If (Length:C16(String:C10($known.class))>0)
			
			$set[String:C10($known.class)]:=True:C214
			
		End if 
	End for each 
	
	var $list : Collection:=OB Keys:C1719($set).sort()
	$list.unshift("Object")  // plain object (no class) always first
	
	return $list
	
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
	
	If ($var.class=Null:C1517) && ($var.type=Is object:K8:27)
		
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
	// Groups local variables into declaration lines, merging variables that share the
	// same type onto a single "var $a; $b : Type" line. Arrays (and any non-"var"
	// form) are emitted individually; variables with an unknown type are skipped.
Function _groupDeclarations($locals : Collection) : Collection
	
	var $lines : Collection:=[]
	var $groups : Object:={}
	var $order : Collection:=[]
	
	var $local : Object
	For each ($local; $locals)
		
		var $built : Text:=This:C1470._buildDeclaration($local)
		
		Case of 
				
				//___________________
			: (Length:C16($built)=0)
				
				// Unknown type → not declared
				
				//___________________
			: (Position:C15("var "; $built)#1)
				
				// Array or other non-"var" declaration → keep as-is
				$lines.push($built)
				
				//___________________
			Else 
				
				// Signature = everything after "var $value" (e.g. " :Text", "" for variant)
				var $sig : Text:=Substring:C12($built; Length:C16("var "+$local.value)+1)
				
				If ($groups[$sig]=Null:C1517)
					
					$groups[$sig]:=[]
					$order.push($sig)
					
				End if 
				
				$groups[$sig].push($local.value)
				
				//___________________
			End case 
	End for each 
	
	var $sig2 : Text
	For each ($sig2; $order)
		
		$lines.push("var "+$groups[$sig2].join("; ")+$sig2)
		
	End for each 
	
	return $lines
	
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
	
	$line:=This:C1470._cleanCode($line)  // drop inline comments so the scans don't trip on "//"
	
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
		: (Match regex:C1019("(?m-si)\\"+$t+"\\s*[-+/\\*]="; $line; 1))  // $var += -= *= /= with a non-literal RHS → numeric
			
			return Is real:K8:4
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)\\"+$t+":=(?:"+Command name:C538(214)+"|"+Command name:C538(215)+")(?=$|\\(|(?:\\s*"+kCommentMark+")"+\
			"|(?:\\s*/\\*))"; $line; 1))
			
			return Is boolean:K8:9
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)\\"+$t+"\\s*\\[\\s*-?\\d"; This:C1470._scopeCode; 1))  // $var[<number>] → collection element access (scans the whole scope)
			
			return Is collection:K8:32
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: (Match regex:C1019("(?m-si)\\"+$t+"\\."; $line; 1))\
			 || (Match regex:C1019("(?m-si):="+Parse formula:C1576("Form:C1466")+"[^.]"; $line; 1))
			
			return This:C1470._memberReceiver($text)
			
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
		Else   // For each variables, then the session syntax store
			
			var $forEach : Integer:=This:C1470._forEachType($text)
			
			If ($forEach#-1)
				
				return $forEach
				
			End if 
			
			return This:C1470._syntax.guessType($text; $line)
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Type of a variable involved in a "For each ( loopVar ; expression )":
	//   • loop variable    → element type from its usage, or Text (object iteration)
	//   • bare iterated var → Collection or Object, per the loop variable's usage
	// Returns -1 when $var is not a For each variable.
Function _forEachType($var : Text) : Integer
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	var $esc : Text:="\\"+$var
	
	// $var is the loop variable: For each ( $var ; … )
	If (Match regex:C1019("(?m-si)(?:For each|Pour chaque)\\s*\\(\\s*"+$esc+"\\s*;"; This:C1470._scopeCode; 1))
		
		var $element : Integer:=This:C1470._loopVarType($var)
		
		return ($element#0) ? $element : Is text:K8:3
		
	End if 
	
	// $var is the (bare) iterated expression: For each ( loopVar ; $var {; begin {; end}} )
	If (Match regex:C1019("(?m-si)(?:For each|Pour chaque)\\s*\\(\\s*(\\$\\w+)\\s*;\\s*"+$esc+"\\s*(?:;|\\))"; This:C1470._scopeCode; 1; $pos; $len))
		
		var $loopVar : Text:=Substring:C12(This:C1470._scopeCode; $pos{1}; $len{1})
		
		return (This:C1470._loopVarType($loopVar)#0) ? Is collection:K8:32 : Is object:K8:27
		
	End if 
	
	return -1
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Element type of a loop variable, inferred from its usage in the scope:
	//   $v[<n>] → collection ; $v.member → object ; $v in arithmetic/comparison → real ;
	//   else 0
Function _loopVarType($var : Text) : Integer
	
	var $esc : Text:="\\"+$var
	
	Case of 
			
			//___________________
		: (Match regex:C1019("(?m-si)"+$esc+"\\s*\\[\\s*-?\\d"; This:C1470._scopeCode; 1))
			
			return Is collection:K8:32
			
			//___________________
		: (Match regex:C1019("(?m-si)"+$esc+"\\."; This:C1470._scopeCode; 1))
			
			return Is object:K8:27
			
			//___________________
		: (Match regex:C1019("(?m-si)(?:"+$esc+"\\s*[-+/\\*%<>]|[-+/\\*%]=?\\s*"+$esc+"\\b|[<>]=?\\s*"+$esc+"\\b)"; This:C1470._scopeCode; 1))
			
			return Is real:K8:4
			
			//___________________
		Else 
			
			return 0
			
			//___________________
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Type constant for a variable used as the receiver of a member ($var.member):
	// derives its class from the accessed member names (e.g. .getText → 4D.File,
	// .length → Collection) and records it so the variable is declared precisely
Function _memberReceiver($var : Text) : Integer
	
	var $class : Text:=This:C1470._receiverClassOf($var)
	
	Case of 
			
			//___________________
		: ($class="Collection")
			
			return Is collection:K8:32
			
			//___________________
		: ($class="") || ($class="Object")
			
			return Is object:K8:27
			
			//___________________
		Else 
			
			This:C1470.classes.push({value: $var; class: $class})
			return Is object:K8:27
			
			//___________________
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Class shared by every member accessed on $var in the scope (e.g. .getText and
	// .extension both resolve to 4D.File); "" when they disagree or none is specific
Function _receiverClassOf($var : Text) : Text
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	var $esc : Text:="\\"+$var
	var $classes : Collection:=[]
	var $start : Integer:=1
	
	While (Match regex:C1019("(?m-si)"+$esc+"\\.([A-Za-z]\\w*)"; This:C1470._scopeCode; $start; $pos; $len))
		
		var $class : Text:=This:C1470._syntax.memberReceiverClass(Substring:C12(This:C1470._scopeCode; $pos{1}; $len{1}))
		
		If (($class#"") && ($classes.indexOf($class)<0))
			
			$classes.push($class)
			
		End if 
		
		$start:=$pos{1}+$len{1}
		
	End while 
	
	return ($classes.length=1) ? $classes[0] : ""
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Return class of the member call ending an assignment RHS (e.g. "…:=$f.file(…)"
	// → "4D.File"); "" when the member has no unambiguous return class
Function _returnClassOf($code : Text) : Text
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("(?mi-s)\\.([A-Za-z]\\w*)\\s*\\([^)]*\\)\\s*$"; $code; 1; $pos; $len))
		
		return This:C1470._syntax.memberReturnClass(Substring:C12($code; $pos{1}; $len{1}))
		
	End if 
	
	return ""
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Removes /* … */ and // comments so the clairvoyance scans are not fooled by them
	// (e.g. "$x  // …" must not look like a division, and a trailing comment must not
	// break an end-of-expression anchor)
Function _cleanCode($text : Text) : Text
	
	var $pos; $len : Integer
	
	While (Match regex:C1019("(?s)/\\*.*?\\*/"; $text; 1; $pos; $len))
		
		$text:=Delete string:C232($text; $pos; $len)
		
	End while 
	
	While (Match regex:C1019("//[^\r\n]*"; $text; 1; $pos; $len))
		
		$text:=Delete string:C232($text; $pos; $len)
		
	End while 
	
	return $text
	
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
	
	READ PICTURE FILE:C678($root.file("field_class.svg").platformPath; $icon)
	This:C1470.classIcon:=$icon
	
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
	