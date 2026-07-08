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
	// Display a pop up menu to toggle the attributes of the current method
Function attributes($target : Text)
	
	If (Not:C34(This:C1470.projectMethod))
		
		ALERT:C41(Localized string:C991("attributesProjectMethodOnly"))
		
		return 
		
	End if 
	
	If (Length:C16($target)=0)
		
		$target:=Current method path:C1201
		
	End if 
	
	If (Length:C16($target)=0)
		
		return 
		
	End if 
	
	var $wsdl : Boolean:=METHOD Get attribute:C1169($target; Attribute published SOAP:K72:8; *)
	
	var $menu:=cs:C1710.ui.menu.new("no-localization")
	
	$menu.append(Localized string:C991("Proc_info_invisible"); String:C10(Attribute invisible:K72:6); METHOD Get attribute:C1169($target; Attribute invisible:K72:6; *))\
		.append(Localized string:C991("Proc_info_availableThrough4dHtml"); String:C10(Attribute published Web:K72:7); METHOD Get attribute:C1169($target; Attribute published Web:K72:7; *))\
		.append(Localized string:C991("Proc_info_offeredAsAWebService"); String:C10(Attribute published SOAP:K72:8); $wsdl)\
		.append(Localized string:C991("Proc_info_publishedInWsdl"); String:C10(Attribute published WSDL:K72:9); METHOD Get attribute:C1169($target; Attribute published WSDL:K72:9; *)).enable($wsdl)\
		.append(Localized string:C991("Proc_info_sharedByComponentsAndHostDatabase"); String:C10(Attribute shared:K72:10); METHOD Get attribute:C1169($target; Attribute shared:K72:10; *))\
		.append(Localized string:C991("Proc_info_availableThroughSql"); String:C10(Attribute published SQL:K72:11); METHOD Get attribute:C1169($target; Attribute published SQL:K72:11; *))\
		.append(Localized string:C991("Proc_info_executeOnServer"); String:C10(Attribute executed on server:K72:12); METHOD Get attribute:C1169($target; Attribute executed on server:K72:12; *))
	
	If ($menu.popup().selected)
		
		var $choice : Integer:=Num:C11($menu.choice)
		
		METHOD SET ATTRIBUTE:C1192($target; $choice; \
			Not:C34(METHOD Get attribute:C1169($target; $choice; *)); *)
		
	End if 
	