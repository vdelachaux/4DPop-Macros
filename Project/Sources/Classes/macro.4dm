property title : Text:=Get window title:C450(Frontmost window:C447)
property name : Text:=""
property objectName : Text:=""
property method : Text:=""
property highlighted : Text:=""

property class : Boolean:=False:C215
property form : Boolean:=False:C215
property trigger : Boolean:=False:C215
property projectMethod : Boolean:=False:C215
property objectMethod : Boolean:=False:C215
property withSelection : Boolean:=False:C215

property line : Text:=""
property lines : Collection:=[]
property lineIndex : Integer:=0

property isCommentBlock : Boolean:=False:C215

property _output : Collection:=[]

property decimalSeparator : Text

property isProject : Boolean:=Bool:C1537(Get database parameter:C643(Is host database a project:K37:99))

// MARK: Delegate
property rgx : cs:C1710.rgx.regex:=cs:C1710.rgx.regex.new()

Class constructor()
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	// Identify the name & the type of the current method
	If (Match regex:C1019("(?m-si)^([^:]*\\s*:\\s)([[:ascii:]]*)(\\.[[:ascii:]]*)?(?:\\s*\\*)?$"; This:C1470.title; 1; $pos; $len))
		
		var $ƒ:=Formula from string:C1601(Parse formula:C1576("Get localized string:C1578($1)"))
		var $t:=Substring:C12(This:C1470.title; $pos{1}; $len{1})
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
	
	If (This:C1470.form)
		
		// TODO: 🚧
		
	Else 
		
		// The full code
		GET MACRO PARAMETER:C997(Full method text:K5:17; $t)
		This:C1470.method:=$t
		
		// The selection
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $t)
		This:C1470.highlighted:=$t
		This:C1470.withSelection:=Length:C16($t)>0
		
	End if 
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
	This:C1470.decimalSeparator:=$t
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get isMacroProcess() : Boolean
	
	return Process info:C1843(Current process:C322).name="Macro_Call"
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setMethodText($text : Text)
	
	SET MACRO PARAMETER:C998(Full method text:K5:17; $text)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setHighlightedText($text : Text)
	
	SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $text)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the target (form/method name) from an editor window's title
