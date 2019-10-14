  //  ----------------------------------------------------
  //  Methode : Méthode objet :◊M4DPop_util
  //  Created : 31/01/06 by Vincent de Lachaux
  //  ----------------------------------------------------
  //  Description
  // 
  //  ---------------------------------------------------- 
C_BOOLEAN:C305($Boo_styled)
C_LONGINT:C283($Lon_choice;$Lon_i;$Lon_start;$Lon_stop)
C_TEXT:C284($Txt_edited;$Txt_popup;$Txt_toInsert)

ARRAY TEXT:C222($tTxt_Tags;8)
$tTxt_Tags{1}:="date"
$tTxt_Tags{2}:="time"
$tTxt_Tags{3}:="user_4D"
$tTxt_Tags{4}:="user_os"
$tTxt_Tags{5}:="version_4D"
$tTxt_Tags{6}:="database_name"
$tTxt_Tags{7}:="method_name"
$tTxt_Tags{8}:="form_name"

For ($Lon_i;1;8;1)
	
	$Txt_popup:=$Txt_popup+$tTxt_Tags{$Lon_i}+";"
	
End for 

$Lon_choice:=Pop up menu:C542($Txt_popup)

If ($Lon_choice#0)
	
	$Txt_toInsert:="<"+$tTxt_Tags{$Lon_choice}+"/>"
	$Txt_edited:=Get edited text:C655
	$Boo_styled:=OBJECT Is styled text:C1261(*;"comment")
	
	GET HIGHLIGHT:C209(<>Txt_buffer;$Lon_start;$Lon_stop)
	
	If (Length:C16($Txt_edited)=0)
		
		If ($Boo_styled)
			
			ST SET PLAIN TEXT:C1136(*;"comment";$Txt_toInsert)
			
		Else 
			
			<>Txt_buffer:=$Txt_toInsert
			
		End if 
		
	Else 
		
		If ($Boo_styled)
			
			ST SET PLAIN TEXT:C1136(*;"comment";$Txt_toInsert;ST Start highlight:K78:13;ST End highlight:K78:14)
			
		Else 
			
			<>Txt_buffer:=Substring:C12(<>Txt_buffer;1;$Lon_start-1)+$Txt_toInsert+"/>"+Substring:C12(<>Txt_buffer;$Lon_stop)
			
		End if 
	End if 
	
	$Lon_stop:=$Lon_start+Length:C16($Txt_toInsert)+(3*Num:C11(Not:C34($Boo_styled)))
	HIGHLIGHT TEXT:C210(<>Txt_buffer;$Lon_stop;$Lon_stop)
	
End if 