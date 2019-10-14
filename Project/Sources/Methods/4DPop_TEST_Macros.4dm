//%attributes = {}
C_TEXT:C284($Txt_buffer)
C_OBJECT:C1216($o)

ARRAY LONGINT:C221($tLon_buffer;0)

  // In compiled mode we propose to create the test method
If (Is compiled mode:C492)
	
	ALERT:C41(Get localized string:C991("MessagestoTryANewMacro"))
	
	CONFIRM:C162(Get localized string:C991("wouldYouWantToCreateThisMethodNow?"))
	
	If (OK=1)
		
		$Txt_buffer:=Get localized string:C991("testMethodForMacros")+Command name:C538(284)+"($Txt_method;$Txt_highlighted)\r\r"+Get localized string:C991("in_txt_methodTheFullMethodContent")+Command name:C538(997)+"(1;$Txt_method)\r\r"+Get localized string:C991("in_txt_highlightedTheHighlightedText")+Command name:C538(997)+"(2;$Txt_highlighted)\r\r"
		
		METHOD SET CODE:C1194("4DPop_TEST_Macros";$Txt_buffer;*)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros";Attribute invisible:K72:6;True:C214;*)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros";Attribute shared:K72:10;True:C214;*)
		
		METHOD OPEN PATH:C1213("4DPop_TEST_Macros";*)
		
	End if 
	
Else 
	
	  // It's our sandbox…
	
	Case of 
			
			  //________________________________________
		: (True:C214)
			
			  //______________________________________________________
		Else 
			
			ARRAY LONGINT:C221($tTxt_buffer;0x0000)
			
			$o:=New object:C1471(\
				"hello";True:C214;\
				"world";False:C215\
				)
			
			  //______________________________________________________
	End case 
End if 