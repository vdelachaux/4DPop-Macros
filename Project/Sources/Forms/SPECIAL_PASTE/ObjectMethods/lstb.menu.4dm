If (<>tTxt_Labels=0)
	
	<>tTxt_Labels:=Find in array:C230(<>tTxt_Labels;<>tTxt_Labels{0})
	
Else 
	
	SET TIMER:C645(-1)
	
End if 