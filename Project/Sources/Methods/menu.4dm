//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : menu
  // ID[7F62512A7B7C487C97E780DCE95400AB]
  // Created 11-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Manipulate menus as objects to make code more readable
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($i)
C_TEXT:C284($t)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(menu ;$0)
	C_TEXT:C284(menu ;$1)
	C_OBJECT:C1216(menu ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)
	
	$o:=New object:C1471(\
		"";"menu";\
		"ref";Create menu:C408;\
		"autoRelease";True:C214;\
		"metacharacters";False:C215;\
		"selected";False:C215;\
		"choice";"";\
		"release";Formula:C1597(RELEASE MENU:C978(This:C1470.ref));\
		"count";Formula:C1597(Count menu items:C405(This:C1470.ref));\
		"action";Formula:C1597(menu ("action";New object:C1471("action";$1;"item";$2)));\
		"append";Formula:C1597(menu ("append";Choose:C955(Value type:C1509($2)=Is object:K8:27;New object:C1471("item";String:C10($1);"menu";$2);New object:C1471("item";String:C10($1);"param";$2;"mark";Bool:C1537($3)))));\
		"cleanup";Formula:C1597(menu ("cleanup"));\
		"editMenu";Formula:C1597(menu ("editMenu"));\
		"enable";Formula:C1597(menu ("enable";New object:C1471("item";$1)));\
		"delete";Formula:C1597(menu ("delete";New object:C1471("item";$1)));\
		"disable";Formula:C1597(menu ("disable";New object:C1471("item";$1)));\
		"fileMenu";Formula:C1597(menu ("fileMenu"));\
		"icon";Formula:C1597(menu ("icon";New object:C1471("icon";$1;"item";$2)));\
		"insert";Formula:C1597(menu ("insert";Choose:C955(Value type:C1509($3)=Is object:K8:27;New object:C1471("item";String:C10($1);"after";Num:C11($2);"menu";$3);New object:C1471("item";String:C10($1);"after";Num:C11($2);"param";$3;"mark";Bool:C1537($4)))));\
		"line";Formula:C1597(menu ("line"));\
		"loadBar";Formula:C1597(menu ("loadBar";New object:C1471("menu";$1)));\
		"method";Formula:C1597(menu ("method";New object:C1471("method";String:C10($1);"item";$2)));\
		"popup";Formula:C1597(menu ("popup";Choose:C955(Count parameters:C259=1;New object:C1471("default";String:C10($1));Choose:C955(Value type:C1509($2)=Is object:K8:27;New object:C1471("default";String:C10($1);"widget";$2);New object:C1471("default";String:C10($1);"xCoord";$2;"yCoord";$3)))));\
		"setBar";Formula:C1597(menu ("setBar"));\
		"shortcut";Formula:C1597(menu ("shortcut";New object:C1471("shortcut";$1;"modifier";Num:C11($2);"item";$3)))\
		)
	
	If (Count parameters:C259>=1)
		
		$c:=Split string:C1554(String:C10($1);";")
		
		$o.autoRelease:=($c.indexOf("keepReference")=-1)
		$o.metacharacters:=($c.indexOf("displayMetacharacters")#-1)
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="action")
			
			SET MENU ITEM PROPERTY:C973($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1);Associated standard action:K28:8;$2.action)
			
			  //______________________________________________________
		: ($1="append")
			
			ASSERT:C1129(Length:C16($2.item)>0)
			
			If ($2.menu#Null:C1517)  // Submenu
				
				If ($o.metacharacters)
					
					APPEND MENU ITEM:C411($o.ref;$2.item;$2.menu.ref)
					
				Else 
					
					APPEND MENU ITEM:C411($o.ref;$2.item;$2.menu.ref;*)
					
				End if 
				
				If ($2.menu.autoRelease)
					
					RELEASE MENU:C978($2.menu.ref)
					
				End if 
				
			Else   // Item
				
				If ($o.metacharacters)
					
					APPEND MENU ITEM:C411($o.ref;$2.item)
					
				Else 
					
					APPEND MENU ITEM:C411($o.ref;$2.item;*)
					
				End if 
				
				SET MENU ITEM PARAMETER:C1004($o.ref;-1;String:C10($2.param))
				SET MENU ITEM MARK:C208($o.ref;-1;Char:C90(18)*Num:C11($2.mark))
				
			End if 
			
			  //______________________________________________________
		: ($1="cleanup")
			
			Repeat   // Remove unnecessary lines at the end
				
				$i:=$o.count()
				
				$t:=Get menu item:C422($o.ref;$i)
				
				If ($t="-")
					
					$o.delete($i)
					
				End if 
			Until ($t#"-")
			
			  // #MARK_TODO
			  // Remove duplicates (lines or items)
			
			  //______________________________________________________
		: ($1="editMenu")  // Standard edit menu
			
			$o.append(":xliff:CommonMenuItemUndo").action(ak undo:K76:51).shortcut("Z")
			$o.append(":xliff:CommonMenuRedo").action(ak redo:K76:52).shortcut("Z";512)
			$o.line()
			$o.append(":xliff:CommonMenuItemCut").action(ak cut:K76:53).shortcut("X")
			$o.append(":xliff:CommonMenuItemCopy").action(ak copy:K76:54).shortcut("C")
			$o.append(":xliff:CommonMenuItemPaste").action(ak paste:K76:55).shortcut("V")
			$o.append(":xliff:CommonMenuItemClear").action(ak clear:K76:56)
			$o.append(":xliff:CommonMenuItemSelectAll").action(ak select all:K76:57).shortcut("A")
			$o.line()
			$o.append(":xliff:CommonMenuItemShowClipboard").action(ak show clipboard:K76:58)
			
			  //______________________________________________________
		: ($1="enable")
			
			ENABLE MENU ITEM:C149($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1))
			
			  //______________________________________________________
		: ($1="delete")
			
			DELETE MENU ITEM:C413(This:C1470.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1))
			
			  //______________________________________________________
		: ($1="disable")
			
			DISABLE MENU ITEM:C150($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1))
			
			  //______________________________________________________
		: ($1="fileMenu")  // Default file menu
			
			$o.append(":xliff:CommonMenuItemQuit").action(ak quit:K76:61).shortcut("Q")
			
			  //______________________________________________________
		: ($1="icon")
			
			SET MENU ITEM ICON:C984($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1);"file:"+String:C10($2.icon))
			
			  //______________________________________________________
		: ($1="insert")
			
			ASSERT:C1129(Length:C16($2.item)>0)
			
			If (String:C10($2._is)="menu")  // Submenu
				
				If ($o.metacharacters)
					
					INSERT MENU ITEM:C412($o.ref;$2.after;$2.item;$2.menu.ref)
					
				Else 
					
					INSERT MENU ITEM:C412($o.ref;$2.after;$2.item;$2.menu.ref;*)
					
				End if 
				
				If ($2.menu.autoRelease)
					
					RELEASE MENU:C978($2.menu.ref)
					
				End if 
				
			Else   // Item
				
				If ($o.metacharacters)
					
					INSERT MENU ITEM:C412($o.ref;$2.after;$2.item)
					
				Else 
					
					INSERT MENU ITEM:C412($o.ref;$2.after;$2.item;*)
					
				End if 
				
				SET MENU ITEM PARAMETER:C1004($o.ref;-1;String:C10($2.param))
				SET MENU ITEM MARK:C208($o.ref;-1;Char:C90(18)*Num:C11($2.mark))
				
			End if 
			
			  //______________________________________________________
		: ($1="line")
			
			APPEND MENU ITEM:C411($o.ref;"-")
			
			  //______________________________________________________
		: ($1="method")
			
			SET MENU ITEM METHOD:C982($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1);$2.method)
			
			  //______________________________________________________
		: ($1="popup")
			
			$o.cleanup()
			
			If ($2.widget#Null:C1517)  // Widget reference
				
				$o.choice:=Dynamic pop up menu:C1006($o.ref;$2.default;Num:C11($2.widget.windowCoordinates.left);Num:C11($2.widget.windowCoordinates.bottom))
				
			Else 
				
				If ($2.xCoord#Null:C1517)
					
					$o.choice:=Dynamic pop up menu:C1006($o.ref;$2.default;Num:C11($2.xCoord);Num:C11($2.yCoord))
					
				Else 
					
					$o.choice:=Dynamic pop up menu:C1006($o.ref;$2.default)
					
				End if 
			End if 
			
			$o.selected:=(Length:C16(String:C10($o.choice))>0)
			
			If ($o.autoRelease)
				
				$o.release()
				
			End if 
			
			  //______________________________________________________
		: ($1="setBar")
			
			SET MENU BAR:C67($o.ref)
			
			If ($o.autoRelease)
				
				$o.release()
				
			End if 
			
			  //______________________________________________________
		: ($1="shortcut")
			
			SET MENU ITEM SHORTCUT:C423($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1);$2.shortcut;$2.modifier)
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End