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

C_TEXT:C284($t_path)

If (False:C215)
	C_TEXT:C284(doc_gTxt_Add_DocumentToFolder ;$0)
	C_TEXT:C284(doc_gTxt_Add_DocumentToFolder ;$1)
	C_TEXT:C284(doc_gTxt_Add_DocumentToFolder ;$2)
End if 

$t_path:=$1

If ($t_path[[Length:C16($t_path)]]#Folder separator:K24:12)
	
	$t_path:=$t_path+Folder separator:K24:12
	
End if 

$0:=$t_path+$2