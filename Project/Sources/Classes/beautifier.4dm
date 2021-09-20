Class extends macro

Class constructor
	
	Super:C1705()
	
	// Preferences
	var $fileSettings : 4D:C1709.File
	$fileSettings:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
	
	If ($fileSettings.original#Null:C1517)
		$fileSettings:=$fileSettings.original
		
	End if 
	
	If ($fileSettings.exists)
		This:C1470.settings:=JSON Parse:C1218($fileSettings.getText()).beautifier
		
	End if 
	
	//format comments
	This:C1470.settings.formatComments:=True:C214
	
	This:C1470.separators:=New collection:C1472
	This:C1470.separators.push("__")
	This:C1470.separators.push("--")
	This:C1470.separators.push("..")
	This:C1470.separators.push("…")
	This:C1470.separators.push("!!")
	This:C1470.separators.push("::")
	
	
	