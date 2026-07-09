property data : Object

// 4D language syntax store (shared singleton — cs.syntax.me).
// Loaded and parsed ONCE per 4D session from the canonical English syntax file
// (…/Resources/en.lproj/syntaxEN.json), which never changes during a session.
// It provides:
//   • the return type and first-parameter type of every global command,
//   • the return type of every class attribute / function.
// These are used by the declaration macro's "clairvoyance" to guess the type of
// undeclared variables.
// In the JSON, both the command names AND the type strings are always in English
// (only the descriptions are localized), so the English file is the canonical
// source whatever the current 4D language. Command names written in English and
// every class attribute / function therefore resolve; French command names (used
// only when 4D runs with the legacy "regional system settings" option) do not and
// simply fall back to the declaration dialog, as before when gram.4dsyntax failed.

shared singleton Class constructor()
	
	var $data : Object:={commands: {}; members: {}; memberClass: {}; memberReturnClass: {}; classNames: []}
	
	// Accumulators for member class inference: owner classes and return-type strings
	var $owners : Object:={}
	var $retstr : Object:={}
	var $classSet : Object:={}  // set of every concrete class name (for the dialog picker)
	
	var $file : 4D:C1709.File:=This:C1470._syntaxFile()
	
	If ($file.exists)
		
		var $json : Object:=JSON Parse:C1218($file.getText())
		
		// Global commands: return type + first parameter type, keyed by lowercased name
		var $name : Text
		For each ($name; $json._command_)
			
			var $entry : Object:=$json._command_[$name]
			$data.commands[Lowercase:C14($name)]:={\
				ret: This:C1470._returnType($entry); \
				params: This:C1470._paramTypes($entry)}
			
		End for each 
		
		// Class attributes & functions (always named in English): return type, keyed
		// by lowercased name. A member name may exist on several classes; when the
		// guessed types differ, it is marked ambiguous (0 → no guess).
		var $namespace : Text
		For each ($namespace; $json)
			
			If (($namespace="_command_") || ($namespace="4D"))
				
				continue  // command registry / class registry, not members
				
			End if 
			
			var $members : Object:=$json[$namespace]
			
			If (Value type:C1509($members)#Is object:K8:27)
				
				continue
				
			End if 
			
			$classSet[This:C1470._concreteClass($namespace)]:=True:C214  // register the class name
			
			var $member : Text
			For each ($member; $members)
				
				If (Value type:C1509($members[$member])#Is object:K8:27)
					
					continue  // e.g. "_inheritedFrom_" : "Document"
					
				End if 
				
				var $key : Text:=Lowercase:C14(Replace string:C233($member; "()"; ""))
				var $type : Integer:=This:C1470._returnType($members[$member])
				
				// Accumulate the owner class and the return-type string (class inference)
				var $concrete : Text:=This:C1470._concreteClass($namespace)
				If ($owners[$key]=Null:C1517)
					$owners[$key]:=[]
				End if 
				If ($owners[$key].indexOf($concrete)<0)
					$owners[$key].push($concrete)
				End if 
				var $rs : Text:=This:C1470._returnTypeString($members[$member])
				If ($retstr[$key]=Null:C1517)
					$retstr[$key]:=[]
				End if 
				If ($retstr[$key].indexOf($rs)<0)
					$retstr[$key].push($rs)
				End if 
				
				Case of 
						
						//______________________________________________________
					: ($data.members[$key]=Null:C1517)
						
						$data.members[$key]:=$type
						
						//______________________________________________________
					: ($data.members[$key]#$type)
						
						$data.members[$key]:=0  // ambiguous across classes → no guess
						
						//______________________________________________________
				End case 
				
			End for each 
		End for each 
		
		// Resolve the accumulators into a receiver class and a return class per member
		var $mkey : Text
		For each ($mkey; $owners)
			$data.memberClass[$mkey]:=This:C1470._receiverClass($owners[$mkey])
		End for each 
		For each ($mkey; $retstr)
			$data.memberReturnClass[$mkey]:=This:C1470._returnClass($retstr[$mkey])
		End for each 
		
		$data.classNames:=OB Keys:C1719($classSet).sort()
	End if 
	
	This:C1470.data:=OB Copy:C1225($data; ck shared:K85:29)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the 4D type constant a variable would get from a single line of code,
	// or 0 when nothing can be inferred from the syntax file. Handled patterns:
	//   $var := <command>(…)          → command return type
	//   $var := <4D|cs>.…             → object (class instance)
	//   $var := <expr>.<member>(…)    → member (function) return type
	//   $var := <expr>.<member>       → member (attribute) return type
	//   <command>( … ; $var ; … )     → type of the matching parameter (any position)
Function guessType($var : Text; $line : Text) : Integer
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	var $esc : Text:="\\"+$var  // the token starts with "$" → escape it for the regex
	
	// Assignment to $var → infer from the right-hand side
	If (Match regex:C1019("(?m-si)"+$esc+"\\s*:=\\s*(.+)$"; $line; 1; $pos; $len))
		
		var $rhs : Text:=Substring:C12($line; $pos{1}; $len{1})
		
		// Class instance: 4D.xxx(…) or cs.xxx(…) → object
		If (Match regex:C1019("(?m-si)^(?:4D|cs)\\."; $rhs; 1))
			
			return Is object:K8:27
			
		End if 
		
		// Command call or bare command at the start of the right-hand side
		var $type : Integer:=This:C1470.commandReturnType(This:C1470._leadingName($rhs))
		
		If ($type#0)
			
			return $type
			
		End if 
		
		// Member access on the right-hand side: ….member(  or  ….member (end of line)
		If (Match regex:C1019("(?m-si)\\.([A-Za-z]\\w*)\\s*(?:\\(|$)"; $rhs; 1; $pos; $len))
			
			return This:C1470.memberReturnType(Substring:C12($rhs; $pos{1}; $len{1}))
			
		End if 
		
		return 0
		
	End if 
	
	// $var used as an argument of a command → type of the parameter at that position
	If (Match regex:C1019("(?m-si)([A-Za-zÀ-ÿ][A-Za-zÀ-ÿ0-9 ]*?)\\s*\\(([^()]*?)"+$esc+"\\b"; $line; 1; $pos; $len))
		
		var $command : Text:=This:C1470._trim(Substring:C12($line; $pos{1}; $len{1}))
		
		return This:C1470.commandParamType($command; This:C1470._argIndex(Substring:C12($line; $pos{2}; $len{2})))
		
	End if 
	
	return 0
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return type of a command (0 if unknown)
Function commandReturnType($name : Text) : Integer
	
	return Num:C11(This:C1470.data.commands[Lowercase:C14($name)].ret)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Type of the argument at position $index (0-based) of a command (0 if unknown)
Function commandParamType($name : Text; $index : Integer) : Integer
	
	var $params : Collection:=This:C1470.data.commands[Lowercase:C14($name)].params
	
	If (($params=Null:C1517) || ($index<0) || ($index>=$params.length))
		
		return 0
		
	End if 
	
	return Num:C11($params[$index])
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// 0-based position of an argument, given the (parenthesis-free) text that precedes
	// it inside the call; string literals are stripped so their ";" don't miscount
Function _argIndex($before : Text) : Integer
	
	var $clean : Text:=""
	var $c : Collection:=Split string:C1554($before; Char:C90(Double quote:K21:8))
	var $i : Integer
	
	For ($i; 0; $c.length-1; 2)
		
		$clean+=$c[$i]
		
	End for 
	
	return Length:C16($clean)-Length:C16(Replace string:C233($clean; ";"; ""))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return type of a class attribute or function (0 if unknown or ambiguous)
Function memberReturnType($name : Text) : Integer
	
	return Num:C11(This:C1470.data.members[Lowercase:C14($name)])
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Best-guess class of the RECEIVER of a member (e.g. ".getText" → "4D.File",
	// ".length" → "Collection"); "" when the member is too generic or ambiguous
Function memberReceiverClass($name : Text) : Text
	
	return String:C10(This:C1470.data.memberClass[Lowercase:C14($name)])
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Class of a member's return value when unambiguous (e.g. ".file" → "4D.File"); "" otherwise
Function memberReturnClass($name : Text) : Text
	
	return String:C10(This:C1470.data.memberReturnClass[Lowercase:C14($name)])
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sorted list of every 4D class name found in the syntax file (for the picker)
Function classNames() : Collection
	
	return This:C1470.data.classNames.copy()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Maps a JSON namespace to the concrete 4D class used in declarations
Function _concreteClass($namespace : Text) : Text
	
	Case of 
			
			//______________________________________________________
		: ($namespace="Document")
			
			return "4D.File"  // abstract base of 4D.File
			
			//______________________________________________________
		: ($namespace="Directory")
			
			return "4D.Folder"  // abstract base of 4D.Folder
			
			//______________________________________________________
		: ($namespace="Collection")
			
			return "Collection"  // native type
			
			//______________________________________________________
		: ($namespace="Object")
			
			return "Object"  // native type
			
			//______________________________________________________
		Else 
			
			return "4D."+$namespace
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Best-guess receiver class from the owner classes of a member: ignored when the
	// member belongs to more than three classes (too generic); otherwise resolved by
	// priority
Function _receiverClass($owners : Collection) : Text
	
	var $o : Collection:=$owners.distinct()
	
	Case of 
			
			//______________________________________________________
		: ($o.length=0) || ($o.length>3)
			
			return ""
			
			//______________________________________________________
		: ($o.length=1)
			
			return $o[0]
			
			//______________________________________________________
	End case 
	
	var $priority : Collection:=["Collection"; "4D.File"; "4D.Folder"; "4D.Entity"; "4D.EntitySelection"; "Object"; "4D.Blob"]
	var $p : Text
	For each ($p; $priority)
		
		If ($o.indexOf($p)>=0)
			
			return $p
			
		End if 
	End for each 
	
	return ""
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Class of a member's return value when ALL definitions return the same class and
	// none returns a non-class value; "" otherwise
Function _returnClass($strings : Collection) : Text
	
	var $classes : Collection:=[]
	var $hasNonClass : Boolean:=False:C215
	
	var $s : Text
	For each ($s; $strings)
		
		Case of 
				
				//______________________________________________________
			: (Length:C16($s)=0)
				
				// ignore
				
				//______________________________________________________
			: (Position:C15("."; $s)>0)
				
				If ($classes.indexOf($s)<0)
					
					$classes.push($s)
					
				End if 
				
				//______________________________________________________
			Else 
				
				$hasNonClass:=True:C214
				
				//______________________________________________________
		End case 
	End for each 
	
	return (($classes.length=1) && Not:C34($hasNonClass)) ? $classes[0] : ""
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// First "type" token (word/dot characters) of a text, e.g. "4D.File" or "Real"
Function _firstToken($text : Text) : Text
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("([\\w.]+)"; $text; 1; $pos; $len))
		
		return Substring:C12($text; $pos{1}; $len{1})
		
	End if 
	
	return ""
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Raw return-type string of a member entry (keeps class paths like "4D.File")
Function _returnTypeString($entry : Object) : Text
	
	If ($entry.Params#Null:C1517)
		
		var $row : Collection
		For each ($row; $entry.Params)
			
			var $label : Text:=Lowercase:C14(String:C10($row[0]))
			
			If (($label="function result") || ($label="result") || ($label="résultat"))
				
				return This:C1470._firstToken(String:C10($row[1]))
				
			End if 
		End for each 
	End if 
	
	var $syntax : Text:=Split string:C1554(String:C10($entry.Syntax); "<br/>")[0]
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("(?m-si):\\s*([\\w.]+)\\s*$"; $syntax; 1; $pos; $len))
		
		return This:C1470._firstToken(Substring:C12($syntax; $pos{1}; $len{1}))
		
	End if 
	
	return ""
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// The canonical (English) syntax file inside the running 4D application
Function _syntaxFile() : 4D:C1709.File
	
	var $rel : Text:="en.lproj/syntaxEN.json"
	
	return Is macOS:C1572\
		 ? Folder:C1567(Application file:C491; fk platform path:K87:2).file("Contents/Resources/"+$rel)\
		 : File:C1566(Application file:C491; fk platform path:K87:2).parent.file("Resources/"+$rel)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return type of a command / member entry, from its "Params" result row or,
	// failing that, from the trailing type of its "Syntax" signature
Function _returnType($entry : Object) : Integer
	
	If ($entry.Params#Null:C1517)
		
		var $row : Collection
		For each ($row; $entry.Params)
			
			var $label : Text:=Lowercase:C14(String:C10($row[0]))
			
			If (($label="function result") || ($label="result") || ($label="résultat"))
				
				return This:C1470._const(String:C10($row[1]))
				
			End if 
		End for each 
	End if 
	
	// No explicit result row → parse the trailing type of the first syntax variant
	var $syntax : Text:=Split string:C1554(String:C10($entry.Syntax); "<br/>")[0]
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("(?m-si):\\s*([\\w.]+)\\s*$"; $syntax; 1; $pos; $len))
		
		return This:C1470._const(Substring:C12($syntax; $pos{1}; $len{1}))
		
	End if 
	
	return 0
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Ordered list of the argument types of a command entry (skips the result row;
	// the "*" operator keeps its slot as 0 to preserve positional alignment)
Function _paramTypes($entry : Object) : Collection
	
	var $types : Collection:=[]
	
	If ($entry.Params=Null:C1517)
		
		return $types
		
	End if 
	
	var $row : Collection
	For each ($row; $entry.Params)
		
		var $label : Text:=Lowercase:C14(String:C10($row[0]))
		
		If (($label="function result") || ($label="result") || ($label="résultat"))
			
			continue  // the return type, not an argument
			
		End if 
		
		$types.push(This:C1470._const(String:C10($row[1])))  // "*" operator → 0
		
	End for each 
	
	return $types
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Maps a JSON type string to a 4D type constant (0 = no usable type)
Function _const($type : Text) : Integer
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	// Keep the first type token ("Real, Undefined", "Integer )", "4D.File"…).
	// The token may start with a digit, e.g. "4D.Blob", so allow any word character.
	If (Match regex:C1019("(?m-si)([\\w][\\w.]*)"; $type; 1; $pos; $len))
		
		$type:=Substring:C12($type; $pos{1}; $len{1})
		
	Else 
		
		return 0
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: (Position:C15("."; $type)>0)  // 4D.xxx / cs.xxx class instance → object
			
			return Is object:K8:27
			
			//______________________________________________________
		: ($type="Text")
			
			return Is text:K8:3
			
			//______________________________________________________
		: ($type="Integer")
			
			return Is longint:K8:6
			
			//______________________________________________________
		: ($type="Real") || ($type="Number")
			
			return Is real:K8:4
			
			//______________________________________________________
		: ($type="Boolean")
			
			return Is boolean:K8:9
			
			//______________________________________________________
		: ($type="Object")
			
			return Is object:K8:27
			
			//______________________________________________________
		: ($type="Collection")
			
			return Is collection:K8:32
			
			//______________________________________________________
		: ($type="Time")
			
			return Is time:K8:8
			
			//______________________________________________________
		: ($type="Date")
			
			return Is date:K8:7
			
			//______________________________________________________
		: ($type="Picture")
			
			return Is picture:K8:10
			
			//______________________________________________________
		: ($type="Pointer")
			
			return Is pointer:K8:14
			
			//______________________________________________________
		: ($type="Blob")
			
			return Is BLOB:K8:12
			
			//______________________________________________________
		: ($type="Variant")
			
			return Is variant:K8:33
			
			//______________________________________________________
		Else   // any, Expression, Table, Field, Variable, Array, Operator, Null…
			
			return 0
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Leading command-name candidate at the start of an expression (letters, digits
	// and spaces, up to the first "(", operator, "." or end)
Function _leadingName($text : Text) : Text
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("(?m-si)^([A-Za-zÀ-ÿ][A-Za-zÀ-ÿ0-9 ]*?)\\s*(?:\\(|$|[^A-Za-zÀ-ÿ0-9 (])"; $text; 1; $pos; $len))
		
		return This:C1470._trim(Substring:C12($text; $pos{1}; $len{1}))
		
	End if 
	
	return ""
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Trims leading and trailing spaces (the Trim command is unavailable before 21R3)
Function _trim($text : Text) : Text
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("(?m-si)^\\s*(.*?)\\s*$"; $text; 1; $pos; $len))
		
		return Substring:C12($text; $pos{1}; $len{1})
		
	End if 
	
	return $text
	