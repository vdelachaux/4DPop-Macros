//%attributes = {"invisible":true}
C_TEXT:C284($0)
C_OBJECT:C1216($1)
C_TEXT:C284($2)

C_TEXT:C284($key;$t;$t_code)
C_OBJECT:C1216($Obj_object)

If (False:C215)
	C_TEXT:C284(codeForObject ;$0)
	C_OBJECT:C1216(codeForObject ;$1)
	C_TEXT:C284(codeForObject ;$2)
End if 

$Obj_object:=$1  // Object to analyse

If (Count parameters:C259=2)
	
	$key:=$2  // If recursive call
	$t_code:="New object:C1471"
	
Else 
	
	$key:="$o"
	$t_code:="$o:=New object:C1471"
	
End if 

For each ($t;$Obj_object)
	
	If (Length:C16($t)=0)\
		 | (Match regex:C1019("^\\d";$t;1))
		
		$t_code:=$t_code+"\r"+$key+"[\""+$t+"\"]:="
		
		Case of 
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is null:K8:31)
				
				$t_code:=$t_code+"Null:C1517"
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is object:K8:27)
				
				$t_code:=$t_code+codeForObject ($Obj_object[$t];$key+"[\""+$t+"\"]")
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is text:K8:3)
				
				$t_code:=$t_code+"\""+$Obj_object[$t]+"\""
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is real:K8:4)\
				 | (Value type:C1509($Obj_object[$t])=Is longint:K8:6)
				
				$t_code:=$t_code+String:C10($Obj_object[$t])
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is boolean:K8:9)
				
				$t_code:=$t_code+Choose:C955($Obj_object[$t];"True:C214";"False:C215")
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is date:K8:7)
				
				$t_code:=$t_code+"!"+String:C10($Obj_object[$t])+"!"
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is collection:K8:32)
				
				$t_code:=$t_code+codeForCollection ($Obj_object[$t];$key+"[\""+$t+"\"]")
				
				  //______________________________________________________
		End case 
		
	Else 
		
		$t_code:=$t_code+"\r"+$key+"."+$t+":="
		
		Case of 
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is null:K8:31)
				
				$t_code:=$t_code+"Null:C1517"
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is object:K8:27)
				
				$t_code:=$t_code+codeForObject ($Obj_object[$t];$key+"."+$t)
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is text:K8:3)
				
				$t_code:=$t_code+"\""+$Obj_object[$t]+"\""
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is real:K8:4)\
				 | (Value type:C1509($Obj_object[$t])=Is longint:K8:6)
				
				$t_code:=$t_code+String:C10($Obj_object[$t])
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is boolean:K8:9)
				
				$t_code:=$t_code+Choose:C955($Obj_object[$t];"True:C214";"False:C215")
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is date:K8:7)
				
				$t_code:=$t_code+"!"+String:C10($Obj_object[$t])+"!"
				
				  //______________________________________________________
			: (Value type:C1509($Obj_object[$t])=Is collection:K8:32)
				
				$t_code:=$t_code+codeForCollection ($Obj_object[$t];$key+"."+$t)
				
				  //______________________________________________________
		End case 
	End if 
End for each 

$0:=$t_code  // 4D code