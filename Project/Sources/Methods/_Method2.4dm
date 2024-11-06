//%attributes = {}
// hello world
var $t : Text
var $i; $j : Integer
var $x : Integer
var $o : Object
var $c : Collection

var $Txt_line : Text:="http://something"

If (True:C214) && (True:C214)  // if
	// Affectation
Else 
	
	// A "If" statement should never omit "Else"
	If (True:C214)  // true
		Use ($o)  // use
			If (True:C214)
				
				// A "If" statement should never omit "Else"
				
				Use ($o)
					
					For each ($t; $c)
						
						//
						For each ($t; $c)
							
							Case of 
								: (True:C214)
									//
								: (False:C215)
									//
									
									//mark:-
								Else 
									
									//comment
									While (True:C214)
										
										//do
									End while 
									
							End case 
							//
						End for each 
						
					End for each 
					
				End use   // 1 End use
			End if   // 1 End if
			
		End use   // 2 End use
	End if   // 2 End if
	
End if   // 3 End if

//mark:-test
If (True:C214)
	If (True:C214)
		If (True:C214)
			If (True:C214)
				//%R-
				$x:=1
				//%R+
			End if 
			For ($i; 1; 100; 1)
				
				For ($j; 1; 100)
					
					Case of 
						: (True:C214)
							continue
						: (False:C215)
							Begin SQL
								
							End SQL
							
							//
						Else 
							Use ($o)
								//
							End use 
							break
					End case 
				End for 
			End for 
		End if 
		
	End if 
	
End if 