Function _windowTitle($window : Integer) : Text
	
	var $ref : Integer:=Count parameters:C259>=1 ? $window : Frontmost window:C447
	
	var $c : Collection:=Split string:C1554(Get window title:C450($ref); ":"; sk trim spaces:K86:2)
	var $title : Text:=$c[Num:C11($c.length>1)]
	
	// PC bug: the title is suffixed with '*' when the method is modified and not saved
	$title:=Replace string:C233($title; " *"; "")
	$title:=Replace string:C233($title; "*"; "")
	
	return $title
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function paste($text : Text; $useSelection : Boolean)
	
	$useSelection:=Count parameters:C259>=2 ? $useSelection : This:C1470.withSelection
	
	SET MACRO PARAMETER:C998($useSelection ? Highlighted method text:K5:18 : Full method text:K5:17; $text)
	
	This:C1470.tokenize()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function tokenize()
	
	If (Structure file:C489=Structure file:C489(*))
		
		return 
		
	End if 
	
	// Force tokenisation
	var $i : Integer
	For ($i; 1; Count tasks:C335; 1)
		
		If (Process info:C1843($i).type=Design process:K36:9)
			
			POST EVENT:C467(Key down event:K17:4; Enter:K15:35; Tickcount:C458; 0; 0; 0; $i)
			
			break
			
		End if 
	End for 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function split($useSelection : Boolean; $options : Integer)
	
	If (Count parameters:C259>=1)
		
		var $target : Text:=$useSelection ? This:C1470.highlighted : This:C1470.method
		
	Else 
		
		$target:=This:C1470.highlighted || This:C1470.method
		
	End if 
	
	$options:=Count parameters:C259>=2 ? $options : sk trim spaces:K86:2
	
	This:C1470.lines:=Split string:C1554($target; "\r"; $options)
	
	//MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function localizedControlFlow($control : Text) : Text
	
	return cs:C1710.controlFlow.me.localized($control)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function noSelection() : Boolean
	
	If (Not:C34(This:C1470.withSelection))
		
		BEEP:C151
		ALERT:C41("This macro requires text to be selected before it is called!")
		return True:C214
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isEmpty( ...  : Text) : Boolean
	
	return Length:C16(Copy parameters:C1790.join(""))=0
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNotEmpty( ...  : Text) : Boolean
	
	return Length:C16(Copy parameters:C1790.join(""))>0
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isMultiline($line) : Boolean
	
	return Match regex:C1019("(?mi-s).*?\\\\$"; $line; 1; *)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNotMultiline($line) : Boolean
	
	return Not:C34(This:C1470.isMultiline($line))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isComment($line : Text) : Boolean
	
	return (Length:C16($line)>0)\
		 && ((Position:C15(kCommentMark; $line)=1) || (Position:C15("/*"; $line)=1) || (Position:C15("*/"; $line)=1))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNotComment($line : Text) : Boolean
	
	return Not:C34(This:C1470.isComment($line))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isReservedComment($line : Text) : Boolean
	
	return ($line=(kCommentMark+"}"))\
		 || ($line=(kCommentMark+"]"))\
		 || ($line=(kCommentMark+")"))\
		 || (Match regex:C1019("(?mi-s)^//%[A-Z][+-](?:\\d{3}\\.\\d)?$"; $line; 1; *))\
		 || (Match regex:C1019("(?mi-s)^/\\*.*\\*/$"; $line; 1; *))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNotReservedComment($line : Text) : Boolean
	
	return Not:C34(This:C1470.isReservedComment($line))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isMarkerComment($line : Text) : Boolean
	
	If (This:C1470.isComment($line))
		
		return Match regex:C1019("(?mi-s)^//\\s*(?:mark|todo|fixme):"; $line; 1; *)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNotMarkerComment($line : Text) : Boolean
	
	return Not:C34(This:C1470.isMarkerComment($line))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isSeparatorLineComment($line : Text) : Boolean
	
	If (This:C1470.isComment($line))
		
		return Match regex:C1019("(?mi-s)^//\\s*(?:mark|todo|fixme):-"; $line; 1; *)\
			 || Match regex:C1019("(?mi-s)^//\\s*(.)(?:\\1|\\s){10,}"; $line; 1; *)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNotSeparatorLineComment($line : Text) : Boolean
	
	return Not:C34(This:C1470.isSeparatorLineComment($line))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isOpeningReservedComment($line : Text) : Boolean
	
	return ($line=(kCommentMark+"}"))\
		 || ($line=(kCommentMark+"]"))\
		 || ($line=(kCommentMark+")"))\
		 || (Match regex:C1019("(?m-si)^//%[A-Z]-$"; $line; 1; *))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNotOpeningReservedComment($line : Text) : Boolean
	
	return Not:C34(This:C1470.isOpeningReservedComment($line))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isClosingReservedComment($line : Text) : Boolean
	
	return ($line=(kCommentMark+"}"))\
		 || ($line=(kCommentMark+"]"))\
		 || ($line=(kCommentMark+")"))\
		 || (Match regex:C1019("(?m-si)^//%[A-Z]\\+$"; $line; 1; *))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNotClosingReservedComment($line : Text) : Boolean
	
	return Not:C34(This:C1470.isClosingReservedComment($line))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Search for an unused character for a temporary replacement, for example 😉
Function unusedCharacter($code : Text) : Text
	
	var $i : Integer
	var $c : Collection:=[126; 167; 182; 248; 8225; 8226; 8734; 8776; 63743]
	
	Repeat 
		
		var $t : Text:=Char:C90($c[$i])
		
		If (Position:C15($t; $code)=0)
			
			return $t
			
		End if 
		
		$i+=1
		
	Until (False:C215)
	
