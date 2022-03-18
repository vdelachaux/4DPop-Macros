//%attributes = {"invisible":true}
#DECLARE($entryPoint : Text; $data : Object)->$meta : Object

If (False:C215)
	C_TEXT:C284(declaration_UI; $1)
	C_OBJECT:C1216(declaration_UI; $2)
	C_OBJECT:C1216(declaration_UI; $0)
End if 

var $t : Text
var $bottom; $height; $left; $right; $top; $width : Integer
var $o : Object
var $types : Collection
var $menu; $subMenu : cs:C1710.menu

Case of 
		
		//______________________________________________________
	: (Count parameters:C259=0)  // Listbox UI
		
		$meta:=New object:C1471
		
		$meta.cell:=New object:C1471
		
		$meta.cell.count:=New object:C1471(\
			"textDecoration"; "normal"; \
			"fontWeight"; "normal"; \
			"fontStyle"; "normal")
		
		If (Bool:C1537(This:C1470.array))
			
			$meta.cell.value:=New object:C1471(\
				"textDecoration"; "underline")
			
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
					
					If (This:C1470.label="→ return()")
						
						$meta.stroke:="automatic"
						
					Else 
						
						$meta.stroke:="orange"
						
					End if 
					
				Else 
					
					$meta.fontWeight:="bold"
					
				End if 
			End if 
		End if 
		
		//______________________________________________________
	: ($entryPoint="refresh")  // Update UI
		
		If (Count parameters:C259>=2)
			
			$o:=$data
			
		Else 
			
			$o:=Form:C1466.current
			
		End if 
		
		If ($o#Null:C1517)
			
			Form:C1466.isSelected.show()
			
			For each ($t; Form:C1466.types.query("value!=null").extract("name"))
				
				OBJECT SET VALUE:C1742($t; False:C215)
				
			End for each 
			
			If (Num:C11($o.type)#0)
				
				OBJECT SET VALUE:C1742(Form:C1466.types[$o.type].name; True:C214)
				
			End if 
			
			Form:C1466.array.enable(Not:C34(Bool:C1537($o.parameter)) & (Form:C1466.$notforArray.indexOf(Form:C1466.types[$o.type].name)=-1))
			Form:C1466.array.setValue(Bool:C1537($o.array))
			
			For each ($t; Form:C1466.$notforArray)
				
				OBJECT SET ENABLED:C1123(*; $t; Not:C34(Bool:C1537($o.array)))
				
			End for each 
			
			Form:C1466.subset:=Form:C1466.subset  // Touch to update
			
			LISTBOX SELECT ROW:C912(*; "declarationList"; Form:C1466.index; lk replace selection:K53:1)
			
			OBJECT GET COORDINATES:C663(*; "code"; $left; $top; $right; $bottom)
			OBJECT GET BEST SIZE:C717(*; "code"; $width; $height)
			
		Else 
			
			// Hide UI
			Form:C1466.isSelected.hide()
			
		End if 
		
		//______________________________________________________
	: ($entryPoint="filter")
		
		$menu:=cs:C1710.menu.new()
		$menu.append("all"; "all"; "all"=String:C10(Form:C1466.currentFilter))
		$menu.line()
		$menu.append("undefined"; "undefined"; "undefined"=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("type=0").length>0)
		$menu.append("unused"; "unused"; "unused"=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("count=0").length>0)
		$menu.line()
		$menu.append("parameters"; "parameters"; "parameters"=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("parameter=true").length>0)
		$menu.append("variables"; "variables"; "variables"=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("parameter=null").length>0)
		$menu.append("arrays"; "arrays"; "arrays"=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("array=true").length>0)
		$menu.line()
		
		$subMenu:=cs:C1710.menu.new()
		$types:=Form:C1466.types.extract("name"; "name"; "value"; "value").query("value!=null").orderBy("name")
		
		For each ($o; $types)
			
			$subMenu.append($o.name; $o.name; $o.name=String:C10(Form:C1466.currentFilter)).enable(Form:C1466.variables.query("type=:1"; $o.value).length>0)
			
		End for each 
		
		$menu.append("type"; $subMenu)
		
		$menu.popup(Form:C1466.filter)
		
		If ($menu.selected)
			
			Case of 
					
					//______________________________________________________
				: ($menu.choice="all")
					
					Form:C1466.subset:=Form:C1466.variables
					
					//______________________________________________________
				: ($menu.choice="undefined")
					
					Form:C1466.subset:=Form:C1466.variables.query("type=0")
					
					//______________________________________________________
				: ($menu.choice="unused")
					
					Form:C1466.subset:=Form:C1466.variables.query("count=0")
					
					//______________________________________________________
				: ($menu.choice="parameters")
					
					Form:C1466.subset:=Form:C1466.variables.query("parameter=true")
					
					//______________________________________________________
				: ($menu.choice="variables")
					
					Form:C1466.subset:=Form:C1466.variables.query("parameter=null")
					
					//______________________________________________________
				: ($menu.choice="arrays")
					
					Form:C1466.subset:=Form:C1466.variables.query("array=true")
					
					//______________________________________________________
				Else 
					
					$o:=$types.query("name=:1"; $menu.choice).pop()
					Form:C1466.subset:=Form:C1466.variables.query("type=:1"; $o.value)
					
					//______________________________________________________
			End case 
			
			Form:C1466.currentFilter:=$menu.choice
			Form:C1466.filter.setTitle($menu.choice)
			
			If (Form:C1466.subset.length>0)
				
				LISTBOX SELECT ROW:C912(*; "declarationList"; 1; lk replace selection:K53:1)
				
			Else 
				
				LISTBOX SELECT ROW:C912(*; "declarationList"; 0; lk remove from selection:K53:3)
				
			End if 
			
			SET TIMER:C645(-1)
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: "+$entryPoint)
		
		//______________________________________________________
End case 