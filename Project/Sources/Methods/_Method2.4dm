//%attributes = {}
// hello world
var $t : Text
var $c : Collection
var $x : Integer:=1
var $o : Object
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
	//%R-
	$x:=1
	//%R+
	
End if 
