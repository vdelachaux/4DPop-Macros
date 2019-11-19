//%attributes = {"invisible":true}
C_TEXT:C284($0)
C_COLLECTION:C1488($1)
C_TEXT:C284($2)

C_LONGINT:C283($i)
C_TEXT:C284($cmd;$key)
C_COLLECTION:C1488($c)

If (False:C215)
	C_TEXT:C284(codeForCollection ;$0)
	C_COLLECTION:C1488(codeForCollection ;$1)
	C_TEXT:C284(codeForCollection ;$2)
End if 

$c:=$1

If (Count parameters:C259=2)
	
	$key:=$2
	$cmd:="New collection:C1472"
	
Else 
	
	$key:="$c"
	$cmd:="$c:=New collection:C1472"
	
End if 

For ($i;0;$c.length-1;1)
	
	Case of 
			
			  //______________________________________________________
		: (Value type:C1509($c[$i])=Is object:K8:27)
			
			$cmd:=$cmd+"\r$oo:="+codeForObject ($c[$i];"$oo")+"\r"+$key+".push($oo)"
			
			  //______________________________________________________
		: (Value type:C1509($c[$i])=Is collection:K8:32)
			
			If ($c[$i].length=0)
				
				  // Put an empty collection
				$cmd:=$cmd+"\r"+$key+".push("+codeForCollection ($c[$i];$key)+")"
				
			Else 
				
				$cmd:=$cmd+"\r$cc:="+codeForCollection ($c[$i];"$cc")+"\r"+$key+".push($cc)"
				
			End if 
			
			  //______________________________________________________
		Else 
			
			$cmd:=$cmd+"\r"+$key+".push("
			
			Case of 
					
					  //______________________________________________________
				: (Value type:C1509($c[$i])=Is null:K8:31)
					
					$cmd:=$cmd+"Null:C1517"
					
					  //______________________________________________________
				: (Value type:C1509($c[$i])=Is text:K8:3)
					
					$cmd:=$cmd+"\""+$c[$i]+"\""
					
					  //______________________________________________________
				: (Value type:C1509($c[$i])=Is real:K8:4)\
					 | (Value type:C1509($c[$i])=Is longint:K8:6)
					
					$cmd:=$cmd+String:C10($c[$i])
					
					  //______________________________________________________
				: (Value type:C1509($c[$i])=Is boolean:K8:9)
					
					$cmd:=$cmd+Choose:C955($c[$i];"True:C214";"False:C215")
					
					  //______________________________________________________
				: (Value type:C1509($c[$i])=Is date:K8:7)
					
					$cmd:=$cmd+"!"+String:C10($c[$i])+"!"
					
					  //______________________________________________________
				Else 
					
					  // A "Case of" statement should never omit "Else"
					
					  //______________________________________________________
			End case 
			
			$cmd:=$cmd+")"
			
			  //______________________________________________________
	End case 
	
End for 

$0:=$cmd