Function isNumeric($in : Text) : Boolean
	
	return Match regex:C1019("(?mi-s)^(?:\\+|-)?\\d*?(?:(?:\\.|,)\\d*?)??"; $in; 1; *)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isDECLARE($in : Text) : Boolean
	
	return Position:C15("#DECLARE"; $in)=1
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isConstructor($in : Text) : Boolean
	
	return Match regex:C1019("(?m-si)^(singleton\\s|shared\\s)??(singleton\\s|shared\\s)??Class constructor"; $in; 1; *)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isFunction($in : Text) : Boolean
	
	return Match regex:C1019("(?m-si)^(local\\s|shared\\s)??(local\\s|shared\\s)??Function(.*?)\\((.*?)\\)"; $in; 1; *)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function constantValue($in : Text)
	
	If (This:C1470.noSelection())
		
		return 
		
	End if 
	
	var $txt:=This:C1470.highlighted
	var $value:=Formula from string:C1601($txt).call()
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is undefined:K8:13)
			
			ALERT:C41("["+$txt+"] does not seem to be a constant!")
			
			//______________________________________________________
		: (Value type:C1509($value)=Is text:K8:3)
			
			ALERT:C41("["+$txt+"] (Text) = \""+String:C10($value)+"\"")
			
			//______________________________________________________
		Else 
			
			ALERT:C41("["+$txt+"] (Numeric) = "+String:C10($value))
			
			//______________________________________________________
	End case 
	
	//MARK:-[MACROS]
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
	
	cs:C1710.declaration.new()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Beautifier()
	
	cs:C1710.beautifier.new()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Paste after transformations
Function SpecialPaste()
	
	cs:C1710.specialPaste.new()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Paste the contents of the clipboard and copy the selection
Function PasteAndKeepTarget()
	
	If (This:C1470.noSelection())
		
		return 
		
	End if 
	
	var $t : Text:=Get text from pasteboard:C524  // Get the text content of the clipboard
	
	If (Length:C16($t)=0)
		
		ALERT:C41("No text into the pasteboard")
		
	End if 
	
	// Put the highlighted text on the clipboard…
	CLEAR PASTEBOARD:C402
	SET TEXT TO PASTEBOARD:C523(This:C1470.highlighted)
	
	// …and replace it with the previous one.
	This:C1470.setHighlightedText($t)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function objectLiteral()
	
	var $t : Text:=This:C1470.withSelection ? This:C1470.highlighted : This:C1470.method
	var $rgx:=cs:C1710.rgx.regex.new($t; "(?ms-i)New object\\((.*?)\\)")
	$t:=$rgx.substitute("{\\1}")
	$rgx.setTarget($t)
	$rgx.setPattern("(?msi)\"(?=[^0-9])([^-\\s\"]+)\"\\s*;\\s*([^;}]+)")
	$t:=$rgx.substitute("\\1:\\2")
	This:C1470.paste($t)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// v13+ replace If(test) var:=x Else var:=y End if by var:=Choose(test;x;y)
Function Choose()
	
	var $t : Text
	var $affect; $index : Integer
	var $c : Collection
	
	If (This:C1470.noSelection())
		
		return 
		
	End if 
	
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Copy the selected text
Function CopyWithTokens()
	
	If (This:C1470.noSelection())
		
		return 
		
	End if 
	
	var $line : Text
	var $c : Collection:=[]
	
	For each ($line; Split string:C1554(This:C1470.highlighted; "\r"))
		
		$c.push(Parse formula:C1576($line; Formula out with tokens:K88:3))
		
	End for each 
	
	SET TEXT TO PASTEBOARD:C523($c.join("\r"))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Replaces a method name in quotation marks with a tokenized call
