//%attributes = {"invisible":true}
ARRAY LONGINT:C221($x;0)
C_LONGINT:C283($i)
For ($i;1;Size of array:C274($x))
	  //"For ($i;1;Size of array($x))" must be changed to "For ($i;1;Size of array($x);1)"
End for 
FORM GET PROPERTIES:C674("ABOUT";$i;$x)  //MUST NOT BE MODIFIED
For ($i;1;Size of array:C274($x);1)
	  //must not be modified
End for 