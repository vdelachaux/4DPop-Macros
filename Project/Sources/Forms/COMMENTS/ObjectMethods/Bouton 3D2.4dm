  //  ----------------------------------------------------
  //  Methode : Méthode objet :◊M4DPop_util
  //  Created : 31/01/06 by Vincent de Lachaux
  //  ----------------------------------------------------
C_BOOLEAN:C305($bStyled)
C_LONGINT:C283($end;$l;$start)
C_TEXT:C284($t;$tMenu;$tTag)
C_COLLECTION:C1488($c)

$c:=New collection:C1472(\
"date";\
"time";\
"user_4D";\
"user_os";\
"version_4D";\
"database_name";\
"method_name";\
"form_name"\
)

For each ($t;$c)
	
	$tMenu:=$tMenu+$t+";"
	
End for each 

$l:=Pop up menu:C542($tMenu)

If ($l#0)
	
	$tTag:="<"+$c[$l-1]+"/>"
	$bStyled:=OBJECT Is styled text:C1261(*;"comment")
	
	GET HIGHLIGHT:C209(*;"comment";$start;$end)
	
	If (Length:C16(Get edited text:C655)=0)
		
		If ($bStyled)
			
			ST SET PLAIN TEXT:C1136(*;"comment";$tTag)
			
		Else 
			
			Form:C1466.text:=$tTag
			
		End if 
		
	Else 
		
		If ($bStyled)
			
			ST SET PLAIN TEXT:C1136(*;"comment";$tTag;ST Start highlight:K78:13;ST End highlight:K78:14)
			
		Else 
			
			Form:C1466.text:=Substring:C12(Form:C1466.text;1;$start-1)+$tTag+"/>"+Substring:C12(Form:C1466.text;$end)
			
		End if 
	End if 
	
	$end:=$start+Length:C16($tTag)+(3*Num:C11(Not:C34($bStyled)))
	HIGHLIGHT TEXT:C210(*;"comment";$end;$end)
	
End if 