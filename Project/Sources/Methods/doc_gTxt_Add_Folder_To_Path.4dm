//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Méthode : x_gTxt_Add_Folder_To_Path
  // Created 26/10/05 par Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_BOOLEAN:C305($3)

C_TEXT:C284($Txt_Directory_Symbol;$Txt_Path)

If (False:C215)
	C_TEXT:C284(doc_gTxt_Add_Folder_To_Path ;$0)
	C_TEXT:C284(doc_gTxt_Add_Folder_To_Path ;$1)
	C_TEXT:C284(doc_gTxt_Add_Folder_To_Path ;$2)
	C_BOOLEAN:C305(doc_gTxt_Add_Folder_To_Path ;$3)
End if 

$Txt_Path:=$1
$Txt_Directory_Symbol:=System folder:C487[[Length:C16(System folder:C487)]]

If ($Txt_Path[[Length:C16($Txt_Path)]]#$Txt_Directory_Symbol)
	
	$Txt_Path:=$Txt_Path+$Txt_Directory_Symbol
	
End if 

$Txt_Path:=$Txt_Path+$2+$Txt_Directory_Symbol

If (Count parameters:C259>2)
	
	If ($3)
		
		If (Test path name:C476($Txt_Path)#Is a folder:K24:2)
			
			CREATE FOLDER:C475($Txt_Path)
			
		End if 
	End if 
End if 

$0:=$Txt_Path