//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : Private_CODE_TO_EXECUTE
// ID[AE63DE138BAC461AA60933E0CF35F72A]
// Created 08/10/12 by Vincent de Lachaux
// ----------------------------------------------------
var $code; $line; $method; $outpout; $params; $pattern : Text
var $result : Text
var $withParams; $withResult : Boolean
var $i : Integer
var $rgx : cs:C1710.rgx.regex

ARRAY TEXT:C222($_lines; 0x0000)
ARRAY TEXT:C222($_controlFlow; 0x0000)

// Mark:Get the Command names
ARRAY TEXT:C222($_commands; 0x0000)

Repeat 
	
	$i+=1
	$line:=Command name:C538($i)
	
	If (Bool:C1537(OK))
		
		APPEND TO ARRAY:C911($_commands; $line)
		
	End if 
Until (OK=0)

_o_localizedControlFlow(""; ->$_controlFlow)

For ($i; 1; Size of array:C274($_controlFlow); 1)
	
	APPEND TO ARRAY:C911($_commands; $_controlFlow{$i})
	
End for 

GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $code)

COLLECTION TO ARRAY:C1562(Split string:C1554($code; "\r"; sk trim spaces:K86:2); $_lines)

$pattern:="^(?:(.*?):=)?(.*?)(?:\\s*\\(+(.*?)\\))?$"

For ($i; 1; Size of array:C274($_lines); 1)
	
	$line:=$_lines{$i}
	
	Case of 
			
			//______________________________________
		: (Length:C16($line)=0)\
			 | ($line="//@")
			
			$outpout+=$line
			
			//______________________________________
		Else 
			
			$rgx:=cs:C1710.rgx.regex.new($line; $pattern)
			
			If ($rgx.match())
				
				$method:=$rgx.group(3)
				
				If (Find in array:C230($_commands; $method)=-1)
					
					$result:=$rgx.group(2)
					$withResult:=(Length:C16($result)>0)
					
					$params:=$rgx.group(4)
					$withParams:=(Length:C16($params)>0)
					
					$outpout:=$outpout\
						+"//"+$line\
						+"\r"+$_commands{1007}\
						+"(\""+$method+"\""\
						+Choose:C955($withResult; ";"+$result; Choose:C955($withParams; ";*"; ""))+Choose:C955($withParams; ";"+$params; "")\
						+")"
					
				Else 
					
					$outpout+=$line
					
				End if 
				
			Else 
				
				$outpout+=$line
				
			End if 
			
			//______________________________________
	End case 
	
	$outpout+="\r"
	
End for 

SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $outpout)