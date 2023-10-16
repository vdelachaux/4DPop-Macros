property title; name; objectName; method; highlighted; decimalSeparator : Text
property class; form; trigger; projectMethod; objectMethod; withSelection : Boolean
property lineTexts : Collection
property _controlFlow : Object
property rgx : cs:C1710.regex

Class constructor()
	
	var $t : Text
	var $ƒ : 4D:C1709.Function
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	This:C1470.title:=Get window title:C450(Frontmost window:C447)
	
	// Identify the name & the type of the current method
	This:C1470.name:=""
	This:C1470.objectName:=""
	This:C1470.projectMethod:=False:C215
	This:C1470.objectMethod:=False:C215
	This:C1470.class:=False:C215
	This:C1470.form:=False:C215
	This:C1470.trigger:=False:C215
	
	If (Match regex:C1019("(?m-si)^([^:]*\\s*:\\s)([[:ascii:]]*)(\\.[[:ascii:]]*)?(?:\\s*\\*)?$"; This:C1470.title; 1; $pos; $len))
		
		$ƒ:=Formula from string:C1601(Parse formula:C1576("_localized string:C1578($1)"))
		$t:=Substring:C12(This:C1470.title; $pos{1}; $len{1})
		This:C1470.projectMethod:=($t=$ƒ.call(Null:C1517; "common_method"))
		This:C1470.objectMethod:=($t=$ƒ.call(Null:C1517; "common_objectMethod"))
		This:C1470.class:=(Position:C15("Class:"; $t)=1)
		This:C1470.form:=($t=$ƒ.call(Null:C1517; "common_form"))
		This:C1470.trigger:=($t=$ƒ.call(Null:C1517; "common_Trigger"))
		
		This:C1470.name:=Substring:C12(This:C1470.title; $pos{2}; $len{2})
		
		If ($pos{3}>0)
			
			This:C1470.objectName:=Substring:C12(This:C1470.title; $pos{3}; $len{3})
			
		End if 
		
	Else 
		
		// 👀 What is it?
		
	End if 
	
	This:C1470.method:=""
	This:C1470.highlighted:=""
	This:C1470.withSelection:=False:C215
	
	If (This:C1470.form)
		
		// #TO_DO 🚧
		
	Else 
		
		// The full code
		GET MACRO PARAMETER:C997(Full method text:K5:17; $t)
		This:C1470.method:=$t
		
		// The selection
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $t)
		This:C1470.highlighted:=$t
		This:C1470.withSelection:=Length:C16($t)>0
		
	End if 
	
	This:C1470.lineTexts:=[]
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
	This:C1470.decimalSeparator:=$t
	
	This:C1470.rgx:=cs:C1710.regex.new()
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get macroCall() : Boolean
	
	var $name : Text
	var $state; $time : Integer
	
	PROCESS PROPERTIES:C336(Current process:C322; $name; $state; $time)
	return $name="Macro_Call"
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function split($useSelection : Boolean)
	
	var $target : Text
	
	If (Count parameters:C259>=1)
		
		$target:=$useSelection ? This:C1470.highlighted : This:C1470.method
		
	Else 
		
		$target:=This:C1470.withSelection ? This:C1470.highlighted : This:C1470.method
		
	End if 
	
	This:C1470.lineTexts:=Split string:C1554($target; "\r"; sk trim spaces:K86:2)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setMethodText($text : Text)
	
	SET MACRO PARAMETER:C998(Full method text:K5:17; $text)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setHighlightedText($text : Text)
	
	SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $text)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function localizedControlFlow($control : Text) : Text
	
	This:C1470._controlFlow:=This:C1470._controlFlow || JSON Parse:C1218(File:C1566("/RESOURCES/controlFlow.json").getText())
	return Command name:C538(41)="ALERT" ? $control : This:C1470._controlFlow.fr(This:C1470._controlFlow.intl.indexOf($control))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function PasteColor()
	
	var $color : Integer
	
	$color:=Select RGB color:C956($color)
	
	If (Bool:C1537(OK))
		
		This:C1470.setHighlightedText(String:C10($color & 0x00FFFFFF; "&x")+kCaret)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Compiler Directives for local variables
Function Declarations()
	
	DECLARATION
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Beautifier()
	
	cs:C1710.beautifier.new().beautify()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//#v11 Paste after transformations
Function SpecialPaste()
	
	cs:C1710.specialPaste.new()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Paste the contents of the clipboard and copy the selection
