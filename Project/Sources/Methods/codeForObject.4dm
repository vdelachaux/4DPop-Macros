//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($Obj_object : Object; $key : Text) : Text

var $code; $t : Text

If (Count parameters:C259=2)  // Recursive call
	
	$code:="New object:C1471"
	
Else 
	
	$key:="$o"
	$code:="$o:=New object:C1471"
	
End if 

For each ($t; $Obj_object)
	
	If (Length:C16($t)=0)\
		 | (Match regex:C1019("^\\d"; $t; 1))
		
		$code+="\r"+$key+"[\""+$t+"\"]:="
		
		Case of 
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is null:K8:31)
				
				$code+="Null:C1517"
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is object:K8:27)
				
				$code+=codeForObject($Obj_object[$t]; $key+"[\""+$t+"\"]")
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is text:K8:3)
				
				$code+="\""+$Obj_object[$t]+"\""
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is real:K8:4)\
				 | (Value type:C1509($Obj_object[$t])=Is longint:K8:6)
				
				$code+=String:C10($Obj_object[$t])
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is boolean:K8:9)
				
				$code+=$Obj_object[$t] ? "True:C214" : "False:C215"
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is date:K8:7)
				
				$code+="!"+String:C10($Obj_object[$t])+"!"
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is collection:K8:32)
				
				$code+=codeForCollection($Obj_object[$t]; $key+"[\""+$t+"\"]")
				
				// ______________________________________________________
		End case 
		
	Else 
		
		$code+="\r"+$key+"."+$t+":="
		
		Case of 
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is null:K8:31)
				
				$code+="Null:C1517"
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is object:K8:27)
				
				$code+=codeForObject($Obj_object[$t]; $key+"."+$t)
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is text:K8:3)
				
				$code+="\""+$Obj_object[$t]+"\""
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is real:K8:4)\
				 | (Value type:C1509($Obj_object[$t])=Is longint:K8:6)
				
				$code+=String:C10($Obj_object[$t])
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is boolean:K8:9)
				
				$code+=$Obj_object[$t] ? "True:C214" : "False:C215"
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is date:K8:7)
				
				$code+="!"+String:C10($Obj_object[$t])+"!"
				
				// ______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is collection:K8:32)
				
				$code+=codeForCollection($Obj_object[$t]; $key+"."+$t)
				
				// ______________________________________________________
		End case 
	End if 
End for each 

return $code  // 4D code