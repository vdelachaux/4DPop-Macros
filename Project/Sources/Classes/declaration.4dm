/*═══════════════════*/
Class extends macro
/*═══════════════════*/

Class constructor
	
	Super:C1705()
	
	// Preferences
	DECLARATION("Get_Syntax_Preferences")
	
	This:C1470.ignoreDeclarations:=True:C214
	
	This:C1470.locales:=New collection:C1472
	This:C1470.parameters:=New collection:C1472
	
	// Flags
	This:C1470.$inCommentBlock:=False:C215
	
	var $p : Picture
	var $root : Object
	
	$root:=Folder:C1567("/RESOURCES/Images/fieldIcons")
	
	This:C1470.types:=New collection:C1472
	
	READ PICTURE FILE:C678($root.file("field_00.png").platformPath; $p)
	This:C1470.types[0]:=New object:C1471(\
		"name"; "undefined"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is boolean:K8:9); "00")+".png").platformPath; $p)
	This:C1470.types[Is boolean:K8:9]:=New object:C1471(\
		"name"; "boolean"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is BLOB:K8:12); "00")+".png").platformPath; $p)
	This:C1470.types[Is BLOB:K8:12]:=New object:C1471(\
		"name"; "blob"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is collection:K8:32); "00")+".png").platformPath; $p)
	This:C1470.types[Is collection:K8:32]:=New object:C1471(\
		"name"; "collection"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is date:K8:7); "00")+".png").platformPath; $p)
	This:C1470.types[Is date:K8:7]:=New object:C1471(\
		"name"; "date"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is longint:K8:6); "00")+".png").platformPath; $p)
	This:C1470.types[Is longint:K8:6]:=New object:C1471(\
		"name"; "longint"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is object:K8:27); "00")+".png").platformPath; $p)
	This:C1470.types[Is object:K8:27]:=New object:C1471(\
		"name"; "object"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is picture:K8:10); "00")+".png").platformPath; $p)
	This:C1470.types[Is picture:K8:10]:=New object:C1471(\
		"name"; "picture"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is pointer:K8:14); "00")+".png").platformPath; $p)
	This:C1470.types[Is pointer:K8:14]:=New object:C1471(\
		"name"; "pointer"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is real:K8:4); "00")+".png").platformPath; $p)
	This:C1470.types[Is real:K8:4]:=New object:C1471(\
		"name"; "real"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is text:K8:3); "00")+".png").platformPath; $p)
	This:C1470.types[Is text:K8:3]:=New object:C1471(\
		"name"; "text"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is time:K8:8); "00")+".png").platformPath; $p)
	This:C1470.types[Is time:K8:8]:=New object:C1471(\
		"name"; "time"; \
		"icon"; $p)
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Num:C11(Is variant:K8:33); "00")+".png").platformPath; $p)
	This:C1470.types[Is variant:K8:33]:=New object:C1471(\
		"name"; "variant"; \
		"icon"; $p)
	
	This:C1470.notforArray:=New collection:C1472("collection"; "variant")
	
	//==============================================================
