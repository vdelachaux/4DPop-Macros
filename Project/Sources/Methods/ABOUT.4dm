//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : ABOUT
// Created 24/03/06 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
C_TEXT:C284($1)

C_LONGINT:C283($Lon_Bottom; $Lon_Height; $Lon_Left; $Lon_Right; $Lon_Top; $Lon_W)
C_LONGINT:C283($Lon_Width)

If (False:C215)
	C_TEXT:C284(ABOUT; $1)
End if 

C_LONGINT:C283(<>About_Lon_Flip; <>About_Lon_AutoHide; <>About_Lon_Image)
C_TEXT:C284(<>About_Txt_Buffer; <>About_Txt_Macro; <>About_Txt_Displayed)

If (Count parameters:C259>0)
	
	If (Length:C16($1)>0)
		
		<>About_Lon_AutoHide:=Num:C11($1="AutoHide")
		
	End if 
End if 

If (<>About_Lon_AutoHide=0)
	
	GET WINDOW RECT:C443($Lon_Left; $Lon_Top; $Lon_Right; $Lon_Bottom; Frontmost window:C447)
	
	FORM GET PROPERTIES:C674("ABOUT"; $Lon_Width; $Lon_Height)
	
	$Lon_Left:=$Lon_Left+((($Lon_Right-$Lon_Left)\2)-($Lon_Width\2))
	$Lon_Top:=$Lon_Top+((($Lon_Bottom-$Lon_Top)\3)-($Lon_Height\2))
	$Lon_W:=Open window:C153($Lon_Left; $Lon_Top; $Lon_Left+$Lon_Width; $Lon_Top+$Lon_Height; Pop up window:K34:14)
	
Else 
	
	$Lon_W:=Open form window:C675("ABOUT"; Pop up form window:K39:11; On the right:K39:3; At the bottom:K39:6)
	
End if 

DIALOG:C40("ABOUT")