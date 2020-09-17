Class constructor
	
	C_VARIANT:C1683($1)
	C_COLLECTION:C1488($c)
	
	This:C1470.ref:=Null:C1517
	This:C1470.autoRelease:=True:C214
	This:C1470.metacharacters:=False:C215
	This:C1470.selected:=False:C215
	This:C1470.choice:=""
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($1)=Is text:K8:3)
				
				Case of 
						
						//______________________________________________________
					: ($1="menuBar")
						
						This:C1470.ref:=Get menu bar reference:C979
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)\\|MR\\|\\d{12}";$1;1))
						
						// Menu reference
						This:C1470.ref:=$1
						
						//______________________________________________________
					Else 
						
						This:C1470.ref:=Create menu:C408
						
						$c:=Split string:C1554(String:C10($1);";")
						
						Case of 
								
								//-----------------
							: ($c.length>1)
								
								This:C1470.autoRelease:=($c.indexOf("keepReference")=-1)
								This:C1470.metacharacters:=($c.indexOf("displayMetacharacters")#-1)
								
								//-----------------
							: ($1="keepReference")
								
								This:C1470.autoRelease:=False:C215
								
								//-----------------
							: ($1="displayMetacharacters")
								
								This:C1470.metacharacters:=True:C214
								
								//-----------------
							Else 
								
								// Menu bar name
								This:C1470.ref:=Create menu:C408($1)
								
								//-----------------
						End case 
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
			: (Value type:C1509($1)=Is collection:K8:32)
				
				This:C1470.ref:=Create menu:C408
				This:C1470.append($1)
				
				//______________________________________________________
			: (Value type:C1509($1)=Is real:K8:4)
				
				// Menu bar number
				This:C1470.ref:=Create menu:C408($1)
				
				//______________________________________________________
			Else 
				
				This:C1470.ref:=Create menu:C408
				
				//______________________________________________________
		End case 
		
	Else 
		
		This:C1470.ref:=Create menu:C408
		
	End if 
	
/*===============================================*/
Function __isMenu
	
	C_BOOLEAN:C305($0)
	
	If (Asserted:C1132(This:C1470.ref#Null:C1517;Current method name:C684+": The menu reference is null"))
		
		$0:=True:C214
		
	End if 
	
/*===============================================*/
Function release
	
	If (This:C1470.__isMenu())
		
		RELEASE MENU:C978(This:C1470.ref)
		This:C1470.ref:=Null:C1517
		
	End if 
	
/*===============================================*/
Function append
	
	C_VARIANT:C1683($1;$2)
	C_BOOLEAN:C305($3)
	
	C_TEXT:C284($t)
	C_OBJECT:C1216($o)
	
	Case of 
			
			//______________________________________________________
		: (Not:C34(This:C1470.__isMenu()))
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			$t:=Get localized string:C991($1)
			$t:=Choose:C955(Length:C16($t)>0;$t;$1)
			
			ASSERT:C1129(Length:C16($t)>0;Current method name:C684+": An empty item will not be displayed")
			
			If (Count parameters:C259>=2)
				
				If (Value type:C1509($2)=Is object:K8:27)// Submenu
					
					If (This:C1470.metacharacters)
						
						APPEND MENU ITEM:C411(This:C1470.ref;$t;$2.ref)
						
					Else 
						
						APPEND MENU ITEM:C411(This:C1470.ref;$t;$2.ref;*)
						
					End if 
					
					If ($2.autoRelease)
						
						RELEASE MENU:C978($2.ref)
						
					End if 
					
				Else 
					
					If (This:C1470.metacharacters)
						
						APPEND MENU ITEM:C411(This:C1470.ref;$t)
						
					Else 
						
						APPEND MENU ITEM:C411(This:C1470.ref;$t;*)
						
					End if 
					
					If (Count parameters:C259>1)
						
						SET MENU ITEM PARAMETER:C1004(This:C1470.ref;-1;String:C10($2))
						
						If (Count parameters:C259>2)
							
							SET MENU ITEM MARK:C208(This:C1470.ref;-1;Char:C90(18)*Num:C11($3))
							
						End if 
					End if 
				End if 
			Else 
				
				If (This:C1470.metacharacters)
					
					APPEND MENU ITEM:C411(This:C1470.ref;$t)
					
				Else 
					
					APPEND MENU ITEM:C411(This:C1470.ref;$t;*)
					
				End if 
			End if 
			
			//______________________________________________________
		: (Value type:C1509($1)=Is collection:K8:32)
			
			For each ($o;$1)
				
				If (This:C1470.metacharacters)
					
					APPEND MENU ITEM:C411(This:C1470.ref;String:C10($o.label))
					
				Else 
					
					APPEND MENU ITEM:C411(This:C1470.ref;String:C10($o.label);*)
					
				End if 
				
				SET MENU ITEM PARAMETER:C1004(This:C1470.ref;-1;String:C10($o.parameter))
				SET MENU ITEM MARK:C208(This:C1470.ref;-1;Char:C90(18)*Num:C11($o.marked))
				
				If ($o.action#Null:C1517)
					
					This:C1470.action($o.action)
					
				End if 
				
				If ($o.enabled#Null:C1517)
					
					This:C1470.enable(Bool:C1537($o.enabled))
					
				End if 
				
				If ($o.icon#Null:C1517)
					
					This:C1470.icon(String:C10($o.icon))
					
				End if 
				
				If ($o.method#Null:C1517)
					
					This:C1470.method(String:C10($o.method))
					
				End if 
				
				If ($o.shortcut#Null:C1517)
					
					This:C1470.shortcut($o.shortcut)
					
				End if 
			End for each 
			
			//______________________________________________________
		Else 
			
			// A "Case of" statement should never omit "Else"
			//______________________________________________________
	End case 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function delete
	
	C_LONGINT:C283($1)
	
	If (Count parameters:C259=0)
		
		DELETE MENU ITEM:C413(This:C1470.ref;-1)
		
	Else 
		
		DELETE MENU ITEM:C413(This:C1470.ref;$1)
		
	End if 
	
/*===============================================*/
Function line
	
	APPEND MENU ITEM:C411(This:C1470.ref;"-(")
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function enable
	
	C_BOOLEAN:C305($1)
	C_LONGINT:C283($2)
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			ENABLE MENU ITEM:C149(This:C1470.ref;-1)
			
			//______________________________________________________
		: (Count parameters:C259=1)
			
			If ($1)
				
				ENABLE MENU ITEM:C149(This:C1470.ref;-1)
				
			Else 
				
				DISABLE MENU ITEM:C150(This:C1470.ref;-1)
				
			End if 
			
			//______________________________________________________
		Else 
			
			If ($1)
				
				ENABLE MENU ITEM:C149(This:C1470.ref;$2)
				
			Else 
				
				DISABLE MENU ITEM:C150(This:C1470.ref;$2)
				
			End if 
			
			//______________________________________________________
	End case 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function disable
	
	C_LONGINT:C283($1)
	
	If (Count parameters:C259=0)
		
		DISABLE MENU ITEM:C150(This:C1470.ref;-1)
		
	Else 
		
		DISABLE MENU ITEM:C150(This:C1470.ref;$1)
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function action
	
	C_VARIANT:C1683($1)// Text, Number, Boolean
	C_LONGINT:C283($2)
	
	If (Count parameters:C259=1)
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref;-1;Associated standard action:K28:8;$1)
		
	Else 
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref;$2;Associated standard action:K28:8;$1)
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function parameter
	
	C_TEXT:C284($1)
	C_LONGINT:C283($2)
	
	If (Count parameters:C259=0)
		
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref;-1;$1)
		
	Else 
		
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref;$2;$1)
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function property
	
	C_TEXT:C284($1)// property
	C_VARIANT:C1683($2)// value (Text, Number or Boolean)
	C_LONGINT:C283($3)// {target}
	
	If (Count parameters:C259>=3)
		
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref;$3;$1;$2)
		
	Else 
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref;-1;$1;$2)
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function mark
	
	C_BOOLEAN:C305($1)
	C_LONGINT:C283($2)
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			SET MENU ITEM MARK:C208(This:C1470.ref;-1;Char:C90(18))
			
			//______________________________________________________
		: (Count parameters:C259=1)
			
			SET MENU ITEM MARK:C208(This:C1470.ref;-1;Char:C90(18)*Num:C11($1))
			
			//______________________________________________________
		Else 
			
			SET MENU ITEM MARK:C208(This:C1470.ref;$2;Char:C90(18)*Num:C11($1))
			
			//______________________________________________________
	End case 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function shortcut
	
	C_VARIANT:C1683($1)
	C_LONGINT:C283($2)
	
	If (Count parameters:C259>=2)
		
		If (Value type:C1509($1)=Is object:K8:27)
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref;$2;String:C10($1.key);Num:C11($1.modifier))
			
		Else 
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref;$2;String:C10($1);0)
			
		End if 
		
	Else 
		
		If (Value type:C1509($1)=Is object:K8:27)
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref;-1;String:C10($1.key);Num:C11($1.modifier))
			
		Else 
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref;-1;String:C10($1);0)
			
		End if 
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function method
	
	C_TEXT:C284($1)
	C_LONGINT:C283($2)
	
	If (Count parameters:C259>1)
		
		SET MENU ITEM METHOD:C982(This:C1470.ref;$2;$1)
		
	Else 
		
		SET MENU ITEM METHOD:C982(This:C1470.ref;-1;$1)
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function icon
	
	C_TEXT:C284($1)
	C_LONGINT:C283($2)
	
	If (Count parameters:C259>1)
		
		SET MENU ITEM ICON:C984(This:C1470.ref;$2;"path:"+$1)
		
	Else 
		
		SET MENU ITEM ICON:C984(This:C1470.ref;-1;"path:"+$1)
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function setBar
	
	This:C1470.__cleanup()
	
	SET MENU BAR:C67(This:C1470.ref)
	
	If (This:C1470.autoRelease)
		
		This:C1470.release()
		
	End if 
	
