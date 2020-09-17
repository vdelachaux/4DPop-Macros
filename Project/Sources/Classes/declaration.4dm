
Class extends macro

Class constructor
	
	Super:C1705()
	
	// Preferences
	DECLARATION("Get_Syntax_Preferences")
	
	This:C1470.ignoreDeclarations:=False:C215
	
	This:C1470.lines:=New collection:C1472
	This:C1470.locales:=New collection:C1472
	This:C1470.parameters:=New collection:C1472
	
	// Flags
	This:C1470.$inCommentBlock:=False:C215
	
	var $root : Object
	var $icon : Picture
	
	$root:=Folder:C1567("/RESOURCES/Images/fieldIcons")
	
	This:C1470.types:=New collection:C1472
	
	READ PICTURE FILE:C678($root.file("field_00.png").platformPath; $icon)
	This:C1470.types[0]:=New object:C1471(\
		"name"; "undefined"; \
		"icon"; $icon)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is object:K8:27); "00")+".png").platformPath; $icon)
	This:C1470.types[Is object:K8:27]:=New object:C1471(\
		"name"; "object"; \
		"icon"; $icon; \
		"value"; Is object:K8:27; \
		"arrayCommand"; 1221; \
		"directive"; 1216)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is collection:K8:32); "00")+".png").platformPath; $icon)
	This:C1470.types[Is collection:K8:32]:=New object:C1471(\
		"name"; "collection"; \
		"icon"; $icon; \
		"value"; Is collection:K8:32; \
		"directive"; 1488)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is longint:K8:6); "00")+".png").platformPath; $icon)
	This:C1470.types[Is longint:K8:6]:=New object:C1471(\
		"name"; "integer"; \
		"icon"; $icon; \
		"value"; Is longint:K8:6; \
		"arrayCommand"; 221; \
		"directive"; 283)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is boolean:K8:9); "00")+".png").platformPath; $icon)
	This:C1470.types[Is boolean:K8:9]:=New object:C1471(\
		"name"; "boolean"; \
		"icon"; $icon; \
		"value"; Is boolean:K8:9; \
		"arrayCommand"; 223; \
		"directive"; 305)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is text:K8:3); "00")+".png").platformPath; $icon)
	This:C1470.types[Is text:K8:3]:=New object:C1471(\
		"name"; "text"; \
		"icon"; $icon; \
		"value"; Is text:K8:3; \
		"arrayCommand"; 222; \
		"directive"; 284)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is date:K8:7); "00")+".png").platformPath; $icon)
	This:C1470.types[Is date:K8:7]:=New object:C1471(\
		"name"; "date"; \
		"icon"; $icon; \
		"value"; Is date:K8:7; \
		"arrayCommand"; 224; \
		"directive"; 307)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is time:K8:8); "00")+".png").platformPath; $icon)
	This:C1470.types[Is time:K8:8]:=New object:C1471(\
		"name"; "time"; \
		"icon"; $icon; \
		"value"; Is time:K8:8; \
		"arrayCommand"; 1223; \
		"directive"; 306)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is picture:K8:10); "00")+".png").platformPath; $icon)
	This:C1470.types[Is picture:K8:10]:=New object:C1471(\
		"name"; "picture"; \
		"icon"; $icon; \
		"value"; Is picture:K8:10; \
		"arrayCommand"; 279; \
		"directive"; 286)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is variant:K8:33); "00")+".png").platformPath; $icon)
	This:C1470.types[Is variant:K8:33]:=New object:C1471(\
		"name"; "variant"; \
		"icon"; $icon; \
		"value"; Is variant:K8:33; \
		"directive"; 1683)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is pointer:K8:14); "00")+".png").platformPath; $icon)
	This:C1470.types[Is pointer:K8:14]:=New object:C1471(\
		"name"; "pointer"; \
		"icon"; $icon; \
		"value"; Is pointer:K8:14; \
		"arrayCommand"; 280; \
		"directive"; 301)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is BLOB:K8:12); "00")+".png").platformPath; $icon)
	This:C1470.types[Is BLOB:K8:12]:=New object:C1471(\
		"name"; "blob"; \
		"icon"; $icon; \
		"value"; Is BLOB:K8:12; \
		"arrayCommand"; 1222; \
		"directive"; 604)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is real:K8:4); "00")+".png").platformPath; $icon)
	This:C1470.types[Is real:K8:4]:=New object:C1471(\
		"name"; "real"; \
		"icon"; $icon; \
		"value"; Is real:K8:4; \
		"arrayCommand"; 219; \
		"directive"; 285)
	
	This:C1470.$notforArray:=New collection:C1472
	This:C1470.$notforArray.push("collection"; "variant")
	
	This:C1470.loadGramSyntax()
	
	//==============================================================
