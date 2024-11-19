//%attributes = {}
var $x : Integer:=1

If (True:C214)
	$x:=1
End if 





Case of 
		
	: (True:C214)  // True
		
		Case of 
				
			: (True:C214)
				
				If (True:C214)
					
					//comment
					While (True:C214)
						
						//do
					End while 
					
				End if 
				Case of 
						
					: (True:C214)
						
						If (True:C214)
							
							//comment
							While (True:C214)
								
								//do
							End while 
							
						End if 
						
					: (False:C215)
						
						Case of 
								
							: (True:C214)
								
								If (True:C214)
									
									//comment
									While (True:C214)
										
										//do
									End while 
									
								End if 
								
							: (False:C215)
								
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
								
								
							Else 
								
								// A "Case of" statement should never omit "Else"
						End case 
						
					Else 
						
						// A "Case of" statement should never omit "Else"
				End case 
			: (False:C215)
				
				//
				
			Else 
				
				// A "Case of" statement should never omit "Else"
		End case 
		
		//mark:-hello world
	: (False:C215)  // False
		
		//
	Else   // Else
		
		// A "Case of" statement should never omit "Else"
End case 