/*===============================================*/
Function popup
	
	C_VARIANT:C1683($1)
	C_VARIANT:C1683($2)
	C_LONGINT:C283($3)
	
	This:C1470.__cleanup()
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)// At the current location of the mouse
			
			This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref)
			
			//______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)// Widget reference {; default}
			
			If (Count parameters:C259>1)
				
				This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref;String:C10($2);Num:C11($1.windowCoordinates.left);Num:C11($1.windowCoordinates.bottom))
				
			Else 
				
				This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref;"";Num:C11($1.windowCoordinates.left);Num:C11($1.windowCoordinates.bottom))
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)//  default {; x ; y }
			
			If (Count parameters:C259>2)
				
				This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref;$1;Num:C11($2);$3)
				
			Else 
				
				This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref;$1)
				
			End if 
			
			//______________________________________________________
		: (Count parameters:C259<2)
			
			ASSERT:C1129(False:C215;"Missing x & y parameters")
			
			//______________________________________________________
		Else // x ; y  (no item selected)
			
			This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref;"";Num:C11($1);Num:C11($2))
			
			//______________________________________________________
	End case 
	
	This:C1470.selected:=(Length:C16(This:C1470.choice)>0)
	
	If (This:C1470.autoRelease)
		
		This:C1470.release()
		
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function __cleanup// Remove duplicates (lines or items)
	
	C_LONGINT:C283($count;$i)
	C_COLLECTION:C1488($c)
	C_BOOLEAN:C305($b)
	C_OBJECT:C1216($o)
	C_TEXT:C284($t)
	
	Repeat // Remove unwanted lines at the top
		
		$count:=Count menu items:C405(This:C1470.ref)
		$b:=($count>0)
		
		If ($b)
			
			$t:=Get menu item:C422(This:C1470.ref;1)
			$b:=(Length:C16($t)>0)
			
			If ($b)
				
				$b:=($t[[1]]="-")
				
				If ($b)
					
					This:C1470.delete(1)
					
				End if 
			End if 
		End if 
	Until (Not:C34($b))
	
	If ($count>0)
		
		Repeat // Remove unnecessary lines at the end
			
			$count:=Count menu items:C405(This:C1470.ref)
			$t:=Get menu item:C422(This:C1470.ref;$count)
			$b:=(Length:C16($t)>0)
			
			If ($b)
				
				$b:=($t[[1]]="-")
				
				If ($b)
					
					This:C1470.delete($count)
					
				End if 
			End if 
		Until (Not:C34($b))
	End if 
	
	// Remove duplicates (lines or items)
	For ($i;Count menu items:C405(This:C1470.ref);2;-1)
		
		If (Get menu item:C422(This:C1470.ref;$i)=Get menu item:C422(This:C1470.ref;$i-1))
			
			This:C1470.delete($i)
			
		End if 
	End for 
	
