$e:=FORM Event:C1606

Case of 
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.boolean:=cs:C1710.button.new("boolean").highlightShortcut()
		Form:C1466.blob:=cs:C1710.button.new("blob").highlightShortcut()
		Form:C1466.collection:=cs:C1710.button.new("collection").highlightShortcut()
		Form:C1466.date:=cs:C1710.button.new("date").highlightShortcut()
		Form:C1466.longint:=cs:C1710.button.new("longint").highlightShortcut()
		Form:C1466.object:=cs:C1710.button.new("object").highlightShortcut()
		Form:C1466.picture:=cs:C1710.button.new("picture").highlightShortcut()
		Form:C1466.pointer:=cs:C1710.button.new("pointer").highlightShortcut()
		Form:C1466.real:=cs:C1710.button.new("real").highlightShortcut()
		Form:C1466.text:=cs:C1710.button.new("text").highlightShortcut()
		Form:C1466.time:=cs:C1710.button.new("time").highlightShortcut()
		Form:C1466.variant:=cs:C1710.button.new("variant").highlightShortcut()
		
		$c:=New collection:C1472
		$c[Is boolean:K8:9]:=New object:C1471("name"; "boolean")
		$c[Is BLOB:K8:12]:=New object:C1471("name"; "blob")
		$c[Is collection:K8:32]:=New object:C1471("name"; "collection")
		$c[Is date:K8:7]:=New object:C1471("name"; "date")
		$c[Is longint:K8:6]:=New object:C1471("name"; "longint")
		$c[Is object:K8:27]:=New object:C1471("name"; "object")
		$c[Is picture:K8:10]:=New object:C1471("name"; "picture")
		$c[Is pointer:K8:14]:=New object:C1471("name"; "pointer")
		$c[Is real:K8:4]:=New object:C1471("name"; "real")
		$c[Is text:K8:3]:=New object:C1471("name"; "text")
		$c[Is time:K8:8]:=New object:C1471("name"; "time")
		$c[Is variant:K8:33]:=New object:C1471("name"; "variant")
		//$c[Is undefined]:=New object("name"; "undefined")
		
		Form:C1466.types:=$c
		
		Form:C1466.notforArray:=New collection:C1472("collection"; "variant")
		
		var $p : Picture
		$root:=Folder:C1567("/RESOURCES/Images/fieldIcons")
		
		For each ($o; Form:C1466.variables)
			
			$file:=$root.file("field_"+String:C10(Num:C11($o.type); "00")+".png")
			READ PICTURE FILE:C678($file.platformPath; $p)
			$o.icon:=$p
			
		End for each 
		
		
		Form:C1466.subset:=Form:C1466.variables
		
		LISTBOX SELECT ROW:C912(*; "declarationList"; 1; lk replace selection:K53:1)
		
		SELECT LIST ITEMS BY POSITION:C381(*; "subset"; 1)
		
		//______________________________________________________
	: (False:C215)
		
		
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 