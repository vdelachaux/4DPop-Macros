Class extends macro

property preview : Text:=""
property original : Text:=""
property options; currentTargetIndex; selected : Integer
property currentTarget : Object

property columns : Integer:=80  // Default text column number

property target : Collection:=[]

property windowRef : Integer:=Open form window:C675("SPECIAL_PASTE"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4; *)

Class constructor()
	
	Super:C1705()
	
	var $t : Text
	var $o : Object
	For each ($t; [\
		"string"; \
		"comments"; \
		"tokenized"; \
		"patternRegex"; \
		"pathname"; \
		"insertInText"; \
		"htmlExpression"; \
		"htmlCode"; \
		"jsonCode"; \
		"toUTF8"; \
		"fromUTF8"])
		
		$o:={\
			label: " "+Localized string:C991($t); \
			transform: $t}
		
		Case of 
				
				//______________________________________________________
			: (New collection:C1472(\
				"string"; \
				"comments"; \
				"htmlCode").indexOf($t)#-1)
				
				$o.options:=New object:C1471
				$o.options["1"]:="deleteIndentation"
				$o.options["2"]:="ignoreBlankLines"
				
				//______________________________________________________
			: ($t="pathname")
				
				$o.options:=New object:C1471
				$o.options["1"]:="relative"
				$o.options["2"]:="posix"
				
				//______________________________________________________
		End case 
		
		This:C1470.target.push($o)
		
	End for each 
	
	DIALOG:C40("SPECIAL_PASTE"; This:C1470)
	
	If (Bool:C1537(OK))
		
		var $selected : Integer:=This:C1470.currentTargetIndex
		_o_Preferences("Set_Value"; "specialPasteChoice"; ->$selected)
		
		var $options : Integer:=This:C1470.options
		_o_Preferences("Set_Value"; "specialPasteOptions"; ->$options)
		
		This:C1470.setHighlightedText(This:C1470.preview+kCaret)
		
	End if 
	
	CLOSE WINDOW:C154(This:C1470.windowRef)
	
	//=========================================================================
Function refresh()
	
	SET TIMER:C645(-1)
	
	//=========================================================================
Function onLoad()
	
	var $options; $selected : Integer
	var $ptr : Pointer
	
	This:C1470.original:=Get file from pasteboard:C976(1)
	
	If (Length:C16(This:C1470.original)>0)
		
		// Find a file or a folder
		LISTBOX SELECT ROW:C912(*; "choice"; 5; lk replace selection:K53:1)
		This:C1470.selected:=5
		
	Else 
		
		// Get the raw text
		This:C1470.original:=Get text from pasteboard:C524
		
		_o_Preferences("Get_Value"; "specialPasteChoice"; ->$selected)
		This:C1470.selected:=Choose:C955(($selected>This:C1470.target.length) | ($selected<=0); 1; $selected)
		
	End if 
	
	LISTBOX SELECT ROW:C912(*; "choice"; This:C1470.selected; lk replace selection:K53:1)
	
	_o_Preferences("Get_Value"; "specialPasteOptions"; ->$options)
	This:C1470.options:=$options
	
	OBJECT SET VALUE:C1742("option_2"; Num:C11($options ?? 10))
	OBJECT SET VALUE:C1742("option_1"; Num:C11($options ?? 11))
	
	This:C1470.preview:=This:C1470.original
	
	This:C1470.refresh()
	
	//=========================================================================
Function update()
	
	SET TIMER:C645(0)
	
	If (This:C1470.currentTarget.options#Null:C1517)
		
		OBJECT SET TITLE:C194(*; "option_1"; Localized string:C991(This:C1470.currentTarget.options["1"]))
		OBJECT SET ENABLED:C1123(*; "option_1"; True:C214)
		
		OBJECT SET TITLE:C194(*; "option_2"; Localized string:C991(This:C1470.currentTarget.options["2"]))
		OBJECT SET ENABLED:C1123(*; "option_2"; True:C214)
		
	Else 
		
		OBJECT SET ENABLED:C1123(*; "option_1"; False:C215)
		OBJECT SET ENABLED:C1123(*; "option_2"; False:C215)
		
	End if 
	
	This:C1470.preview:=This:C1470[This:C1470.currentTarget.transform]()
	
	//=========================================================================
Function validate()
	
	This:C1470.update()
	
	ACCEPT:C269
	
	//=========================================================================
Function string($text : Text) : Text
	
	$text:=Count parameters:C259>0 ? $text : This:C1470.original
	
	$text:=Replace string:C233($text; "\\"; "\\"*2)
	$text:=Replace string:C233($text; Char:C90(Double quote:K15:41); "\\\"")
	$text:=Replace string:C233($text; Char:C90(Carriage return:K15:38); "\\r")
	$text:=Replace string:C233($text; Char:C90(Line feed:K15:40); "\\n")
	$text:=Replace string:C233($text; Char:C90(Tab:K15:37); "\\t")
	
	return "\""+Replace string:C233(str_hyphenation($text; This:C1470.columns; "\\\r+"); "\\\r+"; "\"\\\r+\"")+"\""
	
	//=========================================================================
Function comments() : Text
	
	var $text; $t : Text
	var $i : Integer
	var $c : Collection
	
	$t:=Replace string:C233(This:C1470.original; "\t"; "")
	
	If (This:C1470.options ?? 10)  // Ignore blank lines
		
		$c:=Split string:C1554($t; "\r"; sk ignore empty strings:K86:1)
		
	Else 
		
		$c:=Split string:C1554($t; "\r")
		
	End if 
	
	If ($c.length>1)
		
		$text:="/*\r"+$c.join("\r")+"\r*/"
		
	Else 
		
		For each ($t; $c)
			
			If (This:C1470.options ?? 11)  // Delete indentation
				
				$c[$i]:=Replace string:C233($t; "\t"; "")
				
			Else 
				
				$c[$i]:=Replace string:C233($t; "\t"; "    ")
				
			End if 
			
			If (This:C1470.options ?? 10)  // Ignore blank lines
				
				If (Length:C16($t)#0)
					
					$text+=kCommentMark+str_hyphenation($t; This:C1470.columns; "\r"+kCommentMark)+"\r"
					
				End if 
				
			Else 
				
				$text+=kCommentMark+str_hyphenation($t; This:C1470.columns; "\r"+kCommentMark)+"\r"
				
			End if 
			
			$i+=1
			
		End for each 
	End if 
	
	return $text
	
	//=========================================================================
Function htmlCode() : Text
	
	var $i : Integer
	
	var $t : Text
	
	$t:=Replace string:C233(This:C1470.original; "\r\n"; "\r")
	$t:=Replace string:C233($t; "\n"; "\r")
	
	var $c : Collection:=Split string:C1554($t; "\r"; sk trim spaces:K86:2)
	
	var $text : Text:="$htmlCode:="
	
	For each ($t; $c)
		
		$i+=1
		
		$t:=Replace string:C233($t; "\\"; "\\"*2)
		$t:=Replace string:C233($t; "\""; "\\\"")
		
		// Delete indentation (optional)
		$t:=Replace string:C233($t; "\t"; This:C1470.options ?? 11 ? "" : "    ")
		
		If (This:C1470.options ?? 10)
			
			If (Length:C16($t)#0)
				
				$text+=($i=1 ? "" : "\\\r+\"")+$t+"\""
				
			End if 
			
		Else 
			
			$text+=($i=1 ? "" : "\\\r+\"")+$t+"\""
			
		End if 
	End for each 
	
	return $text
	
	//=========================================================================
Function htmlExpression() : Text
	
	var $text : Text:="$4DTEXT(This.original)"
	
	var $x : Blob
	TEXT TO BLOB:C554($text; $x; Mac text without length:K22:10)
	PROCESS 4D TAGS:C816($x; $x)
	
	return This:C1470.string(BLOB to text:C555($x; Mac text without length:K22:10))
	
	//=========================================================================
Function patternRegex()->$converted : Text
	
	// To use a literal backslash in a pattern, precede it with a backslash ("\\").
	$converted:=Replace string:C233(This:C1470.original; Char:C90(92); Char:C90(92)*2)
	
	// The backslash character  followed by a special character, it takes away any special meaning that character may have.
	// This use of backslash as an escape character applies both inside and outside character classes.
	// This escaping enables the usage of characters like *, +, (, { as literals in a pattern.
	$converted:=Replace string:C233($converted; "*"; "\\*")
	$converted:=Replace string:C233($converted; "+"; "\\+")
	$converted:=Replace string:C233($converted; "("; "\\(")
	$converted:=Replace string:C233($converted; ")"; "\\)")
	$converted:=Replace string:C233($converted; "{"; "\\{")
	$converted:=Replace string:C233($converted; "}"; "\\}")
	
	$converted:=Replace string:C233($converted; Char:C90(Space:K15:42); "\\s")
	$converted:=Replace string:C233($converted; Char:C90(Carriage return:K15:38); "\\r")
	$converted:=Replace string:C233($converted; Char:C90(Line feed:K15:40); "\\n")
	$converted:=Replace string:C233($converted; Char:C90(Tab:K15:37); "\\t")
	$converted:=Replace string:C233($converted; " "; "\\xCA")
	
	If ($converted[[1]]#"\"")
		
		$converted:="\""+$converted
		
	End if 
	
	If ($converted[[Length:C16($converted)]]#"\"")
		
		$converted:=$converted+"\""
		
	End if 
	
	//=========================================================================
Function pathname()->$converted : Text
	
	var $pathname : Text
	var $file; $folder : Object
	
	$pathname:=Get file from pasteboard:C976(1)
	
	If (Length:C16($pathname)>0)
		
		$file:=File:C1566($pathname; fk platform path:K87:2)
		$folder:=Folder:C1567(Folder:C1567(fk resources folder:K87:11; *).platformPath; fk platform path:K87:2)
		
		If (This:C1470.options ?? 10)  // POSIX
			
			$pathname:=$file.path
			
		End if 
		
		If (This:C1470.options ?? 11)  // Relative
			
			If (Position:C15($folder.path; $pathname; *)=1)
				
				$pathname:="/RESOURCES/"+Delete string:C232($pathname; 1; Length:C16($folder.path))
				
			End if 
		End if 
		
		$converted:="\""+$pathname+"\""
		
	End if 
	
	//=========================================================================
Function insertInText()->$converted : Text
	
	If (Length:C16(This:C1470.original)>0)
		
		$converted:="\"+"+This:C1470.original+"+\""
		
	End if 
	
	//=========================================================================
Function jsonCode()->$converted : Text
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.original="[@")\
			 & (This:C1470.original="@]")
			
			$converted:=codeForCollection(JSON Parse:C1218(This:C1470.original))
			
			//______________________________________________________
		: (This:C1470.original="{@")\
			 & (This:C1470.original="@}")
			
			$converted:=codeForObject(JSON Parse:C1218(This:C1470.original))
			
			//______________________________________________________
		Else 
			
			$converted:=This:C1470.original
			
			//______________________________________________________
	End case 
	
	//=========================================================================
Function tokenized()->$converted : Text
	
	var $t : Text
	var $c : Collection
	
	If (Length:C16(This:C1470.original)>0)
		
		$c:=Split string:C1554(This:C1470.original; "\r")
		
		For each ($t; $c)
			
			If (Length:C16($t)>0)
				
				$converted:=$converted+"\r"+Parse formula:C1576($t; Formula out with tokens:K88:3)
				
			End if 
		End for each 
		
		// Remove first carriage return
		$converted:=This:C1470.string(Delete string:C232($converted; 1; 1))
		
	End if 
	
	//=========================================================================
Function toUTF8()->$converted : Text
	
	var $x : Blob
	
	If (Length:C16(This:C1470.original)>0)
		
		$converted:=Replace string:C233(This:C1470.original; "\\"; "")
		CONVERT FROM TEXT:C1011($converted; "UTF-8"; $x)
		$converted:=This:C1470.string(BLOB to text:C555($x; Mac text without length:K22:10))
		
	End if 
	
	//=========================================================================
Function fromUTF8()->$converted : Text
	
	var $x : Blob
	
	If (Length:C16(This:C1470.original)>0)
		
		$converted:=Replace string:C233(This:C1470.original; "\\"; "")
		TEXT TO BLOB:C554($converted; $x; Mac text without length:K22:10)
		$converted:=This:C1470.string(Convert to text:C1012($x; "UTF-8"))
		
	End if 