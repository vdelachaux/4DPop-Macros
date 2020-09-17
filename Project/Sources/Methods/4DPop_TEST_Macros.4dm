//%attributes = {}
var $o : Object
var $t : Text

// In compiled mode we propose to create the test method
If (Is compiled mode:C492)
	
	ALERT:C41(Get localized string:C991("MessagestoTryANewMacro"))
	
	CONFIRM:C162(Get localized string:C991("wouldYouWantToCreateThisMethodNow?"))
	
	If (OK=1)
		
		$t:=Get localized string:C991("testMethodForMacros")+Command name:C538(284)+"($Txt_method;$Txt_highlighted)\r\r"+Get localized string:C991("in_txt_methodTheFullMethodContent")+Command name:C538(997)+"(1;$Txt_method)\r\r"+Get localized string:C991("in_txt_highlightedTheHighlightedText")+Command name:C538(997)+"(2;$Txt_highlighted)\r\r"
		
		METHOD SET CODE:C1194("4DPop_TEST_Macros"; $t; *)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros"; Attribute invisible:K72:6; True:C214; *)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros"; Attribute shared:K72:10; True:C214; *)
		
		METHOD OPEN PATH:C1213("4DPop_TEST_Macros"; *)
		
	End if 
	
Else 
	
	// It's our sandbox…
	
	Case of 
			
			//________________________________________
		: (True:C214)  //evaluate
			
			GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $t)
			
			If (Length:C16($t)>0)
				
				$o:=Formula from string:C1601($t)
				ALERT:C41(String:C10($o.call()))
				
			Else 
				
				// A "If" statement should never omit "Else" 
				
			End if 
			
			//________________________________________
		: (True:C214)
			
			$o:=cs:C1710.declaration.new().parse()
			
			If ($o.variables.length>0)
				
				$o.formWindow:=Open form window:C675("NEW_DECLARATION"; Movable form dialog box:K39:8; Horizontally centered:K39:1; At the top:K39:5; *)
				DIALOG:C40("NEW_DECLARATION"; $o)
				
				If (Bool:C1537(OK))
					
					SET MACRO PARAMETER:C998(Choose:C955($o.selection; Highlighted method text:K5:18; Full method text:K5:17); $o.method)
					
				End if 
				
				CLOSE WINDOW:C154
				
			Else 
				
				ALERT:C41("No local variable or parameter into the method!")
				
			End if 
			
			//______________________________________________________
	End case 
End if 