Function PasteAndKeepTarget()
	
	var $t : Text
	
	If (This:C1470._noSelection())
		
		return 
		
	End if 
	
	$t:=Get text from pasteboard:C524  // Get the text content of the clipboard
	
	If (Length:C16($t)=0)
		
		ALERT:C41("No text into the pasteboard")
		
	End if 
	
	// Put the highlighted text on the clipboard…
	CLEAR PASTEBOARD:C402
	SET TEXT TO PASTEBOARD:C523(This:C1470.highlighted)
	
	// …and replace it with the previous one.
	This:C1470.setHighlightedText($t)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// v13+ replace If(test) var:=x Else var:=y End if by var:=Choose(test;x;y)
Function Choose()
	
	var $t : Text
	var $affect; $index : Integer
	var $c : Collection
	
	If (This:C1470.withSelection)
		
		$c:=Split string:C1554(This:C1470.highlighted; "\r"; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
		
		If ($c.length=5)
			
			ARRAY LONGINT:C221($pos; 0x0000)
			ARRAY LONGINT:C221($len; 0x0000)
			
			If (Match regex:C1019(Choose:C955(Command name:C538(1)="Sum"; "If"; "Si")+"\\s*\\(([^\\)]*)\\).*"; $c[0]; 1; $pos; $len))
				
				$index:=Position:C15(":="; $c[1])
				
				If ($index>0)
					
					$affect:=Position:C15(":="; $c[3])
					
					If ($affect>0)
						
						$t:=Substring:C12($c[1]; 1; $index-1)\
							+":="\
							+Command name:C538(955)\
							+"("\
							+Substring:C12($c[0]; $pos{1}; $len{1})\
							+";"\
							+Substring:C12($c[1]; $index+2)\
							+";"\
							+Substring:C12($c[3]; $affect+2)\
							+")"
						
						This:C1470.setHighlightedText($t)
						
					End if 
				End if 
			End if 
		End if 
		
	Else 
		
		BEEP:C151
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Copy the selected text
Function CopyWithTokens()
	
	var $line : Text
	var $c : Collection
	
	If (This:C1470._noSelection())
		
		return 
		
	End if 
	
	$c:=New collection:C1472
	
	For each ($line; Split string:C1554(This:C1470.highlighted; "\r"))
		
		$c.push(Parse formula:C1576($line; Formula out with tokens:K88:3))
		
	End for each 
	
	SET TEXT TO PASTEBOARD:C523($c.join("\r"))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Replaces a method name in quotation marks with a tokenized call
Function ConvertToCallWithToken()
	
	If (This:C1470._noSelection())
		
		return 
		
	End if 
	
	If (This:C1470.highlighted="\"@") & (This:C1470.highlighted="@\"")
		
		SET MACRO PARAMETER:C998(Highlighted method text:K5:18; "Formula:C1597("+Replace string:C233(This:C1470.highlighted; "\""; "")+").source")
		POST KEY:C465(3)
		
	Else 
		
		ALERT:C41("Selected text must be enclosed in quotation marks")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function zipForShare()
	
	var $name : Text
	var $folder; $zipArchive; $folderTempo; $o : Object
	
/*
zip the current database folder after performing some cleanup :
- delete invisible files & folders (name beginning with a dot)
- delete files and folders whose names begin with a "_" character.)
- delete the Preferences, Settings, Trash & DerivedData folders…
- delete the userPreferences.xxx folders
	
The zip archive is created at the same level as the selected folder.
*/
	
	$folder:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)  // Folder(DOCUMENT; fk platform path)
	
	$folderTempo:=$folder.copyTo(Folder:C1567(Temporary folder:C486; fk platform path:K87:2); $folder.name; fk overwrite:K87:5)
	
	For each ($o; $folderTempo.files(fk recursive:K87:7).query("(fullName =.@) OR (fullName =_@)"))
		
		$o.delete()
		
	End for each 
	
	For each ($o; $folderTempo.folders(fk recursive:K87:7).query("(fullName =.@) OR (fullName =_@) OR (fullName =Logs)"))
		
		$o.delete(Delete with contents:K24:24)
		
	End for each 
	
	For each ($o; $folderTempo.folders().query("fullName =userPreferences.@"))
		
		$o.delete(Delete with contents:K24:24)
		
	End for each 
	
	For each ($name; [\
		"Settings"; \
		"Preferences"; \
		"Project/DerivedData"; \
		"Project/Trash"; \
		"Data"; \
		"Build"; \
		"Libraries"\
		])
		
		$o:=$folderTempo.folder($name)
		
		If ($o.exists)
			
			$o.delete(Delete with contents:K24:24)
			
		End if 
	End for each 
	
	For each ($name; [\
		"LICENSE"; \
		"make.json"; \
		"lastbuild"; \
		"readme.md"; \
		"Info.plist"\
		])
		
		$o:=$folderTempo.file($name)
		
		If ($o.exists)
			
			$o.delete()
			
		End if 
	End for each 
	
	$zipArchive:=$folder.parent.file($folder.name+".zip")
	$zipArchive.delete(Delete with contents:K24:24)
	
	If (ZIP Create archive:C1640($folderTempo; $zipArchive; ZIP Without enclosing folder:K91:7).success)
		
		SHOW ON DISK:C922($zipArchive.platformPath)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function RemoveBlankLines()
	
	var $line; $out : Text
	
	For each ($line; Split string:C1554(Length:C16(This:C1470.highlighted)=0 ? This:C1470.method : This:C1470.highlighted; "\r"; sk ignore empty strings:K86:1))
		
		If ($line#"// ")
			
			$out:=$out+$line+"\r"
			
		End if 
	End for each 
	
	If (Length:C16(This:C1470.highlighted)=0)
		
		This:C1470.setMethodText($out)
		
	Else 
		
		This:C1470.setHighlightedText($out)
		
	End if 
	
	//MARK:-[COMMENTS]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function commentBlock
	
	This:C1470.setHighlightedText("/*\r"+This:C1470.highlighted+"\r*/")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function duplicateAndComment()
	
	If (This:C1470._noSelection())
		
		return 
		
	End if 
	
	If (Split string:C1554(This:C1470.highlighted; "\r").length=1)
		
		This:C1470.setHighlightedText(This:C1470._comment()+"\r"+This:C1470.highlighted+kCaret)*/
		
	Else 
		
		This:C1470.setHighlightedText(This:C1470._comment()+This:C1470.highlighted+kCaret)*/
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function comment()
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	If (This:C1470._noSelection())
		
		return 
		
	End if 
	
	If (Match regex:C1019("(?si-m)/\\*(.*)\\*/\\s*"; This:C1470.highlighted; 1; $pos; $len))\
		 || (Match regex:C1019("(?mi-s)//\\s*(.*)$"; This:C1470.highlighted; 1; $pos; $len))
		
		var $c : Collection
		$c:=Split string:C1554(Substring:C12(This:C1470.highlighted; $pos{1}; $len{1}); "\r")
		
		If ($c.length=1)
			
			This:C1470.setHighlightedText($c[0]+"\r")
			
		Else 
			
			This:C1470.setHighlightedText($c.join("\r"))
			
		End if 
	End if 
	
	This:C1470.setHighlightedText(This:C1470._comment())
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _comment() : Text
	
	var $c : Collection
	$c:=Split string:C1554(This:C1470.highlighted; "\r")
	
	If ($c[0]="")
		
		$c.remove(0)
		
	End if 
	
	If ($c[$c.length-1]="")
		
		$c.remove($c.length-1)
		
	End if 
	
	If ($c.length=1)
		
		var v1; v2; v3; v4 : Variant
		Formula from string:C1601(":C1810(v1; v2; v3; v4)").call()
		
		If ($c[0]=Split string:C1554(This:C1470.method; "\r")[v3])
			
			return "// "+This:C1470.highlighted
			
		Else 
			
			return "/*"+This:C1470.highlighted+"*/"
			
		End if 
		
	Else 
		
		return "/*\r"+$c.join("\r")+"\r*/"+("\r"*Num:C11(v1=v2))
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _noSelection() : Boolean
	
	If (Not:C34(This:C1470.withSelection))
		
		BEEP:C151
		ALERT:C41("This macro requires text to be selected before it is called!")
		return True:C214
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _paste($text : Text; $useSelection : Boolean)
	
	var $target : Integer
	
	If (Count parameters:C259>=2)
		
		$target:=Choose:C955($useSelection; Highlighted method text:K5:18; Full method text:K5:17)
		
	Else 
		
		$target:=Choose:C955(This:C1470.withSelection; Highlighted method text:K5:18; Full method text:K5:17)
		
	End if 
	
	SET MACRO PARAMETER:C998($target; $text)
	
	If (Structure file:C489=Structure file:C489(*))
		
		return 
		
	End if 
	
	// Force tokenisation
	var $name : Text
	var $i; $mode; $origin; $state; $time; $UID : Integer
	
	For ($i; 1; Count tasks:C335; 1)
		
		PROCESS PROPERTIES:C336($i; $name; $state; $time; $mode; $UID; $origin)
		
		If ($origin=Design process:K36:9)
			
			POST EVENT:C467(Key down event:K17:4; Enter:K15:35; Tickcount:C458; 0; 0; 0; $i)
			
			break
			
		End if 
	End for 
	