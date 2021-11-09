Class constructor($x : 4D:C1709.File)  //comments
	
	This:C1470.test:=$x
	
Function empty
	This:C1470.context:=Form:C1466.$dialog[This:C1470.name]
	
Function group($a : Text)
	var $x : Blob
	
	
Function subform($a : Text)->$this : Object
	$this:=This:C1470
	
Function thermometer($a : Text)->$this : Object
	
	var $x : Blob
	var $o : Object
	
	$o:=New object:C1471
	SET BLOB SIZE:C606($x; 0)
	
	$this:=This:C1470
	
Function formObject($a : Text)->$this : Object
	$this:=This:C1470
	
Function button($a : Text)->$this : Object
	$this:=This:C1470
	
Function field($x : 4D:C1709.File)->$field : Object
	
	$field:=$x.platformPath
	
Function addToGroup($g : Object)
	
Function init()
	
	var $group : cs:C1710.group
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.subform("ribbon")
	This:C1470.subform("description")
	This:C1470.subform("project")
	This:C1470.subform("footer")
	
	$group:=This:C1470.group("taskUI")
	This:C1470.thermometer("taskIndicator").addToGroup($group)
	This:C1470.formObject("taskDescription").addToGroup($group)
	
	This:C1470.subform("browser")
	
	$group:=This:C1470.group("messageGroup")
	This:C1470.subform("message").addToGroup($group)
	This:C1470.button("messageButton").addToGroup($group)
	This:C1470.formObject("messageBack").addToGroup($group)
	
	// Create the context, id any
	If (Form:C1466.$dialog=Null:C1517)
		
		Form:C1466.$dialog:=New object:C1471
		
	End if 
	
	If (Form:C1466.$dialog[This:C1470.name]=Null:C1517)
		
		Form:C1466.$dialog[This:C1470.name]:=New object:C1471
		
	End if 
	
	This:C1470.context:=Form:C1466.$dialog[This:C1470.name]
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	//exposed Function exposed($x : Blob)->$y : Blob
	
	//var $i : Integer
	
	//For ($i; 1; BLOB size($x); 1)
	
	//End for
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Removes the element set by $node
	//%W-550.4
Function remove($node : Text)->$this : cs:C1710.xml
	//%W+550.4
	//%W-550.2
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470._requiredRef($node))
			
			DOM REMOVE XML ELEMENT:C869($node)
			This:C1470.success:=Bool:C1537(OK)
			
		End if 
	End if 
	//%W+550.2
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function updateColorScheme($x : 4D:C1709.File)->$y : 4D:C1709.Blob
	
	var $icon : Picture
	var $file : 4D:C1709.File
	
	$y:=$x
	
	//exposed Function get computedName()->$name : Text  //comments
	//$name:=Uppercase(This.Name)
	
	This:C1470.colorScheme:=FORM Get color scheme:C1761
	This:C1470.isDark:=(FORM Get color scheme:C1761="dark")
	
	This:C1470.fieldIcons:=New collection:C1472
	This:C1470.filterIcon:=$icon
	
	// * PRE-LOADING ICONS FOR FIELD TYPES
	For each ($file; Folder:C1567("/RESOURCES/images/dark/fieldsIcons").files(Ignore invisible:K24:16))
		
		READ PICTURE FILE:C678($file.platformPath; $icon)
		This:C1470.fieldIcons[Num:C11(Replace string:C233($file.name; "field_"; ""))]:=$icon
		
	End for each 
	
Function popAttribute($node; $attribute : Text)->$value
	
	var $o; $toto
	
	$o:=$node
	$toto:=$node
	
	//var $color : cs.color
	
Function setDatasource()
	
	If (Form:C1466._dataclassesItem#Null:C1517)
		
		If (Form:C1466.choiceList.dataSource=Null:C1517)
			
			Form:C1466.choiceList.dataSource:=New object:C1471("dataClass"; Form:C1466._dataclassesItem.name)
			
		Else 
			
			Form:C1466.choiceList.dataSource.dataClass:=Form:C1466._dataclassesItem.name
			
		End if 
		
		If (Form:C1466._attributesItem#Null:C1517)
			
			Form:C1466.choiceList.dataSource.field:=Form:C1466._attributesItem.name
			
		Else 
			
			OB REMOVE:C1226(Form:C1466.choiceList.dataSource; "field")
			
		End if 
		
	Else 
		
		If (Form:C1466.choiceList.dataSource#Null:C1517)
			
			OB REMOVE:C1226(Form:C1466.choiceList.dataSource; "dataClass")
			OB REMOVE:C1226(Form:C1466.choiceList.dataSource; "field")
			
		End if 
	End if 
	
Function setURL
	
	var $1 : Text
	
	If (Count parameters:C259>=1)
		
		This:C1470.url:=$1
		
		// Add missing / if necessary
		If (Not:C34(Match regex:C1019("/$"; This:C1470.url; 1)))
			
			This:C1470.url:=This:C1470.url+"/"
			
		End if 
		
		// Add missing handler if needed
		If (Not:C34(Match regex:C1019(This:C1470.handler+"/$"; This:C1470.url; 1)))
			
			This:C1470.url:=This:C1470.url+This:C1470.handler+"/"
			
		End if 
		
	Else 
		
		// Default url to the current database
		var $o : Object
		$o:=WEB Get server info:C1531
		
/*
WARNING: "localhost" may not find the server if the computer is connected to a network.
127.0.0.1, on the other hand, will connect directly without going out to the network.
*/
		
		Case of 
				
				//________________________________________
			: (Bool:C1537($o.security.HTTPEnabled))  // Priority for http
				
				This:C1470.url:="http://127.0.0.1:"+String:C10($o.options.webPortID)+"/"+This:C1470.handler+"/"
				
				//________________________________________
			: (Bool:C1537($o.security.HTTPSEnabled))  // Only https, use it
				
				This:C1470.url:="https://127.0.0.1:"+String:C10($o.options.webHTTPSPortID)+"/"+This:C1470.handler+"/"
				
				//________________________________________
			Else 
				
				This:C1470.url:="http://127.0.0.1:"+String:C10(WEB Get server info:C1531.options.webPortID)+"/"+This:C1470.handler+"/"
				
				//________________________________________
		End case 
	End if 
	
Function addField($field : Object; $fields : Collection)
	
	var $ok : Boolean
	var $index : Integer
	
	$ok:=True:C214
	
	If ($field.fieldType=8859)
		
		// 1-N relation with published related data class
		$ok:=(Form:C1466.dataModel[String:C10($field.relatedTableNumber)]#Null:C1517)
		
	End if 
	
	If ($ok)
		
		If ($field.fieldType#8859)  // Not 1-N relation
			
			$index:=$fields.indexOf(Null:C1517)
			
			If (($index#-1))
				
				// Set
				$fields[$index]:=$field
				
			Else 
				
				// Append
				$fields.push($field)
				
			End if 
			
		Else 
			
			// Append
			$fields.push($field)
			
		End if 
	End if 