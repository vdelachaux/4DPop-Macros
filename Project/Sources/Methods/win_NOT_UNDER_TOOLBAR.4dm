//%attributes = {"invisible":true,"preemptive":"incapable"}
  // ----------------------------------------------------
  // Méthode : win_NOT_UNDER_TOOBAR
  // Created 28/10/05 par Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_LONGINT:C283($0)

C_LONGINT:C283($Lon_Bottom;$Lon_Left;$Lon_Right;$Lon_Top;$Lon_Window)

If (False:C215)
	C_LONGINT:C283(win_NOT_UNDER_TOOLBAR ;$0)
End if 

$Lon_Window:=Current form window:C827
GET WINDOW RECT:C443($Lon_Left;$Lon_Top;$Lon_Right;$Lon_Bottom;$Lon_Window)

If ($Lon_Top<Tool bar height:C1016)
	
	SET WINDOW RECT:C444($Lon_Left;50;$Lon_Right;$Lon_Bottom+Tool bar height:C1016+10;$Lon_Window)
	
End if 

$0:=$Lon_Window