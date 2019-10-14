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
If (This:C1470=Null:C1517)
	
	$o:=New object:C1471(\
		"_is";"menu";\
		"ref";Create menu:C408;\
		"autoRelease";True:C214;\
		"metacharacters";False:C215;\
		"selected";False:C215;\
		"choice";"";\
		"append";Formula:C1597(menu ("append";Choose:C955(Value type:C1509($2)=Is object:K8:27;New object:C1471("item";String:C10($1);"menu";$2);New object:C1471("item";String:C10($1);"param";$2;"mark";Bool:C1537($3)))));\
		"insert";Formula:C1597(menu ("insert";Choose:C955(Value type:C1509($3)=Is object:K8:27;New object:C1471("item";String:C10($1);"after";Num:C11($2);"menu";$3);New object:C1471("item";String:C10($1);"after";Num:C11($2);"param";$3;"mark";Bool:C1537($4)))));\
		"line";Formula:C1597(menu ("line"));\
		"method";Formula:C1597(SET MENU ITEM METHOD:C982(This:C1470.ref;Choose:C955(Count parameters:C259=2;Num:C11($2);-1);String:C10($1)));\
		"action";Formula:C1597(SET MENU ITEM PROPERTY:C973(This:C1470.ref;Choose:C955(Count parameters:C259=2;Num:C11($2);-1);Associated standard action:K28:8;$1));\
		"shortcut";Formula:C1597(SET MENU ITEM SHORTCUT:C423(This:C1470.ref;Choose:C955(Count parameters:C259=3;$3;-1);$1;Num:C11($2)));\
		"icon";Formula:C1597(SET MENU ITEM ICON:C984(This:C1470.ref;Choose:C955(Count parameters:C259=2;Num:C11($2);-1);"file:"+String:C10($1)));\
		"release";Formula:C1597(RELEASE MENU:C978(This:C1470.ref));\
		"enable";Formula:C1597(ENABLE MENU ITEM:C149(This:C1470.ref;Choose:C955(Count parameters:C259=1;Num:C11($1);-1)));\
		"disable";Formula:C1597(DISABLE MENU ITEM:C150(This:C1470.ref;Choose:C955(Count parameters:C259=1;Num:C11($1);-1)));\
		"delete";Formula:C1597(DELETE MENU ITEM:C413(This:C1470.ref;Choose:C955(Count parameters:C259=1;Num:C11($1);-1)));\
		"popup";Formula:C1597(menu ("popup";Choose:C955(Count parameters:C259=1;New object:C1471("default";String:C10($1));Choose:C955(Value type:C1509($2)=Is object:K8:27;New object:C1471("default";String:C10($1);"widget";$2);New object:C1471("default";String:C10($1);"xCoord";$2;"yCoord";$3)))));\
		"cleanup";Formula:C1597(menu ("cleanup"));\
		"count";Formula:C1597(Count menu items:C405(This:C1470.ref));\
		"standardEditMenu";Formula:C1597(menu ("standardEditMenu"));\
		"setBar";Formula:C1597(menu ("setBar"))\
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
		: ($1="line")
			
			APPEND MENU ITEM:C411($o.ref;"-")
			
			  //______________________________________________________
		: ($1="setBar")
			
			SET MENU BAR:C67($o.ref)
			
			If ($o.autoRelease)
				
				$o.release()
				
			End if 
			
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
		: ($1="standardEditMenu")  // Create a standard edit menu
			
			$o.append(":xliff:CommonMenuItemCut").action(ak cut:K76:53).shortcut("X")
			$o.append(":xliff:CommonMenuItemCopy").action(ak copy:K76:54).shortcut("C")
			$o.append(":xliff:CommonMenuItemPaste").action(ak paste:K76:55).shortcut("V")
			$o.append(":xliff:CommonMenuItemClear").action(ak clear:K76:56)
			$o.append(":xliff:CommonMenuItemSelectAll").action(ak select all:K76:57).shortcut("A")
			
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