//%attributes = {"invisible":true,"shared":true,"preemptive":"incapable"}
// In compiled mode we propose to create the test method
ARRAY TEXT:C222($methods; 0x0000)
METHOD GET NAMES:C1166($methods; "4DPop_TEST_Macros"; *)

If (Size of array:C274($methods)=0)
	
	CONFIRM:C162(Localized string:C991("wouldYouWantToCreateThisMethodNow?"))
	
	If (Bool:C1537(OK))
		
		var $c:=[]
		$c.push(Localized string:C991("testMethodForMacros"); \
			"var $Txt_method; $Txt_highlighted : Text"; \
			""; \
			Localized string:C991("in_txt_methodTheFullMethodContent"); \
			"GET MACRO PARAMETER:C997(Full method text:K5:17; $Txt_method)"; \
			""; \
			Localized string:C991("in_txt_highlightedTheHighlightedText"); \
			"GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $Txt_highlighted)"; \
			""; \
			"// It's our sandbox…")
		
		METHOD SET CODE:C1194("4DPop_TEST_Macros"; $c.join("\r"); *)
		METHOD SET ATTRIBUTE:C1192("4DPop_TEST_Macros"; \
			Attribute invisible:K72:6; True:C214; \
			Attribute shared:K72:10; True:C214; *)
		
		METHOD OPEN PATH:C1213("4DPop_TEST_Macros"; *)
		
	End if 
	
Else 
	
	// It's our sandbox…
	
	Case of 
			
			//________________________________________
		: (True:C214)  //evaluate
			
			GET MACRO PARAMETER:C997(Full method text:K5:17; $t)
			
			var $rgx:=cs:C1710.regex.new($t; "(?ms-i)New object\\((.*?)\\)")
			var $t:=$rgx.substitute("{\\1}")
			
			$rgx.setTarget($t)
			$rgx.setPattern("(?msi)\"(?=[^0-9])([^-\\s\"]+)\"\\s*;\\s*([^;}]+)")
			$t:=$rgx.substitute("\\1:\\2")
			
			SET MACRO PARAMETER:C998(Full method text:K5:17; $t)
			
			//________________________________________
		: (True:C214)  //evaluate
			
			GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $t)
			
			If (Length:C16($t)>0)
				
				var $ƒ:=Formula from string:C1601($t)
				ALERT:C41(String:C10($ƒ.call()))
				
			End if 
			
			//________________________________________
		: (True:C214)
			
			var $o : Object:=cs:C1710.declaration.new().parse()
			
			If ($o.variables.length>0)
				
				$o.formWindow:=Open form window:C675("DECLARATION"; Movable form dialog box:K39:8; Horizontally centered:K39:1; At the top:K39:5; *)
				DIALOG:C40("DECLARATION"; $o)
				
				If (Bool:C1537(OK))
					
					SET MACRO PARAMETER:C998(Choose:C955($o.withSelection; Highlighted method text:K5:18; Full method text:K5:17); $o.method)
					
				End if 
				
				CLOSE WINDOW:C154
				
			Else 
				
				ALERT:C41("No local variable or parameter into the method!")
				
			End if 
			
			//______________________________________________________
	End case 
End if 
