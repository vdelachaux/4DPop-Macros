C_LONGINT:C283($indx)
C_OBJECT:C1216($event)

$event:=FORM Event:C1606

Case of 
		
		  //______________________________________________________
	: ($event.code=On Before Keystroke:K2:6)
		
		If (Character code:C91(Keystroke:C390)=Carriage return:K15:38)
			
			FILTER KEYSTROKE:C389("")
			GOTO OBJECT:C206(*;"rule")
			
		End if 
		
		  //______________________________________________________
	: ($event.code=On Losing Focus:K2:8)
		
		If (Length:C16(Form:C1466.ruleCurrent.value)=0)
			
			$indx:=Form:C1466.rule.indexOf(Form:C1466.ruleSelected[0])
			Form:C1466.rule.remove($indx)
			
			Form:C1466.selected[0].value:=Form:C1466.rule.extract("value").join(";";ck ignore null or empty:K85:5)
			
			If ($indx>Form:C1466.rule.length)
				
				$indx:=Form:C1466.rule.length
				
			End if 
			
			LISTBOX SELECT ROW:C912(*;"rule";$indx;lk replace selection:K53:1)
			Form:C1466.ruleCurrent:=Form:C1466.rule[0]
			
		End if 
		
		  //______________________________________________________
	: ($event.code=On Data Change:K2:15)
		
		If (Length:C16(Form:C1466.ruleCurrent.value)>0)
			
			Form:C1466.ruleSelected[0]:=Form:C1466.ruleCurrent
			Form:C1466.selected[0].value:=Form:C1466.rule.extract("value").join(";";ck ignore null or empty:K85:5)
			Form:C1466.rule:=Form:C1466.rule
			
		Else 
			
			$indx:=Form:C1466.rule.indexOf(Form:C1466.ruleSelected[0])
			Form:C1466.rule.remove($indx)
			
			Form:C1466.selected[0].value:=Form:C1466.rule.extract("value").join(";";ck ignore null or empty:K85:5)
			
			If ($indx>Form:C1466.rule.length)
				
				$indx:=Form:C1466.rule.length
				
			End if 
			
			LISTBOX SELECT ROW:C912(*;"rule";$indx;lk replace selection:K53:1)
			Form:C1466.ruleCurrent:=Form:C1466.rule[0]
			
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessary ("+$event.description+")")
		
		  //______________________________________________________
End case 