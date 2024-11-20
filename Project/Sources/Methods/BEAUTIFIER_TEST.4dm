//%attributes = {"invisible":true}
// MARK: REMOVE EMPTY LINES AT THE BEGIN OF THE METHOD
var $count; $i; $x : Integer
var $Txt; $that : Text
var $b : Boolean

// MARK: PRESERVE COMMENT BEFORE OPENING
If (True:C214)
	
	// MARK: A LINE OF COMMENTS MUST BE PRECEDED BY A LINE BREAK
	$Txt:="toto"
	
	//ALL COMMENT WILL BE PRECEDED BY A SPACE AND THE FIRST LETTER WILL BE CAPITALIZED
	
	Case of 
		: (True:C214)  //"Case of” elements will be preceded by a comment line, according to the level, if it is not already a comment
			
			Case of 
					//mark:- DON'T ADD SEPARATOR LINE HERE
				: (True:C214)
					
					If (True:C214)  //comment
						
						If (True:C214)
							
							For ($i; 1; 10; 1)
								
								While ($b)
									
									//comment
									$count+=$x
									
								End while 
							End for 
							
							// Use ternary operator instead If…Else…End if
							$Txt:=$count=1 ? $that : "that"
							
							// #ACI0097825
							$count:=$b ? 1 : 2
							
						End if 
					End if 
				: (True:C214)
					
					Case of 
						: (True:C214)
							
							If (True:C214)
								
								If (True:C214)
									
									For ($i; 1; 10; 1)
/*
         THIS IS A MULTILINES BLOCK
                                                           */
										While ($b)
											
											// mark: THESE
											// 3 LINES
											// REMAIN GROUPED
											$count+=$x
/* A ONE-LINE BLOCK IS CONSIDERED A ONE-LINE COMMENT */
											
										End while   // GROUPING CLOSURE INSTRUCTIONS BELOW
										
									End for 
									
								End if 
								
							End if 
							
/*NOT A BLOCK*/$count:=$count*$i
							$count:=True:C214 ? 1 : 2/*NOT A BLOCK*/
							
						: (True:C214)
							Case of 
								: (True:C214)
									If (True:C214)
										If (True:C214)
											For ($i; 1; 10; 1)
												While ($b)
													//comment
													$count+=$x
												End while 
											End for 
										End if 
									End if 
								: (True:C214)
									$count:=1
									$count:=2
								: (True:C214)
									For ($i; 1; 10; 1)
										$count:=$count*$i
										// mark:SPLIT LITERAL OBJECT WITH MORE THAN 2 MEMBERS
										var $o : Object:={hello: "hello"; world: "World"}
										
										$o:={property1: "value1"; property2: "value2"; property3: "value3"; property4: "value4"; property5: "value5"}
										// SAME FOR COLLECTIONS
										var $c : Collection:=["hello"; "world"]
										
										$c:=[1; 2; "hello"; "world"]
										
										// mark:SPLIT KEY/VALUE COMMANDS
										var $root; $node; $xpath : Text
										var $pic : Picture
										
										OB SET:C1220($o; "property"; 0; "property1"; 1; "property2"; 2; "property3"; 3)
										
										OB SET:C1220($o; "property"; 12-(10*2); "property1"; "value1"; "property2"; "valu2"; "property3"; "value3")  // Test2
										
										OB SET:C1220($o; "property"; "value"; "property1"; {test: "hello"; test2: "world"}; "property2"; "valu2"; "property3"; "value3")
										
										OB SET:C1220($o; "property"; "value")
										
										//OB SET($o; "property"; 0; "property1"; 1; "property2"; 2; "property3"; 3; "zz")/* ERROR IN PARAMETER COUNT */
										
										SVG SET ATTRIBUTE:C1055(*; "toto"; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")
										
										SVG SET ATTRIBUTE:C1055($pic; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")
										
										SVG SET ATTRIBUTE:C1055($pic; "id"; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment
										
										SVG SET ATTRIBUTE:C1055(*; "toto"; "id"; "attribute"; "value"; "attribute1"; "value1")
										
										SVG SET ATTRIBUTE:C1055(*; "toto"; "id"; "attribute"; "value")
										
										SVG SET ATTRIBUTE:C1055($pic; "id"; "attribute"; "value")  // Comment
										
										DOM SET XML ATTRIBUTE:C866($node; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment
										
										DOM SET XML ATTRIBUTE:C866($node; "attribute"; "value")  // Comment
										
										$node:=DOM Create XML element:C865($root; $xpath; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment
										
										//ST SET ATTRIBUTES(*; "toto"; 10; 20; "attribute"; 0; "attribute1"; 1; "attribute2"; 2)  // Comment
										
										//ST SET ATTRIBUTES($txt; $startSel; $endSel; "attribute"; "value"; "attribute1"; "value1"; "attribute2"; "value2")  // Comment
										
										$o:=New object:C1471("property1"; 1; "property2"; 2)
										
										$count:=$count*$i
										
										var $isWindows; $isMac; $isLinux : Boolean
										$txt:=Choose:C955($isWindows; "windows"; Choose:C955($isMac; "mac"; Choose:C955($isLinux; "linux"; "?")))  //comment
										
										
										//mark:REMOVE THE MULTIPLE EMPTY LINES ABOVE
									End for 
									//BLOCK {
									Begin SQL
										
										SELECT *
										FROM _USER_COLUMNS
										INTO:test
										
									End SQL
									//}
									
								Else 
									
									//mark:DELETE THE MULTIPLE EMPTY LINES BELOW
									
									
									
									
									
									var $v
									
									$v:=""
									//mark:OPTIMIZE COMPARISON WITH AN EMPTY STRING
									If ($v="")
										
									End if 
							End case 
						: (True:C214)
							Try
								$x:=1
							Catch
								$count:=$count*$i
							End try
						Else 
							While ($b)
								//%R-
								$x:=1  //Don't add line before a closing compiler directive comment
								//%R+
							End while 
					End case 
				: (True:C214)
					For ($i; 1; 10; 1)
						$count:=$count*$i
					End for 
				Else 
					While ($b)
						$count+=$x
					End while 
			End case 
		: (True:C214)
			For ($i; 1; 10; 1)
				continue
				For ($i; 1; 10; 1)
					For ($i; 1; 10; 1)
						$count:=$count*$i
					End for 
					break
				End for 
			End for 
		Else 
			While ($b)
				$count+=$x
			End while 
			return 
	End case 
Else 
	If ((Length:C16($txt)=0) | (Length:C16($txt)#0)) && (True:C214)  //SPLIT TEST LINES WITH & AND |
		$Txt:="titi"
	End if 
End if 
//mark:REMOVE EMPTY LINES AT THE END OF THE METHOD