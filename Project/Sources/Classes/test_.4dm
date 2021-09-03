Class constructor($x : 4D:C1709.File)  //comments
	
	This:C1470.test:=$x
	
Function empty
	
	This:C1470.context:=Form:C1466.$dialog[This:C1470.name]
	
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
Function test($x : 4D:C1709.File)->$y : Object  //comments
	
	$y:=$x
	
	//exposed Function get computedName()->$name : Text  //comments
	
	//$name:=Uppercase(This.Name)
	
Function updateColorScheme()
	
	var $icon : Picture
	var $file : 4D:C1709.File
	
	This:C1470.colorScheme:=FORM Get color scheme:C1761
	This:C1470.isDark:=(FORM Get color scheme:C1761="dark")
	
	This:C1470.fieldIcons:=New collection:C1472
	This:C1470.filterIcon:=$icon
	
	// * PRE-LOADING ICONS FOR FIELD TYPES
	For each ($file; Folder:C1567("/RESOURCES/images/dark/fieldsIcons").files(Ignore invisible:K24:16))
		
		READ PICTURE FILE:C678($file.platformPath; $icon)
		This:C1470.fieldIcons[Num:C11(Replace string:C233($file.name; "field_"; ""))]:=$icon
		
	End for each 
	
	//var $color : cs.color