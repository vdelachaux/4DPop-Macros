//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : Compiler_Rgx
// Created 28/09/07 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------

var rgxError : Integer

If (False:C215)
	_O_C_OBJECT:C1216(Rgx_match; $0)
	_O_C_OBJECT:C1216(Rgx_match; $1)
	
	// Public ----------------------------
	_O_C_LONGINT:C283(Rgx_ExtractText; $0)
	_O_C_TEXT:C284(Rgx_ExtractText; $1)
	_O_C_TEXT:C284(Rgx_ExtractText; $2)
	_O_C_TEXT:C284(Rgx_ExtractText; $3)
	_O_C_POINTER:C301(Rgx_ExtractText; $4)
	_O_C_LONGINT:C283(Rgx_ExtractText; $5)
	
	_O_C_TEXT:C284(Rgx_Get_Pattern; $0)
	_O_C_TEXT:C284(Rgx_Get_Pattern; $1)
	_O_C_TEXT:C284(Rgx_Get_Pattern; $2)
	_O_C_POINTER:C301(Rgx_Get_Pattern; $3)
	
	_O_C_LONGINT:C283(Rgx_MatchText; $0)
	_O_C_TEXT:C284(Rgx_MatchText; $1)
	_O_C_TEXT:C284(Rgx_MatchText; $2)
	_O_C_POINTER:C301(Rgx_MatchText; $3)
	_O_C_LONGINT:C283(Rgx_MatchText; $4)
	
	_O_C_LONGINT:C283(Rgx_SplitText; $0)
	_O_C_TEXT:C284(Rgx_SplitText; $1)
	_O_C_TEXT:C284(Rgx_SplitText; $2)
	_O_C_POINTER:C301(Rgx_SplitText; $3)
	_O_C_LONGINT:C283(Rgx_SplitText; $4)
	
	_O_C_LONGINT:C283(Rgx_SubstituteText; $0)
	_O_C_TEXT:C284(Rgx_SubstituteText; $1)
	_O_C_TEXT:C284(Rgx_SubstituteText; $2)
	_O_C_POINTER:C301(Rgx_SubstituteText; $3)
	_O_C_LONGINT:C283(Rgx_SubstituteText; $4)
	
	// Private ----------------------------
	_O_C_TEXT:C284(rgx_Options; $0)
	_O_C_LONGINT:C283(rgx_Options; $1)
End if 