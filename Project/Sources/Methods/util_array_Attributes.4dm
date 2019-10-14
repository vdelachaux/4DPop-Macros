//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : util_array_Attributes
  // Created 29/06/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($1)
C_POINTER:C301($2)
C_POINTER:C301($3)
C_POINTER:C301($4)

C_LONGINT:C283($Lon_Columns;$Lon_Dimension;$Lon_Size;$Lon_x)
C_TEXT:C284($Txt_Buffer;$Txt_Tempo_1;$Txt_Tempo_2)

If (False:C215)
	C_TEXT:C284(util_array_Attributes ;$1)
	C_POINTER:C301(util_array_Attributes ;$2)
	C_POINTER:C301(util_array_Attributes ;$3)
	C_POINTER:C301(util_array_Attributes ;$4)
End if 

$Txt_Buffer:=$1

$Lon_Columns:=-1
$Lon_Size:=-1
$Lon_Dimension:=0

$Txt_Tempo_1:=""
$Txt_Tempo_2:=""

$Lon_x:=Position:C15(";";$Txt_Buffer)

If ($Lon_x>0)
	
	$Txt_Tempo_1:=Substring:C12($Txt_Buffer;$Lon_x+1)
	$Txt_Tempo_1:=Replace string:C233($Txt_Tempo_1;")";"")
	
	If (str_isNumeric ($Txt_Tempo_1))
		
	Else 
		$Txt_Tempo_1:="-1"
	End if 
	
	$Txt_Buffer:=Substring:C12($Txt_Buffer;$Lon_x+1)
	
End if 

$Lon_x:=Position:C15(";";$Txt_Buffer)

If ($Lon_x>0)
	
	$Txt_Tempo_2:=Substring:C12($Txt_Buffer;$Lon_x+1)
	$Txt_Tempo_2:=Replace string:C233($Txt_Tempo_2;")";"")
	
	If (str_isNumeric ($Txt_Tempo_2))
		
	Else 
		$Txt_Tempo_2:="-1"
	End if 
	
	$Lon_Dimension:=2
	$Lon_Columns:=Num:C11($Txt_Tempo_1)
	$Lon_Size:=Num:C11($Txt_Tempo_2)
	
Else 
	
	$Lon_Dimension:=1
	$Lon_Size:=Num:C11($Txt_Tempo_1)
	
End if 

$2->:=$Lon_Dimension
$3->:=$Lon_Size
$4->:=$Lon_Columns