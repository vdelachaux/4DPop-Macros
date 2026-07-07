//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Method : ABOUT
// Created 24/03/06 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($text : Text)

var $autoHide : Boolean:=($text="AutoHide")

If (Not:C34($autoHide))
	
	var $left; $top; $right; $bottom : Integer
	GET WINDOW RECT:C443($left; $top; $right; $bottom; Frontmost window:C447)
	
	var $width; $height : Integer
	FORM GET PROPERTIES:C674("ABOUT"; $width; $height)
	
	$left+=((($right-$left)\2)-($width\2))
	$top+=((($bottom-$top)\3)-($height\2))
	var $winRef:=Open window:C153($left; $top; $left+$width; $top+$height; Pop up window:K34:14)
	
Else 
	
	$winRef:=Open form window:C675("ABOUT"; Pop up form window:K39:11; On the right:K39:3; At the bottom:K39:6)
	
End if 

DIALOG:C40("ABOUT"; {\
autoHide: $autoHide; \
displayed: ""; \
flip: 180; \
image: 3000; \
picture: getResource("scomber"; "PICT"); \
version: "4DPop Macros"})