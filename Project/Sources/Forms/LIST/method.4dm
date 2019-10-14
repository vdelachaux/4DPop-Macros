  // ----------------------------------------------------
  // Methode : Méthode formulaire : M4DPop_List
  // ----------------------------------------------------
C_LONGINT:C283($Lon_Bottom;$Lon_Bottom_Screen;$Lon_CurrentWindow;$Lon_Event;$Lon_Height)
C_LONGINT:C283($Lon_Hide;$Lon_Left;$Lon_LineHeight;$Lon_Right;$Lon_Size)
C_LONGINT:C283($Lon_Top;$Lon_Unused;$Lon_Width)

$Lon_Event:=Form event code:C388
$Lon_Hide:=30*60  //Value of the timer to automatically hide

Case of 
		  //-----------------------------------------------------
	: ($Lon_Event=On Timer:K2:25)
		If (<>timerEvent<0)
			SET TIMER:C645(0)
			CANCEL:C270
		Else 
			<>Txt_buffer:=""
			<>timerEvent:=-1
			SET TIMER:C645($Lon_Hide)
		End if 
		  //-----------------------------------------------------
	: ($Lon_Event=On Deactivate:K2:10)
		SET TIMER:C645(0)
		<>Txt_buffer:=""
		  //-----------------------------------------------------
	: ($Lon_Event=On Load:K2:1)
		
		  //Put the focus variable off screen
		OBJECT MOVE:C664(*;"_focus";-1000;-1000;-1000;-1000)
		GOTO OBJECT:C206(*;"_focus")
		
		  //Get the number of lines to display
		$Lon_Size:=Size of array:C274(<>tTxt_Labels)
		
		  //Calculating the height of the window & if we must displaying the scrollbar
		  //{
		$Lon_CurrentWindow:=Current form window:C827
		SCREEN COORDINATES:C438($Lon_Unused;$Lon_Unused;$Lon_Unused;$Lon_Bottom_Screen)
		GET WINDOW RECT:C443($Lon_Left;$Lon_Top;$Lon_Right;$Lon_Bottom;$Lon_CurrentWindow)
		$Lon_LineHeight:=LISTBOX Get rows height:C836(<>tBoo_ListBox)
		$Lon_Height:=$Lon_LineHeight*$Lon_Size
		$Lon_Height:=$Lon_Height+15  //Hauteur de l'entête
		OBJECT SET SCROLLBAR:C843(*;"ListBox";False:C215;(($Lon_Top+$Lon_Height)>$Lon_Bottom_Screen))
		While (($Lon_Top+$Lon_Height)>$Lon_Bottom_Screen)
			$Lon_Height:=$Lon_Height-$Lon_LineHeight
		End while 
		$Lon_Bottom:=$Lon_Top+$Lon_Height
		  //}
		
		  //Optimal size of the first column
		  //{
		OBJECT GET BEST SIZE:C717(<>tTxt_Labels;$Lon_Width;$Lon_Unused;600)
		If (($Lon_Width+19)>210)
			$Lon_Right:=$Lon_Left+$Lon_Width+19
		End if 
		LISTBOX SET COLUMN WIDTH:C833(*;"M4DPop_tTxt_Labels";$Lon_Width+10)
		  //}
		
		  //Must we displaying the second column?
		  //{
		If (Length:C16(<>tTxt_Comments{1})=0)
			LISTBOX DELETE COLUMN:C830(<>tBoo_ListBox;2;1)
		Else 
			  //Yes :-> Get the optimal size of the second column
			  //{
			OBJECT GET BEST SIZE:C717(<>tTxt_Comments;$Lon_Width;$Lon_Unused;400)
			LISTBOX SET COLUMN WIDTH:C833(*;"M4DPop_tTxt_Comments";$Lon_Width)
			$Lon_Right:=$Lon_Right+$Lon_Width+19
			LISTBOX SET GRID:C841(<>tBoo_ListBox;False:C215;True:C214)
			  //}
			  //.....................................................
		End if 
		  //}
		
		  //Finally, resize the window …
		SET WINDOW RECT:C444($Lon_Left;$Lon_Top;$Lon_Right;$Lon_Bottom;$Lon_CurrentWindow)
		
		  //… & set window title
		<>Txt_Title:=<>Txt_Title+" : "+String:C10($Lon_Size)
		
		<>Txt_buffer:=""
		<>timerEvent:=-1
		  //-----------------------------------------------------
	: ($Lon_Event=On Unload:K2:2)
		SET TIMER:C645(0)
		  //-----------------------------------------------------
	Else 
		SET TIMER:C645(0)
		SET TIMER:C645($Lon_Hide)
		  //-----------------------------------------------------
End case 



