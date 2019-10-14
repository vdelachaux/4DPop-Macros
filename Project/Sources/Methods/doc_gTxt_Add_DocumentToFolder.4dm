//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Méthode : x_gTxt_Add_Document_To_Folder
  // Created 26/10/05 par Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_TEXT:C284($Txt_Directory_Symbol;$Txt_Path)

If (False:C215)
	C_TEXT:C284(doc_gTxt_Add_DocumentToFolder ;$0)
	C_TEXT:C284(doc_gTxt_Add_DocumentToFolder ;$1)
	C_TEXT:C284(doc_gTxt_Add_DocumentToFolder ;$2)
End if 

$Txt_Path:=$1
$Txt_Directory_Symbol:=System folder:C487[[Length:C16(System folder:C487)]]

If ($Txt_Path[[Length:C16($Txt_Path)]]#$Txt_Directory_Symbol)
	
	$Txt_Path:=$Txt_Path+$Txt_Directory_Symbol
	
End if 

$0:=$Txt_Path+$2