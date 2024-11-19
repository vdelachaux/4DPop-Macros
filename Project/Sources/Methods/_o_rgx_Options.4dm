//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : rgx_Options
// Created 28/09/07 by Vincent
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
_O_C_TEXT:C284($0)
_O_C_LONGINT:C283($1)

_O_C_LONGINT:C283($Lon_Options)
_O_C_TEXT:C284($Txt_Pattern)

If (False:C215)
	_O_C_TEXT:C284(_o_rgx_Options; $0)
	_O_C_LONGINT:C283(_o_rgx_Options; $1)
End if 

$Lon_Options:=$1

If ($Lon_Options ?? 0) | ($Lon_Options ?? 1) | ($Lon_Options ?? 2) | ($Lon_Options ?? 3)
	$Txt_Pattern:="(?"
	$Txt_Pattern:=$Txt_Pattern+("i"*Num:C11($Lon_Options ?? 0))
	$Txt_Pattern:=$Txt_Pattern+("m"*Num:C11($Lon_Options ?? 1))
	$Txt_Pattern:=$Txt_Pattern+("s"*Num:C11($Lon_Options ?? 2))
	$Txt_Pattern:=$Txt_Pattern+("x"*Num:C11($Lon_Options ?? 3))
	$Txt_Pattern:=$Txt_Pattern+")"
End if 

$0:=$Txt_Pattern