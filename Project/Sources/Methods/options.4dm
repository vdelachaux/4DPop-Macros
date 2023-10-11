//%attributes = {"invisible":true}
#DECLARE($data : Object)

If (False:C215)
	C_OBJECT:C1216(options; $1)
End if 

var $title : Text
var $run : Boolean
var $bottom; $i; $left; $right; $top : Integer

ARRAY LONGINT:C221($windows; 0)

$title:=Get localized string:C991("preferences")

WINDOW LIST:C442($windows)

For ($i; 1; Size of array:C274($windows); 1)
	
	If (Get window title:C450($windows{$i})=$title)
		
		$run:=True:C214
		break
		
	End if 
End for 

If (Not:C34($run))
	
	CALL WORKER:C1389(1; "SETTINGS")
	
Else 
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $windows{$i})
	SET WINDOW RECT:C444($left; $top; $right; $bottom; $windows{$i})
	
End if 