Function ConvertToCallWithToken()
	
	If (This:C1470.noSelection())
		
		return 
		
	End if 
	
	If (Match regex:C1019("(?mi-s)^\"[^\"]*\""; This:C1470.highlighted; 1; *))
		
		This:C1470.paste("Formula:C1597("+Replace string:C233(This:C1470.highlighted; "\""; "")+").source")
		POST KEY:C465(3)
		
	Else 
		
		ALERT:C41("Selected text must be enclosed in quotation marks")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function convert_hexa()
	
	If (This:C1470.noSelection())
		
		return 
		
	End if 
	
	If (This:C1470.isNumeric(This:C1470.highlighted))
		
		This:C1470.paste(String:C10(Num:C11(This:C1470.highlighted); "&x")+kCaret)
		
	Else 
		
		BEEP:C151
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function convert_decimal()
	
	If (This:C1470.noSelection())
		
		return 
		
	End if 
	
	If (This:C1470.highlighted="0x@")
		
		This:C1470.paste(String:C10(This:C1470._hex2long(This:C1470.highlighted))+kCaret)
		
	Else 
		
		BEEP:C151
		
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
	
	For each ($line; Split string:C1554(This:C1470.highlighted || This:C1470.method; "\r"; sk ignore empty strings:K86:1))
		
		If ($line#"// ")
			
			$out+=$line+"\r"
			
		End if 
	End for each 
	
	This:C1470.paste($out)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function comment()
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	If (This:C1470.noSelection())
		
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function commentBlock
	
	This:C1470.paste("/*\r"+This:C1470.highlighted+"\r*/")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Comments the boundary keywords (open / mid / close) of the outermost
	// control structure found in the selection ("current level")
Function comment_current_level()
	
	If (This:C1470.noSelection())
		
		return 
		
	End if 
	
	var $keywords : Collection:=cs:C1710.controlFlow.me.keywords
	
	// Order matters: "For each" before "For", "End for each" before "End for"
	var $open : Collection:=[$keywords[13]; $keywords[7]; $keywords[5]; $keywords[3]; $keywords[9]; $keywords[11]; $keywords[0]]
	var $close : Collection:=[$keywords[14]; $keywords[8]; $keywords[6]; $keywords[4]; $keywords[10]; $keywords[12]; $keywords[2]]
	var $else : Text:=$keywords[1]
	
	var $lines : Collection:=Split string:C1554(This:C1470.highlighted; "\r")
	var $depth; $i : Integer
	var $changed : Boolean:=False:C215
	var $line; $trimmed : Text
	
	For each ($line; $lines)
		
		$trimmed:=This:C1470._trimLeft($line)
		
		Case of 
				
				// A closing keyword: comment it only when it closes the outermost block
			: (This:C1470._beginsWithAny($trimmed; $close))
				
				$depth-=1
				
				If ($depth=0)
					
					$lines[$i]:=kCommentMark+$line
					$changed:=True:C214
					
				End if 
				
				// An opening keyword: comment it only at the outermost level
			: (This:C1470._beginsWithAny($trimmed; $open))
				
				If ($depth=0)
					
					$lines[$i]:=kCommentMark+$line
					$changed:=True:C214
					
				End if 
				
				$depth+=1
				
				// An "Else" or a "Case of" item belonging to the outermost block
			: (($depth=1) && ((This:C1470._beginsWith($trimmed; $else)) || (Position:C15(":"; $trimmed)=1)))
				
				$lines[$i]:=kCommentMark+$line
				$changed:=True:C214
				
		End case 
		
		$i+=1
		
	End for each 
	
	If ($changed)
		
		This:C1470.setHighlightedText($lines.join("\r"))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Displays the comment editor and pastes the entered comment block into the selection
Function edit_comment()
	
	var $comments : Text:=This:C1470.highlighted
	var $c : Collection:=Split string:C1554($comments; "\r")
	var $t : Text
	var $i; $position : Integer
	
	// Remove any existing comment marks before editing
	For each ($t; $c)
		
		$position:=Position:C15(kCommentMark; $t)
		
		If ($position>0)
			
			$c[$i]:=Substring:C12($t; $position+Length:C16(kCommentMark))
			
		End if 
		
		$i+=1
		
	End for each 
	
	var $window : Integer:=Open form window:C675("COMMENTS"; Movable dialog box:K34:7; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	SET MENU BAR:C67(1)
	
	var $o : Object:=New object:C1471("text"; $c.join("\r"))
	DIALOG:C40("COMMENTS"; $o)
	CLOSE WINDOW:C154
	
	If (Not:C34(Bool:C1537(OK)))
		
		return 
		
	End if 
	
	$comments:=$o.text
	
	If (Length:C16($comments)=0)
		
		return 
		
	End if 
	
	If (Position:C15("<span"; $comments)>0)
		
		$comments:=ST Get plain text:C1092($comments)
		
	End if 
	
	// Comment each non-empty line
	$c:=Split string:C1554($comments; "\r")
	$i:=0
	
	For each ($t; $c)
		
		If (Length:C16($t)>0)
			
			$c[$i]:=kCommentMark+Char:C90(Space:K15:42)+$t
			
		End if 
		
		$i+=1
		
	End for each 
	
	$comments:=$c.join("\r")
	
	// Expand placeholders
	$comments:=Replace string:C233($comments; "<date/>"; String:C10(Current date:C33))
	$comments:=Replace string:C233($comments; "<time/>"; String:C10(Current time:C178))
	$comments:=Replace string:C233($comments; "<user_4D/>"; Current user:C182)
	$comments:=Replace string:C233($comments; "<user_os/>"; Current machine:C483)
	$comments:=Replace string:C233($comments; "<version_4D/>"; Application version:C493(*))
	$comments:=Replace string:C233($comments; "<database_name/>"; Structure file:C489)
	
	var $title : Text:=This:C1470._windowTitle(Frontmost window:C447)
	$comments:=Replace string:C233($comments; "<method_name/>"; $title)
	
	$title:=Get window title:C450(Next window:C448(Frontmost window:C447))
	$position:=Position:C15(" - "; $title)
	
	If ($position>0)
		
		$title:=Delete string:C232($title; 1; $position+2)
		
	End if 
	
	$title:=Replace string:C233($title; " *"; "")
	
	If (Position:C15(Localized string:C991("Form: "); $title)>0)
		
		$comments:=Replace string:C233($comments; "<form_name/>"; $title)
		
	End if 
	
	This:C1470.setHighlightedText($comments+kCaret)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// True if $text (already left-trimmed) begins with $keyword as a whole word
Function _beginsWith($text : Text; $keyword : Text) : Boolean
	
	If (Position:C15($keyword; $text)#1)
		
		return False:C215
		
	End if 
	
	var $next : Integer:=Length:C16($keyword)+1
	
	If (Length:C16($text)<$next)
		
		return True:C214
		
	End if 
	
	var $char : Text:=$text[[$next]]
	return ($char=" ") || ($char="(") || ($char=Char:C90(9))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// True if $text begins with any of the given keywords (as whole words)
Function _beginsWithAny($text : Text; $keywords : Collection) : Boolean
	
	var $keyword : Text
	
	For each ($keyword; $keywords)
		
		If (This:C1470._beginsWith($text; $keyword))
			
			return True:C214
			
		End if 
		
	End for each 
	
	return False:C215
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Removes leading spaces and tabs
Function _trimLeft($text : Text) : Text
	
	var $t : Text:=$text
	var $tab : Text:=Char:C90(9)
	
	While ((Length:C16($t)>0) && (($t[[1]]=" ") || ($t[[1]]=$tab)))
		
		$t:=Substring:C12($t; 2)
		
	End while 
	
	return $t
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function duplicateAndComment()
	
	If (This:C1470.noSelection())
		
		return 
		
	End if 
	
	If (Split string:C1554(This:C1470.highlighted; "\r").length=1)
		
		This:C1470.setHighlightedText(This:C1470._comment()+"\r"+This:C1470.highlighted+kCaret)
		
	Else 
		
		This:C1470.setHighlightedText(This:C1470._comment()+This:C1470.highlighted+kCaret)
		
	End if 
	
	// MARK:-
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
		Formula from string:C1601("4D:C1810(v1; v2; v3; v4)").call()
		
		If ($c[0]=Split string:C1554(This:C1470.method; "\r")[v3])
			
			return "// "+This:C1470.highlighted
			
		Else 
			
			return "/*"+This:C1470.highlighted+"*/"
			
		End if 
		
	Else 
		
		return "/*\r"+$c.join("\r")+"\r*/"+("\r"*Num:C11(v1=v2))
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _hex2long($hex : Text) : Integer
	
	var $num : Real
	var $charCode; $i; $length : Integer
	
	$hex:=Uppercase:C13($hex)
	$length:=Length:C16($hex)
	
	For ($i; $length; 1; -1)
		
		$charCode:=Character code:C91($hex[[$i]])
		
		Case of 
				
				// ……………………………………………………………
			: (($charCode>47)\
				 && ($charCode<58))  // 0..9
				
				$num+=(($charCode-48)*(16^($length-$i)))
				
				// ……………………………………………………………
			: (($charCode>64)\
				 && ($charCode<71))  // A..F
				
				$num+=(($charCode-55)*(16^($length-$i)))
				
				// ……………………………………………………………
			Else   // "x" of Ox or other gizmo...
				
				break
				
				// ……………………………………………………………
		End case 
	End for 
	
	return Int:C8($num)