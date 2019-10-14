//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : doc_SET_TYPE_AND_CREATOR
  // Created 05/05/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

C_LONGINT:C283($Lon_PlateForm)
C_TEXT:C284($Txt_Creator;$Txt_Path;$Txt_Type)

If (False:C215)
	C_TEXT:C284(doc_SET_TYPE_AND_CREATOR ;$1)
	C_TEXT:C284(doc_SET_TYPE_AND_CREATOR ;$2)
	C_TEXT:C284(doc_SET_TYPE_AND_CREATOR ;$3)
End if 

$Txt_Path:=$1

If (Count parameters:C259>1)
	
	$Txt_Type:=$2
	
	If (Count parameters:C259>2)
		
		$Txt_Creator:=$3
		
	End if 
End if 

_O_PLATFORM PROPERTIES:C365($Lon_PlateForm)

If ($Lon_PlateForm#Windows:K25:3)
	
	While (Test path name:C476($Txt_Path)#Is a document:K24:1)
		
		IDLE:C311
		
	End while 
	
	_O_SET DOCUMENT TYPE:C530($Txt_Path;$Txt_Type)
	_O_SET DOCUMENT CREATOR:C531($Txt_Path;$Txt_Creator)
	
End if 