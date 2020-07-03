//%attributes = {"invisible":true}
C_BOOLEAN:C305($Boo_something)
C_LONGINT:C283($Lon_count;$Lon_x)
C_TEXT:C284($Txt_that;$Txt_this)

If (($Lon_count=1.5) & ($Lon_x>0.1))
	
	$Txt_this:=$Txt_that  //Use Choose instead If…Else…End if
	
Else 
	
	$Txt_this:="that"
	
End if 

Case of 
		//______________________________________________________
	: (True:C214)
		
		If ($Boo_something)
			
			$Txt_this:=$Txt_that  //result 1
			
		Else 
			
			$Txt_this:="that"  //result 2
			
		End if 
		
		//______________________________________________________
	: (False:C215)
		
		//______________________________________________________
	Else 
		
		//______________________________________________________
End case 