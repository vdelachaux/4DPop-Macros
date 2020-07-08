//%attributes = {}

C_OBJECT:C1216($gram)

$gram:=New object:C1471(\
String:C10(Is object:K8:27); New collection:C1472; \
String:C10(Is boolean:K8:9); New collection:C1472; \
String:C10(Is longint:K8:6); New collection:C1472; \
String:C10(Is text:K8:3); New collection:C1472; \
String:C10(Is real:K8:4); New collection:C1472; \
String:C10(Is collection:K8:32); New collection:C1472; \
String:C10(Is pointer:K8:14); New collection:C1472; \
String:C10(Is date:K8:7); New collection:C1472; \
String:C10(Is time:K8:8); New collection:C1472)


var $file : Object
$file:=Folder:C1567(Get 4D folder:C485(-1); fk platform path:K87:2).file("gram.4dsyntax")

If ($file.exists)
	
	var $oPatterns : Object
	$oPatterns:=New object:C1471
	$oPatterns.affectation:="(?mi-s)\\%:=(?_:C{#})"
	
	var $i,$return : Integer
	var $t : Text
	
	For each ($t; Split string:C1554($file.getText(); "\r"; sk trim spaces:K86:2))
		
		$i:=$i+1
		$return:=-1
		
		Case of 
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\t@"; $t; 1))  // The command entry is unused
				
				// Skip
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\to\\s<==\\s"; $t; 1))
				
				$return:=Is object:K8:27
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tj\\s<==\\s"; $t; 1))
				
				$return:=Is collection:K8:32
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tB\\s<==\\s"; $t; 1))
				
				$return:=Is boolean:K8:9
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tL\\s<==\\s"; $t; 1))
				
				$return:=Is longint:K8:6
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tS\\s<==\\s"; $t; 1))
				
				$return:=Is text:K8:3
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\ta\\d*\\s<==\\s"; $t; 1))
				
				$return:=Is text:K8:3
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tR\\s<==\\s"; $t; 1))
				
				$return:=Is real:K8:4
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\t[uU]\\s<==\\s"; $t; 1))
				
				$return:=Is pointer:K8:14
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tD\\s<==\\s"; $t; 1))
				
				$return:=Is date:K8:7
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tT\\s<==\\s"; $t; 1))
				
				$return:=Is time:K8:8
				
				//______________________________________________________
			: (False:C215)
				
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				//______________________________________________________
		End case 
		
		Case of 
				
				//______________________________________________________
			: ($return#-1)
				
				If ($gram[String:C10($return)].length=0)
					
					$gram[String:C10($return)].push(Replace string:C233($oPatterns.affectation; "{#}"; String:C10($i)))
					
				Else 
					
					$gram[String:C10($return)][0]:=$gram[String:C10($return)][0]+"|(?_:C"+String:C10($i)+")"
					
				End if 
				
				//______________________________________________________
		End case 
	End for each 
	
	
	For each ($t; $gram)
		
		$gram[$t]:=Replace string:C233(Parse formula:C1576($gram[$t][0]); "?_"; "?:")
		
	End for each 
	
End if 