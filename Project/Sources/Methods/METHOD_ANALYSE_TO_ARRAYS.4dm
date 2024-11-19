//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : METHOD_ANALYSE_TO_ARRAYS
// ID[343B51683A1C4F40A7E8BC192481999C]
// Created #3-2-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Populates 3 arrays with the types, labels and descriptions of parameters of a method.
// ----------------------------------------------------
// Modified by Vincent de Lachaux (23/12/13)
// Adding description of the extraction of the parameters
// ----------------------------------------------------
// Modified by Vincent de Lachaux (04/02/14)
// Adding management of objects
// Optimization: the obsolete types was put at the end
// ----------------------------------------------------
// Declarations
var $1 : Text
var $2 : Pointer
var $3 : Pointer
var $4 : Pointer

var $Boo_stop : Boolean
var $Lon_i; $Lon_index; $Lon_indice; $Lon_parameters; $Lon_typeNumber; $Lon_x : Integer
var $Ptr_arrayComments; $Ptr_arrayLabels; $Ptr_arrayTypes : Pointer
var $Txt_comment; $Txt_label; $Txt_method : Text

ARRAY LONGINT:C221($tLon_length; 0)
ARRAY LONGINT:C221($tLon_positions; 0)
ARRAY TEXT:C222($tTxt_comments; 0)
ARRAY TEXT:C222($tTxt_labels; 0)
ARRAY TEXT:C222($tTxt_types; 0)

If (False:C215)
	_O_C_TEXT:C284(METHOD_ANALYSE_TO_ARRAYS; $1)
	_O_C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $2)
	_O_C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $3)
	_O_C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $4)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=4; "Missing parameter"))
	
	$Txt_method:=$1  // Text of the method to analyse
	$Ptr_arrayTypes:=$2  // Pointer to the array of types to populate
	$Ptr_arrayLabels:=$3  // Pointer to the array of labels to populate
	$Ptr_arrayComments:=$4  // Pointer to the array of comments to populate
	
	ARRAY TEXT:C222($tTxt_commands; 15)
	$tTxt_commands{1}:=Command name:C538(283)  // C_LONGINT
	$tTxt_commands{2}:=Command name:C538(284)  // C_TEXT
	$tTxt_commands{3}:=Command name:C538(285)  // C_REAL
	$tTxt_commands{4}:=Command name:C538(306)  // C_TIME
	$tTxt_commands{5}:=Command name:C538(301)  // C_POINTER
	$tTxt_commands{6}:=Command name:C538(286)  // C_PICTURE
	$tTxt_commands{7}:=Command name:C538(307)  // C_DATE
	$tTxt_commands{8}:=Command name:C538(305)  // C_BOOLEAN
	$tTxt_commands{9}:=Command name:C538(604)  // C_BLOB
	$tTxt_commands{10}:=Command name:C538(1216)  // C_OBJECT
	$tTxt_commands{11}:=Command name:C538(282)  // C_INTEGER
	$tTxt_commands{12}:=Command name:C538(352)  // C_GRAPH
	$tTxt_commands{13}:=Command name:C538(293)  // C_STRING
	$tTxt_commands{14}:=Command name:C538(1488)  // C_COLLECTION
	$tTxt_commands{15}:=Command name:C538(1683)  // C_VARIANT
	
	ARRAY TEXT:C222($tTxt_argumentType; 15)
	$tTxt_argumentType{1}:=Localized string:C991("LongInteger")
	$tTxt_argumentType{2}:=Localized string:C991("Text")
	$tTxt_argumentType{3}:=Localized string:C991("Real")
	$tTxt_argumentType{4}:=Localized string:C991("Time")
	$tTxt_argumentType{5}:=Localized string:C991("Pointer")
	$tTxt_argumentType{6}:=Localized string:C991("Picture")
	$tTxt_argumentType{7}:=Localized string:C991("Date")
	$tTxt_argumentType{8}:=Localized string:C991("Boolean")
	$tTxt_argumentType{9}:=Localized string:C991("BLOB")
	$tTxt_argumentType{10}:=Localized string:C991("Object")
	$tTxt_argumentType{11}:=Localized string:C991("Integer")
	$tTxt_argumentType{12}:=Localized string:C991("Graph")
	$tTxt_argumentType{13}:=Localized string:C991("Alpha")
	$tTxt_argumentType{14}:=Localized string:C991("Collection")
	$tTxt_argumentType{15}:="Variant"
	
	$Lon_typeNumber:=Size of array:C274($tTxt_commands)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

