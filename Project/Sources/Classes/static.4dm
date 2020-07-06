/*

Static objects are generally used for setting the appearance of the form and its 
labels as well as for the graphic interface.Static objects do not have 
associated variables like active objects.

            ╔══════════════════════════════════════════════╗
            ║ This is the parent class of all form objects ║
            ╚══════════════════════════════════════════════╝

                                ┏━━━━━━━━┓           ┏━━━━━━━━━┓
                             ┏━━┫ button ┃        ┏━━┫ picture ┃
                             ┃  ┗━━━━━━━━┛        ┃  ┗━━━━━━━━━┛
┏━━━━━━━━┓     ┏━━━━━━━━┓    ┃  ┏━━━━━━━━━━━━┓    ┃  ┏━━━━━━━━━┓
┃ static ┣━━━━━┫ widget ┣━━━━╋━━┫ scrollable ┣━━━━╋━━┫ listbox ┃
┗━━━━━━━━┛     ┗━━━━━━━━┛    ┃  ┗━━━━━━━━━━━━┛    ┃  ┗━━━━━━━━━┛
                             ┃  ┏━━━━━━━━━━┓      ┃  ┏━━━━━━━━━┓
                             ┣━━┫ progress ┃      ┗━━┫ subform ┃
                             ┃  ┗━━━━━━━━━━┛         ┗━━━━━━━━━┛
                             ┃  ┏━━━━━━━┓
                             ┣━━┫ input ┃
                             ┃  ┗━━━━━━━┛
                             ┃  ┏━━━━━━━━━┓
                             ┗━━┫ stepper ┃
                                ┗━━━━━━━━━┛
*/

Class constructor
	
	C_TEXT:C284($1)
	
	If (Count parameters:C259>=1)
		
		This:C1470.name:=$1
		
	Else 
		
		  // Called from the widget method
		This:C1470.name:=OBJECT Get name:C1087(Object current:K67:2)
		
	End if 
	
	This:C1470.type:=OBJECT Get type:C1300(*;This:C1470.name)
	
	If (Asserted:C1132(This:C1470.type#0;Current method name:C684+": No objects found named \""+This:C1470.name+"\""))
		
		This:C1470._updateCoordinates()
		
	End if 
	
/*════════════════════════════════════════════
.hide() -> This
══════════════════════════*/
Function hide
	
	OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.show() -> This
.show(bool) -> This
══════════════════════════*/
Function show
	
	C_BOOLEAN:C305($1)
	
	If (Count parameters:C259>=1)
		
		If ($1)
			
			OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214)
			
		Else 
			
			OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215)
			
		End if 
		
	Else 
		
		OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214)
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════*/
Function getVisible
	
	C_BOOLEAN:C305($0)
	
	$0:=OBJECT Get visible:C1075(*;This:C1470.name)
	
/*════════════════════════════════════════════
.enable() -> This
.enable(bool) -> This
══════════════════════════*/
Function enable
	
	C_BOOLEAN:C305($1)
	
	If (Count parameters:C259>=1)
		
		If ($1)
			
			OBJECT SET ENABLED:C1123(*;This:C1470.name;True:C214)
			
		Else 
			
			OBJECT SET ENABLED:C1123(*;This:C1470.name;False:C215)
			
		End if 
		
	Else 
		
		OBJECT SET ENABLED:C1123(*;This:C1470.name;True:C214)
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.disable() -> This
══════════════════════════*/
Function disable
	
	OBJECT SET ENABLED:C1123(*;This:C1470.name;False:C215)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.setTitle(text) -> This
══════════════════════════*/
Function setTitle
	
	C_TEXT:C284($1)  // Text or resname
	C_TEXT:C284($t)
	
	$t:=Get localized string:C991($1)
	$t:=Choose:C955(Length:C16($t)>0;$t;$1)  // Revert if no localization
	
	OBJECT SET TITLE:C194(*;This:C1470.name;$t)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.getTitle() -> text
══════════════════════════*/
Function getTitle
	
	C_TEXT:C284($0)
	
	$0:=OBJECT Get title:C1068(*;This:C1470.name)
	
/*════════════════════════════════════════════
.setCoordinates (left;top;right;bottom) -> This
.setCoordinates (obj) -> This
  obj = {"left":int,"top":int,"right":int,"bottom":int}
══════════════════════════*/
Function setCoordinates
	
	C_VARIANT:C1683($1)
	C_LONGINT:C283($2;$3;$4)
	
	C_OBJECT:C1216($o)
	
	If (Value type:C1509($1)=Is object:K8:27)
		
		$o:=New object:C1471(\
			"left";Num:C11($1.left);\
			"top";Num:C11($1.top);\
			"right";Num:C11($1.right);\
			"bottom";Num:C11($1.bottom))
		
	Else 
		
		$o:=New object:C1471(\
			"left";Num:C11($1);\
			"top";Num:C11($2);\
			"right";Num:C11($3);\
			"bottom";Num:C11($4))
		
	End if 
	
	OBJECT SET COORDINATES:C1248(*;This:C1470.name;$o.left;$o.top;$o.right;$o.bottom)
	
	This:C1470._updateCoordinates($o.left;$o.top;$o.right;$o.bottom)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.getCoordinates() -> obj 
  obj = {"left":int,"top":int,"right":int,"bottom":int})
══════════════════════════*/
Function getCoordinates
	
	C_OBJECT:C1216($0)
	C_LONGINT:C283($left;$top;$right;$bottom)
	
	OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
	This:C1470._updateCoordinates($left;$top;$right;$bottom)
	
	$0:=This:C1470.coordinates
	
