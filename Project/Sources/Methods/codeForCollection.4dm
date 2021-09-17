//%attributes = {"invisible":true}
var $0 : Text
var $1 : Collection
var $2 : Text

If (False:C215)
	C_TEXT:C284(codeForCollection; $0)
	C_COLLECTION:C1488(codeForCollection; $1)
	C_TEXT:C284(codeForCollection; $2)
End if 

var $key; $t_code : Text
var $i : Integer
var $c : Collection

$c:=$1  // Collection to analyse

If (Count parameters:C259=2)
	
	$key:=$2  // If recursive call
	$t_code:="New collection:C1472"
	
Else 
	
	$key:="$c"
	$t_code:="$c:=New collection:C1472"
	
End if 

For ($i; 0; $c.length-1; 1)
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($c[$i])=Is object:K8:27)
			
			$t_code:=$t_code+"\r$oo:="+codeForObject($c[$i]; "$oo")+"\r"+$key+".push($oo)"
			
			//______________________________________________________
		: (Value type:C1509($c[$i])=Is collection:K8:32)
			
			If ($c[$i].length=0)
				
				// Put an empty collection
				$t_code:=$t_code+"\r"+$key+".push("+codeForCollection($c[$i]; $key)+")"
				
			Else 
				
				$t_code:=$t_code+"\r$cc:="+codeForCollection($c[$i]; "$cc")+"\r"+$key+".push($cc)"
				
			End if 
			
			//______________________________________________________
		Else 
			
			$t_code:=$t_code+"\r"+$key+".push("
			
			Case of 
					
					//______________________________________________________
				: (Value type:C1509($c[$i])=Is null:K8:31)
					
					$t_code:=$t_code+"Null:C1517"
					
					//______________________________________________________
				: (Value type:C1509($c[$i])=Is text:K8:3)
					
					$t_code:=$t_code+"\""+$c[$i]+"\""
					
					//______________________________________________________
				: (Value type:C1509($c[$i])=Is real:K8:4)\
					 | (Value type:C1509($c[$i])=Is longint:K8:6)
					
					$t_code:=$t_code+String:C10($c[$i])
					
					//______________________________________________________
				: (Value type:C1509($c[$i])=Is boolean:K8:9)
					
					$t_code:=$t_code+Choose:C955($c[$i]; "True:C214"; "False:C215")
					
					//______________________________________________________
				: (Value type:C1509($c[$i])=Is date:K8:7)
					
					$t_code:=$t_code+"!"+String:C10($c[$i])+"!"
					
					//______________________________________________________
				Else 
					
					// A "Case of" statement should never omit "Else"
					//______________________________________________________
			End case 
			
			$t_code:=$t_code+")"
			
			//______________________________________________________
	End case 
End for 

$0:=$t_code  // 4D code