/*===============================================*/
Function file// Default File menu
	
	This:C1470.append(":xliff:CommonMenuItemQuit").action(ak quit:K76:61).shortcut("Q")
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function edit// Standard Edit menu
	
	This:C1470.append(":xliff:CommonMenuItemUndo").action(ak undo:K76:51).shortcut("Z")
	This:C1470.append(":xliff:CommonMenuRedo").action(ak redo:K76:52).shortcut("Z";512)
	This:C1470.line()
	This:C1470.append(":xliff:CommonMenuItemCut").action(ak cut:K76:53).shortcut("X")
	This:C1470.append(":xliff:CommonMenuItemCopy").action(ak copy:K76:54).shortcut("C")
	This:C1470.append(":xliff:CommonMenuItemPaste").action(ak paste:K76:55).shortcut("V")
	This:C1470.append(":xliff:CommonMenuItemClear").action(ak clear:K76:56)
	This:C1470.append(":xliff:CommonMenuItemSelectAll").action(ak select all:K76:57).shortcut("A")
	This:C1470.line()
	This:C1470.append(":xliff:CommonMenuItemShowClipboard").action(ak show clipboard:K76:58)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function fonts// Fonts menu with or without styles
	
	C_BOOLEAN:C305($1;$b)
	C_LONGINT:C283($i;$j)
	C_TEXT:C284($Mnu_styles)
	
	If (Count parameters:C259>0)
		
		$b:=$1
		
	End if 
	
	ARRAY TEXT:C222($tTxt_fontsFamilly;0x0000)
	FONT LIST:C460($tTxt_fontsFamilly)
	
	If ($b)
		
		For ($i;1;Size of array:C274($tTxt_fontsFamilly);1)
			
			ARRAY TEXT:C222($tTxt_styles;0x0000)
			ARRAY TEXT:C222($tTxt_names;0x0000)
			
			FONT STYLE LIST:C1362($tTxt_fontsFamilly{$i};$tTxt_styles;$tTxt_names)
			
			If (Size of array:C274($tTxt_styles)>0)
				
				If (Size of array:C274($tTxt_styles)>1)
					
					$Mnu_styles:=Create menu:C408
					
					For ($j;1;Size of array:C274($tTxt_styles);1)
						
						APPEND MENU ITEM:C411($Mnu_styles;$tTxt_styles{$j})// Localized name
						SET MENU ITEM PARAMETER:C1004($Mnu_styles;-1;$tTxt_names{$j})// System name
						
					End for 
					
					APPEND MENU ITEM:C411(This:C1470.ref;$tTxt_fontsFamilly{$i};$Mnu_styles)// Familly name
					RELEASE MENU:C978($Mnu_styles)
					
				Else 
					
					APPEND MENU ITEM:C411(This:C1470.ref;$tTxt_fontsFamilly{$i})
					SET MENU ITEM PARAMETER:C1004(This:C1470.ref;-1;$tTxt_names{1})
					
				End if 
				
			Else 
				
				This:C1470.append($tTxt_fontsFamilly{$i};$tTxt_fontsFamilly{$i})// Familly name
				
			End if 
		End for 
		
	Else 
		
		For ($i;1;Size of array:C274($tTxt_fontsFamilly);1)
			
			This:C1470.append($tTxt_fontsFamilly{$i};$tTxt_fontsFamilly{$i})// Familly name
			
		End for 
	End if 
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*===============================================*/
Function windows// Windows menu
	
	C_OBJECT:C1216($0)
	C_COLLECTION:C1488($c)
	C_LONGINT:C283($i;$j;$l)
	C_TEXT:C284($t)
	C_OBJECT:C1216($o)
	
	ARRAY LONGINT:C221($aL;0x0000)
	WINDOW LIST:C442($aL)
	
	$c:=New collection:C1472
	
	For ($i;1;Size of array:C274($aL);1)
		
		$c.push(New object:C1471(\
			"ref";$aL{$i};\
			"name";Get window title:C450($aL{$i});\
			"process";Window process:C446($aL{$i})))
		
	End for 
	
	$c:=$c.orderBy(New collection:C1472(\
		New object:C1471("propertyPath";"process";"descending";True:C214);\
		New object:C1471(\
		"propertyPath";"name")))
	
	If ($c.length>0)
		
		$l:=Frontmost window:C447
		
		$j:=$c[0].process
		$t:=Substring:C12($c[0].name;1;Position:C15(":";$c[0].name))
		
		For each ($o;$c)
			
			If ($o.process#$j)\
				 | (Substring:C12($o.name;1;Position:C15(":";$o.name))#$t)
				
				This:C1470.line()
				$j:=$o.process
				$t:=Substring:C12($o.name;1;Position:C15(":";$o.name))
				
			End if 
			
			This:C1470.append($o.name;$o.ref;$l=$o.ref)
			
		End for each 
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function itemCount
	
	C_LONGINT:C283($0)
	
	$0:=Count menu items:C405(This:C1470.ref)
	
/*===============================================*/
Function items// Returns menu items as collection
	
	C_COLLECTION:C1488($0)
	C_LONGINT:C283($i)
	
	ARRAY TEXT:C222($aT_item;0x0000)
	ARRAY TEXT:C222($aT_ref;0x0000)
	GET MENU ITEMS:C977(This:C1470.ref;$aT_item;$aT_ref)
	
	$0:=New collection:C1472
	
	For ($i;1;Size of array:C274($aT_item);1)
		
		$0.push(New object:C1471(\
			"item";$aT_item{$i};\
			"ref";$aT_ref{$i}))
		
	End for 
	
/*===============================================*/
Function getReference
	
	C_TEXT:C284($0)
	C_VARIANT:C1683($1)
	
	C_LONGINT:C283($indx)
	
	ARRAY TEXT:C222($aT_titles;0)
	ARRAY TEXT:C222($aT_refs;0)
	GET MENU ITEMS:C977(This:C1470.ref;$aT_titles;$aT_refs)
	
	Case of 
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			$indx:=Find in array:C230($aT_titles;$1)
			
			//______________________________________________________
		: (Value type:C1509($1)=Is real:K8:4)
			
			$indx:=$1
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;Current method name:C684+": invalid type")
			
			//______________________________________________________
	End case 
	
	If (Asserted:C1132($indx>0;"Item \""+String:C10($1)+"\" not found"))
		
		$0:=$aT_refs{$indx}
		
	End if 