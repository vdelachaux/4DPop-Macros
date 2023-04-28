//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Méthode : private_INVERT_EXPRESSION
// Created 24/10/05 par Vincent de Lachaux
// Alias Macro_Inverser_Expression from Olivier DESCHANELS
// ----------------------------------------------------
// Description
// Inverse les expressions 4D
// ----------------------------------------------------
// Modified by vdl (05/02/08)
// v11 compatibility
// ----------------------------------------------------
C_TEXT:C284($0)
C_LONGINT:C283($1)
C_LONGINT:C283($2)
C_LONGINT:C283(${3})

C_LONGINT:C283($Lon_Error; $Lon_i; $Lon_Line; $Lon_Line_Number; $Lon_Parameters; $Lon_Position; $Lon_size; $Lon_start)
C_TEXT:C284($Txt_Code; $Txt_Command; $Txt_Comment; $Txt_result)

If (False:C215)
	C_TEXT:C284(INVERT_EXPRESSION; $0)
	C_LONGINT:C283(INVERT_EXPRESSION; $1)
	C_LONGINT:C283(INVERT_EXPRESSION; $2)
	C_LONGINT:C283(INVERT_EXPRESSION; ${3})
End if 

$Lon_Parameters:=Count parameters:C259

Case of 
		
		//______________________________________________________
	: ($Lon_Parameters=0)
		
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $Txt_result)
		
		ARRAY TEXT:C222(<>tTxt_lines; 0x0000)
		$Lon_Error:=Rgx_SplitText("\\r"; $Txt_result; -><>tTxt_lines; 0 ?+ 11)
		
		$Txt_result:=""
		$Lon_Line_Number:=Size of array:C274(<>tTxt_lines)
		
		For ($Lon_Line; 1; $Lon_Line_Number; 1)
			
			$Txt_Code:=<>tTxt_lines{$Lon_Line}
			$Txt_Comment:=""
			$Lon_Position:=Position:C15(":="; $Txt_Code)
			
			If ($Lon_Position>0)
				
				$Txt_Result:=Substring:C12($Txt_Code; 1; $Lon_Position-1)
				$Txt_Code:=Substring:C12($Txt_Code; $Lon_Position+2)
				
			Else 
				
				$Txt_Result:=""
				
			End if 
			
			$Lon_Position:=Position:C15("("; $Txt_Code)
			
			If ($Lon_Position>0)
				
				$Txt_Command:=Substring:C12($Txt_Code; 1; $Lon_Position-1)
				$Txt_Code:=Substring:C12($Txt_Code; $Lon_Position+1)
				
			Else 
				
				$Txt_Command:=$Txt_Code
				$Txt_Code:=""
				
			End if 
			
			ARRAY TEXT:C222(M_4DPop_tTxt_Buffer; 0)
			M_4DPop_tTxt_Buffer{0}:=$Txt_Result
			
			If (Length:C16($Txt_Code)#0)
				
				While ($Txt_Code[[Length:C16($Txt_Code)]]#")")
					
					$Txt_Comment:=$Txt_Code[[Length:C16($Txt_Code)]]+$Txt_Comment
					$Txt_Code:=Substring:C12($Txt_Code; 1; Length:C16($Txt_Code)-1)
					
				End while 
				
				If (Length:C16($Txt_Code)#0)
					
					$Txt_Code:=Substring:C12($Txt_Code; 1; Length:C16($Txt_Code)-1)
					
					While (Length:C16($Txt_Code)#0)
						
						$Lon_Position:=Position:C15(";"; $Txt_Code)
						
						If ($Lon_Position>0)
							
							APPEND TO ARRAY:C911(M_4DPop_tTxt_Buffer; Substring:C12($Txt_Code; 1; $Lon_Position-1))
							$Txt_Code:=Substring:C12($Txt_Code; $Lon_Position+1)
							
						Else 
							
							APPEND TO ARRAY:C911(M_4DPop_tTxt_Buffer; $Txt_Code)
							$Txt_Code:=""
							
						End if 
					End while 
				End if 
				
				APPEND TO ARRAY:C911(M_4DPop_tTxt_Buffer; $Txt_Comment)
				
			End if 
			
			Case of 
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(10))  //Chaine
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 11; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(11))  //Num
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 10; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(52))  //CHARGER ENREGISTREMENT
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 212; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(212))  //LIBERER ENREGISTREMENT
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 52; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(76))  //Enregistrements trouves
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 77; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(77))  //REGLER SERIE
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 76; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(78))  //ENVOYER ENREGISTREMENT
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 79; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(79))  //RECEVOIR ENREGISTREMENT
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 78; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(80))  //ENVOYER VARIABLE
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 81; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(81))  //RECEVOIR VARIABLE
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 80; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(90))  //Caractere
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 91; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(91))  //Code ascii
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 90; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(119))  //ADJOINDRE ELEMENT
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 561; 1; 2)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(561))  //ENLEVER ELEMENT
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 119; 1; 2)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(145))  //LECTURE SEULEMENT
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 146; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(146))  //LECTURE ECRITURE
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 145; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(214))  //Vrai
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(0; 215)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(215))  //Faux
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(0; 214)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(260))  //SELECTION VERS TABLEAU
					
					If (Position:C15("]"; M_4DPop_tTxt_Buffer{1})=Length:C16(M_4DPop_tTxt_Buffer{1}))
						
						$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 261; -3)
						
					Else 
						
						$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 261; -1)
						
					End if 
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(261))  //TABLEAU VERS SELECTION
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 260; -1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(287))  //TABLEAU VERS ENUMERATION
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 288; 2; 1; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(288))  //ENUMERATION VERS TABLEAU
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 287; 2; 1; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(433))  //AFFICHER BARRE OUTILS
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 434)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(434))  //CACHER BARRE OUTILS
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 433)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(463))  //Mac vers Windows
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 464; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(464))  //Windows vers Mac
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 463; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(519))  //Mac vers ISO
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 520; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(520))  //ISO vers Mac
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 463; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(523))  //ECRIRE TEXTE DANS PRESSE PAPIERS
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 524)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(524))  //Lire texte dans presse papiers
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 523; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(525))  //DOCUMENT VERS BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 526; 1; 2; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(526))  //BLOB VERS DOCUMENT
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 525; 1; 2; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(532))  //VARIABLE VERS BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 533; 2; 1; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(533))  //BLOB VERS VARIABLE
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 532; 2; 1; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(534))  //COMPRESSER BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 535; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(535))  //DECOMPRESSER BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 534; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(548))  //ENTIER VERS BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 549; 2; 3; 4)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(549))  //BLOB vers entier
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 548; 0; 1; 2; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(550))  //ENTIER LONG VERS BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 551; 2; 3; 4)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(551))  //BLOB vers entier long
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 550; 0; 1; 2; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(552))  //REEL VERS BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 553; 2; 3; 4)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(553))  //BLOB vers reel
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 552; 0; 1; 2; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(554))  //TEXTE VERS BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 555; 2; 3; 4)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(555))  //BLOB vers texte
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 554; 0; 1; 2; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(556))  //LISTE VERS BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(2; 557; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(557))  //BLOB vers liste
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 556; 1; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(559))  //INSERER DANS BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 560; 1; 2; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(560))  //SUPPRIMER DANS BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 559; 1; 2; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(565))  //LIRE IMAGE DANS BIBLIOTHEQUE
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 566; 2; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(566))  //ECRIRE IMAGE DANS BIBLIOTHEQUE
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 565; 2; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(605))  //Taille BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 606; 1; 0)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(606))  //FIXER TAILLE BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(1; 605; 2)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(678))  //LIRE FICHIER IMAGE
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 680; 1; 2; MAXLONG:K35:2)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(680))  //ECRIRE FICHIER IMAGE
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 678; 1; 2)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(682))  //BLOB VERS IMAGE
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 692; 2; 1; MAXLONG:K35:2)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(692))  //IMAGE VERS BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 682; 2; 1)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(689))  //CRYPTER BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 690; 1; 2; 3)
					
					//…………………………………………………
				: ($Txt_Command=Command name:C538(690))  //DECRYPTER BLOB
					
					$Txt_result:=$Txt_result+INVERT_EXPRESSION(-1; 689; 1; 2; 3)
					
					//…………………………………………………
				Else 
					
					$Txt_result:=$Txt_result+<>tTxt_lines{$Lon_Line}+"\r"
					
					//…………………………………………………
			End case 
			
			If ($Lon_Line#$Lon_Line_Number)
				
				//Add  carriage return
				If (($Txt_result[[Length:C16($Txt_result)]])#"\r")
					
					$Txt_result:=$Txt_result+"\r"
					
				End if 
			End if 
		End for 
		
		ARRAY TEXT:C222(M_4DPop_tTxt_Buffer; 0)
		
		SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $Txt_result+"<"+"caret/>")
		
		//______________________________________________________
	: ($Lon_Parameters>1)
		
		If ($1#-1)
			
			//Function
			$Txt_result:=M_4DPop_tTxt_Buffer{$1}+":="
			
		End if 
		
		$Txt_result:=$Txt_result+Command name:C538($2)
		
		If ($Lon_Parameters>2)
			
			//Open parenthesis
			$Txt_result:=$Txt_result+"("
			
			Case of 
					
					//______________________________________________________
				: ($2=11) & (False:C215)  //Num
					
					$Txt_result:=$Txt_result+"\""+M_4DPop_tTxt_Buffer{${3}}+"\""
					
					//______________________________________________________
				: ($3<0)  //Invert all arguments
					
					$Lon_start:=Abs:C99($3)
					$Lon_size:=Size of array:C274(M_4DPop_tTxt_Buffer)
					$Lon_size:=$Lon_size-Num:C11(($Lon_size%2)>0)
					
					For ($Lon_i; $Lon_start; $Lon_size; 1)
						
						$Txt_result:=$Txt_result+(";"*Num:C11($Lon_i>$Lon_start))
						$Txt_result:=$Txt_result+M_4DPop_tTxt_Buffer{$Lon_i+1}+";"+M_4DPop_tTxt_Buffer{$Lon_i}
						$Lon_i:=$Lon_i+1
						
					End for 
					
					//______________________________________________________
				Else 
					
					For ($Lon_i; 3; $Lon_Parameters; 1)
						
						If (${$Lon_i}<=(Size of array:C274(M_4DPop_tTxt_Buffer)-1))
							
							$Txt_result:=$Txt_result+(";"*Num:C11($Lon_i#3))+M_4DPop_tTxt_Buffer{${$Lon_i}}
							
						Else 
							
							$Txt_result:=$Txt_result+(";"*Num:C11($Lon_i#3))+"Parameter_"+String:C10($Lon_i)
							
						End if 
					End for 
					
					//______________________________________________________
			End case 
			
			//Close parenthesis
			$Txt_result:=$Txt_result+")"
			
		End if 
		
		$Txt_result:=$Txt_result+M_4DPop_tTxt_Buffer{Size of array:C274(M_4DPop_tTxt_Buffer)}
		
		$0:=$Txt_result  //inverted
		
		//______________________________________________________
End case 