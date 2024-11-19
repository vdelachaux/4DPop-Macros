property file:=4D:C1709.File

Class constructor
	
	This:C1470.file:=This:C1470.loadPreferences()
	
	//=========================================================================
Function loadPreferences()->$settingFile : 4D:C1709.File
	
	var $key : Text
	var $value : Variant
	var $x : Blob
	var $o; $settings; $shared : Object
	var $src : 4D:C1709.File
	var $4DPopFolder : 4D:C1709.Folder
	
	// Retrieve the root folder of 4DPop settings
	$4DPopFolder:=Folder:C1567(fk user preferences folder:K87:10).folder("4DPop")
	$4DPopFolder.create()
	
	$settingFile:=$4DPopFolder.file("4DPop Preferences.xml")
	
	If ($settingFile.original#Null:C1517)
		
		$settingFile:=$settingFile.original
		
	End if 
	
	If (Not:C34($settingFile.exists))  // Let's try with a old file
		
		$src:=$4DPopFolder.file("4DPop Macros.xml")
		
		If ($src.exists)
			
			// Check that it is a setting file (a bug copied the macro file here)
			If (_o_xml_fileToObject($src.platformPath).value.M_4DPop#Null:C1517)
				
				// Get it
				$src.copyTo($4DPopFolder; "4DPop Preferences.xml")
				
			Else 
				
				// Delete it
				$src.delete()
				
			End if 
		End if 
	End if 
	
	If (Not:C34($settingFile.exists))  // Let's try with a very old preference file...
		
		$src:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop v11/preferences.xml")
		
		If ($src.exists)
			
			// Get it
			$src.copyTo($settingFile.parent; "4DPop Preferences.xml")
			
		End if 
	End if 
	
	If (Not:C34($settingFile.exists))  // Create the default preferences
		
		$src:=Folder:C1567(fk resources folder:K87:11).file("preferences.template")
		$src.copyTo($settingFile.parent; "4DPop Preferences.xml")
		
	End if 
	
	If (Storage:C1525.macros=Null:C1517)
		
		Use (Storage:C1525)
			
			Storage:C1525.macros:=New shared object:C1526("lastUsed"; "")
			
			Use (Storage:C1525.macros)
				
				Storage:C1525.macros.preferences:=New shared object:C1526
				
				If ($settingFile.exists)
					
					Use (Storage:C1525.macros.preferences)
						
						//Storage.macros.preferences.file:=$settingFile
						
						Storage:C1525.macros.preferences.platformPath:=$settingFile.platformPath
						
						$o:=_o_xml_fileToObject($settingFile.platformPath)
						
						If ($o.success)
							
							$settings:=$o.value.M_4DPop
							
							For each ($key; $settings)
								
								If ($settings[$key].$#Null:C1517)
									
									$value:=$settings[$key].$
									TEXT TO BLOB:C554($value; $x; Mac text without length:K22:10)
									BASE64 DECODE:C896($x)
									$value:=BLOB to text:C555($x; Mac text without length:K22:10)
									SET BLOB SIZE:C606($x; 0)
									
									$settings[$key]:=Choose:C955(Match regex:C1019("^\\d+$"; $value; 1); Num:C11($value); $value)
									
								End if 
							End for each 
							
						Else 
							
							// A "If" statement should never omit "Else"
							
						End if 
					End use 
					
					Storage:C1525.macros.declarations:=New shared object:C1526
					
					Use (Storage:C1525.macros.declarations)
						
						Storage:C1525.macros.declarations.version:=$settings.declarations.version
						
						Storage:C1525.macros.declarations.declaration:=New shared collection:C1527
						
						For each ($o; $settings.declarations.declaration)
							
							$shared:=New shared object:C1526
							
							Use ($shared)
								
								For each ($key; $o)
									
									$shared[$key]:=$o[$key]
									
								End for each 
								
								Storage:C1525.macros.declarations.declaration.push($shared)
								
							End use 
						End for each 
					End use 
					
				Else 
					
					ALERT:C41(Localized string:C991("File not found.")+" : \""+$settingFile.path+"\"")
					
				End if 
			End use 
		End use 
	End if 
	