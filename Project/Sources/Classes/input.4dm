
/*═══════════════════*/
Class extends widget
/*═══════════════════*/

Class constructor
	
	C_TEXT:C284($1;$2)
	
	If (Count parameters:C259>=2)
		
		Super:C1705($1;$2)
		
	Else 
		
		Super:C1705($1)
		
	End if 
	
/*════════════════════════════════════════════
.setFilter(int) -> This
.setFilter(text) -> This
════════════════════════════════════════════*/
Function setFilter
	
	C_VARIANT:C1683($1)
	C_TEXT:C284($2;$t)
	
	If (Value type:C1509($1)=Is real:K8:4)
		
		  // Predefined formats
		
		Case of 
				
				  //………………………………………………………………………
			: ($1=Is integer:K8:5)\
				 | ($1=Is longint:K8:6)\
				 | ($1=Is integer 64 bits:K8:25)
				
				OBJECT SET FILTER:C235(*;This:C1470.name;"&\"0-9;-;+\"")
				
				  //………………………………………………………………………
			: ($1=Is real:K8:4)
				
				If (Count parameters:C259>=2)  // Separator
					
					$t:=$2
					
				Else 
					
					GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$t)
					
				End if 
				
				OBJECT SET FILTER:C235(*;This:C1470.name;"&\"0-9;"+$t+";.;-;+\"")
				
				  //………………………………………………………………………
			: ($1=Is time:K8:8)
				
				If (Count parameters:C259>=2)  // Separator
					
					$t:=$2
					
				Else 
					
					GET SYSTEM FORMAT:C994(Time separator:K60:11;$t)
					
				End if 
				
				OBJECT SET FILTER:C235(*;This:C1470.name;"&\"0-9;"+$t+";:\"")
				
				  //………………………………………………………………………
			: ($1=Is date:K8:7)
				
				If (Count parameters:C259>=2)  // Separator
					
					$t:=$2
					
				Else 
					
					GET SYSTEM FORMAT:C994(Date separator:K60:10;$t)
					
				End if 
				
				OBJECT SET FILTER:C235(*;This:C1470.name;"&\"0-9;"+$t+";/\"")
				
				  //………………………………………………………………………
			Else 
				
				OBJECT SET FILTER:C235(*;This:C1470.name;"")  // Text as default
				
				  //………………………………………………………………………
		End case 
		
	Else 
		
		OBJECT SET FILTER:C235(*;This:C1470.name;String:C10($1))
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.getFilter() -> text
════════════════════════════════════════════*/
Function getFilter
	
	C_TEXT:C284($0)
	
	$0:=OBJECT Get filter:C1073(*;This:C1470.name)