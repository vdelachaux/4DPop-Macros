//%attributes = {"invisible":true,"preemptive":"incapable"}
var $o : Object
var $t : Text

// In compiled mode we propose to create the test method
If (Is compiled mode:C492)
	
	ALERT:C41(Get localized string:C991("MessagestoTryANewMacro"))
	
	CONFIRM:C162(Get localized string:C991("wouldYouWantToCreateThisMethodNow?"))
	
	If (OK=1)
		
		$t:=Get localized string:C991("testMethodForMacros")+Command name:C538(284)+"($Txt_method;$Txt_highlighted)\r\r"+Get localized string:C991("in_txt_methodTheFullMethodContent")+Command name:C538(997)+"(1;$Txt_method)\r\r"+Get localized string:C991("in_txt_highlightedTheHighlightedText")+Command name:C538(997)+"(2;$Txt_highlighted)\r\r"
		
		METHOD SET CODE:C1194("4DPop_TEST_Macros"; $t; *)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros"; Attribute invisible:K72:6; True:C214; *)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros"; Attribute shared:K72:10; True:C214; *)
		
		METHOD OPEN PATH:C1213("4DPop_TEST_Macros"; *)
		
	End if 
	
Else 
	
	// It's our sandbox…
	
	Case of 
			
			//________________________________________
		: (True:C214)
			
			var $class; $code; $extend; $function; $line; $name; $type : Text
			var $out : Text
			var $property : Object
			var $c; $functions; $mermaid; $properties : Collection
			
			ARRAY LONGINT:C221($len; 0)
			ARRAY LONGINT:C221($pos; 0)
			
			$class:=Split string:C1554(Get window title:C450(Frontmost window:C447); ":"; sk trim spaces:K86:2)[1]
			
			$mermaid:=[]
			$mermaid.push("classDiagram")
			
			GET MACRO PARAMETER:C997(Full method text:K5:17; $code)
			
			$properties:=[]
			
			$functions:=[]
			
			//MARK:-PARSE
			For each ($line; Split string:C1554($code; "\r"; sk ignore empty strings:K86:1+sk trim spaces:K86:2))
				
				Case of 
						
						//______________________________________________________
					: (Match regex:C1019("(?mi-s)Class extends (\\w*)"; $line; 1; $pos; $len; *))
						
						$extend:=Substring:C12($line; $pos{1}; $len{1})
						
						//______________________________________________________
					: ($line="property@")  // Declared properties
						
						$c:=Split string:C1554(Replace string:C233($line; "property "; ""); ":"; sk trim spaces:K86:2)
						$type:=$c.length=1 ? "Variant" : $c[1]
						
						For each ($name; Split string:C1554($c[0]; ";"; sk trim spaces:K86:2))
							
							$properties.push({name: $name; type: $type})
							
						End for each 
						
						//______________________________________________________
					: (Match regex:C1019("(?mi-s)This.(\\$*\\w*)\\s*:=\\s*([^/\\n]*)"; $line; 1; $pos; $len; *))
						
						$name:=Substring:C12($line; $pos{1}; $len{1})
						$property:=$properties.query("name = :1"; $name).first()
						
						If ($property=Null:C1517)
							
							$property:={name: $name; type: "??"}
							$properties.push($property)
							
						Else 
							
							If ($property.type#"??")
								
								continue
								
							End if 
						End if 
						
						$type:=Substring:C12($line; $pos{2}; $len{2})
						
						Case of 
								
								//______________________________________________________
							: ($type="[@")\
								 | ($type="New collection@")
								
								$property.type:="Collection"
								
								//______________________________________________________
							: ($type="{@")\
								 | ($type="New object@")
								
								$property.type:="Object"
								
								//______________________________________________________
							Else 
								
								$property.type:="??"
								
								//______________________________________________________
						End case 
						
						//______________________________________________________
					: (Match regex:C1019("(?mi-s)Function\\s([gs]et\\s)?(\\w*)(?:\\(([^)]*)\\))?(?: : ((?:cs\\.)?\\w*))"; $line; 1; $pos; $len; *))
						
						$name:=Substring:C12($line; $pos{2}; $len{2})
						
						If ($len{1}>0)  // Property
							
							$property:=$properties.query("name = :1"; $name).first()
							
							If ($property=Null:C1517)
								
								$property:={name: $name; type: "??"}
								$properties.push($property)
								
							End if 
							
							If (Substring:C12($line; $pos{2}; $len{2})="set")
								
								$property.writable:=True:C214
								
							End if 
							
							If ($len{4}>0)
								
								$property.type:=Substring:C12($line; $pos{4}; $len{4})
								
							End if 
							
							continue
							
						End if 
						
						// Function
						$function:=($name[[1]]="_" ? "-" : "+")+$name+"("
						
						If ($len{3}>0)
							
							$function+=Replace string:C233(Substring:C12($line; $pos{3}; $len{3}); "$"; "")
							
						End if 
						
						$function+=")"
						
						If ($len{4}>0)
							
							$function+=" "+Substring:C12($line; $pos{4}; $len{4})
							
						End if 
						
						$functions.push($function)
						
						//______________________________________________________
					Else 
						
						// A "Case of" statement should never omit "Else"
						
						//______________________________________________________
				End case 
			End for each 
			
			//MARK:-RESUME
			If ($extend#"")
				
				$mermaid.push($extend+" <|-- "+$class)
				
			End if 
			
			$mermaid.push("class "+$class+" {")
			
			For each ($property; $properties.orderBy("name"))
				
				$mermaid.push(($property.name[[1]]="_" ? "-" : "+")+($property.type#Null:C1517 ? $property.type : "??")+" "+$property.name)
				
			End for each 
			
			For each ($function; $functions.orderBy())
				
				$mermaid.push($function)
				
			End for each 
			
			$mermaid.push("}")
			
			SET TEXT TO PASTEBOARD:C523($mermaid.join("\r"))
			BEEP:C151
			
			//________________________________________
		: (True:C214)  //evaluate
			
			GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $t)
			
			If (Length:C16($t)>0)
				
				$o:=Formula from string:C1601($t)
				ALERT:C41(String:C10($o.call()))
				
			Else 
				
				// A "If" statement should never omit "Else" 
				
			End if 
			
			//________________________________________
		: (True:C214)
			
			$o:=cs:C1710.declaration.new().parse()
			
			If ($o.variables.length>0)
				
				$o.formWindow:=Open form window:C675("NEW_DECLARATION"; Movable form dialog box:K39:8; Horizontally centered:K39:1; At the top:K39:5; *)
				DIALOG:C40("NEW_DECLARATION"; $o)
				
				If (Bool:C1537(OK))
					
					SET MACRO PARAMETER:C998(Choose:C955($o.withSelection; Highlighted method text:K5:18; Full method text:K5:17); $o.method)
					
				End if 
				
				CLOSE WINDOW:C154
				
			Else 
				
				ALERT:C41("No local variable or parameter into the method!")
				
			End if 
			
			//______________________________________________________
	End case 
End if 
