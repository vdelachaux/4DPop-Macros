//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : Private_Boo_Set_Preferences
// Created 06/05/06 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($Boo_OK)
C_TEXT:C284($Txt_Name; $Txt_Value)

If (False:C215)
	C_BOOLEAN:C305(_o_Preferences_Set; $0)
	C_TEXT:C284(_o_Preferences_Set; $1)
	C_TEXT:C284(_o_Preferences_Set; $2)
End if 

$Txt_Name:=$1
$Txt_Value:=$2
$Boo_OK:=_o_Preferences("Set_Value"; $Txt_Name; ->$Txt_Value)

$0:=$Boo_OK