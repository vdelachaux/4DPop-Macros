property data : Object

// Regex patterns store (shared singleton — cs.patterns.me).
// Loaded ONCE per 4D session from the /RESOURCES/regex/ folder.
// Each *.txt file becomes a group named after the file (without extension); each
// line is "<key><TAB><raw regex>". Patterns are written WITHOUT 4D escaping, which
// keeps them readable and easy to maintain.

shared singleton Class constructor()
	
	var $data : Object:={}
	
	var $folder : 4D:C1709.Folder:=Folder:C1567("/RESOURCES/regex")
	
	If ($folder.exists)
		
		var $file : 4D:C1709.File
		For each ($file; $folder.files())
			
			If ($file.extension=".txt")
				
				$data[$file.name]:=This:C1470._parse($file.getText())
				
			End if 
		End for each 
	End if 
	
	This:C1470.data:=OB Copy:C1225($data; ck shared:K85:29)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the patterns of a group (e.g. "macro") as an object {key: pattern}
Function group($name : Text) : Object
	
	return This:C1470.data[$name]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Parses a "<key><TAB><raw regex>" resource text into an object
Function _parse($text : Text) : Object
	
	var $o : Object:={}
	var $line; $key : Text
	var $tab : Integer
	
	For each ($line; Split string:C1554($text; "\n"))
		
		$line:=Replace string:C233($line; "\r"; "")
		
		If ((Length:C16($line)=0) || (Position:C15("#"; $line)=1))
			
			continue
			
		End if 
		
		$tab:=Position:C15("\t"; $line)
		
		If ($tab>0)
			
			$key:=Substring:C12($line; 1; $tab-1)
			$o[$key]:=Substring:C12($line; $tab+1)
			
		End if 
	End for each 
	
	return $o
