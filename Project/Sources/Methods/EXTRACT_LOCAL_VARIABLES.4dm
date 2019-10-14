//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : private_EXTRACT_LOCAL_VARIABLES
  // Created 14/04/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($1)
C_POINTER:C301($2)

C_LONGINT:C283($Lon_count;$Lon_i;$Lon_options)
C_POINTER:C301($Ptr_array)
C_TEXT:C284($Txt_method;$Txt_target)

If (False:C215)
	C_TEXT:C284(EXTRACT_LOCAL_VARIABLES ;$1)
	C_POINTER:C301(EXTRACT_LOCAL_VARIABLES ;$2)
End if 

ARRAY TEXT:C222(<>tTxt_lines;0)

$Txt_target:=$1  //"method" or "selection" (default)
$Ptr_array:=$2  //array to populate

If ($Txt_target="Method")  //…de la méthode…
	
	GET MACRO PARAMETER:C997(Full method text:K5:17;$Txt_method)
	
Else   //…ou de la sélection.
	
	GET MACRO PARAMETER:C997(Highlighted method text:K5:18;$Txt_method)
	
End if 

  //Split_Method
$Lon_options:=$Lon_options ?+ 0  // Pas les lignes vides
$Lon_options:=$Lon_options ?+ 1  // Pas les lignes de commentaires
Util_SPLIT_METHOD ($Txt_method;-><>tTxt_lines;$Lon_options)

  //$Lon_Error:=Rgx_SplitText ("\\r";$Txt_Method;->◊tTxt_Lines;(0 ?+ 10) ?+ 11)

For ($Lon_i;1;Size of array:C274(<>tTxt_lines);1)
	
	util_Lon_Local_in_line (<>tTxt_lines{$Lon_i};$Ptr_array)
	
End for 

$Lon_count:=Size of array:C274($Ptr_array->)
ARRAY LONGINT:C221($tLon_sortOrder;$Lon_count)
$Ptr_array->:=0

For ($Lon_i;1;$Lon_count;1)
	
	$Ptr_array->:=$Ptr_array->+1
	$tLon_sortOrder{$Lon_i}:=2*Num:C11(Position:C15("{";$Ptr_array->{$Lon_i})>0)
	
	If (str_isNumeric (Replace string:C233(Replace string:C233(Substring:C12($Ptr_array->{$Lon_i};2);"{";"");"}";"")))
		
	Else 
		
		  //%W-533.3
		$tLon_sortOrder{$Ptr_array->}:=20
		  //%W+533.3
		
	End if 
End for 

MULTI SORT ARRAY:C718($tLon_sortOrder;>;$Ptr_array->;>)