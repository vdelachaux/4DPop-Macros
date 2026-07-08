property file : 4D:C1709.File
property loaded : Boolean:=False:C215

// Preferences accessor (modern rewrite of the legacy _o_Preferences method).
// Reads/writes the base64-encoded values in <M_4DPop><preferences> of the
// "4DPop Preferences.xml" file and mirrors them into Storage.macros.

shared singleton Class constructor()
	
	This:C1470.file:=This:C1470._resolveFile()
	
	If (Storage:C1525.macros=Null:C1517)
		
		Use (Storage:C1525)
			
			Storage:C1525.macros:=New shared object:C1526("lastUsed"; "")
			
		End use 
		
	End if 
	
	This:C1470.loaded:=This:C1470._populate()
	
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
	// (Re)reads the file into Storage.macros.preferences + declarations; returns the success
Function _populate() : Boolean
	
	If (Not:C34(This:C1470.file.exists))
		
		ALERT:C41(Localized string:C991("File not found.")+" : \""+This:C1470.file.path+"\"")
		
		return False:C215
		
	End if 
	
	Use (Storage:C1525.macros)
		
		If (Storage:C1525.macros.preferences=Null:C1517)
			
			Storage:C1525.macros.preferences:=New shared object:C1526
			
		End if 
		
	End use 
	
	Use (Storage:C1525.macros.preferences)
		
		Storage:C1525.macros.preferences.platformPath:=This:C1470.file.platformPath
		
	End use 
	
	var $o : Object:=cs:C1710.xml.me.fileToObject(This:C1470.file.platformPath)
	
	If (Not:C34($o.success))
		
		return False:C215
		
	End if 
	
	var $settings : Object:=$o.value.M_4DPop
	var $key : Text
	
	Use (Storage:C1525.macros.preferences)
		
		For each ($key; $settings.preferences)
			
			If ($settings.preferences[$key].$#Null:C1517)
				
				Storage:C1525.macros.preferences[$key]:=This:C1470._decode($settings.preferences[$key].$)
				
			End if 
			
		End for each 
		
	End use 
	
	Use (Storage:C1525.macros)
		
		Storage:C1525.macros.declarations:=New shared object:C1526
		
	End use 
	
	Use (Storage:C1525.macros.declarations)
		
		Storage:C1525.macros.declarations.version:=$settings.declarations.version
		Storage:C1525.macros.declarations.declaration:=New shared collection:C1527
		
		var $declaration : Object
		
		For each ($declaration; $settings.declarations.declaration)
			
			var $shared : Object:=New shared object:C1526
			
			Use ($shared)
				
				For each ($key; $declaration)
					
					$shared[$key]:=$declaration[$key]
					
				End for each 
				
			End use 
			
			Storage:C1525.macros.declarations.declaration.push($shared)
			
		End for each 
		
	End use 
	
	return True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the value of a preference (integer-looking text is coerced to a number), or Null
Function get($key : Text) : Variant
	
	var $result : Variant:=Null:C1517
	var $root : Text:=DOM Parse XML source:C719(String:C10(This:C1470.file.platformPath))
	
	If (OK#1)
		
		return $result
		
	End if 
	
	var $node : Text:=DOM Find XML element:C864($root; "/M_4DPop/preferences/"+$key)
	
	If (OK=1)
		
		var $encoded : Text
		DOM GET XML ELEMENT VALUE:C731($node; $encoded)
		$result:=This:C1470._decode($encoded)
		
	End if 
	
	DOM CLOSE XML:C722($root)
	
	return $result
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sets (creating it if needed) a preference value, then reloads Storage
Function set($key : Text; $value : Variant)
	
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
	
	This:C1470._populate()
	
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