Function split
	var $0 : Object
	
	Super:C1706.split(This:C1470.selection)
	
	$0:=This:C1470
	
	//==============================================================
Function getType
	var $0 : Integer
	var $1 : Text
	
	Case of 
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C283"); $1)=1)\
			 | (Position:C15(Parse formula:C1576(":C221"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Integer"; $1; 1)
			
			$0:=Is longint:K8:6
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C284"); $1)=1)\
			 | (Position:C15(Parse formula:C1576(":C222"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Text"; $1; 1)
			
			$0:=Is text:K8:3
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C285"); $1)=1)\
			 | (Position:C15(Parse formula:C1576(":C219"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Real"; $1; 1)
			
			$0:=Is real:K8:4
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C286"); $1)=1)\
			 | (Position:C15(Parse formula:C1576(":C279"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Picture"; $1; 1)
			
			$0:=Is picture:K8:10
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C301"); $1)=1)\
			 | (Position:C15(Parse formula:C1576(":C280"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Pointer"; $1; 1)
			
			$0:=Is pointer:K8:14
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C305"); $1)=1)\
			 | (Position:C15(Parse formula:C1576(":C223"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Boolean"; $1; 1)
			
			$0:=Is boolean:K8:9
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C306"); $1)=1)\
			 | (Position:C15(Parse formula:C1576(":C1223"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Time"; $1; 1)
			
			$0:=Is time:K8:8
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C307"); $1)=1)\
			 | (Position:C15(Parse formula:C1576(":C224"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Date"; $1; 1)
			
			$0:=Is date:K8:7
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C604"); $1)=1)\
			 | (Position:C15(Parse formula:C1576(":C1222"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Blob"; $1; 1)
			
			$0:=Is BLOB:K8:12
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C1216"); $1)=1)\
			 | (Position:C15(Parse formula:C1576(":C1221"); $1)=1)
			
			// | Match regex("(?mi-s)\\s*:\\s*(?:Object)|(?:cs\\.)|(?:4d\\.)"; $1; 1)
			
			$0:=Is object:K8:27
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C1488"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Collection"; $1; 1)
			
			$0:=Is collection:K8:32
			
			//______________________________________________________
		: (Position:C15(Parse formula:C1576(":C1683"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Variant"; $1; 1)
			
			$0:=Is variant:K8:33
			
			//______________________________________________________
		: (Position:C15("var"; $1)=1)
			
			$0:=Is variant:K8:33
			
			//______________________________________________________
	End case 
	
	//==============================================================
Function setType
	var $1 : Integer
	var $2 : Object
	
	var $o : Object
	
	If (Count parameters:C259>=2)
		
		$o:=$2
		
	Else 
		
		$o:=Form:C1466.current
		
	End if 
	
	$o.type:=$1
	$o.icon:=This:C1470.types[$o.type].icon
	
	//==============================================================
Function removeDirective  // Remove the compilation directives
	var $len; $pos : Integer
	
	If (This:C1470.selection)
		
		If (Match regex:C1019("(?mi-s)((?:If|Si)\\s*\\((?:False|Faux)\\)\\R(?:\\s*C_[^(]*\\("+This:C1470.name+";.*\\R)+(?:End if|Fin de si)[^\\R]*\\R\\R)"; This:C1470.highlighted; 1; $pos; $len))
			
			This:C1470.highlighted:=Delete string:C232(This:C1470.highlighted; $pos; $len)
			
		End if 
		
	Else 
		
		If (Match regex:C1019("(?mi-s)((?:If|Si)\\s*\\((?:False|Faux)\\)\\R(?:\\s*C_[^(]*\\("+This:C1470.name+";.*\\R)+(?:End if|Fin de si)[^\\R]*\\R\\R)"; This:C1470.method; 1; $pos; $len))
			
			This:C1470.method:=Delete string:C232(This:C1470.method; $pos; $len)
			
		End if 
	End if 
	
	//==============================================================
Function parse  // Parses the code to extract parameters and local variables
	var $0 : Object
	
	var $comment; $t; $text : Text
	var $static : Boolean
	var $l : Integer
	var $line; $o; $parameter; $rgx; $variable : Object
	var $c : Collection
	
	ARRAY LONGINT:C221($_len; 0x0000)
	ARRAY LONGINT:C221($_pos; 0x0000)
	
	This:C1470.removeDirective()
	This:C1470.split()
	
	For each ($text; This:C1470.lineTexts)
		
		$line:=New object:C1471(\
			"code"; $text)
		
		$comment:=""
		
		//ASSERT($oLine.code#"APPEND TO ARRAY($tObj_test; ${10}->)")
		//ASSERT(Position("$tMatches"; $line.code)=0)
		//ASSERT($tLine#"OB SET($_o3;@")
		
		Case of 
				
				//______________________________________________________
			: (Length:C16($text)=0)  // Empty line
				
				$line.type:=Choose:C955(This:C1470.$inCommentBlock; "comment"; "empty")
				
				//______________________________________________________
			: (Match regex:C1019("(?mi-s)^(//)|(/\\*)|(?:.*(\\*/))"; $line.code; 1; $_pos; $_len))  // Comments
				
				$line.type:="comment"
				
				Case of 
						
						//___________________________________
					: ($_pos{2}>0)  // Begin comment block
						
						This:C1470.$inCommentBlock:=Not:C34(Match regex:C1019("(?mi-s)^/\\*.*\\*/"; $line.code; 1))
						
						//___________________________________
					: ($_pos{3}>0)  // End comment block
						
						This:C1470.$inCommentBlock:=False:C215
						
						//___________________________________
				End case 
				
				//______________________________________________________
			: (This:C1470.$inCommentBlock)  // In comment block
				
				$line.type:="comment"
				
				//______________________________________________________
			Else 
				
				// Remove textual values
				Rgx_SubstituteText("(?m-si)(\"[^\"]*\")"; ""; ->$text)
				
				// Remove Comments
				Rgx_SubstituteText("(?m-si)(//.*$)"; ""; ->$text)
				
				// Searches parameters $0-N & ${N} into the line
				
/*------------------------------------------------------
declaration macro must omit the parameters of a formula
--> https://github.com/vdelachaux/4DPop-Macros/issues/6
--------------------------------------------------------*/
				$t:=$text
				$l:=Position:C15(Parse formula:C1576(":C1597")+"("; $text; 1; *)
				
				If ($l>0)
					
					$c:=Split string:C1554(Substring:C12($text; $l); "(")
					$c[$c.length-1]:=Replace string:C233($c[$c.length-1]; ")"; ""; $c.length-2)
					$text:=Replace string:C233($text; $c.join("("); "")
					
				End if 
				
				$rgx:=Rgx_match(New object:C1471(\
					"pattern"; "(?mi-s)(\\$\\{?\\d+\\}?)+"; \
					"target"; $text; \
					"all"; True:C214))
				
				$text:=$t
/*--------------------------------------------------------*/
				
				If ($rgx.success)  // Parameter(s)
					
					For each ($t; $rgx.match.extract("data").distinct())
						
						$parameter:=This:C1470.parameters.query("value=:1"; $t).pop()
						
						If ($parameter=Null:C1517)
							
							$parameter:=New object:C1471(\
								"parameter"; True:C214; \
								"value"; $t; \
								"code"; $line.code; \
								"count"; 0)
							
							This:C1470.parameters.push($parameter)
							
						Else 
							
							$parameter.count:=$parameter.count+1
							
						End if 
						
						If ($parameter.type=Null:C1517)
							
							If (Match regex:C1019("(?mi-s)var\\s|C_"; $text; 1))  // Declaration line
								
								If (Match regex:C1019("(?mi-s)\\s*:\\s*(?:Object)|((?:cs\\.\\w+)|(?:4d\\.\\w+))"; $text; 1; $_pos; $_len))
									
									If ($_pos{1}#-1)
										
										$parameter.class:=Substring:C12($text; $_pos{1}; $_len{1})
										
									End if 
									
									$parameter.type:=Is object:K8:27
									
								Else 
									
									$line.type:="declaration"
									$parameter.type:=This:C1470.getType($text)
									
								End if 
								
								If (Match regex:C1019("(?mi-s)//(.*)$"; $line.code; 1; $_pos; $_len))
									
									$parameter.comment:=Substring:C12($line.code; $_pos{1}; $_len{1})
									
								End if 
								
							Else   // Try to be clairvoyant
								
								$parameter.type:=This:C1470.clairvoyant($t; $line.code)
								
							End if 
						End if 
					End for each 
					
					This:C1470.parameters:=This:C1470.parameters.distinct(ck diacritical:K85:3)
					
				End if 
				
				Case of 
						
						//______________________________________________________
					: (Match regex:C1019("(?mi-s)var\\s|C_"; $text; 1))  // Declaration line
						
						$line.type:="declaration"
						
						$rgx:=Rgx_match(New object:C1471(\
							"pattern"; "(?m-si)(?<!\\.)(\\$\\w+)"; \
							"target"; $text; \
							"all"; True:C214))
						
						If ($rgx.success)
							
							For each ($t; $rgx.match.extract("data").distinct())
								
								If (Match regex:C1019("(?mi-s)(\\$\\{?\\d+\\}?)"; $t; 1))  // Parameter
									
									$parameter:=This:C1470.parameters.query("value=:1"; $t).pop()
									
									If ($parameter=Null:C1517)
										
										$parameter:=New object:C1471(\
											"parameter"; True:C214; \
											"value"; $t; \
											"code"; $line.code; \
											"count"; 0)
										
										This:C1470.parameters.push($parameter)
										
									Else 
										
										$parameter.count:=$parameter.count+1
										
									End if 
									
								Else 
									
									$variable:=This:C1470.locales.query("value=:1"; $t).pop()
									
									If ($variable=Null:C1517)
										
										$variable:=New object:C1471(\
											"value"; $t; \
											"code"; $line.code; \
											"count"; 0)
										
										This:C1470.locales.push($variable)
										
									Else 
										
										$variable.count:=$variable.count+1
										
									End if 
									
									If (Not:C34(This:C1470.ignoreDeclarations))
										
										If (Match regex:C1019("(?mi-s)\\s*:\\s*(?:Object)|((?:cs\\.\\w+)|(?:4d\\.\\w+))"; $text; 1; $_pos; $_len))
											
											If ($_pos{1}#-1)
												
												$variable.class:=Substring:C12($text; $_pos{1}; $_len{1})
												
											End if 
											
											$variable.type:=Is object:K8:27
											
											//OB REMOVE($line; "type")
											
										Else 
											
											$variable.type:=This:C1470.getType($text)
											
										End if 
									End if 
								End if 
							End for each 
						End if 
						
						//______________________________________________________
					: (Match regex:C1019("(?mi-s)^(?:ARRAY|TABLEAU)\\s*[^(]*\\(([^;]*);\\s*[\\dx]+(?:;\\s*([\\dx]+))?\\)"; $text; 1; $_pos; $_len))  // Array declaration
						
						$static:=Match regex:C1019("(?mi-s)0x"; $text; 1)
						
						If (Not:C34($static))
							
							$line.type:="declaration"
							
						End if 
						
						$t:=Substring:C12($line.code; $_pos{1}; $_len{1})
						
						$variable:=This:C1470.locales.query("value=:1"; $t).pop()
						
						If ($variable=Null:C1517)
							
							$variable:=New object:C1471(\
								"value"; $t; \
								"code"; $line.code; \
								"count"; 0)
							
							This:C1470.locales.push($variable)
							
						Else 
							
							$variable.count:=$variable.count+1
							
						End if 
						
						$variable.array:=True:C214
						$variable.dimension:=1+Num:C11(($_pos{2}#-1))
						$variable.static:=$static
						$variable.type:=This:C1470.getType($text)
						
						//______________________________________________________
					: ($text="Class constructor@")  // #UNLOCALIZED KEY WORD
						
						$line.type:="constructor"
						
						//______________________________________________________
					: ($text="Function @")  // #UNLOCALIZED KEY WORD
						
						$line.type:="function"
						
						//______________________________________________________
					Else   // Extract local variables
						
						$rgx:=Rgx_match(New object:C1471(\
							"pattern"; "(?m-si)(?<!\\.)(\\$\\w+)"; \
							"target"; $text; \
							"all"; True:C214))
						
						If ($rgx.success)
							
							For each ($t; $rgx.match.extract("data").distinct())
								
								If (Not:C34(Match regex:C1019("(?mi-s)(\\$\\{?\\d+\\}?)"; $t; 1)))  // Parameter
									
									$variable:=This:C1470.locales.query("value=:1"; $t).pop()
									
									If ($variable=Null:C1517)
										
										$variable:=New object:C1471(\
											"value"; $t; \
											"code"; $line.code; \
											"count"; 1)
										
										This:C1470.locales.push($variable)
										
									Else 
										
										$variable.count:=$variable.count+1
										
									End if 
									
									If ($variable.type=Null:C1517)
										
										$l:=Private_Lon_Declaration_Type($t)
										
										If ($l#0)  // Got a type from syntax parameters
											
											If ($l>100)
												
												$variable.array:=True:C214
												$l:=$l-100
												
											End if 
											
											$variable.type:=Choose:C955($l; \
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
											
											$variable.type:=This:C1470.getType($line.code)
											
											If ($variable.type=0)
												
												$variable.type:=This:C1470.clairvoyant($t; $line.code)
												
											Else 
												
												If (Match regex:C1019("(?m-si)^(?:ARRAY|TABLEAU)\\s[^(]*\\([^;]*;[^;]*(?:;([^;]*))?\\)"; $line.code; 1; $_pos; $_len))
													
													$variable.array:=True:C214
													
												End if 
											End if 
										End if 
									End if 
								End if 
							End for each 
						End if 
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
		End case 
		
		This:C1470.lines.push($line)
		
	End for each 
	
	This:C1470.localeNumber:=This:C1470.locales.length
	This:C1470.parameterNumber:=This:C1470.parameters.length
	
	This:C1470.locales:=This:C1470.locales.orderBy("value asc")
	This:C1470.parameters:=This:C1470.parameters.orderBy("value asc")
	
	// Place the parameter set last
	$o:=This:C1470.parameters.query("value=${@").pop()
	
	If ($o#Null:C1517)
		
		This:C1470.parameters.push($o)
		This:C1470.parameters.remove(This:C1470.parameters.indexOf($o))
		
	End if 
	
	// Finally do a flat list
	This:C1470.variables:=This:C1470.parameters.combine(This:C1470.locales)
	
	$0:=This:C1470
	
	//==============================================================
Function apply
	var $t; $text; $directive : Text
	var $build; $i; $l : Integer
	var $o; $type : Object
	var $c; $cc : Collection
	
	$t:=Application version:C493($build)
	
	// PARAMETERS
	$c:=This:C1470.variables.query("parameter=true")
	
	If ($c.length>0)
		
		For each ($o; $c)
			
			If ($o.class#Null:C1517)
				
				$text:=$text+"var "+$o.value+" :"+$o.class
				$directive:=$directive+":C1216("+This:C1470.name+";"+$o.value+")"
				
			Else 
				
				$text:=$text+"var "+$o.value+" :"+This:C1470.types[$o.type].name
				$directive:=$directive+":C"+String:C10(This:C1470.types[$o.type].directive)+"("+This:C1470.name+";"+$o.value+")"
				
			End if 
			
			If ($o.comment#Null:C1517)
				
				$text:=$text+"//"+$o.comment+"\r"
				$directive:=$directive+"//"+$o.comment+"\r"
				
			Else 
				
				$text:=$text+"\r"
				$directive:=$directive+"\r"
				
			End if 
		End for each 
		
		If (This:C1470.projectMethod)
			
			$directive:=Delete string:C232($directive; Length:C16($directive); 1)
			$text:=$text+"\r"
			
			$text:=Choose:C955(Command name:C538(1)="Sum"; $text+"If(False)\r"+$directive+"\rEnd if\r"; $text+"Si(Faux)\r"+$directive+"\rFin de si\r")
			
		End if 
		
		// Remove the last carriage return
		$text:=Delete string:C232($text; Length:C16($text); 1)
		
	End if 
	
	// VARIABLES
	$c:=This:C1470.variables.query("parameter=null & array=null & count>0 & class=null")
	
	If ($c.length>0)
		
		$text:=$text+("\r\r"*Num:C11(Length:C16($text)>0))
		
		For each ($type; This:C1470.types.query("value!=null"))
			
			$cc:=New collection:C1472
			
			For each ($o; $c.query("type=:1"; $type.value))
				
				$cc.push($o.value)
				
			End for each 
			
			If ($cc.length>10)  // Limit to 10 variables per line
				
				For ($i; 1; $cc.length; 10)
					
					$text:=Choose:C955($build>=254227; $text+"var "+$cc.slice(0; 10).join("; ")+" :"+$type.name+"\r"; $text+"var "+$cc.slice(0; 10).join(", ")+" :"+$type.name+"\r")
					$cc.remove(0; 10)
					
				End for 
			End if 
			
			If ($cc.length>0)
				
				$text:=Choose:C955($build>=254227; $text+"var "+$cc.join("; ")+" :"+$type.name+"\r"; $text+"var "+$cc.join(", ")+" :"+$type.name+"\r")
				
			End if 
		End for each 
		
		// Remove the last carriage return
		$text:=Delete string:C232($text; Length:C16($text); 1)
		
	End if 
	
	// CLASSES
	$c:=This:C1470.variables.query("parameter=null & array=null & count>0 & class!=null")
	
	If ($c.length>0)
		
		$text:=$text+("\r\r"*Num:C11(Length:C16($text)>0))
		
		For each ($t; $c.distinct("class"))
			
			$text:=Choose:C955($build>=254227; $text+"var "+$c.query("class=:1"; $t).extract("value").join("; ")+" :"+$t+"\r"; $text+"var "+$c.query("class=:1"; $t).extract("value").join(", ")+" :"+$t+"\r")
			
		End for each 
		
		// Remove the last carriage return
		$text:=Delete string:C232($text; Length:C16($text); 1)
		
	End if 
	
	// ARRAYS
	$c:=This:C1470.variables.query("array=true & count>0 & static=false")
	
	If ($c.length>0)
		
		$text:=$text+("\r\r"*Num:C11(Length:C16($text)>0))
		
		For each ($type; This:C1470.types.query("arrayCommand!=null"))
			
			For each ($o; $c.query("type=:1"; $type.value))
				
				If ($o.dimension#Null:C1517)
					
					$text:=$text+Parse formula:C1576(":C"+String:C10($type.arrayCommand))\
						+"("+$o.value+(";0"*$o.dimension)+")\r"
					
				End if 
			End for each 
		End for each 
		
		// Remove the last carriage return
		$text:=Delete string:C232($text; Length:C16($text); 1)
		
	End if 
	
	// Look for the first empty or declaration line
	For each ($o; This:C1470.lines) While ($l#MAXLONG:K35:2)
		
		$t:=String:C10($o.type)
		
		Case of 
				
				//___________________
			: ($t="comment")
				
				$l:=$l+1
				
				//___________________
			: ($t="empty")\
				 | ($t="declaration")
				
				$o.code:=$text+kCaret+"\r"
				$o.type:=""
				$text:=""
				
				$l:=MAXLONG:K35:2
				
				//___________________
			Else 
				
				If ($l=0)
					
					// Insert before
					$Text:=$Text+"\r\r"
					
				Else 
					
					$text:=Substring:C12($text; 1; Length:C16($text)-1)+kCaret
					
				End if 
				
				$l:=MAXLONG:K35:2
				
				//___________________
		End case 
	End for each 
	
	// Restore the code
	For each ($o; This:C1470.lines)
		
		$t:=String:C10($o.type)
		
		Case of 
				
				//___________________
			: ($t="declaration")
				
				// Skip
				
				//___________________
			: ($t="empty")
				
				If ($text="@\r\r")
					
					// Skip
					
				Else 
					
					$text:=$text+"\r"
					
				End if 
				
				//________________________________________
			Else 
				
				$text:=$text+$o.code+"\r"
				
				//________________________________________
		End case 
	End for each 
	
	// Remove the last carriage return
	$text:=Delete string:C232($text; Length:C16($text); 1)
	
	This:C1470.method:=$text
	
	//==============================================================
Function clairvoyant
	var $0 : Integer
	var $1 : Text
	var $2 : Text
	
	var $pattern; $t; $type : Text
	var $indx : Integer
	
	$t:=Replace string:C233(Replace string:C233($1; "{"; "\\{"); "}"; "\\}")
	
	Case of 
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)\\"+$t+":=\"[^\"]*\""\
			+"|"+Command name:C538(16)+"\\(\\"+$t+"\\)"; $2; 1))  // Length
			
			$0:=Is text:K8:3
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)\\"+$t+"[:><]?[=><]?\\d+[."+This:C1470.decimalSeparator+"]\\d+"; $2; 1))\
			 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K30:1"); $2; 1))\
			 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K30:2"); $2; 1))\
			 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K30:3"); $2; 1))\
			 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K30:4"); $2; 1))
			
			$0:=Is real:K8:4
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)\\"+$t+"[:><]?[=><]?\\d+"; $2; 1))\
			 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K35:1"); $2; 1))\
			 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K35:2"); $2; 1))\
			 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K35:3"); $2; 1))
			
			$0:=Is longint:K8:6
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)\\"+$t+":=(?:"+Command name:C538(214)+"|"+Command name:C538(215)+")(?=$|\\(|(?:\\s*//)|(?:\\s*/\\*))"; $2; 1))
			
			$0:=Is boolean:K8:9
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)\\"+$t+"\\."; $2; 1))\
			 | (Match regex:C1019("(?m-si):=cs\\.[^.]*\\.new\\("; $2; 1))\
			 | (Match regex:C1019("(?m-si):="+Parse formula:C1576(":C1466")+"[^.]"; $2; 1))
			
			$0:=Is object:K8:27
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)\\"+$t+":=(?:!\\d+-\\d+-\\d+!)"; $2; 1))
			
			$0:=Is date:K8:7
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)\\"+$t+":=(?:\\?\\d+:\\d+:\\d+\\?)"; $2; 1))
			
			$0:=Is time:K8:8
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)\\"+$t+":=->"; $2; 1))\
			 | (Match regex:C1019("(?mi-s)\\"+$t+"->"; $2; 1))
			
			$0:=Is pointer:K8:14
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)(?:For|Boucle)\\s\\((?:[^;]*;\\s*){0,3}(\\"+$t+")"; $2; 1))
			
			$0:=Is longint:K8:6
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)(?:If|Si|Not|Non)\\s*\\(\\"+$t+"\\)"; $2; 1))
			
			$0:=Is boolean:K8:9
			
			//______________________________________________________
			
		Else   // Use gram.syntax
			
			For each ($type; This:C1470.gramSyntax) While ($0=0)
				
				$indx:=Position:C15("_"; $type)
				
				If ($indx>0)
					
					For each ($pattern; This:C1470.gramSyntax[$type]) While ($0=0)
						
						If (Match regex:C1019(Replace string:C233($pattern; "%"; $t); $2; 1))
							
							$0:=Num:C11(Substring:C12($type; 1; $indx-1))
							
						End if 
					End for each 
					
				Else 
					
					For each ($pattern; This:C1470.gramSyntax[$type]) While ($0=0)
						
						If (Match regex:C1019(Replace string:C233($pattern; "%"; $t)+"(?=$|\\(|(?:\\s*//)|(?:\\s*/\\*))"; $2; 1))
							
							$0:=Num:C11($type)
							
						End if 
					End for each 
				End if 
			End for each 
			
			//______________________________________________________
	End case 
	
	//==============================================================
