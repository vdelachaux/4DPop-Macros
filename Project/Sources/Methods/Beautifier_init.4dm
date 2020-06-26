//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : Beautifier_init
// Database: 4DPop Macros
// ID[E6DE73DD5E4144629FB13DBEFCED98D6]
// Created #30-1-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($0)

C_LONGINT:C283($Lon_options;$Lon_parameters)

If (False:C215)
	C_LONGINT:C283(Beautifier_init;$0)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		// <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// Remove empty lines at the begin of method
$Lon_options:=0 ?+ 0

// Remove empty lines at the end of method
$Lon_options:=$Lon_options ?+ 1

// Line break before branching structures
$Lon_options:=$Lon_options ?+ 2

// Line break before and after sequential structures included
$Lon_options:=$Lon_options ?+ 3

// Separation line for Case of
$Lon_options:=$Lon_options ?+ 4

// Line break before looping structures
$Lon_options:=$Lon_options ?+ 5

// A key / value per line
$Lon_options:=$Lon_options ?+ 6

// Add the increment for the loops
$Lon_options:=$Lon_options ?+ 7

// Grouping closure instructions
$Lon_options:=$Lon_options ?+ 8

// Remove consecutive blank lines
$Lon_options:=$Lon_options ?+ 9

// A line of comments must be preceded by a line break
$Lon_options:=$Lon_options ?+ 10

// Split test lines with "&" and "|"
$Lon_options:=$Lon_options ?+ 11

// Replace comparisons to an empty string by length test
$Lon_options:=$Lon_options ?+ 12

// Replace "If(test) var:=x Else var:=y End if" by "var:=Choose(test;x;y)"
$Lon_options:=$Lon_options ?+ 13

// Replace deprecated command
$Lon_options:=$Lon_options ?+ 14

// Add a space after the comment note and capitalize the first letter
$Lon_options:=$Lon_options ?+ 15

// Var declarations instructions
$Lon_options:=$Lon_options ?+ 16

// ----------------------------------------------------
// Return
$0:=$Lon_options

// ----------------------------------------------------
// End