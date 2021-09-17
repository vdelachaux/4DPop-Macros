Class extends preferences

Class constructor($page : Text)
	
	var $indx : Integer
	
	Super:C1705()
	
	// Install menu bar to allow Copy - Paste
	cs:C1710.menu.new().defaultMinimalMenuBar().setBar()
	
	// Display the settings dialog box
	This:C1470.windowRef:=Open form window:C675("SETTINGS"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	
	This:C1470.loadSettings()
	
	This:C1470.pages:=New collection:C1472("beautifier"; "declarations")
	This:C1470.page:=1
	
	If (Count parameters:C259>=1)
		
		$indx:=This:C1470.pages.indexOf($page)
		
		If ($indx#-1)
			
			This:C1470.page:=$indx+1
			
		End if 
	End if 
	
	DIALOG:C40("SETTINGS"; This:C1470)
	
	CLOSE WINDOW:C154(This:C1470.windowRef)
	
	//==============================================================
Function loadSettings()
	
	var $key : Text
	var $o : Object
	var $fileSettings : 4D:C1709.File
	
	$fileSettings:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
	
	If ($fileSettings.original#Null:C1517)
		
		$fileSettings:=$fileSettings.original
		
	End if 
	
	If (Not:C34($fileSettings.exists))
		
		$o:=This:C1470.convertXmlPrefToJson()
		
		If ($o#Null:C1517)
			
			$fileSettings.setText(JSON Stringify:C1217($o; *))
			
		End if 
	End if 
	
	If (Not:C34($fileSettings.exists))
		
		// Use default settings
		File:C1566("/RESOURCES/default.settings").copyTo($fileSettings.parent; "4DPop Macros.settings")
		
	End if 
	
	This:C1470.file:=$fileSettings
	
	This:C1470.settings:=JSON Parse:C1218(This:C1470.file.getText())
	
	This:C1470.beautifier:=New collection:C1472
	
	For each ($key; This:C1470.settings.beautifier)
		
		This:C1470.beautifier.push(New object:C1471(\
			"key"; $key; \
			"label"; Get localized string:C991($key); \
			"on"; Bool:C1537(This:C1470.settings.beautifier[$key])))
		
	End for each 
	
	//==============================================================
Function convertXmlPrefToJson()->$settings : Object
	
	var $key : Text
	var $l : Integer
	var $x : Blob
	var $o; $oo; $xml : Object
	var $c; $keywords : Collection
	
	If (This:C1470.file.exists)
		
		$xml:=xml_fileToObject(This:C1470.file.platformPath)
		
		If ($xml.success)
			
			$xml:=$xml.value.M_4DPop
			
			$settings:=New object:C1471
			
			$settings.version:=New object:C1471
			
			For each ($key; $xml.version)
				
				$settings.version[$key]:=$xml.version[$key].$
				
			End for each 
			
			$settings.declaration:=New object:C1471(\
				"version"; $xml.declarations.version; \
				"rules"; $xml.declarations.declaration)
			
			$c:=New collection:C1472
			$c[1]:=293
			$c[2]:=604
			$c[3]:=305
			$c[4]:=307
			$c[5]:=282
			$c[6]:=283
			$c[7]:=352
			$c[8]:=306
			$c[9]:=286
			$c[10]:=301
			$c[11]:=285
			$c[12]:=284
			$c[13]:=1216
			$c[14]:=1488
			$c[15]:=1683
			$c[101]:=218
			$c[102]:=1222
			$c[103]:=223
			$c[104]:=224
			$c[105]:=220
			$c[106]:=221
			$c[108]:=1223
			$c[109]:=279
			$c[110]:=280
			$c[111]:=219
			$c[112]:=222
			$c[113]:=1221
			
			$c[122]:=284
			
			$keywords:=New collection:C1472
			$keywords.push(New object:C1471("no"; 283; "key"; "Integer"))
			$keywords.push(New object:C1471("no"; 284; "key"; "Text"))
			$keywords.push(New object:C1471("no"; 285; "key"; "Real"))
			$keywords.push(New object:C1471("no"; 286; "key"; "Picture"))
			$keywords.push(New object:C1471("no"; 301; "key"; "Pointer"))
			$keywords.push(New object:C1471("no"; 305; "key"; "Boolean"))
			$keywords.push(New object:C1471("no"; 306; "key"; "Time"))
			$keywords.push(New object:C1471("no"; 307; "key"; "Date"))
			$keywords.push(New object:C1471("no"; 604; "key"; "Blob"))
			$keywords.push(New object:C1471("no"; 1216; "key"; "Object"))
			$keywords.push(New object:C1471("no"; 1488; "key"; "Collection"))
			$keywords.push(New object:C1471("no"; 1683; "key"; "Variant"))
			
			For each ($o; $settings.declaration.rules)
				
				$o.label:=Command name:C538($c[$o.type])+":C"+String:C10($c[$o.type])
				
				// Replace with keywords if any
				
				For each ($oo; $keywords)
					
					If (Position:C15($o.label; Parse formula:C1576(":C"+String:C10($oo.no)))=1)
						
						$o.label:=$oo.key
						
					End if 
				End for each 
			End for each 
			
			TEXT TO BLOB:C554($xml.preferences.options.$; $x; Mac text without length:K22:10)
			BASE64 DECODE:C896($x)
			$l:=Num:C11(BLOB to text:C555($x; Mac text without length:K22:10))
			
			$settings.declaration.options:=New object:C1471(\
				"methodDeclaration"; $l ?? 27; \
				"trimEmptyLines"; $l ?? 29; \
				"generateComments"; $l ?? 31)
			
			If ($xml.preferences.numberOfVariablePerLine.$#Null:C1517)
				
				TEXT TO BLOB:C554($xml.preferences.numberOfVariablePerLine.$; $x; Mac text without length:K22:10)
				BASE64 DECODE:C896($x)
				$settings.declaration.options.numberOfVariablePerLine:=Num:C11(BLOB to text:C555($x; Mac text without length:K22:10))
				
			Else 
				
				$settings.declaration.options.numberOfVariablePerLine:=10
				
			End if 
			
			If ($xml.preferences["beautifier-options"].$#Null:C1517)
				
				TEXT TO BLOB:C554($xml.preferences["beautifier-options"].$; $x; Mac text without length:K22:10)
				BASE64 DECODE:C896($x)
				$l:=Num:C11(BLOB to text:C555($x; Mac text without length:K22:10))
				
				$settings.beautifier:=New object:C1471(\
					"replaceDeprecatedCommand"; $l ?? 15; \
					"removeConsecutiveBlankLines"; $l ?? 10; \
					"removeEmptyLinesAtTheBeginOfMethod"; $l ?? 1; \
					"removeEmptyLinesAtTheEndOfMethod"; $l ?? 2; \
					"lineBreakBeforeBranchingStructures"; $l ?? 3; \
					"lineBreakBeforeLoopingStructures"; $l ?? 6; \
					"lineBreakBeforeAndAfterSequentialStructuresIncluded"; $l ?? 4; \
					"separationLineForCaseOf"; $l ?? 5; \
					"aLineOfCommentsMustBePrecededByALineBreak"; $l ?? 11; \
					"groupingClosureInstructions"; $l ?? 9; \
					"addTheIncrementForTheLoops"; $l ?? 8; \
					"splitTestLines"; $l ?? 12; \
					"replaceComparisonsToAnEmptyStringByLengthTest"; $l ?? 13; \
					"replaceIfElseEndIfByChoose"; $l ?? 14; \
					"splitKeyValueLines"; $l ?? 7)
				
			Else 
				
				$settings.beautifier:=New object:C1471(\
					"replaceDeprecatedCommand"; True:C214; \
					"removeConsecutiveBlankLines"; True:C214; \
					"removeEmptyLinesAtTheBeginOfMethod"; True:C214; \
					"removeEmptyLinesAtTheEndOfMethod"; True:C214; \
					"lineBreakBeforeBranchingStructures"; True:C214; \
					"lineBreakBeforeLoopingStructures"; True:C214; \
					"lineBreakBeforeAndAfterSequentialStructuresIncluded"; True:C214; \
					"separationLineForCaseOf"; True:C214; \
					"aLineOfCommentsMustBePrecededByALineBreak"; True:C214; \
					"groupingClosureInstructions"; True:C214; \
					"addTheIncrementForTheLoops"; True:C214; \
					"splitTestLines"; True:C214; \
					"replaceComparisonsToAnEmptyStringByLengthTest"; True:C214; \
					"replaceIfElseEndIfByChoose"; False:C215; \
					"splitKeyValueLines"; True:C214)
				
			End if 
			
			If ($xml.preferences.specialPasteChoice.$#Null:C1517)
				
				TEXT TO BLOB:C554($xml.preferences.specialPasteChoice.$; $x; Mac text without length:K22:10)
				BASE64 DECODE:C896($x)
				$settings.specialPast:=New object:C1471(\
					"selected"; Num:C11(BLOB to text:C555($x; \
					Mac text without length:K22:10)))
				
			Else 
				
				$settings.specialPast:=New object:C1471(\
					"selected"; 1)
				
			End if 
			
			If ($xml.preferences.specialPasteOptions.$#Null:C1517)
				
				TEXT TO BLOB:C554($xml.preferences.specialPasteOptions.$; $x; Mac text without length:K22:10)
				BASE64 DECODE:C896($x)
				$l:=Num:C11(BLOB to text:C555($x; Mac text without length:K22:10))
				$settings.specialPast.options:=New object:C1471(\
					"ignoreBlankLines"; $l ?? 10; \
					"deleteIndentation"; $l ?? 11)
				
			Else 
				
				$settings.specialPast.options:=New object:C1471(\
					"ignoreBlankLines"; False:C215; \
					"deleteIndentation"; False:C215)
				
			End if 
			
		Else 
			
			// PARSING ERROR
			
		End if 
	End if 