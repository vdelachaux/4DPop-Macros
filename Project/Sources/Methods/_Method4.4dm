//%attributes = {}
var $x : Integer:=1

Case of 
		
	: (True:C214)  // True
		
		//
		
		// Mark:-
	: (False:C215)  // False
		
		//
	Else   // Else
		
		// A "Case of" statement should never omit "Else"
End case 

Case of 
		
	: (True:C214)
		
		If (True:C214)
			
			//comment
			While (True:C214)
				
				//do
			End while 
			
		End if 
		
	: (False:C215)
		
		//
		
	Else 
		
		// A "Case of" statement should never omit "Else"
End case 