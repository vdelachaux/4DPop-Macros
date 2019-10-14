Case of 
		  //-----------------------------------------------------
	: (Form event code:C388=On Load:K2:1)
		LISTBOX SELECT ROW:C912(Self:C308->;1)
		  //-----------------------------------------------------
	: (Form event code:C388=On Double Clicked:K2:5)
		If (Self:C308->#0)
			ACCEPT:C269
		End if 
		  //-----------------------------------------------------
	Else 
		SET TIMER:C645(30*60)  //auto-hide
		  //-----------------------------------------------------
End case 