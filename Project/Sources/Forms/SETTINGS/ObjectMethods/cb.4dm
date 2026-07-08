var $o : Object

If (Macintosh command down:C546)\
 | (Windows Alt down:C563)
	
	For each ($o; Form:C1466.beautifier)
		
		$o.on:=Form:C1466.current.on
		
	End for each 
	
	Form:C1466.beautifier:=Form:C1466.beautifier
	
End if 