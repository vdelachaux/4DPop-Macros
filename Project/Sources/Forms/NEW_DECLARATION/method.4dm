var $e : Object
$e:=FORM Event:C1606

Case of 
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Load:K2:1)
		
		var $c : Collection
		$c:=New collection:C1472
		Form:C1466.boolean:=cs:C1710.button.new("boolean").highlightShortcut().bestSize()
		$c.push(Form:C1466.boolean)
		Form:C1466.blob:=cs:C1710.button.new("blob").highlightShortcut().bestSize()
		$c.push(Form:C1466.blob)
		Form:C1466.collection:=cs:C1710.button.new("collection").highlightShortcut().bestSize()
		$c.push(Form:C1466.collection)
		Form:C1466.date:=cs:C1710.button.new("date").highlightShortcut().bestSize()
		$c.push(Form:C1466.date)
		Form:C1466.integer:=cs:C1710.button.new("integer").highlightShortcut().bestSize()
		$c.push(Form:C1466.integer)
		Form:C1466.object:=cs:C1710.button.new("object").highlightShortcut().bestSize()
		$c.push(Form:C1466.object)
		Form:C1466.picture:=cs:C1710.button.new("picture").highlightShortcut().bestSize()
		$c.push(Form:C1466.picture)
		Form:C1466.pointer:=cs:C1710.button.new("pointer").highlightShortcut().bestSize()
		$c.push(Form:C1466.pointer)
		Form:C1466.real:=cs:C1710.button.new("real").highlightShortcut().bestSize()
		$c.push(Form:C1466.real)
		Form:C1466.text:=cs:C1710.button.new("text").highlightShortcut().bestSize()
		$c.push(Form:C1466.text)
		Form:C1466.time:=cs:C1710.button.new("time").highlightShortcut().bestSize()
		$c.push(Form:C1466.time)
		Form:C1466.variant:=cs:C1710.button.new("variant").highlightShortcut().bestSize()
		$c.push(Form:C1466.variant)
		Form:C1466.array:=cs:C1710.button.new("array").highlightShortcut().bestSize()
		$c.push(Form:C1466.array)
		
		Form:C1466.isSelected:=cs:C1710.group.new($c)
		
		Form:C1466.list:=cs:C1710.listbox.new("declarationList")
		Form:C1466.list.events.push(On Mouse Move:K2:35)
		
		Form:C1466.filter:=cs:C1710.button.new("filter")
		Form:C1466.filter.setTitle("all")
		Form:C1466.currentFilter:="all"
		
		Form:C1466.refresh:=Formula:C1597(declaration_UI("refresh"))
		OBJECT SET SCROLLBAR:C843(*; "declarationList"; 0; 2)
		
		var $o : Object
		
		For each ($o; Form:C1466.variables)
			
			$o.icon:=Form:C1466.types[Num:C11($o.type)].icon
			
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
		
		Form:C1466.apply()
		
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
	: ($e.code=On Clicked:K2:4)
		
		Case of 
				
				//======================================
			: (Form:C1466.boolean.catch($e))
				
				Form:C1466.setType(Is boolean:K8:9)
				
				//======================================
			: (Form:C1466.blob.catch($e))
				
				Form:C1466.setType(Is BLOB:K8:12)
				
				//======================================
			: (Form:C1466.collection.catch($e))
				
				Form:C1466.setType(Is collection:K8:32)
				
				//======================================
			: (Form:C1466.date.catch($e))
				
				Form:C1466.setType(Is date:K8:7)
				
				//======================================
			: (Form:C1466.integer.catch($e))
				
				Form:C1466.setType(Is longint:K8:6)
				
				//======================================
			: (Form:C1466.object.catch($e))
				
				Form:C1466.setType(Is object:K8:27)
				
				//======================================
			: (Form:C1466.picture.catch($e))
				
				Form:C1466.setType(Is picture:K8:10)
				
				//======================================
			: (Form:C1466.pointer.catch($e))
				
				Form:C1466.setType(Is pointer:K8:14)
				
				//======================================
			: (Form:C1466.real.catch($e))
				
				Form:C1466.setType(Is real:K8:4)
				
				//======================================
			: (Form:C1466.text.catch($e))
				
				Form:C1466.setType(Is text:K8:3)
				
				//======================================
			: (Form:C1466.time.catch($e))
				
				Form:C1466.setType(Is time:K8:8)
				
				//======================================
			: (Form:C1466.variant.catch($e))
				
				Form:C1466.setType(Is variant:K8:33)
				
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