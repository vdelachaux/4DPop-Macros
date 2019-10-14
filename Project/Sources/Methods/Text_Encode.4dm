//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Methode : Private_Encode_Text
  // Created 24/02/06 par Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Encodes Text $1 with the encoding $2 (UTF-8 if $2 is missing)
  // ----------------------------------------------------
  // Modified by vdl (08/10/07)
  // 2004 -> v11
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BLOB:C604($Blb_Buffer)
C_TEXT:C284($Txt_charSet;$Txt_result;$Txt_Target)

If (False:C215)
	C_TEXT:C284(Text_Encode ;$0)
	C_TEXT:C284(Text_Encode ;$1)
	C_TEXT:C284(Text_Encode ;$2)
End if 

$Txt_Target:=$1

If (Count parameters:C259>=2)
	
	$Txt_charSet:=$2
	
End if 

If (Length:C16($Txt_charSet)=0)
	
	$Txt_charSet:="UTF-8"
	
End if 

If (Length:C16($Txt_Target)>0)
	
	CONVERT FROM TEXT:C1011($Txt_Target;$Txt_charSet;$Blb_Buffer)
	$Txt_result:=BLOB to text:C555($Blb_Buffer;Mac text without length:K22:10)
	
End if 

$0:=$Txt_result