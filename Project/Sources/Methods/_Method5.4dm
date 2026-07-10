//%attributes = {}


/*
Case of 
: (True)
If (True)  //comment
If (True)  //comment
For ($i; 1; 10; 1)  //comment
While ($x)
//comment
$count:=$count+$i
End while 
End for 
End if 
End if 
: (True)
$count:=1
$count:=2
: (True)
For ($i; 1; 10; 1)
$count:=$count*$i
End for   //REMOVE CONSECUTIVE BLANK LINES {

//bloc {
Begin SQL

SELECT *
FROM _USER_COLUMNS
INTO :test

End SQL
//}

Else   //REMOVE CONSECUTIVE BLANK LINES }
While ($x)
$count:=$count+$i
End while 
End case 

$count:=Choose(True; 1; 2)
*/
