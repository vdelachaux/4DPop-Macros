//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : Private_Txt_Get_Preferences
// Created 06/05/06 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)

C_TEXT:C284($Txt_Name; $Txt_Value)

If (False:C215)
	C_TEXT:C284(Preferences_Get; $0)
	C_TEXT:C284(Preferences_Get; $1)
End if 

$Txt_Name:=$1

If (_o_Preferences("Get_Value"; $Txt_Name; ->$Txt_Value))
	
	$0:=$Txt_Value
	
End if 