Repeat 
	
	$Lon_index:=$Lon_index+1
	
	ARRAY TEXT:C222($tTxt_patterns; $Lon_typeNumber)
	
	For ($Lon_i; 1; $Lon_typeNumber; 1)
		
		$tTxt_patterns{$Lon_i}:="(?m)^"+$tTxt_commands{$Lon_i}+"\\s*\\([^\\)]*\\$"+String:C10($Lon_index)+"[;\\)]"
		
	End for 
	
	If (Match regex:C1019("(?m)^[\\$\\u25CA[<>]](\\w+):=\\$"+String:C10($Lon_index)+"(?:.*?//([^\\r$]*))*$"; $Txt_method; 1; $tLon_positions; $tLon_length))
		
		// Get label
		$Txt_label:=Substring:C12($Txt_method; $tLon_positions{1}; $tLon_length{1})
		
		// Remove prefix if any (the 1 to 4 first characters before an underscore)
		$Lon_x:=Position:C15("_"; $Txt_label)
		
		If ($Lon_x>0)\
			 & ($Lon_x<=5)
			
			$Txt_label:=Substring:C12($Txt_label; $Lon_x+1)
			
		End if 
		
		// Remove suffix if any (the 1 to 2 last characters after an underscore)
		$Lon_x:=Position:C15("_"; $Txt_label)
		
		If ($Lon_x>0)\
			 & ($Lon_x>=(Length:C16($Txt_label)-3))
			
			$Txt_label:=Substring:C12($Txt_label; 1; $Lon_x-1)
			
		End if 
		
		$Txt_comment:=Choose:C955(Size of array:C274($tLon_positions)>1; Substring:C12($Txt_method; $tLon_positions{2}; $tLon_length{2}); "")
		
	Else 
		
		// Not found
		$Txt_label:="Param_"+String:C10($Lon_index)
		$Txt_comment:=""
		
	End if 
	
	$Boo_stop:=True:C214
	
	For ($Lon_i; 1; $Lon_typeNumber; 1)
		
		If (Match regex:C1019($tTxt_patterns{$Lon_i}; $Txt_method; 1; $tLon_positions; $tLon_length))
			
			APPEND TO ARRAY:C911($tTxt_types; $tTxt_argumentType{$Lon_i})
			APPEND TO ARRAY:C911($tTxt_labels; $Txt_label)
			APPEND TO ARRAY:C911($tTxt_comments; $Txt_comment)
			
			$Lon_i:=MAXLONG:K35:2-1  // STOP
			$Boo_stop:=False:C215
			
		End if 
	End for 
Until ($Boo_stop)

// Variable number of parameters of the same type
For ($Lon_i; 1; $Lon_typeNumber; 1)
	
	If (Match regex:C1019("(?m)^"+$tTxt_commands{$Lon_i}+"\\s*\\([^\\)]*\\$\\{(\\d+)\\}"; $Txt_method; 1; $tLon_positions; $tLon_length))
		
		$Lon_indice:=Num:C11(Substring:C12($Txt_method; $tLon_positions{1}; $tLon_length{1}))
		
		While (Size of array:C274($tTxt_types)<$Lon_indice)
			
			APPEND TO ARRAY:C911($tTxt_types; "Undefined")
			APPEND TO ARRAY:C911($tTxt_labels; "Param_"+String:C10(Size of array:C274($tTxt_types)))
			APPEND TO ARRAY:C911($tTxt_comments; "")
			
		End while 
		
		$tTxt_types{$Lon_indice}:=$tTxt_argumentType{$Lon_i}
		$tTxt_labels{$Lon_indice}:=$tTxt_labels{$Lon_indice}+" ; … ; N"
		
		$Lon_i:=MAXLONG:K35:2-1  // STOP
		
	End if 
End for 

// Type of the function if any
For ($Lon_i; 1; $Lon_typeNumber; 1)
	
	If (Match regex:C1019("(?m)^"+$tTxt_commands{$Lon_i}+"\\s*\\([^\\)]*\\$0[^\\)]*"; $Txt_method; 1; $tLon_positions; $tLon_length))
		
		$tTxt_types{0}:=$tTxt_argumentType{$Lon_i}
		
		If (Match regex:C1019("(?m)^\\$0:=[\\$\\u25CA[<>]](\\w+)"+"(?:.*?//([^\\r$]*))*$"; $Txt_method; 1; $tLon_positions; $tLon_length))
			
			$Txt_label:=Substring:C12($Txt_method; $tLon_positions{1}; $tLon_length{1})
			
			// Remove prefix if any (the 1 to 4 first characters before an underscore)
			$Lon_x:=Position:C15("_"; $Txt_label)
			
			If ($Lon_x>0)\
				 & ($Lon_x<=5)
				
				$Txt_label:=Substring:C12($Txt_label; $Lon_x+1)
				
			End if 
			
			// Remove suffix if any (the 1 to 2 last characters after an underscore)
			$Lon_x:=Position:C15("_"; $Txt_label)
			
			If ($Lon_x>0)\
				 & ($Lon_x>=(Length:C16($Txt_label)-3))
				
				$Txt_label:=Substring:C12($Txt_label; 1; $Lon_x-1)
				
			End if 
			
			$tTxt_labels{0}:=$Txt_label
			
			$tTxt_comments{0}:=Choose:C955(Size of array:C274($tLon_positions)>1; Substring:C12($Txt_method; $tLon_positions{2}; $tLon_length{2}); "")
			
		End if 
		
		$Lon_i:=MAXLONG:K35:2-1  // STOP
		
	End if 
End for 

//%W-518.1
COPY ARRAY:C226($tTxt_types; $Ptr_arrayTypes->)
COPY ARRAY:C226($tTxt_labels; $Ptr_arrayLabels->)
COPY ARRAY:C226($tTxt_comments; $Ptr_arrayComments->)
//%W+518.1

// ----------------------------------------------------
// End