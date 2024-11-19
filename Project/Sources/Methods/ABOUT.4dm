//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Method : ABOUT
// Created 24/03/06 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($text : Text)

var $Lon_Bottom; $Lon_Height; $Lon_Left; $Lon_Right; $Lon_Top; $Lon_W : Integer
var $Lon_Width : Integer

var <>About_Lon_Flip; <>About_Lon_AutoHide; <>About_Lon_Image : Integer
var <>About_Txt_Buffer; <>About_Txt_Macro; <>About_Txt_Displayed : Text

If (Count parameters:C259>0)
	
	If (Length:C16($text)>0)
		
		<>About_Lon_AutoHide:=Num:C11($text="AutoHide")
		
	End if 
End if 

If (<>About_Lon_AutoHide=0)
	
	GET WINDOW RECT:C443($Lon_Left; $Lon_Top; $Lon_Right; $Lon_Bottom; Frontmost window:C447)
	
	FORM GET PROPERTIES:C674("ABOUT"; $Lon_Width; $Lon_Height)
	
	$Lon_Left+=((($Lon_Right-$Lon_Left)\2)-($Lon_Width\2))
	$Lon_Top+=((($Lon_Bottom-$Lon_Top)\3)-($Lon_Height\2))
	$Lon_W:=Open window:C153($Lon_Left; $Lon_Top; $Lon_Left+$Lon_Width; $Lon_Top+$Lon_Height; Pop up window:K34:14)
	
Else 
	
	$Lon_W:=Open form window:C675("ABOUT"; Pop up form window:K39:11; On the right:K39:3; At the bottom:K39:6)
	
End if 

DIALOG:C40("ABOUT")