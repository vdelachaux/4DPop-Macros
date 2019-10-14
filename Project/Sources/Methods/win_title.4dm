//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : win_title
  // Database: 4DPop Macros
  // ID[69FD98BC194541619466271C60F30493]
  // Created #17-7-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_parameters;$Win_ref)
C_TEXT:C284($Txt_title)
C_COLLECTION:C1488($Col_)


If (False:C215)
	C_TEXT:C284(win_title ;$0)
	C_LONGINT:C283(win_title ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Win_ref:=$1
		
	Else 
		
		$Win_ref:=Frontmost window:C447
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Col_:=Split string:C1554(Get window title:C450($Win_ref);":";sk trim spaces:K86:2)

$Txt_title:=$Col_[Num:C11($Col_.length>1)]

  // #17-7-2014
  // PC bug: The window title is suffixed with a '*' when method is modified and not saved
$Txt_title:=Replace string:C233($Txt_title;" *";"")
$Txt_title:=Replace string:C233($Txt_title;"*";"")

  // ----------------------------------------------------
  // Return
$0:=$Txt_title

  // ----------------------------------------------------
  // End