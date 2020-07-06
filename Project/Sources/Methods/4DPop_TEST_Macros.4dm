//%attributes = {}
//%attributes = {}
C_TEXT:C284($Txt_buffer)

// In compiled mode we propose to create the test method
If (Is compiled mode:C492)
	
	ALERT:C41(Get localized string:C991("MessagestoTryANewMacro"))
	
	CONFIRM:C162(Get localized string:C991("wouldYouWantToCreateThisMethodNow?"))
	
	If (OK=1)
		
		$Txt_buffer:=Get localized string:C991("testMethodForMacros")+Command name:C538(284)+"($Txt_method;$Txt_highlighted)\r\r"+Get localized string:C991("in_txt_methodTheFullMethodContent")+Command name:C538(997)+"(1;$Txt_method)\r\r"+Get localized string:C991("in_txt_highlightedTheHighlightedText")+Command name:C538(997)+"(2;$Txt_highlighted)\r\r"
		
		METHOD SET CODE:C1194("4DPop_TEST_Macros"; $Txt_buffer; *)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros"; Attribute invisible:K72:6; True:C214; *)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros"; Attribute shared:K72:10; True:C214; *)
		
		METHOD OPEN PATH:C1213("4DPop_TEST_Macros"; *)
		
	End if 
	
