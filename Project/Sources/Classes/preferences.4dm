property file : 4D:C1709.File
property loaded : Boolean:=False:C215
property data : Object

// Preferences accessor (shared singleton — cs.preferences.me).
// Owns the preferences in memory (This.data), reads/writes the base64-encoded
// values in <M_4DPop><preferences> of the "4DPop Preferences.xml" file.

shared singleton Class constructor()
	
	This:C1470.data:=New shared object:C1526
	This:C1470.file:=This:C1470._resolveFile()
	This:C1470.loaded:=This:C1470._load()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Resolves the settings file, restoring it from an old file or the template if needed
Function _resolveFile() : 4D:C1709.File
	
	var $settingFile; $src : 4D:C1709.File
	var $4DPopFolder : 4D:C1709.Folder
	
	$4DPopFolder:=Folder:C1567(fk user preferences folder:K87:10).folder("4DPop")
	$4DPopFolder.create()
	
	$settingFile:=$4DPopFolder.file("4DPop Preferences.xml")
	
	If ($settingFile.original#Null:C1517)
		
		$settingFile:=$settingFile.original
		
	End if 
	
	If (Not:C34($settingFile.exists))  // Let's try with an old file
		
		$src:=$4DPopFolder.file("4DPop Macros.xml")
		
		If ($src.exists)
			
			// Check that it is a setting file (a bug copied the macro file here)
			If (cs:C1710.xml.me.fileToObject($src.platformPath).value.M_4DPop#Null:C1517)
				
				$src.copyTo($4DPopFolder; "4DPop Preferences.xml")
				
			Else 
				
				$src.delete()
				
			End if 
		End if 
	End if 
	
	If (Not:C34($settingFile.exists))  // Let's try with a very old preference file…
		
		$src:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop v11/preferences.xml")
		
		If ($src.exists)
			
			$src.copyTo($settingFile.parent; "4DPop Preferences.xml")
			
		End if 
	End if 
	
	If (Not:C34($settingFile.exists))  // Create the default preferences
		
		$src:=Folder:C1567(fk resources folder:K87:11).file("preferences.template")
		$src.copyTo($settingFile.parent; "4DPop Preferences.xml")
		
	End if 
	
	return $settingFile
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Loads the file into This.data; returns the success
Function _load() : Boolean
	
	If (Not:C34(This:C1470.file.exists))
		
		ALERT:C41(Localized string:C991("File not found.")+" : \""+This:C1470.file.path+"\"")
		
		return False:C215
		
	End if 
	
	var $o : Object:=cs:C1710.xml.me.fileToObject(This:C1470.file.platformPath)
	
	If (Not:C34($o.success))
		
		return False:C215
		
	End if 
	
	var $preferences : Object:=$o.value.M_4DPop.preferences
	
	If ($preferences#Null:C1517)
		
		var $key : Text
		
		Use (This:C1470.data)
			
			For each ($key; $preferences)
				
				If ($preferences[$key].$#Null:C1517)
					
					This:C1470.data[$key]:=This:C1470._decode($preferences[$key].$)
					
				End if 
				
			End for each 
			
		End use 
		
	End if 
	
	return True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the in-memory value of a preference (Null if not set)
Function get($key : Text) : Variant
	
	return This:C1470.data[$key]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sets a preference: updates This.data and persists it (creating the node if needed) to the file
Function set($key : Text; $value : Variant)
	
	Use (This:C1470.data)
		
		This:C1470.data[$key]:=$value
		
	End use 
	
	var $root : Text:=DOM Parse XML source:C719(This:C1470.file.platformPath)
	
	If (OK#1)
		
		return 
		
	End if 
	
	var $node : Text:=DOM Find XML element:C864($root; "/M_4DPop/preferences/"+$key)
	
	If (OK=0)
		
		$node:=DOM Create XML element:C865($root; "/M_4DPop/preferences/"+$key)
		
	End if 
	
	If (OK=1)
		
		DOM SET XML ELEMENT VALUE:C868($node; This:C1470._encode($value))
		
		If (OK=1)
			
			DOM EXPORT TO FILE:C862($root; This:C1470.file.platformPath)
			
		End if 
	End if 
	
	DOM CLOSE XML:C722($root)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Base64-decodes a stored value and coerces integer-looking text to a number
Function _decode($encoded : Text) : Variant
	
	var $blob : Blob
	TEXT TO BLOB:C554($encoded; $blob; Mac text without length:K22:10)
	BASE64 DECODE:C896($blob)
	var $text : Text:=BLOB to text:C555($blob; Mac text without length:K22:10)
	SET BLOB SIZE:C606($blob; 0)
	
	return Choose:C955(Match regex:C1019("^\\d+$"; $text; 1); Num:C11($text); $text)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Serialises a value to base64 text for storage
Function _encode($value : Variant) : Text
	
	var $blob : Blob
	var $text : Text:=String:C10($value)
	TEXT TO BLOB:C554($text; $blob; Mac text without length:K22:10)
	BASE64 ENCODE:C895($blob)
	$text:=BLOB to text:C555($blob; Mac text without length:K22:10)
	SET BLOB SIZE:C606($blob; 0)
	
	return $text
