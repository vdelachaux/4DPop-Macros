//%attributes = {}


$syntax:=New object:C1471(\
String:C10(Is object:K8:27);New collection:C1472;\
String:C10(Is boolean:K8:9);New collection:C1472;\
String:C10(Is longint:K8:6);New collection:C1472;\
String:C10(Is text:K8:3);New collection:C1472;\
String:C10(Is real:K8:4);New collection:C1472;\
String:C10(Is collection:K8:32);New collection:C1472;\
String:C10(Is pointer:K8:14);New collection:C1472;\
String:C10(Is date:K8:7);New collection:C1472;\
String:C10(Is time:K8:8);New collection:C1472)

$file:=Folder:C1567(Get 4D folder:C485(-1);fk platform path:K87:2).file("gram.4dsyntax")

If ($file.exists)
	
	$c:=Split string:C1554($file.getText();"\r";sk trim spaces:K86:2)
	
	$i:=0
	
	For each ($t;$c)
		
		$i:=$i+1
		
		Case of 
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\t@";$t;1))
				
				// Skip
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\to\\s<==\\s";$t;1))
				
				$syntax[String:C10(Is object:K8:27)].push("\\%:=:C"+String:C10($i))
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tj\\s<==\\s";$t;1))
				
				$syntax[String:C10(Is collection:K8:32)].push("\\%:=:C"+String:C10($i))
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tB\\s<==\\s";$t;1))
				
				$syntax[String:C10(Is boolean:K8:9)].push("\\%:=:C"+String:C10($i))
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tL\\s<==\\s";$t;1))
				
				$syntax[String:C10(Is longint:K8:6)].push("\\%:=:C"+String:C10($i))
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tS\\s<==\\s";$t;1))
				
				$syntax[String:C10(Is text:K8:3)].push("\\%:=:C"+String:C10($i))
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\ta\\d*\\s<==\\s";$t;1))
				
				$syntax[String:C10(Is text:K8:3)].push("\\%:=:C"+String:C10($i))
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tR\\s<==\\s";$t;1))
				
				$syntax[String:C10(Is real:K8:4)].push("\\%:=:C"+String:C10($i))
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\t[uU]\\s<==\\s";$t;1))
				
				$syntax[String:C10(Is pointer:K8:14)].push("\\%:=:C"+String:C10($i))
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tD\\s<==\\s";$t;1))
				
				$syntax[String:C10(Is date:K8:7)].push("\\%:=:C"+String:C10($i))
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\tT\\s<==\\s";$t;1))
				
				$syntax[String:C10(Is time:K8:8)].push("\\%:=:C"+String:C10($i))
				
				//______________________________________________________
			: (False:C215)
				
				
				
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				
				//______________________________________________________
		End case 
		
		
		
	End for each 
	
	$t:=Parse formula:C1576($syntax[String:C10(Is object:K8:27)][0])
	
End if 