Function loadGramSyntax
	var $t : Text
	var $first; $i; $return : Integer
	var $file; $patterns : Object
	
	This:C1470.gramSyntax:=New object:C1471(\
		String:C10(Is object:K8:27); New collection:C1472; \
		String:C10(Is object:K8:27)+"_1"; New collection:C1472; \
		String:C10(Is boolean:K8:9); New collection:C1472; \
		String:C10(Is boolean:K8:9)+"_1"; New collection:C1472; \
		String:C10(Is longint:K8:6); New collection:C1472; \
		String:C10(Is longint:K8:6)+"_1"; New collection:C1472; \
		String:C10(Is text:K8:3); New collection:C1472; \
		String:C10(Is text:K8:3)+"_1"; New collection:C1472; \
		String:C10(Is real:K8:4); New collection:C1472; \
		String:C10(Is real:K8:4)+"_1"; New collection:C1472; \
		String:C10(Is collection:K8:32); New collection:C1472; \
		String:C10(Is collection:K8:32)+"_1"; New collection:C1472; \
		String:C10(Is pointer:K8:14); New collection:C1472; \
		String:C10(Is pointer:K8:14)+"_1"; New collection:C1472; \
		String:C10(Is date:K8:7); New collection:C1472; \
		String:C10(Is date:K8:7)+"_1"; New collection:C1472; \
		String:C10(Is time:K8:8); New collection:C1472; \
		String:C10(Is time:K8:8)+"_1"; New collection:C1472; \
		String:C10(Is BLOB:K8:12)+"_1"; New collection:C1472)
	
	$file:=Folder:C1567(Get 4D folder:C485(-1); fk platform path:K87:2).file("gram.4dsyntax")
	
	If ($file.exists)
		
		$patterns:=New object:C1471
		$patterns.affectation:="(?m-is)\\%:=(?:#)(?=$|\\(|(?:\\s*//)|(?:\\s*/\\*))"
		$patterns.affectationSuite:="|(?:#)(?=$|\\(|(?:\\s*//)|(?:\\s*/\\*))"
		$patterns.first:="(?m-is)#\\s*\\(\\%"
		
		For each ($t; Split string:C1554($file.getText(); "\r"; sk trim spaces:K86:2))
			
			$i:=$i+1
			$return:=-1
			$first:=-1
			
			//ASSERT($t#"\to <== Path to object : 42 : a ; L'")
			
			Case of 
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\t@"; $t; 1))
					
					// The command entry is unused
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\to\\s<==\\s"; $t; 1))\
					 & ($i#3)\
					 & ($i#4)
					
					$return:=Is object:K8:27
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\tj\\s<==\\s"; $t; 1))
					
					$return:=Is collection:K8:32
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\tB\\s<==\\s"; $t; 1))
					
					$return:=Is boolean:K8:9
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\tL\\s<==\\s"; $t; 1))
					
					$return:=Is longint:K8:6
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\tS\\s<==\\s"; $t; 1))
					
					$return:=Is text:K8:3
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\ta\\d*\\s<==\\s"; $t; 1))
					
					$return:=Is text:K8:3
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\tR\\s<==\\s"; $t; 1))
					
					$return:=Is real:K8:4
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\tU\\s<==\\s"; $t; 1))
					
					$return:=Is pointer:K8:14
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\tD\\s<==\\s"; $t; 1))
					
					$return:=Is date:K8:7
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\tT\\s<==\\s"; $t; 1))
					
					$return:=Is time:K8:8
					
					//______________________________________________________
			End case 
			
			If ($return#-1)
				
				If (This:C1470.gramSyntax[String:C10($return)].length=0)
					
					This:C1470.gramSyntax[String:C10($return)].push(Replace string:C233($patterns.affectation; "#"; Parse formula:C1576(":C"+String:C10($i))))
					
				Else 
					
					This:C1470.gramSyntax[String:C10($return)][0]:=This:C1470.gramSyntax[String:C10($return)][0]\
						+Replace string:C233($patterns.affectationSuite; "#"; Parse formula:C1576(":C"+String:C10($i)))
					
				End if 
			End if 
			
			Case of 
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^[^:]+\\s:\\s\\d+\\s:\\s(?:[^;/]*)?o"; $t; 1))
					
					$first:=Is object:K8:27
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^[^:]+\\s:\\s\\d+\\s:\\s(?:[^;/]*)?j"; $t; 1))
					
					$first:=Is collection:K8:32
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^[^:]+\\s:\\s\\d+\\s:\\s(?:[^;/]*)?a"; $t; 1))
					
					$first:=Is text:K8:3
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^[^:]+\\s:\\s\\d+\\s:\\s(?:[^;/]*)?L"; $t; 1))
					
					$first:=Is longint:K8:6
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^[^:]+\\s:\\s\\d+\\s:\\s(?:[^;/]*)?R"; $t; 1))
					
					$first:=Is real:K8:4
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^[^:]+\\s:\\s\\d+\\s:\\s(?:[^;/]*)?D"; $t; 1))
					
					$first:=Is date:K8:7
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^[^:]+\\s:\\s\\d+\\s:\\s(?:[^;/]*)?T"; $t; 1))
					
					$first:=Is time:K8:8
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^[^:]+\\s:\\s\\d+\\s:\\s(?:[^;/]*)?B"; $t; 1))
					
					$first:=Is boolean:K8:9
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^[^:]+\\s:\\s\\d+\\s:\\s(?:[^;/]*)?b"; $t; 1))
					
					$first:=Is BLOB:K8:12
					
					//________________________________________
			End case 
			
			If ($first#-1)
				
				This:C1470.gramSyntax[String:C10($first)+"_1"].push(Replace string:C233($patterns.first; "#"; Parse formula:C1576(":C"+String:C10($i))))
				
			End if 
		End for each 
	End if 