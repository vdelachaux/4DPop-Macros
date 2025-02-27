//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($entryPoint : Text; $data : Object) : Object

Case of 
		
		// ______________________________________________________
	: (Count parameters:C259=0)  // Listbox UI
		
		var $meta:={cell: {count: {\
			textDecoration: "normal"; \
			fontWeight: "normal"; \
			fontStyle: "normal"}}}
		
		If (Bool:C1537(This:C1470.array))
			
			$meta.cell.value:={textDecoration: "underline"}
			
		End if 
		
		If (FORM Event:C1606.isRowSelected)
			
			If (This:C1470.type=0)
				
				$meta.stroke:="white"
				$meta.fill:="red"
				
			Else 
				
				If (This:C1470.count=0)
					
					If (This:C1470.label="→ return()")
						
						$meta.stroke:="automatic"
						$meta.fill:="dodgerblue"
						
					Else 
						
						$meta.stroke:="white"
						$meta.fill:="orange"
						
					End if 
					
				Else 
					
					$meta.fill:="dodgerblue"
					
				End if 
			End if 
			
		Else 
			
			If (This:C1470.type=0)
				
				$meta.stroke:="red"
				
			Else 
				
				If (This:C1470.count=0)
					
					$meta.stroke:=This:C1470.label="→ return()" ? "Automatic" : "Orange"
					
				Else 
					
					$meta.fontWeight:="bold"
					
				End if 
			End if 
		End if 
		
		return $meta
		
		// ______________________________________________________
	: ($entryPoint="refresh")  // Update UI
		
		$o:=Count parameters:C259>=2 ? $data : Form:C1466.current
		
		If ($o=Null:C1517)
			
			// Hide UI
			Form:C1466.isSelected.hide()
			
			return 
			
		End if 
		
		Form:C1466.isSelected.show()
		
		var $t : Text
		
		For each ($t; Form:C1466.types.query("value!=null").extract("name"))
			
			OBJECT SET VALUE:C1742($t; False:C215)
			
		End for each 
		
		If (Num:C11($o.type)#0)
			
			OBJECT SET VALUE:C1742(Form:C1466.types[$o.type].name; True:C214)
			
		End if 
		
		If ($o.type#Null:C1517)
			
			Form:C1466.array.enable(Not:C34(Bool:C1537($o.parameter)) & (Form:C1466._notforArray.indexOf(Form:C1466.types[$o.type].name)=-1))
			
		End if 
		
		Form:C1466.array.setValue(Bool:C1537($o.array))
		
		For each ($t; Form:C1466._notforArray)
			
			OBJECT SET ENABLED:C1123(*; $t; Not:C34(Bool:C1537($o.array)))
			
		End for each 
		
		Form:C1466.subset:=Form:C1466.subset  // Touch to update
		
		LISTBOX SELECT ROW:C912(*; "declarationList"; Form:C1466.index; lk replace selection:K53:1)
		
		var $bottom; $height; $left; $right; $top; $width : Integer
		OBJECT GET COORDINATES:C663(*; "code"; $left; $top; $right; $bottom)
		OBJECT GET BEST SIZE:C717(*; "code"; $width; $height)
		
		// ______________________________________________________
	: ($entryPoint="filter")
		
		var $menu:=cs:C1710.menu.new()
		$menu.append("All"; "all"; "all"=String:C10(Form:C1466.currentFilter))\
			.line()\
			.append("Undefined"; "undefined"; "undefined"=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("type=0").length>0)\
			.append("Unused"; "unused"; "unused"=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("count=0").length>0)\
			.line()\
			.append("Parameters"; "parameters"; "parameters"=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("parameter=true").length>0)\
			.append("Variables"; "variables"; "variables"=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("parameter=null").length>0)\
			.append("Arrays"; "arrays"; "arrays"=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("array=true").length>0)\
			.line()
		
		var $subMenu:=cs:C1710.menu.new()
		var $types : Collection:=Form:C1466.types.extract("name"; "name"; "value"; "value").query("value!=null").orderBy("name")
		
		var $o : Object
		
		For each ($o; $types)
			
			$subMenu.append(Uppercase:C13(String:C10($o.name)[[1]])+Substring:C12($o.name; 2); $o.name; $o.name=String:C10(Form:C1466.currentFilter))\
				.enable(Form:C1466.variables.query("type=:1"; $o.value).length>0)
			
		End for each 
		
		$menu.append("Ttype"; $subMenu)
		
		If (Not:C34($menu.popup(Form:C1466.filter).selected))
			
			return 
			
		End if 
		
		Case of 
				
				// ______________________________________________________
			: ($menu.choice="all")
				
				Form:C1466.subset:=Form:C1466.variables
				
				// ______________________________________________________
			: ($menu.choice="undefined")
				
				Form:C1466.subset:=Form:C1466.variables.query("type=0")
				
				// ______________________________________________________
			: ($menu.choice="unused")
				
				Form:C1466.subset:=Form:C1466.variables.query("count=0")
				
				// ______________________________________________________
			: ($menu.choice="parameters")
				
				Form:C1466.subset:=Form:C1466.variables.query("parameter=true")
				
				// ______________________________________________________
			: ($menu.choice="variables")
				
				Form:C1466.subset:=Form:C1466.variables.query("parameter=null")
				
				// ______________________________________________________
			: ($menu.choice="arrays")
				
				Form:C1466.subset:=Form:C1466.variables.query("array=true")
				
				// ______________________________________________________
			Else 
				
				$o:=$types.query("name=:1"; $menu.choice).pop()
				Form:C1466.subset:=Form:C1466.variables.query("type=:1"; $o.value)
				
				// ______________________________________________________
		End case 
		
		Form:C1466.currentFilter:=$menu.choice
		Form:C1466.filter.setTitle($menu.choice)
		
		If (Form:C1466.subset.length>0)
			
			LISTBOX SELECT ROW:C912(*; "declarationList"; 1; lk replace selection:K53:1)
			
		Else 
			
			LISTBOX SELECT ROW:C912(*; "declarationList"; 0; lk remove from selection:K53:3)
			
		End if 
		
		SET TIMER:C645(-1)
		
		// ______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: "+$entryPoint)
		
		// ______________________________________________________
End case 