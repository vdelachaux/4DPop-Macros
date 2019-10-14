//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Méthode : str_gLon_Hex_To_Long
  // Alias zRes_Hex_en_décimal
  // Created 3/09/98 par Vincent
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_LONGINT:C283($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_ASCII;$Lon_End_i;$Lon_i)
C_REAL:C285($Num_Result)
C_TEXT:C284($a80_Hexa)

If (False:C215)
	C_LONGINT:C283(str_gLon_Hex_To_Long ;$0)
	C_TEXT:C284(str_gLon_Hex_To_Long ;$1)
End if 

$a80_Hexa:=Uppercase:C13($1)
$Lon_End_i:=Length:C16($a80_Hexa)

For ($Lon_i;$Lon_End_i;1;-1)
	
	$Lon_ASCII:=Character code:C91($a80_Hexa[[$Lon_i]])
	
	Case of 
			
			  //……………………………………………………………
		: (($Lon_ASCII>47)\
			 & ($Lon_ASCII<58))  //0..9
			
			$Num_Result:=$Num_Result+(($Lon_ASCII-48)*(16^($Lon_End_i-$Lon_i)))
			
			  //……………………………………………………………
		: (($Lon_ASCII>64)\
			 & ($Lon_ASCII<71))  //A..F
			
			$Num_Result:=$Num_Result+(($Lon_ASCII-55)*(16^($Lon_End_i-$Lon_i)))
			
			  //……………………………………………………………
		Else   //x de Ox de 4D ou autre bidule…
			
			  //…Arrêt de la conversion
			$Lon_i:=0
			
			  //……………………………………………………………
	End case 
End for 

$0:=Int:C8($Num_Result)