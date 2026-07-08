//%attributes = {"invisible":true,"preemptive":"incapable"}
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
#DECLARE($code : Text) : Text

var $parameterCount; $i; $lineNumber; $position; $commandIndex : Integer
var $output; $line; $command : Text
var $lines; $controlFlow : Collection

ARRAY TEXT:C222($commandNames; 0)
ARRAY TEXT:C222($_buffer; 0)

If (Count parameters:C259=0)  // Macro mode: read the current selection
	
	GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $code)
	
End if 

$lines:=Split string:C1554($code; "\r"; sk trim spaces:K86:2)
$output:=""

// Récupérer les noms de commande localisés

Repeat 
	
	$i+=1
	$output:=Command name:C538($i)
	
	If (OK=1)
		
		If (Character code:C91($output)#At sign:K15:46)
			
			APPEND TO ARRAY:C911($commandNames; $output)
			
		End if 
	End if 
Until (OK=0)

$controlFlow:=cs:C1710.controlFlow.me.keywords

$lineNumber:=0

For each ($line; $lines)
	
	$lineNumber+=1
	
	ARRAY TEXT:C222($_buffer; 0)
	
	$position:=Position:C15(":="; $line)
	
	If ($position>0)
		
		$_buffer{0}:=Substring:C12($line; 1; $position-1)
		$line:=Substring:C12($line; $position+2)
		
	Else 
		
		$_buffer{0}:=""
		
	End if 
	
	$position:=Position:C15("("; $line)
	
	If ($position>0)
		
		$command:=Substring:C12($line; 1; $position-1)
		$line:=Substring:C12($line; $position+1)
		
	Else 
		
		$command:=$line
		$line:=""
		
	End if 
	
	While ($command=" @")
		
		$command:=Substring:C12($command; 2)
		
	End while 
	
	While ($command="@ ")
		
		$command:=Substring:C12($command; 1; Length:C16($command)-1)
		
	End while 
	
	If (Length:C16($line)#0)
		
		While ($line[[Length:C16($line)]]#")")
			
			$line:=Substring:C12($line; 1; Length:C16($line)-1)
			
		End while 
		
		If (Length:C16($line)#0)
			
			$line:=Substring:C12($line; 1; Length:C16($line)-1)
			
			While (Length:C16($line)#0)
				
				$position:=Position:C15(";"; $line)
				
				If ($position>0)
					
					APPEND TO ARRAY:C911($_buffer; Substring:C12($line; 1; $position-1))
					$line:=Substring:C12($line; $position+1)
					
				Else 
					
					APPEND TO ARRAY:C911($_buffer; $line)
					$line:=""
					
				End if 
			End while 
		End if 
	End if 
	
	$parameterCount:=Size of array:C274($_buffer)
	
	Case of 
			
			// ______________________________________________________
		: (Length:C16($command+$line)=0)  // Ligne vide
			
			$output+="\r"
			
			// ______________________________________________________
		: ($command=kCommentMark+"@")  // Ligne de commentaire
			
			If ($lineNumber>1)
				
				$output+="\r"
				
			End if 
			
			$output+=$command
			
			// ______________________________________________________
		: ($controlFlow.indexOf($command)>=0)  // Structure conditionelle
			
			If ($lineNumber>1)
				
				$output+="\r"
				
			End if 
			
			If (Length:C16($_buffer{0})>0)
				
				$output+=$_buffer{0}+":="
				
			End if 
			
			$output+=$command
			
			If ($parameterCount>0)
				
				$output+="("
				
				For ($i; 1; $parameterCount; 1)
					
					$output+=$_buffer{$i}
					
					If ($i<$parameterCount)
						
						$output+=";"
						
					End if 
				End for 
				
				$output+=")"
				
			End if 
			
			// ______________________________________________________
		Else 
			
			If ($lineNumber>1)
				
				$output+="\r"
				
			End if 
			
			// D'abord la ligne d'origine en commentaires…
			$output+=kCommentMark+" "
			
			If (Length:C16($_buffer{0})>0)
				
				$output+=$_buffer{0}+":="
				
			End if 
			
			$output+=$command
			
			If ($parameterCount>0)
				
				$output+="("
				
				For ($i; 1; $parameterCount; 1)
					
					$output+=$_buffer{$i}
					
					If ($i<$parameterCount)
						
						$output+=";"
						
					End if 
				End for 
				
				$output+=")"
				
			End if 
			
			$output+="\r"
			
			// …Puis appel de la commande EXECUTER
			$output+=Command name:C538(63)+"("
			
			// Eventuel retour
			If (Length:C16($_buffer{0})>0)
				
				$output+="\""+$_buffer{0}+":=\"+"
				
			End if 
			
			// Estce une commande 4D ?
			$commandIndex:=Find in array:C230($commandNames; $command)
			
			If ($commandIndex>0)
				
				$output+=Command name:C538(538)
				$output+="("
				$output+=String:C10($commandIndex)
				$output+=")"
				
			Else 
				
				$output+="\""+$command+"\""
				
			End if 
			
			If ($parameterCount>0)
				
				$output+="+\"("
				
				For ($i; 1; $parameterCount; 1)
					
					$output+=Replace string:C233($_buffer{$i}; "\""; "\\\"")
					
					If ($i<$parameterCount)
						
						$output+=";"
						
					End if 
				End for 
				
				$output+=")\""
				
			End if 
			
			$output+=")"
			//________________________________________________________________________________
	End case 
End for each 

If (Count parameters:C259=0)  // Macro mode: replace the selection
	
	SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $output)
	
Else 
	
	return $output
	
End if 