/*════════════════════════════════════════════
.bestSize(obj) -> This
  obj = {"alignment":int,"min":int,"max:int}}
	
.bestSize({alignment{;min{;max}}}) -> This
══════════════════════════*/
Function bestSize
	
	C_VARIANT:C1683($1)
	C_LONGINT:C283($2;$3)
	C_OBJECT:C1216($o)
	C_LONGINT:C283($left;$top;$right;$bottom;$width;$height)
	
	If (Value type:C1509($1)=Is object:K8:27)
		
		$o:=$1
		
		If ($o.alignment=Null:C1517)
			
			$o.alignment:=Align left:K42:2
			
		End if 
		
	Else 
		
		$o:=New object:C1471
		
		If (Count parameters:C259>=1)
			
			$o.alignment:=$1
			
			If (Count parameters:C259>=2)
				
				$o.min:=$2
				
				If (Count parameters:C259>=3)
					
					$o.max:=$3
					
				End if 
			End if 
			
		Else 
			
			$o.alignment:=Align left:K42:2
			
		End if 
	End if 
	
	OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
	
	If ($o.max#Null:C1517)
		
		OBJECT GET BEST SIZE:C717(*;This:C1470.name;$width;$height;$o.max)
		
	Else 
		
		OBJECT GET BEST SIZE:C717(*;This:C1470.name;$width;$height)
		
	End if 
	
	Case of 
			
			  //______________________________
		: (This:C1470.type=Object type static text:K79:2)\
			 | (This:C1470.type=Object type checkbox:K79:26)
			
			If (Num:C11($o.alignment)=Align left:K42:2)
				
				  // Add 10 pixels
				$width:=$width+10
				
			End if 
			
			  //______________________________
		: (This:C1470.type=Object type push button:K79:16)
			
			  // Add 10% for margins
			$width:=Round:C94($width*1.1;0)
			
			  //______________________________
		Else 
			
			  // Add 10 pixels
			$width:=$width+10
			
			  //______________________________
	End case 
	
	If ($o.min#Null:C1517)
		
		$width:=Choose:C955($width<$o.min;$o.min;$width)
		
	End if 
	
	If ($o.alignment=Align right:K42:4)
		
		$left:=$right-$width
		
	Else 
		
		  // Default is Align left
		$right:=$left+$width
		
	End if 
	
	OBJECT SET COORDINATES:C1248(*;This:C1470.name;$left;$top;$right;$bottom)
	This:C1470._updateCoordinates($left;$top;$right;$bottom)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.moveHorizontally(int) -> This
══════════════════════════*/
Function moveHorizontally
	
	C_LONGINT:C283($1)
	C_LONGINT:C283($left;$top;$right;$bottom)
	
	OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
	
	$left:=$left+$1
	$right:=$right+$1
	
	This:C1470.setCoordinates(New object:C1471(\
		"left";$left;\
		"top";$top;\
		"right";$right;\
		"bottom";$bottom))
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.moveVertically(int) -> This
══════════════════════════*/
Function moveVertically
	
	C_LONGINT:C283($1)
	C_LONGINT:C283($left;$top;$right;$bottom)
	
	OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
	
	$top:=$top+$1
	$bottom:=$bottom+$1
	
	This:C1470.setCoordinates(New object:C1471(\
		"left";$left;\
		"top";$top;\
		"right";$right;\
		"bottom";$bottom))
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.resizeHorizontally(int) -> This
══════════════════════════*/
Function resizeHorizontally
	
	C_LONGINT:C283($1)
	C_LONGINT:C283($left;$top;$right;$bottom)
	
	OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
	
	$right:=$right+$1
	
	This:C1470.setCoordinates(New object:C1471(\
		"left";$left;\
		"top";$top;\
		"right";$right;\
		"bottom";$bottom))
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.resizeVertically(int) -> This
══════════════════════════*/
Function resizeVertically
	
	C_LONGINT:C283($1)
	C_LONGINT:C283($left;$top;$right;$bottom)
	
	OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
	
	$bottom:=$bottom+$1
	
	This:C1470.setCoordinates(New object:C1471(\
		"left";$left;\
		"top";$top;\
		"right";$right;\
		"bottom";$bottom))
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════
.setDimension(width {; height}) -> This
══════════════════════════*/
Function setDimension
	
	C_LONGINT:C283($1;$2)
	C_OBJECT:C1216($o)
	
	$o:=This:C1470.getCoordinates()
	$o.right:=$o.left+$1
	
	If (Count parameters:C259>=2)
		
		$o.bottom:=$o.top+$2
		
	End if 
	
	OBJECT SET COORDINATES:C1248(*;This:C1470.name;$o.left;$o.top;$o.right;$o.bottom)
	This:C1470._updateCoordinates($o.left;$o.top;$o.right;$o.bottom)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════*/
Function _updateCoordinates
	
	C_LONGINT:C283($1;$2;$3;$4)
	C_LONGINT:C283($left;$top;$right;$bottom)
	
	If (Count parameters:C259>=4)
		
		$left:=$1
		$top:=$2
		$right:=$3
		$bottom:=$4
		
	Else 
		
		OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
		
	End if 
	
	This:C1470.coordinates:=New object:C1471(\
		"left";$left;\
		"top";$top;\
		"right";$right;\
		"bottom";$bottom)
	
	This:C1470.dimensions:=New object:C1471(\
		"width";$right-$left;\
		"height";$bottom-$top)
	
	CONVERT COORDINATES:C1365($left;$top;XY Current form:K27:5;XY Current window:K27:6)
	CONVERT COORDINATES:C1365($right;$bottom;XY Current form:K27:5;XY Current window:K27:6)
	
	This:C1470.windowCoordinates:=New object:C1471(\
		"left";$left;\
		"top";$top;\
		"right";$right;\
		"bottom";$bottom)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*════════════════════════════════════════════*/