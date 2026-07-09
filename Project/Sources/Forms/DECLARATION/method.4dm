var $e:=FORM Event:C1606

Case of 
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Load:K2:1)
		
		var $c:=[]
		Form:C1466.boolean:=cs:C1710.ui.button.new("boolean").highlightShortcut().bestSize()
		$c.push(Form:C1466.boolean)
		Form:C1466.blob:=cs:C1710.ui.button.new("blob").highlightShortcut().bestSize()
		$c.push(Form:C1466.blob)
		Form:C1466.collection:=cs:C1710.ui.button.new("collection").highlightShortcut().bestSize()
		$c.push(Form:C1466.collection)
		Form:C1466.date:=cs:C1710.ui.button.new("date").highlightShortcut().bestSize()
		$c.push(Form:C1466.date)
		Form:C1466.integer:=cs:C1710.ui.button.new("integer").highlightShortcut().bestSize()
		$c.push(Form:C1466.integer)
		Form:C1466.object:=cs:C1710.ui.button.new("object").highlightShortcut().bestSize()
		$c.push(Form:C1466.object)
		Form:C1466.picture:=cs:C1710.ui.button.new("picture").highlightShortcut().bestSize()
		$c.push(Form:C1466.picture)
		Form:C1466.pointer:=cs:C1710.ui.button.new("pointer").highlightShortcut().bestSize()
		$c.push(Form:C1466.pointer)
		Form:C1466.real:=cs:C1710.ui.button.new("real").highlightShortcut().bestSize()
		$c.push(Form:C1466.real)
		Form:C1466.text:=cs:C1710.ui.button.new("text").highlightShortcut().bestSize()
		$c.push(Form:C1466.text)
		Form:C1466.time:=cs:C1710.ui.button.new("time").highlightShortcut().bestSize()
		$c.push(Form:C1466.time)
		Form:C1466.variant:=cs:C1710.ui.button.new("variant").highlightShortcut().bestSize()
		$c.push(Form:C1466.variant)
		Form:C1466.array:=cs:C1710.ui.button.new("array").highlightShortcut().bestSize()
		$c.push(Form:C1466.array)
		
		Form:C1466.isSelected:=cs:C1710.ui.group.new($c)
		
		Form:C1466.list:=cs:C1710.ui.listbox.new("declarationList")
		Form:C1466.list.events.push(On Mouse Move:K2:35)
		
		Form:C1466.filter:=cs:C1710.ui.button.new("filter")
		Form:C1466.filter.setTitle("All")
		Form:C1466.currentFilter:="all"
		
		// Class picker (shown only for Object-typed variables): all 4D classes from the
		// syntax file + "Object" + the cs.*/4D.* classes referenced in the parsed code
		Form:C1466.classDrop:=cs:C1710.ui.dropDown.new("classPopup"; {values: Form:C1466._classChoices(); placeholder: "Object"}).addToGroup(Form:C1466.isSelected)
		
		cs:C1710.ui.static.new("line1").addToGroup(Form:C1466.isSelected)
		cs:C1710.ui.static.new("line2").addToGroup(Form:C1466.isSelected)
		
		Form:C1466.refresh:=Formula:C1597(declaration_UI("refresh"))
		OBJECT SET SCROLLBAR:C843(*; "declarationList"; 0; 2)
		
		var $o : Object
		For each ($o; Form:C1466.variables)
			
			$o.icon:=Form:C1466._iconFor($o)
			
		End for each 
		
		SELECT LIST ITEMS BY POSITION:C381(*; "filter"; 1)
		Form:C1466.subset:=Form:C1466.variables
		LISTBOX SELECT ROW:C912(*; "declarationList"; 1; lk replace selection:K53:1)
		SET TIMER:C645(-1)
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		Form:C1466.refresh()
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Validate:K2:3)
		
		Form:C1466._apply()
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: (Form:C1466.list.catch($e))
		
		If ($e.code=On Selection Change:K2:29)
			
			Form:C1466.refresh()
			
		End if 
		
		If (Num:C11($e.row)>0)\
			 & (Num:C11($e.row)<=Form:C1466.subset.length)
			
			Form:C1466.list.setHelpTip(Form:C1466.subset[$e.row-1].code)
			
		Else 
			
			Form:C1466.list.setHelpTip("")
			
		End if 
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: (Form:C1466.classDrop.catch($e))
		
		If (Form:C1466.current#Null:C1517)
			
			var $picked : Text:=String:C10(Form:C1466.classDrop.value)
			
			Form:C1466.current.class:=($picked="Object") ? "" : $picked
			Form:C1466.current.type:=Is object:K8:27
			Form:C1466.current.icon:=Form:C1466._iconFor(Form:C1466.current)
			
		End if 
		
		Form:C1466.refresh()
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Clicked:K2:4)
		
		Case of 
				
				//======================================
			: (Form:C1466.boolean.catch($e))
				
				Form:C1466._setType(Is boolean:K8:9)
				
				//======================================
			: (Form:C1466.blob.catch($e))
				
				Form:C1466._setType(Is BLOB:K8:12)
				
				//======================================
			: (Form:C1466.collection.catch($e))
				
				Form:C1466._setType(Is collection:K8:32)
				
				//======================================
			: (Form:C1466.date.catch($e))
				
				Form:C1466._setType(Is date:K8:7)
				
				//======================================
			: (Form:C1466.integer.catch($e))
				
				Form:C1466._setType(Is longint:K8:6)
				
				//======================================
			: (Form:C1466.object.catch($e))
				
				Form:C1466._setType(Is object:K8:27)
				
				//======================================
			: (Form:C1466.picture.catch($e))
				
				Form:C1466._setType(Is picture:K8:10)
				
				//======================================
			: (Form:C1466.pointer.catch($e))
				
				Form:C1466._setType(Is pointer:K8:14)
				
				//======================================
			: (Form:C1466.real.catch($e))
				
				Form:C1466._setType(Is real:K8:4)
				
				//======================================
			: (Form:C1466.text.catch($e))
				
				Form:C1466._setType(Is text:K8:3)
				
				//======================================
			: (Form:C1466.time.catch($e))
				
				Form:C1466._setType(Is time:K8:8)
				
				//======================================
			: (Form:C1466.variant.catch($e))
				
				Form:C1466._setType(Is variant:K8:33)
				
				//======================================
			: (Form:C1466.array.catch($e))
				
				Form:C1466.current.array:=Form:C1466.array.getValue()
				Form:C1466.current.dimension:=Num:C11(Form:C1466.current.array)
				
				//======================================
			: (Form:C1466.filter.catch($e))
				
				declaration_UI("filter")
				
				//======================================
		End case 
		
		Form:C1466.refresh()
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 