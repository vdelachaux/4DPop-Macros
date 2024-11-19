//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : util_Lon_array_declaration
// Database: 4DPop Macros
// ID[88F13770CF8D4D67A33D2BECEAE3581E]
// Created 02/01/07 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Extract array description
// ----------------------------------------------------
// Modified by Vincent de Lachaux (21/01/14)
// Complete refactoring
// ----------------------------------------------------
// Declarations
_O_C_LONGINT:C283($0)
_O_C_TEXT:C284($1)
_O_C_POINTER:C301(${2})

_O_C_BOOLEAN:C305($Boo_ignore; $Boo_localArray)
_O_C_LONGINT:C283($Lon_column; $Lon_error; $Lon_parameters; $Lon_row; $Lon_stringLength; $Lon_x)
_O_C_POINTER:C301($Ptr_Array)
_O_C_TEXT:C284($Txt_arrayName; $Txt_column; $Txt_pattern; $Txt_row; $Txt_target)

If (False:C215)
	_O_C_LONGINT:C283(_o_array_declaration; $0)
	_O_C_TEXT:C284(_o_array_declaration; $1)
	_O_C_POINTER:C301(_o_array_declaration; ${2})
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2; "Missing parameter"))
	
	$Txt_target:=$1  //text to analyse
	$Ptr_Array:=$2  // Pointer to array to populate
	
	//default values
	CLEAR VARIABLE:C89($Ptr_Array->{0})
	$Ptr_Array->:=0
	$Boo_ignore:=True:C214
	$Lon_row:=-1
	$Lon_column:=-1
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
ARRAY TEXT:C222($tTxt_results; 0x0000; 0x0000)
$Txt_pattern:="^(?:(\\d*);)?([^;]*);([^;)]*)(?:;([^)]*))?\\).*$"
$Lon_error:=_o_Rgx_ExtractText($Txt_pattern; $Txt_target; "1 2 3 4"; ->$tTxt_results)

If ($Lon_error=0)
	
	//string lenth for array string
	$Lon_stringLength:=Num:C11($tTxt_results{1}{1})
	
	//array name
	$Txt_arrayName:=$tTxt_results{1}{2}
	$Boo_localArray:=($Txt_arrayName[[1]]="$")
	
	//array size
	$Txt_row:=$tTxt_results{1}{3}
	
	Case of 
			
			//______________________________________________________
		: (_o_isNumeric($Txt_row))  //numeric declaration
			
			$Lon_row:=Num:C11($Txt_row)
			$Boo_ignore:=($Lon_row>0)
			
			If ($Boo_ignore)
				
				$Ptr_Array->{0}:=$Txt_arrayName
				
			End if 
			
			//______________________________________________________
		: ($Txt_row[[1]]="$")  //dimension is in a local variable
			
			$Ptr_Array->{0}:=$Txt_arrayName
			
			If ($Lon_parameters>=3)
				
				//Append to local variables
				_o_util_Lon_Local_in_line($Txt_row; $3)
				
			End if 
			
			//______________________________________________________
		: (Position:C15("0x"; $Txt_row)=1)  //exception
			
			$Lon_row:=Num:C11($Txt_row)
			$Ptr_Array->{0}:=$Txt_arrayName
			
			//______________________________________________________
		Else 
			
			//Global or interprocess
			
			//______________________________________________________
	End case 
	
	//two-dimensional Arrays
	$Txt_column:=$tTxt_results{1}{4}
	
	Case of 
			
			//______________________________________________________
		: (Length:C16($Txt_column)=0)
			
			//______________________________________________________
		: (_o_isNumeric($Txt_column))  //numeric declaration
			
			$Lon_column:=Num:C11($Txt_column)
			
			//______________________________________________________
		: ($Txt_column[[1]]="$")  //dimension is in a local variable
			
			If ($Lon_parameters>=3)
				
				//Append to local variables
				_o_util_Lon_Local_in_line($Txt_column; $3)
				
			End if 
			
			//______________________________________________________
		: (Position:C15("0x"; $Txt_column)=1)  //exception
			
			$Lon_column:=Num:C11($Txt_column)
			
			//______________________________________________________
		Else 
			
			//Global or interprocess
			
			//______________________________________________________
	End case 
	
	If ($Boo_localArray)\
		 & (Not:C34($Boo_ignore))
		
		$Lon_x:=Find in array:C230($Ptr_Array->; $Txt_arrayName)
		
		If ($Lon_x=-1)
			
			APPEND TO ARRAY:C911($Ptr_Array->; $Txt_arrayName)
			$Lon_x:=Size of array:C274($Ptr_Array->)
			
			If ($Lon_parameters>=3)
				
				_o_util_Lon_Local_in_line($Txt_arrayName; $3)
				
			End if 
		End if 
		
		$Ptr_Array->:=$Lon_x
		
	End if 
	
	If ($Lon_parameters>=4)
		
		$4->:=$Lon_row
		
		If ($Lon_parameters>=5)
			
			$5->:=($Lon_column#-1)
			
		End if 
	End if 
End if 

$0:=$Lon_stringLength

// ----------------------------------------------------
// End