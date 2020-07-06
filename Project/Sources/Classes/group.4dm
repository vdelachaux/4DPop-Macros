/*————————————————————————————————————————————————————————————————————————————————
A group is a collection of static or active objects

You can define it by passing N objects as parameters
--> cs.group.new(object1, object2, …, objectN)

or a collection of objects
--> cs.group.new(object collection)

or a comma separated list of object names
--> cs.group.new("name1,name2,…,nameN")
in this case, all named objects are initialized with widget class

——————————————————————————*/
Class constructor
	
	C_VARIANT:C1683($1)
	C_OBJECT:C1216(${2})
	
	C_LONGINT:C283($i)
	C_TEXT:C284($t)
	
	If (Asserted:C1132(Count parameters:C259>0;"Missing parameter"))
		
		Case of 
				
				  //___________________________
			: (Value type:C1509($1)=Is collection:K8:32)
				
				This:C1470.members:=$1
				
				  //___________________________
			: (Value type:C1509($1)=Is object:K8:27)  // 1 to n objects
				
				This:C1470.members:=New collection:C1472
				
				For ($i;1;Count parameters:C259;1)
					
					This:C1470.members.push(${$i})
					
				End for 
				
				  //___________________________
			: (Value type:C1509($1)=Is text:K8:3)  // Comma separated list of object names
				
				This:C1470.members:=New collection:C1472
				
				For each ($t;Split string:C1554($1;","))
					
					This:C1470.members.push(cs:C1710.widget.new($t))  // Widget by default
					
				End for each 
				
				  //___________________________
			Else 
				
				ASSERT:C1129(False:C215;"Bad parameter type")
				
				  //___________________________
		End case 
	End if 
	
/*════════════════════════════════════════════
Returns True if the passed object or object name is part of the group
	
.include(obj) --> bool
	
or
	
.include("name") --> bool
	
════════════════════════════════════════════*/
Function include
	
	C_BOOLEAN:C305($0)
	C_VARIANT:C1683($1)
	
	Case of 
			
			  //______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)
			
			$0:=(This:C1470.members.indexOf($1)#-1)
			
			  //______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			$0:=(This:C1470.members.query("name=:1";$1).pop()#Null:C1517)
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unmanaged parameter type")
			
			  //______________________________________________________
	End case 
	
/*════════════════════════════════════════════
Performs a horizontal distribution, from left to right,
of the elements according to their best size
	
.distributeHorizontally({obj})
	
The optional object type parameter allow to specify:
- The starting point x in pixels in the form (start)
- The spacing in pixels to respect between the elements (spacing)
- The minimum width to respect in pixels (minWidth)
- The maximum width to respect in pixels (maxWidth)
	
════════════════════════════════════════════*/
Function distributeHorizontally
	
	C_OBJECT:C1216($1;$o;$e)
	
	$e:=New object:C1471(\
		"start";0;\
		"spacing";0;\
		"minWidth";0;\
		"maxWidth";0)
	
	If (Count parameters:C259>=1)
		
		If ($1.start#Null:C1517)
			
			$e.start:=Num:C11($1.start)
			
		End if 
		
		If ($1.spacing#Null:C1517)
			
			$e.spacing:=Num:C11($1.spacing)
			
		End if 
	End if 
	
	For each ($o;This:C1470.members)
		
		If (Count parameters:C259>=1)
			
			$o.bestSize($1)
			
		Else 
			
			$o.bestSize()
			
		End if 
		
		If ($e.start#0)
			
			$o.moveHorizontally($e.start-$o.coordinates.left)
			
		End if 
		
		  // Calculate the cumulative shift
		If ($e.spacing=0)
			
			Case of 
					
					  //_______________________________
				: ($o.type=Object type push button:K79:16)
					
					$e.start:=$o.coordinates.right+Choose:C955(Is macOS:C1572;20;20)
					
					  //_______________________________
				: (False:C215)
					
					  //_______________________________
				Else 
					
					$e.start:=$o.coordinates.right
					
					  //_______________________________
			End case 
			
		Else 
			
			$e.start:=$o.coordinates.right+$e.spacing
			
		End if 
	End for each 
	
/*════════════════════════════════════════════
.show()
.show(bool)
════════════════════════════════════════════*/
Function show
	
	C_BOOLEAN:C305($1)
	C_OBJECT:C1216($o)
	
	If (Count parameters:C259>=1)
		
		For each ($o;This:C1470.members)
			
			$o.show($1)
			
		End for each 
		
	Else 
		
		For each ($o;This:C1470.members)
			
			$o.show()
			
		End for each 
	End if 
	
/*════════════════════════════════════════════*/
Function hide
	
	C_OBJECT:C1216($o)
	
	For each ($o;This:C1470.members)
		
		$o.hide()
		
	End for each 
	
/*════════════════════════════════════════════
.enable()
.enable(bool)
════════════════════════════════════════════*/
Function enable
	
	C_BOOLEAN:C305($1)
	C_OBJECT:C1216($o)
	
	If (Count parameters:C259>=1)
		
		For each ($o;This:C1470.members)
			
			$o.enable($1)
			
		End for each 
		
	Else 
		
		For each ($o;This:C1470.members)
			
			$o.enable()
			
		End for each 
	End if 
	
/*════════════════════════════════════════════*/
Function disable
	
	C_OBJECT:C1216($o)
	
	For each ($o;This:C1470.members)
		
		$o.disable()
		
	End for each 
	
/*════════════════════════════════════════════*/