//%attributes = {"invisible":true,"preemptive":"capable"}
//%W-551.2
C_TEXT:C284($Txt)
//%W+551.2
If (True:C214\
 | False:C215)
	$Txt:="titi"
End if 
If (True:C214) & (False:C215)  //<-----
	$Txt:="titi"
End if 
If (True:C214) | (False:C215)  //<-----
	$Txt:="titi"
End if 
If (True:C214) & (False:C215) | (True:C214)  //<-----
	$Txt:="titi"
End if 
Case of 
		//:::::::::::::::
	: (True:C214) & (False:C215)
		$Txt:="titi"
		//:::::::::::::::
	: (False:C215)
		$Txt:="titi"
		//:::::::::::::::
	Else 
		$Txt:="titi"
		//:::::::::::::::
End case 

Case of 
	: (True:C214)
	: (False:C215)
	Else 
End case 