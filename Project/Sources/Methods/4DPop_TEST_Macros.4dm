//%attributes = {}
//%attributes = {}
C_TEXT:C284($Txt_buffer)

// In compiled mode we propose to create the test method
If (Is compiled mode:C492)
	
	ALERT:C41(Get localized string:C991("MessagestoTryANewMacro"))
	
	CONFIRM:C162(Get localized string:C991("wouldYouWantToCreateThisMethodNow?"))
	
	If (OK=1)
		
		$Txt_buffer:=Get localized string:C991("testMethodForMacros")+Command name:C538(284)+"($Txt_method;$Txt_highlighted)\r\r"+Get localized string:C991("in_txt_methodTheFullMethodContent")+Command name:C538(997)+"(1;$Txt_method)\r\r"+Get localized string:C991("in_txt_highlightedTheHighlightedText")+Command name:C538(997)+"(2;$Txt_highlighted)\r\r"
		
		METHOD SET CODE:C1194("4DPop_TEST_Macros";$Txt_buffer;*)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros";Attribute invisible:K72:6;True:C214;*)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros";Attribute shared:K72:10;True:C214;*)
		
		METHOD OPEN PATH:C1213("4DPop_TEST_Macros";*)
		
	End if 
	
Else 
	
	// It's our sandbox…
	
	Case of 
			
			//________________________________________
		: (True:C214)
			
			var $oMethod,$oLine,$rgx,$oParameter : Object
			var $t,$tLine : Text
			
			
			$oMethod:=New object:C1471
			
			GET MACRO PARAMETER:C997(Full method text:K5:17;$t)
			$oMethod.code:=$t
			
			$oMethod.ignoreDeclarations:=True:C214
			
			$oMethod.lines:=New collection:C1472
			
			$oMethod.locales:=New collection:C1472
			$oMethod.parameters:=New collection:C1472
			
			$oMethod.inCommentBlock:=False:C215
			
			GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$t)
			$oMethod.decimalSeparator:=$t
			
			DECLARATION("Get_Syntax_Preferences")
			
			For each ($tLine;Split string:C1554($oMethod.code;"\r";sk trim spaces:K86:2))
				
				$oLine:=New object:C1471
				$oLine.code:=$tLine
				
				If (Length:C16($tLine)=0)  // Empty line
					
					$oLine.status:="empty"
					
				Else 
					
					// Remove textual values
					Rgx_SubstituteText("(?m-si)(\"[^\"]*\")";"";->$tLine)
					
					// Remove Comments
					Rgx_SubstituteText("(?m-si)(//.*$)";"";->$tLine)
					
					$rgx:=Rgx_match(New object:C1471(\
						"pattern";"(?mi-s)(\\$\\{?\\d+\\}?)";\
						"target";$tLine))
					
					If ($rgx.success)
						
						For each ($t;$rgx.match.extract("data").distinct())
							
							$oParameter:=$oMethod.parameters.query("value=:1";$t).pop()
							
							If ($oParameter=Null:C1517)
								
								$oParameter:=New object:C1471(\
									"value";$t)
								
								$oMethod.parameters.push($oParameter)
								
							End if 
							
							Case of 
									
									//______________________________________________________
								: ($oParameter.type#Null:C1517)
									
									// <NOTHING MORE TO DO>
									
									//______________________________________________________
								: ($tLine=(Command name:C538(305)+"@"))\
									 | ($tLine="@: Boolean")
									
									$oParameter.type:=Is boolean:K8:9
									
									//______________________________________________________
								: ($tLine=(Command name:C538(283)+"@"))\
									 | ($tLine="@: Integer")
									
									$oParameter.type:=Is longint:K8:6
									
									//______________________________________________________
								: ($tLine=(Command name:C538(285)+"@"))\
									 | ($tLine="@: Real")
									
									$oParameter.type:=Is real:K8:4
									
									//______________________________________________________
								: ($tLine=(Command name:C538(284)+"@"))\
									 | ($tLine="@: Text")
									
									$oParameter.type:=Is text:K8:3
									
									//______________________________________________________
								: ($tLine=(Command name:C538(1216)+"@"))\
									 | ($tLine="@: Object")
									
									$oParameter.type:=Is object:K8:27
									
									//______________________________________________________
								: ($tLine=(Command name:C538(1448)+"@"))\
									 | ($tLine="@: Collection")
									
									$oParameter.type:=Is collection:K8:32
									
									//______________________________________________________
								: ($tLine=(Command name:C538(604)+"@"))\
									 | ($tLine="@: Blob")
									
									$oParameter.type:=Is BLOB:K8:12
									
									//______________________________________________________
								: ($tLine=(Command name:C538(307)+"@"))\
									 | ($tLine="@: Date")
									
									$oParameter.type:=Is date:K8:7
									
									//______________________________________________________
								: ($tLine=(Command name:C538(306)+"@"))\
									 | ($tLine="@: Time")
									
									$oParameter.type:=Is time:K8:8
									
									//______________________________________________________
								: ($tLine=(Command name:C538(286)+"@"))\
									 | ($tLine="@: Picture")
									
									$oParameter.type:=Is picture:K8:10
									
									//______________________________________________________
								: ($tLine=(Command name:C538(1683)+"@"))\
									 | ($tLine="@: Variant")
									
									$oParameter.type:=Is variant:K8:33
									
									//______________________________________________________
								: ($tLine=(Command name:C538(301)+"@"))\
									 | ($tLine="@: Pointer")
									
									$oParameter.type:=Is pointer:K8:14
									
									//______________________________________________________
								: ($tLine="var @")
									
									$oParameter.type:=Is variant:K8:33
									
									//______________________________________________________
							End case 
						End for each 
						
						$oMethod.parameters:=$oMethod.parameters.distinct(ck diacritical:K85:3)
						
					End if 
					
					Case of 
							
							//______________________________________________________
						: (($tLine="C_@")\
							 | ($tLine="var @"))  // Declaration line
							
							$oLine.status:="declaration"
							
							If (Not:C34($oMethod.ignoreDeclarations))  // Extract local variables
								
								$rgx:=Rgx_match(New object:C1471(\
									"pattern";"(?m-si)(?<!\\.)(\\$\\w+)";\
									"target";$tLine;\
									"all";True:C214))
								
								If ($rgx.success)
									
									For each ($t;$rgx.match.extract("data").distinct())
										
										If (Not:C34(Match regex:C1019("(?mi-s)(\\$\\{?\\d+\\}?)";$t;1)))
											
											$oVariable:=$oMethod.locales.query("value=:1";$t).pop()
											
											If ($oVariable=Null:C1517)
												
												$oVariable:=New object:C1471(\
													"value";$t)
												
												$oMethod.locales.push($oVariable)
												
											End if 
											
											Case of 
													
													//______________________________________________________
												: ($tLine=(Command name:C538(305)+"@"))\
													 | ($tLine="@: Boolean")
													
													$oVariable.type:=Is boolean:K8:9
													
													//______________________________________________________
												: ($tLine=(Command name:C538(283)+"@"))\
													 | ($tLine="@: Integer")
													
													$oVariable.type:=Is longint:K8:6
													
													//______________________________________________________
												: ($tLine=(Command name:C538(285)+"@"))\
													 | ($tLine="@: Real")
													
													$oVariable.type:=Is real:K8:4
													
													//______________________________________________________
												: ($tLine=(Command name:C538(284)+"@"))\
													 | ($tLine="@: Text")
													
													$oVariable.type:=Is text:K8:3
													
													//______________________________________________________
												: ($tLine=(Command name:C538(1216)+"@"))\
													 | ($tLine="@: Object")
													
													$oVariable.type:=Is object:K8:27
													
													//______________________________________________________
												: ($tLine=(Command name:C538(1448)+"@"))\
													 | ($tLine="@: Collection")
													
													$oVariable.type:=Is collection:K8:32
													
													//______________________________________________________
												: ($tLine=(Command name:C538(604)+"@"))\
													 | ($tLine="@: Blob")
													
													$oVariable.type:=Is BLOB:K8:12
													
													//______________________________________________________
												: ($tLine=(Command name:C538(307)+"@"))\
													 | ($tLine="@: Date")
													
													$oVariable.type:=Is date:K8:7
													
													//______________________________________________________
												: ($tLine=(Command name:C538(306)+"@"))\
													 | ($tLine="@: Time")
													
													$oVariable.type:=Is time:K8:8
													
													//______________________________________________________
												: ($tLine=(Command name:C538(286)+"@"))\
													 | ($tLine="@: Picture")
													
													$oVariable.type:=Is picture:K8:10
													
													//______________________________________________________
												: ($tLine=(Command name:C538(1683)+"@"))\
													 | ($tLine="@: Variant")
													
													$oVariable.type:=Is variant:K8:33
													
													//______________________________________________________
												: ($tLine=(Command name:C538(301)+"@"))\
													 | ($tLine="@: Pointer")
													
													$oVariable.type:=Is pointer:K8:14
													
													//______________________________________________________
												: ($tLine="var @")
													
													$oVariable.type:=Is variant:K8:33
													
													//______________________________________________________
											End case 
										End if 
									End for each 
								End if 
							End if 
							
							//______________________________________________________
						: (Match regex:C1019("(?mi-s)ARRAY\\s|TABLEAU\\s";$tLine;1))  // Array declaration
							
							$rgx:=Rgx_match(New object:C1471(\
								"pattern";"(?mi-s)^[^(]+\\(([^;]+);0\\)";\
								"target";$tLine))
							
							If ($rgx.success)
								
								$oVariable:=$oMethod.locales.query("value=:1";$rgx.match[1].data).pop()
								
								If ($oVariable=Null:C1517)
									
									$oVariable:=New object:C1471(\
										"value";$rgx.match[1].data)
									
									$oMethod.locales.push($oVariable)
									
								End if 
								
								$oVariable.array:=True:C214
								
								Case of 
										
										//______________________________________________________
									: ($tLine=(Command name:C538(219)+"@"))
										
										$oVariable.type:=Is real:K8:4
										
										//______________________________________________________
									: ($tLine=(Command name:C538(221)+"@"))
										
										$oVariable.type:=Is longint:K8:6
										
										//______________________________________________________
									: ($tLine=(Command name:C538(222)+"@"))
										
										$oVariable.type:=Is text:K8:3
										
										//______________________________________________________
									: ($tLine=(Command name:C538(223)+"@"))
										
										$oVariable.type:=Is boolean:K8:9
										
										//______________________________________________________
									: ($tLine=(Command name:C538(224)+"@"))
										
										$oVariable.type:=Is date:K8:7
										
										//______________________________________________________
									: ($tLine=(Command name:C538(279)+"@"))
										
										$oVariable.type:=Is picture:K8:10
										
										//______________________________________________________
									: ($tLine=(Command name:C538(280)+"@"))
										
										$oVariable.type:=Is pointer:K8:14
										
										//______________________________________________________
									: ($tLine=(Command name:C538(1221)+"@"))
										
										$oVariable.type:=Is object:K8:27
										
										//______________________________________________________
									: ($tLine=(Command name:C538(1222)+"@"))
										
										$oVariable.type:=Is BLOB:K8:12
										
										//______________________________________________________
									: ($tLine=(Command name:C538(1223)+"@"))
										
										$oVariable.type:=Is time:K8:8
										
										//______________________________________________________
									Else 
										
										$oVariable.type:=Null:C1517
										
										//______________________________________________________
								End case 
							End if 
							
							//______________________________________________________
						: ($tLine=("/"+"/@"))  // Comment line
							
							$oLine.status:="comment"
							
							//______________________________________________________
						: ($tLine="/*@")  // Begin comment block
							
							$oMethod.inCommentBlock:=True:C214
							$oLine.status:="comment"
							
							//______________________________________________________
						: ($oMethod.inCommentBlock)  // In comment block
							
							$oLine.status:="comment"
							
							//______________________________________________________
						: ($tLine="@*/")  // End comment block
							
							$oMethod.inCommentBlock:=False:C215
							$oLine.status:="comment"
							
							//______________________________________________________
						Else   // Extract local variables
							
							$rgx:=Rgx_match(New object:C1471(\
								"pattern";"(?m-si)(?<!\\.)(\\$\\w+)";\
								"target";$tLine;\
								"all";True:C214))
							
							If ($rgx.success)
								
								For each ($t;$rgx.match.extract("data").distinct())
									
									If (Not:C34(Match regex:C1019("(?mi-s)(\\$\\{?\\d+\\}?)";$t;1)))
										
										$oVariable:=$oMethod.locales.query("value=:1";$t).pop()
										
										If ($oVariable=Null:C1517)
											
											$oVariable:=New object:C1471(\
												"value";$t)
											
											$oMethod.locales.push($oVariable)
											
										End if 
										
										If ($oVariable.type=Null:C1517)
											
											$oVariable.code:=$tline
											
											$l:=Private_Lon_Declaration_Type($t)
											
											Case of 
													
													//______________________________________________________
												: ($l#0)
													
													If ($l=1)
														
														$l:=Is text:K8:3
														
													Else 
														
														$l:=101
														$oVariable.array:=True:C214
														$l:=Is text:K8:3
														
													End if 
													
													$oVariable.type:=$l
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)\\"+$t+":=\"[^\"]*\"|"+Command name:C538(16)+"\\(\\"+$t+"\\)";$oLine.code;1))
													
													$oVariable.type:=Is text:K8:3
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)\\"+$t+"[:><]?[=><]?\\d+\\"+$oMethod.decimalSeparator+"\\d+";$oLine.code;1))
													
													$oVariable.type:=Is real:K8:4
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)\\"+$t+"[:><]?[=><]?\\d+";$oLine.code;1))
													
													$oVariable.type:=Is longint:K8:6
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)\\"+$t+":=(?:"+Command name:C538(214)+"|"+Command name:C538(215)+")";$oLine.code;1))
													
													$oVariable.type:=Is boolean:K8:9
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)\\"+$t+":=(?:"+Command name:C538(1471)+"|"+Command name:C538(1218)+"|"+Command name:C538(1597)+")|\\.";$oLine.code;1))
													
													$oVariable.type:=Is object:K8:27
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)\\"+$t+":="+Command name:C538(1472);$oLine.code;1))
													
													$oVariable.type:=Is collection:K8:32
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)\\"+$t+":=(?:(?:!\\d+-\\d+-\\d+!)|"+Command name:C538(33)+")";$oLine.code;1))
													
													$oVariable.type:=Is date:K8:7
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)\\"+$t+":=(?:(?:\\?\\d+:\\d+:\\d+\\?)|"+Command name:C538(178)+")";$oLine.code;1))
													
													$oVariable.type:=Is time:K8:8
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)\\"+$t+":=(?:(?:->)|"+Command name:C538(304)+"\\([^)]*\\))";$oLine.code;1))
													
													$oVariable.type:=Is pointer:K8:14
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)(?:For|Boucle)+\\s*\\((?:(\\"+$t+"))|(?:[^;]+(?:;[^;]+)?;(\\"+$t+"))";$oLine.code;1))
													
													$oVariable.type:=Is longint:K8:6
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)\\"+$t+":="+Command name:C538(1597)+"\\(";$oLine.code;1))
													
													$oVariable.type:=Is object:K8:27
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)(?:If|Si|Not|Non)\\s*\\(\\"+$t+"\\)";$oLine.code;1))
													
													$oVariable.type:=Is boolean:K8:9
													
													//______________________________________________________
												: (Match regex:C1019("(?m-si)"\
													+Command name:C538(1055)+"\\(\\"+$t\
													+"|"+Command name:C538(866)+"\\(\\"+$t\
													+"|"+Command name:C538(865)+"\\(\\"+$t\
													+"|\\"+$t+":="+Command name:C538(865)\
													+"|"+"\\"+$t+":="+Command name:C538(864)+"\\s[^(]*\\(|"+Command name:C538(864)+"\\s[^(]*\\(\\"+$t+""\
													+"|"+Command name:C538(1093)+"\\(\\"+$t\
													;$oLine.code;1))
													
													$oVariable.type:=Is text:K8:3
													
													//______________________________________________________
												Else 
													
													$oVariable.type:=Null:C1517
													
													//______________________________________________________
											End case 
										End if 
									End if 
								End for each 
							End if 
							
							//______________________________________________________
					End case 
				End if 
				
				$oMethod.lines.push($oLine)
				
			End for each 
			
			$oMethod.locales:=$oMethod.locales.orderBy("value asc")
			$oMethod.parameters:=$oMethod.parameters.orderBy("value asc")
			
			//______________________________________________________
	End case 
End if 