Function display
	
	var $1,$o : Object
	
	If (Count parameters:C259>=1)
		
		$o:=$1
		
	Else 
		
		$o:=Form:C1466.current
		
	End if 
	
	If ($o#Null:C1517)
		
		For each ($t; Form:C1466.types.extract("name"))
			
			OBJECT Get pointer:C1124(Object named:K67:5; $t)->:=False:C215
			
		End for each 
		
		If ($o.type#Null:C1517)
			
			OBJECT Get pointer:C1124(Object named:K67:5; Form:C1466.types[$o.type].name)->:=True:C214
			
		End if 
		
		SELECT LIST ITEMS BY REFERENCE:C630(OBJECT Get pointer:C1124(Object named:K67:5; "control")->; 1+Num:C11(Bool:C1537($o.array))+(2*Num:C11(Bool:C1537($o.parameter))))
		
		var $t : Text
		
		For each ($t; Form:C1466.notforArray)
			
			OBJECT SET ENABLED:C1123(*; $t; Not:C34(Bool:C1537($o.array)))
			
		End for each 
		
		Form:C1466.subset:=Form:C1466.subset
		LISTBOX SELECT ROW:C912(*; "declarationList"; Form:C1466.index; lk replace selection:K53:1)
		
		This:C1470.updateTabControl($o)
		
	Else 
		
		// Hide UI
		
	End if 
	
	
	//==============================================================
Function updateTabControl
	
	var $1,$o : Object
	
	If (Count parameters:C259>=1)
		
		$o:=$1
		
	Else 
		
		$o:=Form:C1466.current
		
	End if 
	
	var $b : Boolean
	var $i; $l : Integer
	
	If (Bool:C1537($o.parameter))
		
		GET LIST ITEM PROPERTIES:C631(*; "control"; 1; $b; $l; $i)
		SET LIST ITEM PROPERTIES:C386(*; "control"; 1; False:C215; $l; $i)
		GET LIST ITEM PROPERTIES:C631(*; "control"; 2; $b; $l; $i)
		SET LIST ITEM PROPERTIES:C386(*; "control"; 2; False:C215; $l; $i)
		GET LIST ITEM PROPERTIES:C631(*; "control"; 3; $b; $l; $i)
		SET LIST ITEM PROPERTIES:C386(*; "control"; 3; True:C214; $l; $i)
		
	Else 
		
		GET LIST ITEM PROPERTIES:C631(*; "control"; 1; $b; $l; $i)
		SET LIST ITEM PROPERTIES:C386(*; "control"; 1; True:C214; $l; $i)
		GET LIST ITEM PROPERTIES:C631(*; "control"; 2; $b; $l; $i)
		SET LIST ITEM PROPERTIES:C386(*; "control"; 2; Num:C11($o.type)#42; $l; $i)
		GET LIST ITEM PROPERTIES:C631(*; "control"; 3; $b; $l; $i)
		SET LIST ITEM PROPERTIES:C386(*; "control"; 3; False:C215; $l; $i)
		
	End if 
	
	//==============================================================
Function split
	
	var $1 : Boolean
	
	If (Count parameters:C259>=1)
		
		If ($1)
			
			// Selection
			This:C1470.lines:=Split string:C1554(This:C1470.highlighted; "\r"; sk trim spaces:K86:2)
			
		Else 
			
			This:C1470.lines:=Split string:C1554(This:C1470.code; "\r"; sk trim spaces:K86:2)
			
		End if 
		
	Else 
		
		This:C1470.lines:=Split string:C1554(This:C1470.code; "\r")
		
	End if 
	
	var $0 : Object
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
			 | (Position:C15(Parse formula:C1576(":C1221"); $1)=1)\
			 | Match regex:C1019("(?mi-s)\\s*:\\s*Object"; $1; 1)
			
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
	var $2,$o : Object
	
	If (Count parameters:C259>=2)
		
		$o:=$2
		
	Else 
		
		$o:=Form:C1466.current
		
	End if 
	
	$o.type:=$1
	$o.icon:=This:C1470.types[$o.type].icon
	
	This:C1470.display()
	
	
	//==============================================================
Function filter
	
	var $l : Integer
	$l:=Selected list items:C379(*; OBJECT Get name:C1087(Object current:K67:2); *)
	
	Case of 
			
			//______________________________________________________
		: ($l=0)
			
			Form:C1466.subset:=Form:C1466.variables
			
			//______________________________________________________
		: ($l=-1)
			
			Form:C1466.subset:=Form:C1466.variables.query("parameter=true")
			
			//______________________________________________________
		: ($l=-2)
			
			Form:C1466.subset:=Form:C1466.variables.query("parameter=null")
			
			//______________________________________________________
		: ($l=-3)
			
			Form:C1466.subset:=Form:C1466.variables.query("type=null")
			
			//______________________________________________________
		Else 
			
			Form:C1466.subset:=Form:C1466.variables.query("type=:1"; $l)
			
			//______________________________________________________
	End case 
	
	If (Form:C1466.subset.length>0)
		
		LISTBOX SELECT ROW:C912(*; "declarationList"; 1; lk replace selection:K53:1)
		
	Else 
		
		LISTBOX SELECT ROW:C912(*; "declarationList"; 0; lk remove from selection:K53:3)
		
	End if 
	
	SET TIMER:C645(-1)
	
	//==============================================================
Function parse
	
	var $oLine,$rgx,$oParameter,$oVariable : Object
	var $t,$tLine : Text
	var $l : Integer
	
	ARRAY LONGINT:C221($_position; 0x0000)
	ARRAY LONGINT:C221($_length; 0x0000)
	
	This:C1470.split()
	
	For each ($tLine; This:C1470.lines)
		
		$oLine:=New object:C1471(\
			"code"; $tLine)
		
		//ASSERT($oLine.code#"SET BLOB SIZE($_blob; 0)")
		//ASSERT(Position("$tBlb_blob"; $oLine.code)=0)
		
		Case of 
				
				//______________________________________________________
			: (Length:C16($tLine)=0)  // Empty line
				
				$oLine.type:="empty"
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^(//)|(/\\*)|.*(\\*/)"; $oLine.code; 1; $_position; $_length))  // Comments
				
				$oLine.type:="comment"
				
				Case of 
						
						//___________________________________
					: ($_position{2}>0)  // Begin comment block
						
						This:C1470.$inCommentBlock:=True:C214
						
						//___________________________________
					: ($_position{3}>0)  // End comment block
						
						This:C1470.$inCommentBlock:=False:C215
						
						//___________________________________
				End case 
				
				//______________________________________________________
			: (This:C1470.$inCommentBlock)  // In comment block
				
				$oLine.type:="comment"
				
				//______________________________________________________
			Else 
				
				// Remove textual values
				Rgx_SubstituteText("(?m-si)(\"[^\"]*\")"; ""; ->$tLine)
				
				// Remove Comments
				Rgx_SubstituteText("(?m-si)(//.*$)"; ""; ->$tLine)
				
				// Searches parameters $0-N & ${N} into the line
				$rgx:=Rgx_match(New object:C1471(\
					"pattern"; "(?mi-s)(\\$\\{?\\d+\\}?)+"; \
					"target"; $tLine; \
					"all"; True:C214))
				
				If ($rgx.success)  // Parameter
					
					For each ($t; $rgx.match.extract("data").distinct())
						
						$oParameter:=This:C1470.parameters.query("value=:1"; $t).pop()
						
						If ($oParameter=Null:C1517)
							
							$oParameter:=New object:C1471(\
								"parameter"; True:C214; \
								"value"; $t; \
								"code"; $oLine.code)
							
							This:C1470.parameters.push($oParameter)
							
						End if 
						
						If ($oParameter.type=Null:C1517)
							
							If (Match regex:C1019("(?mi-s)var\\s|C_"; $tLine; 1))  // Declaration line
								
								$oLine.type:="declaration"
								$oParameter.type:=This:C1470.getType($tLine)
								
							End if 
						End if 
					End for each 
					
					This:C1470.parameters:=This:C1470.parameters.distinct(ck diacritical:K85:3)
					
				End if 
				
				Case of 
						
						//______________________________________________________
					: (Match regex:C1019("(?mi-s)var\\s|C_"; $tLine; 1))  // Declaration line
						
						$oLine.type:="declaration"
						
						$rgx:=Rgx_match(New object:C1471(\
							"pattern"; "(?m-si)(?<!\\.)(\\$\\w+)"; \
							"target"; $tLine; \
							"all"; True:C214))
						
						If ($rgx.success)
							
							For each ($t; $rgx.match.extract("data").distinct())
								
								If (Match regex:C1019("(?mi-s)(\\$\\{?\\d+\\}?)"; $t; 1))  // Parameter
									
									//
									
								Else 
									
									$oVariable:=This:C1470.locales.query("value=:1"; $t).pop()
									
									If ($oVariable=Null:C1517)
										
										$oVariable:=New object:C1471(\
											"value"; $t)
										
										This:C1470.locales.push($oVariable)
										
									End if 
									
									If (Not:C34(This:C1470.ignoreDeclarations))
										
										$oVariable.type:=This:C1470.getType($tLine)
										
									End if 
								End if 
							End for each 
						End if 
						
						//______________________________________________________
					: (Match regex:C1019("(?mi-s)ARRAY\\s|TABLEAU\\s"; $tLine; 1))  // Array declaration
						
						$rgx:=Rgx_match(New object:C1471(\
							"pattern"; "(?mi-s)^[^(]+\\(([^;]+);0\\)"; \
							"target"; $tLine))
						
						If ($rgx.success)
							
							$oVariable:=This:C1470.locales.query("value=:1"; $rgx.match[1].data).pop()
							
							If ($oVariable=Null:C1517)
								
								$oVariable:=New object:C1471(\
									"value"; $rgx.match[1].data)
								
								$oVariable.code:=$oLine.code
								
								This:C1470.locales.push($oVariable)
								
							End if 
							
							$oVariable.array:=True:C214
							$oVariable.type:=This:C1470.getType($tLine)
							
						End if 
						
						//______________________________________________________
					: ($tLine="Class constructor@")  // #UNLOCALIZED KEY WORD
						
						$oLine.type:="constructor"
						
						//______________________________________________________
					: ($tLine="Function @")  // #UNLOCALIZED KEY WORD
						
						$oLine.type:="function"
						
						//______________________________________________________
					Else   // Extract local variables
						
						$rgx:=Rgx_match(New object:C1471(\
							"pattern"; "(?m-si)(?<!\\.)(\\$\\w+)"; \
							"target"; $tLine; \
							"all"; True:C214))
						
						If ($rgx.success)
							
							For each ($t; $rgx.match.extract("data").distinct())
								
								$oVariable:=This:C1470.locales.query("value=:1"; $t).pop()
								
								If ($oVariable=Null:C1517)
									
									$oVariable:=New object:C1471(\
										"value"; $t)
									
									This:C1470.locales.push($oVariable)
									
								End if 
								
								If ($oVariable.type=Null:C1517)
									
									$oVariable.code:=$oLine.code
									
									$l:=Private_Lon_Declaration_Type($t)
									
									If ($l#0)  // Got a type from syntax parameters
										
										If ($l>100)
											
											$oVariable.array:=True:C214
											$l:=$l-100
											
										End if 
										
										$oVariable.type:=Choose:C955($l; \
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
										
									Else   // Try to be clairvoyant
										
										//#TODO use a parameter file
										
										//ASSERT($oLine.code#"SET BLOB SIZE($_blob; 0)")
										
										Case of 
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)\\"+$t+":=\"[^\"]*\""\
												+"|"+Command name:C538(16)+"\\(\\"+$t+"\\)"; $oLine.code; 1))  // Length
												
												$oVariable.type:=Is text:K8:3
												
												//______________________________________________________
											: (Match regex:C1019("(?mi-s)\\"+$t+"[:><]?[=><]?\\d+[."+This:C1470.decimalSeparator+"]\\d+"; $oLine.code; 1))\
												 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K30:1"); $oLine.code; 1))\
												 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K30:2"); $oLine.code; 1))\
												 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K30:3"); $oLine.code; 1))\
												 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K30:4"); $oLine.code; 1))
												
												$oVariable.type:=Is real:K8:4
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)\\"+$t+"[:><]?[=><]?\\d+"; $oLine.code; 1))\
												 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K35:1"); $oLine.code; 1))\
												 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K35:2"); $oLine.code; 1))\
												 | (Match regex:C1019(":=\\s*"+Parse formula:C1576(":K35:3"); $oLine.code; 1))
												
												$oVariable.type:=Is longint:K8:6
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)\\"+$t+":=(?:"+Command name:C538(214)+"|"+Command name:C538(215)+")"; $oLine.code; 1))  // True, False
												
												$oVariable.type:=Is boolean:K8:9
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)\\"+$t+":=(?:"+Command name:C538(1471)+"|"+Command name:C538(1218)+"|"+Command name:C538(1597)+")|\\."; $oLine.code; 1))
												
												$oVariable.type:=Is object:K8:27
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)\\"+$t+":="+Command name:C538(1472); $oLine.code; 1))
												
												$oVariable.type:=Is collection:K8:32
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)\\"+$t+":=(?:(?:!\\d+-\\d+-\\d+!)|"+Command name:C538(33)+")"; $oLine.code; 1))
												
												$oVariable.type:=Is date:K8:7
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)\\"+$t+":=(?:(?:\\?\\d+:\\d+:\\d+\\?)|"+Command name:C538(178)+")"; $oLine.code; 1))
												
												$oVariable.type:=Is time:K8:8
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)\\"+$t+":=(?:(?:->)|"+Command name:C538(304)+"\\([^)]*\\))"; $oLine.code; 1))
												
												$oVariable.type:=Is pointer:K8:14
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)(?:For|Boucle)\\s\\((?:[^;]*;\\s*){0,3}(\\"+$t+")"; $oLine.code; 1))
												
												$oVariable.type:=Is longint:K8:6
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)\\"+$t+":="+Command name:C538(1597)+"\\("; $oLine.code; 1))
												
												$oVariable.type:=Is object:K8:27
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)(?:If|Si|Not|Non)\\s*\\(\\"+$t+"\\)"; $oLine.code; 1))
												
												$oVariable.type:=Is boolean:K8:9
												
												//______________________________________________________
											: (Match regex:C1019("(?m-si)"\
												+Command name:C538(1055)+"\\(\\"+$t\
												+"|"+Command name:C538(866)+"\\(\\"+$t\
												+"|"+Command name:C538(865)+"\\(\\"+$t\
												+"|\\"+$t+":="+Command name:C538(865)\
												+"|"+"\\"+$t+":="+Command name:C538(864)+"\\s[^(]*\\(|"+Command name:C538(864)+"\\s[^(]*\\(\\"+$t+""\
												+"|"+Command name:C538(1093)+"\\(\\"+$t\
												; $oLine.code; 1))
												
												$oVariable.type:=Is text:K8:3
												
												//______________________________________________________
											: (Match regex:C1019("(?mi-s)"+Command name:C538(606)+"\\s*\\((\\"+$t+");.*\\)"; $oLine.code; 1))
												
												$oVariable.type:=Is BLOB:K8:12
												
												//______________________________________________________
												
											Else 
												
												//$oVariable.type:=Null
												
												//______________________________________________________
										End case 
									End if 
								End if 
							End for each 
						End if 
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
		End case 
		
		This:C1470.lines.push($oLine)
		
	End for each 
	
	This:C1470.localeNumber:=This:C1470.locales.length
	This:C1470.parameterNumber:=This:C1470.parameters.length
	
	// This.locales:=This.locales.orderBy("value asc")
	This:C1470.parameters:=This:C1470.parameters.orderBy("value asc")
	
	// Place the parameter set last
	var $o : Object
	$o:=This:C1470.parameters.query("value=${@").pop()
	
	If ($o#Null:C1517)
		
		This:C1470.parameters.push($o)
		This:C1470.parameters.remove(This:C1470.parameters.indexOf($o))
		
	End if 
	
	// Finally do a flat list
	This:C1470.variables:=This:C1470.parameters.combine(This:C1470.locales)
	
	var $0 : Object
	$0:=This:C1470
	
	//==============================================================
Function ui
	
	var $0 : Object
	
	$0:=New object:C1471
	$0.cell:=New object:C1471(\
		"value"; New object:C1471(\
		))
	
	If (This:C1470.type=Null:C1517)
		
		$0.stroke:="red"
		$0.fontStyle:="italic"
		
	Else 
		
		$0.stroke:="black"
		$0.fontWeight:="bold"
		
		If (Bool:C1537(This:C1470.array))
			
			$0.textDecoration:="underline"
			
		End if 
	End if 