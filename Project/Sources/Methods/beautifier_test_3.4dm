//%attributes = {"invisible":true,"preemptive":"capable"}
C_LONGINT:C283($end;$Lon_i)
If (True:C214)
	For ($Lon_i;1;$end;10)
		  //comment
		For ($Lon_i;1;$end;1)
			  //comment
			Case of 
				: (True:C214)
				: (False:C215)
					Case of 
						: (True:C214)
						: (False:C215)
						Else 
					End case 
				Else 
			End case 
		End for 
	End for 
	  //CONTINUOUS LINE
	If ((False:C215) | (True:C214)) & (False:C215)
		  //True
	Else 
		  //False
	End if 
End if 