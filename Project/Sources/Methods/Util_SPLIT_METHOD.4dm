//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Method : Util_SPLIT_METHOD
  // Created 28/12/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($1)
C_POINTER:C301($2)
C_LONGINT:C283($3)

C_BOOLEAN:C305($Boo_expurged)
C_LONGINT:C283($Lon_options;$Lon_x)
C_TEXT:C284($Txt_buffer;$Txt_toSplit)

If (False:C215)
	C_TEXT:C284(Util_SPLIT_METHOD ;$1)
	C_POINTER:C301(Util_SPLIT_METHOD ;$2)
	C_LONGINT:C283(Util_SPLIT_METHOD ;$3)
End if 

$Txt_toSplit:=$1

ARRAY TEXT:C222($2->;0)

$Lon_x:=Length:C16($1)
$Lon_x:=Length:C16($Txt_toSplit)

If (Count parameters:C259>2)
	
	$Lon_options:=$3
	
End if 

Repeat 
	
	$Lon_x:=Position:C15("\r";$Txt_toSplit)
	
	If ($Lon_x>0)
		
		$Txt_buffer:=Substring:C12($Txt_toSplit;1;$lon_x-1)
		$Txt_toSplit:=Substring:C12($Txt_toSplit;$Lon_x+1)
		
	Else 
		
		$Txt_buffer:=$Txt_toSplit
		$Txt_toSplit:=""
		$Lon_x:=Num:C11(Length:C16($Txt_buffer)>0)
		
	End if 
	
	If ($Lon_x>0)
		
		Repeat 
			
			$Boo_expurged:=False:C215
			
			Case of 
					
					  //__________________________________
				: (Character code:C91($Txt_buffer)=Line feed:K15:40)
				: (Character code:C91($Txt_buffer)=Tab:K15:37)
				: (Character code:C91($Txt_buffer)=Space:K15:42)
				: (Character code:C91($Txt_buffer)=NBSP ASCII CODE:K15:43)
				: (Character code:C91($Txt_buffer)=160)
				: (Character code:C91($Txt_buffer)=0x0060)\
					 & ($Lon_options ?? 3)
					  //__________________________________
				Else 
					
					$Boo_expurged:=True:C214
					
					  //__________________________________
			End case 
			
			If (Not:C34($Boo_expurged))
				
				$Txt_buffer:=Substring:C12($Txt_buffer;2)
				
			End if 
		Until ($Boo_expurged)
		
		Case of 
				
				  //__________________________________
			: (Length:C16($Txt_buffer)=0)\
				 & ($Lon_options ?? 0)  //skeep empty line
				
				  //__________________________________
			: (Character code:C91($Txt_buffer)=96)\
				 & ($Lon_options ?? 1)  //skeep comment line
				
				  //__________________________________
			Else 
				
				APPEND TO ARRAY:C911($2->;$Txt_buffer)
				
				  //__________________________________
		End case 
	End if 
Until ($Lon_x=0)\
 | (Length:C16($Txt_toSplit)=0)