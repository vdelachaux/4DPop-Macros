//%attributes = {"invisible":true}
#DECLARE($data : Object)

var $i : Integer

ARRAY LONGINT:C221($windows; 0)
WINDOW LIST:C442($windows)

var $title : Text:=Localized string:C991("preferences")

For ($i; 1; Size of array:C274($windows); 1)
	
	If (Get window title:C450($windows{$i})=$title)
		
		// Already running -> move to foreground
		var $bottom; $left; $right; $top : Integer
		GET WINDOW RECT:C443($left; $top; $right; $bottom; $windows{$i})
		SET WINDOW RECT:C444($left; $top; $right; $bottom; $windows{$i})
		
		return 
		
	End if 
End for 

CALL WORKER:C1389(1; Formula:C1597(_SETTINGS))