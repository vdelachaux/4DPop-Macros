//%attributes = {"invisible":true}
C_TEXT:C284($0)
C_OBJECT:C1216($1)
C_TEXT:C284($2)

C_TEXT:C284($cmd;$key;$t)
C_OBJECT:C1216($o)

If (False:C215)
	C_TEXT:C284(codeForObject ;$0)
	C_OBJECT:C1216(codeForObject ;$1)
	C_TEXT:C284(codeForObject ;$2)
End if 

$o:=$1

If (Count parameters:C259=2)
	
	$key:=$2
	$cmd:="New object:C1471"
	
Else 
	
	$key:="$o"
	$cmd:="$o:=New object:C1471"
	
End if 

For each ($t;$o)
	
	If (Length:C16($t)=0)\
		 | (Match regex:C1019("^\\d";$t;1))
		
		$cmd:=$cmd+"\r"+$key+"[\""+$t+"\"]:="
		
		Case of 
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is null:K8:31)
				
				$cmd:=$cmd+"Null:C1517"
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is object:K8:27)
				
				$cmd:=$cmd+codeForObject ($o[$t];$key+"[\""+$t+"\"]")
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is text:K8:3)
				
				$cmd:=$cmd+"\""+$o[$t]+"\""
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is real:K8:4)\
				 | (Value type:C1509($o[$t])=Is longint:K8:6)
				
				$cmd:=$cmd+String:C10($o[$t])
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is boolean:K8:9)
				
				$cmd:=$cmd+Choose:C955($o[$t];"True:C214";"False:C215")
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is date:K8:7)
				
				$cmd:=$cmd+"!"+String:C10($o[$t])+"!"
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is collection:K8:32)
				
				$cmd:=$cmd+codeForCollection ($o[$t];$key+"[\""+$t+"\"]")
				
				  //______________________________________________________
		End case 
		
	Else 
		
		$cmd:=$cmd+"\r"+$key+"."+$t+":="
		
		Case of 
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is null:K8:31)
				
				$cmd:=$cmd+"Null:C1517"
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is object:K8:27)
				
				$cmd:=$cmd+codeForObject ($o[$t];$key+"."+$t)
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is text:K8:3)
				
				$cmd:=$cmd+"\""+$o[$t]+"\""
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is real:K8:4)\
				 | (Value type:C1509($o[$t])=Is longint:K8:6)
				
				$cmd:=$cmd+String:C10($o[$t])
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is boolean:K8:9)
				
				$cmd:=$cmd+Choose:C955($o[$t];"True:C214";"False:C215")
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is date:K8:7)
				
				$cmd:=$cmd+"!"+String:C10($o[$t])+"!"
				
				  //______________________________________________________
			: (Value type:C1509($o[$t])=Is collection:K8:32)
				
				$cmd:=$cmd+codeForCollection ($o[$t];$key+"."+$t)
				
				  //______________________________________________________
		End case 
	End if 
End for each 

$0:=$cmd