  //  ----------------------------------------------------
  //  Method: object method: ◊M4DPop_util
  //  Created : 31/01/06 by Vincent de Lachaux
  //  ----------------------------------------------------
C_BOOLEAN:C305($styled)
C_LONGINT:C283($end;$start)
C_TEXT:C284($t;$tag)
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

var $menu:=cs:C1710.ui.menu.new("no-localization")

For each ($t;$c)
	
	$menu.append($t;$t)
	
End for each 

If ($menu.popup().selected)
	
	$tag:="<"+$menu.choice+"/>"
	$styled:=OBJECT Is styled text:C1261(*;"comment")
	
	GET HIGHLIGHT:C209(*;"comment";$start;$end)
	
	If (Length:C16(Get edited text:C655)=0)
		
		If ($styled)
			
			ST SET PLAIN TEXT:C1136(*;"comment";$tag)
			
		Else 
			
			Form:C1466.text:=$tag
			
		End if 
		
	Else 
		
		If ($styled)
			
			ST SET PLAIN TEXT:C1136(*;"comment";$tag;ST Start highlight:K78:13;ST End highlight:K78:14)
			
		Else 
			
			Form:C1466.text:=Substring:C12(Form:C1466.text;1;$start-1)+$tag+"/>"+Substring:C12(Form:C1466.text;$end)
			
		End if 
	End if 
	
	$end:=$start+Length:C16($tag)+(3*Num:C11(Not:C34($styled)))
	HIGHLIGHT TEXT:C210(*;"comment";$end;$end)
	
End if 