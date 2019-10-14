C_LONGINT:C283($Lon_x)
C_TEXT:C284($Txt_Buffer;$Txt_Frappe)

$Txt_Frappe:=Keystroke:C390

Case of 
		  //……………………………………………………………………………
	: (Form event code:C388=On After Edit:K2:43)
		If (Position:C15($Txt_Frappe;"0123456789abcdefghjiklmnopqrstuvwxyz _")>0)
			$Txt_Buffer:=Get edited text:C655
			$Lon_x:=Find in array:C230(<>tTxt_Labels;("$"*Num:C11(<>tTxt_Labels{1}="$@"))+$Txt_Buffer+"@")
		End if 
		  //……………………………………………………………………………
	: (Character code:C91($Txt_Frappe)=Backspace key:K12:29)
		$Lon_x:=-99
		  //……………………………………………………………………………
	: (Character code:C91($Txt_Frappe)=Up arrow key:K12:18)
		$Lon_x:=<>tBoo_ListBox-Num:C11(<>tBoo_ListBox>1)
		  //……………………………………………………………………………
	: (Character code:C91($Txt_Frappe)=11)
		$Lon_x:=1
		  //……………………………………………………………………………
	: (Character code:C91($Txt_Frappe)=12)
		$Lon_x:=Size of array:C274(<>tBoo_ListBox)
		  //……………………………………………………………………………
	: (Character code:C91($Txt_Frappe)=Down arrow key:K12:19)
		$Lon_x:=<>tBoo_ListBox+Num:C11(<>tBoo_ListBox<Size of array:C274(<>tBoo_ListBox))
		  //……………………………………………………………………………
	: (Position:C15($Txt_Frappe;"0123456789abcdefghjiklmnopqrstuvwxyz _")>0)
		$Txt_Buffer:=Get edited text:C655
		$Lon_x:=Find in array:C230(<>tTxt_Labels;("$"*Num:C11(<>tTxt_Labels{1}="$@"))+$Txt_Buffer+"@")
		  //……………………………………………………………………………
	Else 
		$Lon_x:=-Character code:C91($Txt_Frappe)
		FILTER KEYSTROKE:C389("")
		  //……………………………………………………………………………
End case 

Case of 
		  //.....................................................    
	: ($Lon_x>0)
		LISTBOX SELECT ROW:C912(<>tBoo_ListBox;$Lon_x;0)
		OBJECT SET SCROLL POSITION:C906(<>tBoo_ListBox;$Lon_x;*)
		  //..................................................... 
	: ($Lon_x=-99)
		Self:C308->:=""
		  //..................................................... 
	Else 
		BEEP:C151
		Self:C308->:=""
		  //..................................................... 
End case 

<>timerEvent:=1
SET TIMER:C645(40)
