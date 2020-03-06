//%attributes = {}
C_LONGINT:C283($i;$lRef;$lStyle;$lType)
C_POINTER:C301($ptr)
C_TEXT:C284($t;$tName)

$ptr:=This:C1470.list
GET LIST ITEM:C378($ptr->;*;$lRef;$tName)

If ($lRef>0)
	
	If (Macintosh option down:C545 | Windows Alt down:C563) & Shift down:C543  //Delete typing
		
		SET LIST ITEM PARAMETER:C986($ptr->;$lRef;"type";0)
		
		For ($i;1;14;1)
			
			Get pointer:C304("<>b"+String:C10($i))->:=0
			
		End for 
	End if 
	
	GET LIST ITEM PARAMETER:C985($ptr->;$lRef;"type";$lType)
	$lType:=Abs:C99($lType)
	
	Case of 
			
			  //--------------------------------------
		: ($lType>1000)
			
			$lType:=$lType-1000
			$lStyle:=Bold:K14:2+Italic:K14:3
			
			(OBJECT Get pointer:C1124(Object named:K67:5;"var.NotParameter"))->:=1
			(OBJECT Get pointer:C1124(Object named:K67:5;"array.NotParameter"))->:=0
			
			OBJECT SET ENABLED:C1123(*;"NotInArray_@";False:C215)
			OBJECT SET ENABLED:C1123(*;"@.NotParameter";False:C215)
			
			  //--------------------------------------
		: ($lType>100)
			
			$lType:=$lType-100
			$lStyle:=Bold:K14:2+Underline:K14:4
			
			(OBJECT Get pointer:C1124(Object named:K67:5;"var.NotParameter"))->:=0
			(OBJECT Get pointer:C1124(Object named:K67:5;"array.NotParameter"))->:=1
			
			OBJECT SET ENABLED:C1123(*;"NotInArray_@";False:C215)
			OBJECT SET ENABLED:C1123(*;"@.NotParameter";True:C214)
			
			  //--------------------------------------
		: ($lType=0)
			
			$lStyle:=Italic:K14:3
			
			  //--------------------------------------
		Else 
			
			$lStyle:=Bold:K14:2
			
			(OBJECT Get pointer:C1124(Object named:K67:5;"var.NotParameter"))->:=1
			(OBJECT Get pointer:C1124(Object named:K67:5;"array.NotParameter"))->:=0
			
			OBJECT SET ENABLED:C1123(*;"NotInArray_@";True:C214)
			
			  //--------------------------------------
	End case 
	
	SET LIST ITEM PROPERTIES:C386($ptr->;$lRef;False:C215;$lStyle;"path:/RESOURCES/Images/types/field_"+String:C10($lType)+".png")
	
	If (Match regex:C1019("(?m-si)\\$(?:(?:\\d+)|(?:\\{\\d*\\})+)";$tName;1))
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"var.NotParameter"))->:=1
		(OBJECT Get pointer:C1124(Object named:K67:5;"array.NotParameter"))->:=0
		OBJECT SET ENABLED:C1123(*;"@.NotParameter";False:C215)
		
	Else 
		
		OBJECT SET ENABLED:C1123(*;"@.NotParameter";True:C214)
		
	End if 
	
	If ($lType=1)
		
		GET LIST ITEM PARAMETER:C985($ptr->;$lRef;"size";$t)
		(OBJECT Get pointer:C1124(Object named:K67:5;"Alpha_Length"))->:=$t
		
	Else 
		
		If ($lType=7)
			
			OBJECT SET ENABLED:C1123(*;"array.@";False:C215)
			
		End if 
	End if 
	
	For ($i;1;15;1)
		
		(Get pointer:C304("<>b"+String:C10($i)))->:=Num:C11($i=$lType)
		
	End for 
	
Else 
	
	  //No line selected
	
End if 

(OBJECT Get pointer:C1124(Object named:K67:5;"spinner"))->:=0
OBJECT SET VISIBLE:C603(*;"spinner";False:C215)