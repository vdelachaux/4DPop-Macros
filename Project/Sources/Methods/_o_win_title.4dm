//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : win_title
// Database: 4DPop Macros
// ID[69FD98BC194541619466271C60F30493]
// Created #17-7-2014 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Return the target (form/method name) of an editor window
// ----------------------------------------------------
// Declarations
_O_C_TEXT:C284($0)
_O_C_LONGINT:C283($1)

_O_C_LONGINT:C283($l)
_O_C_TEXT:C284($t)
_O_C_COLLECTION:C1488($c)

If (False:C215)
	_O_C_TEXT:C284(_o_win_title; $0)
	_O_C_LONGINT:C283(_o_win_title; $1)
End if 

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$l:=$1
	
Else 
	
	$l:=Frontmost window:C447
	
End if 

// ----------------------------------------------------
$c:=Split string:C1554(Get window title:C450($l); ":"; sk trim spaces:K86:2)
$t:=$c[Num:C11($c.length>1)]

// #17-7-2014
// PC bug: The window title is suffixed with a '*' when method is modified and not saved
$t:=Replace string:C233($t; " *"; "")
$t:=Replace string:C233($t; "*"; "")

// ----------------------------------------------------
// Return
$0:=$t

// ----------------------------------------------------
// End