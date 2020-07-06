C_TEXT:C284($t)
C_OBJECT:C1216($e; $o)

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Selection Change:K2:29)
		
		$o:=Form:C1466.current
		
		For each ($t; Form:C1466.types.extract("name"))
			
			OBJECT Get pointer:C1124(Object named:K67:5; $t)->:=False:C215
			
		End for each 
		
		
		If ($o.type#Null:C1517)
			
			OBJECT Get pointer:C1124(Object named:K67:5; Form:C1466.types[$o.type].name)->:=True:C214
			
		End if 
		
		SELECT LIST ITEMS BY REFERENCE:C630(OBJECT Get pointer:C1124(Object named:K67:5; "control")->; 1+Num:C11(Bool:C1537($o.array))+(2*Num:C11(Bool:C1537($o.parameter))))
		
		For each ($t; Form:C1466.notforArray)
			
			OBJECT SET ENABLED:C1123(*; $t; Not:C34(Bool:C1537($o.array)))
			
		End for each 
		
		GET LIST ITEM PROPERTIES:C631(*; "control"; 2; $b; $l; $i)
		SET LIST ITEM PROPERTIES:C386(*; "control"; 2; Not:C34((Bool:C1537($o.parameter))) & (Num:C11($o.type)#42); $l; $i)
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		//______________________________________________________
End case 