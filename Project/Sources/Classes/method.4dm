Class extends macro

// Method-related macro actions (modern rewrite of the legacy dispatcher METHODS):
//  • create()     — extract the current selection into a new project method
//  • attributes() — toggle the attributes of the selected method

Class constructor()
	
	Super:C1705()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Extract the highlighted selection into a new project method and replace it with the method call
Function create()
	
	ARRAY TEXT:C222($names; 0x0000)
	METHOD GET NAMES:C1166($names; *)
	
	var $name : Text:=Replace string:C233(Localized string:C991("methodN"); "{count}"; String:C10(Size of array:C274($names)))
	
	Repeat 
		
		$name:=Request:C163(Localized string:C991("methodName"); $name; Localized string:C991("CommonCreate"))
		
		If (OK=1)
			
			If (Find in array:C230($names; $name)>0)
				
				ALERT:C41(Localized string:C991("error_AlreadyMethodeWithThatName"))
				
				OK:=0  // GAME OVER…
				
			End if 
			
		Else 
			
			OK:=2  // STOP
			
		End if 
		
	Until (OK>=1)
	
	If (OK=1)
		
		This:C1470.setHighlightedText($name)
		
		METHOD SET CODE:C1194($name; This:C1470.highlighted; *)
		METHOD OPEN PATH:C1213($name; *)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display a pop up menu to toggle the attributes of the selected method
Function attributes($target : Text)
	
	If (Length:C16($target)=0)
		
		$target:=Current method path:C1201
		
	End if 
	
	If (Length:C16($target)=0)
		
		return 
		
	End if 
	
	var $menu : Text:=Create menu:C408
	
	APPEND MENU ITEM:C411($menu; Localized string:C991("Proc_info_invisible"))
	SET MENU ITEM PARAMETER:C1004($menu; -1; String:C10(Attribute invisible:K72:6))
	SET MENU ITEM MARK:C208($menu; -1; \
		Choose:C955(METHOD Get attribute:C1169($target; Attribute invisible:K72:6; *); Char:C90(18); ""))
	
	APPEND MENU ITEM:C411($menu; Localized string:C991("Proc_info_availableThrough4dHtml"))
	SET MENU ITEM PARAMETER:C1004($menu; -1; String:C10(Attribute published Web:K72:7))
	SET MENU ITEM MARK:C208($menu; -1; \
		Choose:C955(METHOD Get attribute:C1169($target; Attribute published Web:K72:7; *); Char:C90(18); ""))
	
	APPEND MENU ITEM:C411($menu; Localized string:C991("Proc_info_offeredAsAWebService"))
	SET MENU ITEM PARAMETER:C1004($menu; -1; String:C10(Attribute published SOAP:K72:8))
	var $wsdl : Boolean:=METHOD Get attribute:C1169($target; Attribute published SOAP:K72:8; *)
	SET MENU ITEM MARK:C208($menu; -1; \
		Choose:C955($wsdl; Char:C90(18); ""))
	
	APPEND MENU ITEM:C411($menu; Localized string:C991("Proc_info_publishedInWsdl"))
	SET MENU ITEM PARAMETER:C1004($menu; -1; String:C10(Attribute published WSDL:K72:9))
	SET MENU ITEM MARK:C208($menu; -1; \
		Choose:C955(METHOD Get attribute:C1169($target; Attribute published WSDL:K72:9; *); Char:C90(18); ""))
	
	If (Not:C34($wsdl))
		
		DISABLE MENU ITEM:C150($menu; -1)
		
	End if 
	
	APPEND MENU ITEM:C411($menu; Localized string:C991("Proc_info_sharedByComponentsAndHostDatabase"))
	SET MENU ITEM PARAMETER:C1004($menu; -1; String:C10(Attribute shared:K72:10))
	SET MENU ITEM MARK:C208($menu; -1; \
		Choose:C955(METHOD Get attribute:C1169($target; Attribute shared:K72:10; *); Char:C90(18); ""))
	
	APPEND MENU ITEM:C411($menu; Localized string:C991("Proc_info_availableThroughSql"))
	SET MENU ITEM PARAMETER:C1004($menu; -1; String:C10(Attribute published SQL:K72:11))
	SET MENU ITEM MARK:C208($menu; -1; \
		Choose:C955(METHOD Get attribute:C1169($target; Attribute published SQL:K72:11; *); Char:C90(18); ""))
	
	APPEND MENU ITEM:C411($menu; Localized string:C991("Proc_info_executeOnServer"))
	SET MENU ITEM PARAMETER:C1004($menu; -1; String:C10(Attribute executed on server:K72:12))
	SET MENU ITEM MARK:C208($menu; -1; \
		Choose:C955(METHOD Get attribute:C1169($target; Attribute executed on server:K72:12; *); Char:C90(18); ""))
	
	var $choice : Integer:=Num:C11(Dynamic pop up menu:C1006($menu))
	
	If ($choice#0)
		
		METHOD SET ATTRIBUTE:C1192($target; $choice; \
			Not:C34(METHOD Get attribute:C1169($target; $choice; *)); *)
		
	End if 
	
	RELEASE MENU:C978($menu)
	