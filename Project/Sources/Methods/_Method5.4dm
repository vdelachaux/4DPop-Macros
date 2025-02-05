//%attributes = {}
var $x : Boolean
var $count; $i : Integer

Case of 
	: (True:C214)
		If (True:C214)  //comment
			If (True:C214)  //comment
				For ($i; 1; 10; 1)  //comment
					While ($x)
						//comment
						$count:=$count+$i
					End while 
				End for 
			End if 
		End if 
	: (True:C214)
		$count:=1
		$count:=2
	: (True:C214)
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

$count:=Choose:C955(True:C214; 1; 2)