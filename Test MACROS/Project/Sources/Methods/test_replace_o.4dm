//%attributes = {"invisible":true,"preemptive":"capable"}

If (True:C214)
	
	_O_DISABLE BUTTON:C193(OK)
	
	_O_DISABLE BUTTON:C193(*; "monBouton")
	
End if 

If (True:C214)
	
	
	_O_ENABLE BUTTON:C192(OK)
	
	_O_ENABLE BUTTON:C192(*; "monBouton")
	
End if 


If (True:C214)
	
	_O_C_STRING:C293(10; $string)
	
	_O_C_STRING:C293(test_replace_o; 10; $string; $string; $string)
	
End if 


If (True:C214)
	
	_O_C_INTEGER:C282($integer)
	
	_O_C_INTEGER:C282(test_replace_o; $integer; $string; $string)
	
End if 

If (True:C214)
	
	_O_ARRAY STRING:C218(10; $array; 0)
	
	_O_ARRAY STRING:C218(10; $array; 0; 0)
	
End if 
