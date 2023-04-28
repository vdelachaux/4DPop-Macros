//%attributes = {"invisible":true,"preemptive":"incapable"}
  // ----------------------------------------------------
  // Method : Private_Boo_Paste_Regex_Pattern
  // Created 08/10/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_BOOLEAN:C305($0)

C_TEXT:C284($Txt_Converted;$Txt_ToConvert)

If (False:C215)
	C_BOOLEAN:C305(Private_Boo_Paste_Regex_Pattern ;$0)
End if 

$Txt_ToConvert:=Get text from pasteboard:C524

If (OK=1)\
 & (Length:C16($Txt_ToConvert)>0)
	
	$0:=True:C214
	
	  //To use a literal backslash in a pattern, precede it with a backslash ("\\").
	$Txt_Converted:=Replace string:C233($Txt_ToConvert;Char:C90(92);Char:C90(92)*2)
	
	  // The backslash character  followed by a special character, it takes away any special meaning that character may have.
	  // This use of backslash as an escape character applies both inside and outside character classes.
	  // This escaping enables the usage of characters like *, +, (, { as literals in a pattern.
	$Txt_Converted:=Replace string:C233($Txt_Converted;"*";"\\*")
	$Txt_Converted:=Replace string:C233($Txt_Converted;"+";"\\+")
	$Txt_Converted:=Replace string:C233($Txt_Converted;"(";"\\(")
	$Txt_Converted:=Replace string:C233($Txt_Converted;")";"\\)")
	$Txt_Converted:=Replace string:C233($Txt_Converted;"{";"\\{")
	$Txt_Converted:=Replace string:C233($Txt_Converted;"}";"\\}")
	
	$Txt_Converted:=Replace string:C233($Txt_Converted;Char:C90(Space:K15:42);"\\s")
	$Txt_Converted:=Replace string:C233($Txt_Converted;Char:C90(Carriage return:K15:38);"\\r")
	$Txt_Converted:=Replace string:C233($Txt_Converted;Char:C90(Line feed:K15:40);"\\n")
	$Txt_Converted:=Replace string:C233($Txt_Converted;Char:C90(Tab:K15:37);"\\t")
	
	  //$Txt_Converted:=Remplacer chaine($Txt_Converted;Caractere(ASCII Espace insécable );"\\xCA")
	$Txt_Converted:=Replace string:C233($Txt_Converted;" ";"\\xCA")
	
	If ($Txt_Converted[[1]]#"\"")
		
		$Txt_Converted:="\""+$Txt_Converted
		
	End if 
	
	If ($Txt_Converted[[Length:C16($Txt_Converted)]]#"\"")
		
		$Txt_Converted:=$Txt_Converted+"\""
		
	End if 
	
	SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$Txt_Converted+kCaret)
	
End if 