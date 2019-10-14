C_LONGINT:C283($Lon_i)

If (Macintosh option down:C545)\
 | (Windows Alt down:C563)
	
	  //%W-533.3
	Self:C308->{0}:=Self:C308->{Self:C308->}
	  //%W+533.3
	
	For ($Lon_i;1;Size of array:C274(Self:C308->);1)
		
		Self:C308->{$Lon_i}:=Self:C308->{0}
		
	End for 
End if 