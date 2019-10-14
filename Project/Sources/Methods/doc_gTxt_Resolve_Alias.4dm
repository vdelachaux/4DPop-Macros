//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : doc_gTxt_Resolve_Alias
  // Created 18/09/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)

C_TEXT:C284($Txt_Buffer;$Txt_Err_Method)

If (False:C215)
	C_TEXT:C284(doc_gTxt_Resolve_Alias ;$0)
	C_TEXT:C284(doc_gTxt_Resolve_Alias ;$1)
End if 

If (Count parameters:C259>0)
	
	$0:=$1
	$Txt_Err_Method:=Method called on error:C704
	ON ERR CALL:C155(Current method name:C684)
	RESOLVE ALIAS:C695($1;$Txt_Buffer)
	
	If (OK=1)
		
		$0:=$Txt_Buffer
		
	End if 
	
	ON ERR CALL:C155($Txt_Err_Method)
	
Else 
	
	  //No error
	
End if 