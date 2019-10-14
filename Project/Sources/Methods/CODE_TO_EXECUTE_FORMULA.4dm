//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Méthode : private_CODE_TO_EXECUTE
  // Created 24/10/05 par Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Réécris le code sélectionné avec la commande EXECUTER
  // ----------------------------------------------------
  // Modified by vdl (09/10/07)
  // -> v11
  // ----------------------------------------------------
C_LONGINT:C283($Lon_CommandParameters;$Lon_Error;$Lon_i;$Lon_Lignes;$Lon_Position;$Lon_x)
C_TEXT:C284($Txt_Buffer;$Txt_Code;$Txt_Command)

ARRAY TEXT:C222($tTxt_Commands;0)
ARRAY TEXT:C222($tTxt_controlFlow;0)

ARRAY TEXT:C222(<>tTxt_lines;0)

  // Si (Private_Boo_INIT ("4D Pack"))

GET MACRO PARAMETER:C997(Highlighted method text:K5:18;$Txt_Buffer)
$Lon_Error:=Rgx_SplitText ("\\r";$Txt_Buffer;-><>tTxt_lines;0 ?+ 11)
$Txt_Buffer:=""

  // Récupérer les noms de commande localisés

Repeat 
	
	$Lon_i:=$Lon_i+1
	$Txt_Buffer:=Command name:C538($Lon_i)
	
	If (OK=1)
		
		If (Character code:C91($Txt_Buffer)#At sign:K15:46)
			
			APPEND TO ARRAY:C911($tTxt_Commands;$Txt_Buffer)
			
		End if 
	End if 
Until (OK=0)

localizedControlFlow ("";->$tTxt_controlFlow)

For ($Lon_Lignes;1;Size of array:C274(<>tTxt_lines);1)
	
	ARRAY TEXT:C222(M_4DPop_tTxt_Buffer;0)
	
	$Txt_Code:=<>tTxt_lines{$Lon_Lignes}
	
	$Lon_Position:=Position:C15(":=";$Txt_Code)
	
	If ($Lon_Position>0)
		
		M_4DPop_tTxt_Buffer{0}:=Substring:C12($Txt_Code;1;$Lon_Position-1)
		$Txt_Code:=Substring:C12($Txt_Code;$Lon_Position+2)
		
	Else 
		
		M_4DPop_tTxt_Buffer{0}:=""
		
	End if 
	
	$Lon_Position:=Position:C15("(";$Txt_Code)
	
	If ($Lon_Position>0)
		
		$Txt_Command:=Substring:C12($Txt_Code;1;$Lon_Position-1)
		$Txt_Code:=Substring:C12($Txt_Code;$Lon_Position+1)
		
	Else 
		
		$Txt_Command:=$Txt_Code
		$Txt_Code:=""
		
	End if 
	
	While ($Txt_Command=" @")
		
		$Txt_Command:=Substring:C12($Txt_Command;2)
		
	End while 
	
	While ($Txt_Command="@ ")
		
		$Txt_Command:=Substring:C12($Txt_Command;1;Length:C16($Txt_Command)-1)
		
	End while 
	
	If (Length:C16($Txt_Code)#0)
		
		While ($Txt_Code[[Length:C16($Txt_Code)]]#")")
			
			$Txt_Code:=Substring:C12($Txt_Code;1;Length:C16($Txt_Code)-1)
			
		End while 
		
		If (Length:C16($Txt_Code)#0)
			
			$Txt_Code:=Substring:C12($Txt_Code;1;Length:C16($Txt_Code)-1)
			
			While (Length:C16($Txt_Code)#0)
				
				$Lon_Position:=Position:C15(";";$Txt_Code)
				
				If ($Lon_Position>0)
					
					APPEND TO ARRAY:C911(M_4DPop_tTxt_Buffer;Substring:C12($Txt_Code;1;$Lon_Position-1))
					$Txt_Code:=Substring:C12($Txt_Code;$Lon_Position+1)
					
				Else 
					
					APPEND TO ARRAY:C911(M_4DPop_tTxt_Buffer;$Txt_Code)
					$Txt_Code:=""
					
				End if 
			End while 
		End if 
	End if 
	
	$Lon_CommandParameters:=Size of array:C274(M_4DPop_tTxt_Buffer)
	
	Case of 
			
			  //______________________________________________________
		: (Length:C16($Txt_Command+$Txt_Code)=0)  // Ligne vide
			
			$Txt_Buffer:=$Txt_Buffer+"\r"
			
			  //______________________________________________________
		: ($Txt_Command="`@")  // Ligne de commentaire
			
			If ($Lon_Lignes>1)
				
				$Txt_Buffer:=$Txt_Buffer+"\r"
				
			End if 
			
			$Txt_Buffer:=$Txt_Buffer+$Txt_Command
			
			  //______________________________________________________
		: (Find in array:C230($tTxt_controlFlow;$Txt_Command)>0)  // Structure conditionelle
			
			If ($Lon_Lignes>1)
				
				$Txt_Buffer:=$Txt_Buffer+"\r"
				
			End if 
			
			If (Length:C16(M_4DPop_tTxt_Buffer{0})>0)
				
				$Txt_Buffer:=$Txt_Buffer+M_4DPop_tTxt_Buffer{0}+":="
				
			End if 
			
			$Txt_Buffer:=$Txt_Buffer+$Txt_Command
			
			If ($Lon_CommandParameters>0)
				
				$Txt_Buffer:=$Txt_Buffer+"("
				
				For ($Lon_i;1;$Lon_CommandParameters;1)
					
					$Txt_Buffer:=$Txt_Buffer+M_4DPop_tTxt_Buffer{$Lon_i}
					
					If ($Lon_i<$Lon_CommandParameters)
						
						$Txt_Buffer:=$Txt_Buffer+";"
						
					End if 
				End for 
				
				$Txt_Buffer:=$Txt_Buffer+")"
				
			End if 
			
			  //______________________________________________________
		Else 
			
			If ($Lon_Lignes>1)
				
				$Txt_Buffer:=$Txt_Buffer+"\r"
				
			End if 
			
			  // D'abord la ligne d'origine en commentaires…
			$Txt_Buffer:=$Txt_Buffer+"`"
			
			If (Length:C16(M_4DPop_tTxt_Buffer{0})>0)
				
				$Txt_Buffer:=$Txt_Buffer+M_4DPop_tTxt_Buffer{0}+":="
				
			End if 
			
			$Txt_Buffer:=$Txt_Buffer+$Txt_Command
			
			If ($Lon_CommandParameters>0)
				
				$Txt_Buffer:=$Txt_Buffer+"("
				
				For ($Lon_i;1;$Lon_CommandParameters;1)
					
					$Txt_Buffer:=$Txt_Buffer+M_4DPop_tTxt_Buffer{$Lon_i}
					
					If ($Lon_i<$Lon_CommandParameters)
						
						$Txt_Buffer:=$Txt_Buffer+";"
						
					End if 
				End for 
				
				$Txt_Buffer:=$Txt_Buffer+")"
				
			End if 
			
			$Txt_Buffer:=$Txt_Buffer+"\r"
			
			  //…Puis appel de la commande EXECUTER
			$Txt_Buffer:=$Txt_Buffer+Command name:C538(63)+"("
			
			  // Eventuel retour
			If (Length:C16(M_4DPop_tTxt_Buffer{0})>0)
				
				$Txt_Buffer:=$Txt_Buffer+"\""+M_4DPop_tTxt_Buffer{0}+":=\"+"
				
			End if 
			
			  // Estce une commande 4D ?
			$Lon_x:=Find in array:C230($tTxt_Commands;$Txt_Command)
			
			If ($Lon_x>0)
				
				$Txt_Buffer:=$Txt_Buffer+Command name:C538(538)
				$Txt_Buffer:=$Txt_Buffer+"("
				$Txt_Buffer:=$Txt_Buffer+String:C10($Lon_x)
				$Txt_Buffer:=$Txt_Buffer+")"
				
			Else 
				
				$Txt_Buffer:=$Txt_Buffer+"\""+$Txt_Command+"\""
				
			End if 
			
			If ($Lon_CommandParameters>0)
				
				$Txt_Buffer:=$Txt_Buffer+"+\"("
				
				For ($Lon_i;1;$Lon_CommandParameters;1)
					
					$Txt_Buffer:=$Txt_Buffer+Replace string:C233(M_4DPop_tTxt_Buffer{$Lon_i};"\"";"\\\"")
					
					If ($Lon_i<$Lon_CommandParameters)
						
						$Txt_Buffer:=$Txt_Buffer+";"
						
					End if 
				End for 
				
				$Txt_Buffer:=$Txt_Buffer+")\""
				
			End if 
			
			$Txt_Buffer:=$Txt_Buffer+")"
			
			  //______________________________________________________
	End case 
End for 

SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$Txt_Buffer)

  // Fin de si