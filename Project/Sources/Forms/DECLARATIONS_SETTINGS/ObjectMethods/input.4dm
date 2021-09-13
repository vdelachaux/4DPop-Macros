var $indx : Integer
var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Before Keystroke:K2:6)
		
		If (Character code:C91(Keystroke:C390)=Carriage return:K15:38)
			
			FILTER KEYSTROKE:C389("")
			GOTO OBJECT:C206(*; "rule")
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Losing Focus:K2:8)
		
		If (Form:C1466.rule.length>1)\
			 & (Length:C16(Form:C1466.ruleCurrent.value)=0)
			
			Form:C1466.rule.remove(Form:C1466.ruleIndex-1)
			Form:C1466.current.value:=Form:C1466.rule.extract("value").join(";"; ck ignore null or empty:K85:5)
			
			SET TIMER:C645(-1)
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Data Change:K2:15)
		
		If (Length:C16(Form:C1466.ruleCurrent.value)>0)
			
			Form:C1466.current.value:=Form:C1466.rule.extract("value").join(";"; ck ignore null or empty:K85:5)
			
		Else 
			
			If (Form:C1466.rule.length>1)
				
				Form:C1466.rule.remove(Form:C1466.ruleIndex-1)
				Form:C1466.current.value:=Form:C1466.rule.extract("value").join(";"; ck ignore null or empty:K85:5)
				
			End if 
		End if 
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessary ("+$e.description+")")
		
		//______________________________________________________
End case 