Else 
	
	// It's our sandbox…
	
	Case of 
			
			//________________________________________
		: (True:C214)
			
			var $oMethod,$oLine,$rgx,$oParameter,$oVariable : Object
			var $t,$tLine : Text
			var $l : Integer
			
			$oMethod:=New object:C1471
			
			// Method
			GET MACRO PARAMETER:C997(Full method text:K5:17; $t)
			$oMethod.code:=$t
			
			// Selection
			GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $t)
			$oMethod.highlighted:=$t
			$oMethod.selection:=Length:C16($t)>0
			
			// Preferences
			$oMethod.ignoreDeclarations:=True:C214
			
			// Extractions
			$oMethod.lines:=New collection:C1472
			$oMethod.locales:=New collection:C1472
			$oMethod.parameters:=New collection:C1472
			
			// Flags
			$oMethod.$inCommentBlock:=False:C215
			
			GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
			$oMethod.decimalSeparator:=$t
			
			DECLARATION("Get_Syntax_Preferences")
			
			For each ($tLine; Split string:C1554($oMethod.code; "\r"; sk trim spaces:K86:2))
				
				$oLine:=New object:C1471
				
				If (Length:C16($tLine)=0)  // Empty line
					
					$oLine.type:="empty"
					
				Else 
					
					$oLine.code:=$tLine
					
					// Remove textual values
					Rgx_SubstituteText("(?m-si)(\"[^\"]*\")"; ""; ->$tLine)
					
					// Remove Comments
					Rgx_SubstituteText("(?m-si)(//.*$)"; ""; ->$tLine)
					
					$rgx:=Rgx_match(New object:C1471(\
						"pattern"; "(?mi-s)(\\$\\{?\\d+\\}?)+"; \
						"target"; $tLine; \
						"all"; True:C214))
					
					If ($rgx.success)  // Parameter
						
						For each ($t; $rgx.match.extract("data").distinct())
							
							$oParameter:=$oMethod.parameters.query("value=:1"; $t).pop()
							
							If ($oParameter=Null:C1517)
								
								$oParameter:=New object:C1471(\
									"parameter"; True:C214; \
									"value"; $t; \
									"code"; $oLine.code)
								
								$oMethod.parameters.push($oParameter)
								
							End if 
							
							If ($oParameter.type=Null:C1517)
								
								If (Match regex:C1019("(?mi-s)var\\s|C_"; $tLine; 1))  // Declaration line
									
									$oLine.type:="declaration"
									$oParameter.type:=:=declarationType($tLine)
									
								End if 
							End if 
						End for each 
						
						$oMethod.parameters:=$oMethod.parameters.distinct(ck diacritical:K85:3)
						
					Else 
						
						Case of 
								
								//______________________________________________________
							: (Match regex:C1019("(?mi-s)var\\s|C_"; $tLine; 1))  // Declaration line
								
								$oLine.type:="declaration"
								
								If (Not:C34($oMethod.ignoreDeclarations))
									
									$rgx:=Rgx_match(New object:C1471(\
										"pattern"; "(?m-si)(?<!\\.)(\\$\\w+)"; \
										"target"; $tLine; \
										"all"; True:C214))
									
									If ($rgx.success)
										
										For each ($t; $rgx.match.extract("data").distinct())
											
											If (Match regex:C1019("(?mi-s)(\\$\\{?\\d+\\}?)"; $t; 1))  // Parameter
												
												//
												
											Else 
												
												$oVariable:=$oMethod.locales.query("value=:1"; $t).pop()
												
												If ($oVariable=Null:C1517)
													
													$oVariable:=New object:C1471(\
														"value"; $t)
													
													$oMethod.locales.push($oVariable)
													
												End if 
												
												$oVariable.type:=declarationType($tLine)
												
											End if 
										End for each 
									End if 
								End if 
								
								//______________________________________________________
							: (Match regex:C1019("(?mi-s)ARRAY\\s|TABLEAU\\s"; $tLine; 1))  // Array declaration
								
								$rgx:=Rgx_match(New object:C1471(\
									"pattern"; "(?mi-s)^[^(]+\\(([^;]+);0\\)"; \
									"target"; $tLine))
								
								If ($rgx.success)
									
									$oVariable:=$oMethod.locales.query("value=:1"; $rgx.match[1].data).pop()
									
									If ($oVariable=Null:C1517)
										
										$oVariable:=New object:C1471(\
											"value"; $rgx.match[1].data)
										
										$oVariable.code:=$oLine.code
										
										$oMethod.locales.push($oVariable)
										
									End if 
									
									$oVariable.array:=True:C214
									$oVariable.type:=declarationType($tLine)
									
								End if 
								
								//______________________________________________________
							: ($tLine=("/"+"/@"))  // Comment line
								
								$oLine.type:="comment"
								
								//______________________________________________________
							: ($tLine="/*@")  // Begin comment block
								
								$oMethod.$inCommentBlock:=True:C214
								$oLine.type:="comment"
								
								//______________________________________________________
							: ($oMethod.$inCommentBlock)  // In comment block
								
								$oLine.type:="comment"
								
								//______________________________________________________
							: ($tLine="@*/")  // End comment block
								
								$oMethod.$inCommentBlock:=False:C215
								$oLine.type:="comment"
								
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
										
										
										
										
										//If (Not(Match regex("(?mi-s)(\\$\\{?\\d+\\}?)"; $t; 1)))
										
										$oVariable:=$oMethod.locales.query("value=:1"; $t).pop()
										
										If ($oVariable=Null:C1517)
											
											$oVariable:=New object:C1471(\
												"value"; $t)
											
											$oMethod.locales.push($oVariable)
											
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
												
												//ASSERT($oLine.code#"$_real:=12.5")
												
												Case of 
														
														//______________________________________________________
													: (Match regex:C1019("(?m-si)\\"+$t+":=\"[^\"]*\""\
														+"|"+Command name:C538(16)+"\\(\\"+$t+"\\)"; $oLine.code; 1))  // Length
														
														$oVariable.type:=Is text:K8:3
														
														//______________________________________________________
													: (Match regex:C1019("(?mi-s)\\"+$t+"[:><]?[=><]?\\d+[."+$oMethod.decimalSeparator+"]\\d+"; $oLine.code; 1))\
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
													: (Match regex:C1019("(?mi-s)(?:For|Boucle)\\s\\((?:[^;]*;\\s*){0,3}(\\$"+$t+")"; $oLine.code; 1))
														
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
														
														$oVariable.type:=Is boolean:K8:9
														
														//______________________________________________________
														
													Else 
														
														//$oVariable.type:=Null
														
														//______________________________________________________
												End case 
											End if 
										End if 
										//End if 
									End for each 
								End if 
								
								//______________________________________________________
						End case 
					End if 
				End if 
				
				$oMethod.lines.push($oLine)
				
			End for each 
			
			$oMethod.locales:=$oMethod.locales.orderBy("value asc")
			$oMethod.parameters:=$oMethod.parameters.orderBy("value asc")
			
			// Place the parameter set last
			$o:=$oMethod.parameters.query("value=${@").pop()
			
			If ($o#Null:C1517)
				
				$oMethod.parameters.push($o)
				$oMethod.parameters.remove($oMethod.parameters.indexOf($o))
				
			End if 
			
			// Finally do a flat list
			$oMethod.variables:=$oMethod.parameters.combine($oMethod.locales)
			
			$l:=Open form window:C675("NEW_DECLARATION"; Movable form dialog box:K39:8; Horizontally centered:K39:1; At the top:K39:5; *)
			DIALOG:C40("NEW_DECLARATION"; $oMethod)
			CLOSE WINDOW:C154
			
			//______________________________________________________
	End case 
End if 