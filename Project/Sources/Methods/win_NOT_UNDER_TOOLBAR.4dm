//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Method : win_NOT_UNDER_TOOLBAR
// Created 28/10/05 by Vincent de Lachaux
// ----------------------------------------------------
// Moves the current form window down if it sits under the toolbar; returns its reference
// ----------------------------------------------------
#DECLARE() : Integer

var $bottom; $left; $right; $top : Integer
var $window : Integer:=Current form window:C827

GET WINDOW RECT:C443($left; $top; $right; $bottom; $window)

If ($top<Tool bar height:C1016)
	
	SET WINDOW RECT:C444($left; 50; $right; $bottom+Tool bar height:C1016+10; $window)
	
End if 

return $window
