//%attributes = {"invisible":true,"preemptive":"capable"}

//REMOVE EMPTY LINES AT THE BEGIN OF THE METHOD
var $count; $i; $x : Integer
var $Txt; $that : Text
var $b : Boolean
//PRESERVE COMMENT BEFORE OPENING
If (True:C214)
	//A LINE OF COMMENTS MUST BE PRECEDED BY A LINE BREAK
	$Txt:="toto"
	Case of   //comment
		: (True:C214)  //comment
			Case of 
				: (True:C214)
					If (True:C214)  //comment
						If (True:C214)  //comment
							For ($i; 1; 10; 1)  //comment
								While ($b)
									//comment
									$count:=$count+$x
								End while 
							End for 
							//Use ternary operator instead If…Else…End if
							If ($count=1)
								
								$Txt:=$that
								
							Else 
								
								$Txt:="that"
								
							End if 
							//#ACI0097825
							If ($b)
								
								$count:=1
								
							Else 
								
								$count:=2
								
							End if 
							
						End if 
					End if 
				: (True:C214)
					Case of 
						: (True:C214)
							If (True:C214)  //comment
								If (True:C214)  //comment
									For ($i; 1; 10; 1)  //comment
										While ($b)
											//BEGIN GROUPED COMMENT
											//SUITE GROUPED COMMENT
											//END GROUPED COMMENT
											$count:=$count+$x
										End while   //GROUPING CLOSURE INSTRUCTIONS BELOW
										
									End for 
									
								End if 
								
							End if 
							
							$count:=Choose:C955(True:C214; 1; 2)  //text
							
						: (True:C214)
							Case of 
								: (True:C214)
									If (True:C214)  //comment
										If (True:C214)  //comment
											For ($i; 1; 10; 1)  //comment
												While ($b)
													//comment
													$count:=$count+$x
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
										
										// SPLIT LITERAL OBJECT
										var $o : Object:={property1: "value1"; property2: "value2"; property3: "value3"; property4: "value4"; property5: "value5"}
										// SPLIT LITERAL COLLECTIONS
										var $c : Collection:=[1; 2; "hello"; "world"]
										
										
										// SPLIT KEY/VALUE COMMANDS
										var $root : Text
										DOM SET XML ATTRIBUTE:C866($root; "name"; "value"; "name"; "value")
										
										$o:=New object:C1471("property1"; 1; "property2"; 2)
										
										
										
										
									End for   //REMOVE THE MULTIPLE EMPTY LINES ABOVE 
									
									//bloc {
									Begin SQL
										
										SELECT *
										FROM _USER_COLUMNS
										INTO:test
										
									End SQL
									//}
									
								Else   //DELETE THE MULTIPLE EMPTY LINES BELOW
									
									
									
									
									While ($b)
										$count:=$count+$x
									End while 
							End case 
						: (True:C214)
							For ($i; 1; 10; 1)
								$count:=$count*$i
							End for 
						Else 
							While ($b)
								//%R-
								$x:=1  //Don't add line before the closing compiler directive comment
								//%R+
							End while 
					End case 
				: (True:C214)
					For ($i; 1; 10; 1)
						$count:=$count*$i
					End for 
				Else 
					While ($b)
						$count:=$count+$x
					End while 
			End case 
		: (True:C214)
			For ($i; 1; 10; 1)
				$count:=$count*$i
			End for 
		Else 
			While ($b)
				$count:=$count+$x
			End while 
	End case 
Else 
	If (($txt="") | ($txt#"")) && (True:C214)  //SPLIT TEST LINES WITH & AND |
		$Txt:="titi"
	End if 
End if 
//REMOVE EMPTY LINES AT THE END OF THE METHOD



