//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($c : Collection; $key : Text) : Text

var $code : Text
var $i : Integer

If (Count parameters:C259=2)  // Recursive call
	
	$code:="New collection:C1472"
	
Else 
	
	$key:="$c"
	$code:="$c:=New collection:C1472"
	
End if 

For ($i; 0; $c.length-1; 1)
	
	Case of 
			
			// ______________________________________________________
		: (Value type:C1509($c[$i])=Is object:K8:27)
			
			$code+="\r$oo:="+codeForObject($c[$i]; "$oo")+"\r"+$key+".push($oo)"
			
			// ______________________________________________________
		: (Value type:C1509($c[$i])=Is collection:K8:32)
			
			If ($c[$i].length=0)
				
				// Put an empty collection
				$code+="\r"+$key+".push("+codeForCollection($c[$i]; $key)+")"
				
			Else 
				
				$code+="\r$cc:="+codeForCollection($c[$i]; "$cc")+"\r"+$key+".push($cc)"
				
			End if 
			
			// ______________________________________________________
		Else 
			
			$code+="\r"+$key+".push("
			
			Case of 
					
					// ______________________________________________________
				: (Value type:C1509($c[$i])=Is null:K8:31)
					
					$code+="Null:C1517"
					
					// ______________________________________________________
				: (Value type:C1509($c[$i])=Is text:K8:3)
					
					$code+="\""+$c[$i]+"\""
					
					// ______________________________________________________
				: (Value type:C1509($c[$i])=Is real:K8:4)\
					 | (Value type:C1509($c[$i])=Is longint:K8:6)
					
					$code+=String:C10($c[$i])
					
					// ______________________________________________________
				: (Value type:C1509($c[$i])=Is boolean:K8:9)
					
					$code+=$c[$i] ? "True:C214" : "False:C215"
					
					// ______________________________________________________
				: (Value type:C1509($c[$i])=Is date:K8:7)
					
					$code+="!"+String:C10($c[$i])+"!"
					
					// ______________________________________________________
				Else 
					
					// A "Case of" statement should never omit "Else"
					// ______________________________________________________
			End case 
			
			$code+=")"
			
			// ______________________________________________________
	End case 
End for 

return $code  // 4D code