//%attributes = {"invisible":true}
var $0 : Text
var $1 : Object
var $2 : Text

If (False:C215)
	C_TEXT:C284(codeForObject; $0)
	C_OBJECT:C1216(codeForObject; $1)
	C_TEXT:C284(codeForObject; $2)
End if 

var $code; $key; $t : Text
var $Obj_object : Object


$Obj_object:=$1  // Object to analyse

If (Count parameters:C259=2)
	$key:=$2  // If recursive call
	$code:="New object:C1471"
	
Else 
	
	$key:="$o"
	$code:="$o:=New object:C1471"
	
End if 

For each ($t; $Obj_object)
	
	If (Length:C16($t)=0)\
		 | (Match regex:C1019("^\\d"; $t; 1))
		
		$code:=$code+"\r"+$key+"[\""+$t+"\"]:="
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is null:K8:31)
				
				$code:=$code+"Null:C1517"
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is object:K8:27)
				
				$code:=$code+codeForObject($Obj_object[$t]; $key+"[\""+$t+"\"]")
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is text:K8:3)
				
				$code:=$code+"\""+$Obj_object[$t]+"\""
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is real:K8:4)\
				 | (Value type:C1509($Obj_object[$t])=Is longint:K8:6)
				
				$code:=$code+String:C10($Obj_object[$t])
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is boolean:K8:9)
				
				$code:=$code+Choose:C955($Obj_object[$t]; "True:C214"; "False:C215")
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is date:K8:7)
				
				$code:=$code+"!"+String:C10($Obj_object[$t])+"!"
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is collection:K8:32)
				
				$code:=$code+codeForCollection($Obj_object[$t]; $key+"[\""+$t+"\"]")
				
				//______________________________________________________
		End case 
	Else 
		
		$code:=$code+"\r"+$key+"."+$t+":="
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is null:K8:31)
				
				$code:=$code+"Null:C1517"
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is object:K8:27)
				
				$code:=$code+codeForObject($Obj_object[$t]; $key+"."+$t)
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is text:K8:3)
				
				$code:=$code+"\""+$Obj_object[$t]+"\""
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is real:K8:4)\
				 | (Value type:C1509($Obj_object[$t])=Is longint:K8:6)
				
				$code:=$code+String:C10($Obj_object[$t])
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is boolean:K8:9)
				
				$code:=$code+Choose:C955($Obj_object[$t]; "True:C214"; "False:C215")
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is date:K8:7)
				
				$code:=$code+"!"+String:C10($Obj_object[$t])+"!"
				
				//______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is collection:K8:32)
				
				$code:=$code+codeForCollection($Obj_object[$t]; $key+"."+$t)
				
				//______________________________________________________
		End case 
	End if 
End for each 

$0:=$code  // 4D code