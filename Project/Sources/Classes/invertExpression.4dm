Class extends macro

// Inverts 4D expressions in the current selection.
// Modern rewrite of the legacy recursive method INVERT_EXPRESSION:
//  • no more shared interprocess array (M_4DPop_tTxt_Buffer): tokens live in a local collection
//  • no more recursion: the "builder" is a plain function (_build) fed with the tokens
//  • the command-inversion table is data-driven (This.rules)

property rules : Object:={}

Class constructor()
	
	Super:C1705()
	
	This:C1470._buildRules()
	This:C1470._process()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Process the highlighted text line by line and paste the inverted result
Function _process()
	
	var $lines : Collection:=Split string:C1554(This:C1470.highlighted; "\r"; sk trim spaces:K86:2)
	var $out : Collection:=[]
	var $line : Text
	
	For each ($line; $lines)
		
		$out.push(This:C1470._invertLine($line))
		
	End for each 
	
	This:C1470.setHighlightedText($out.join("\r")+kCaret)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Invert a single line of code and return the resulting text
Function _invertLine($line : Text) : Text
	
	var $assignee; $command; $rest; $comment : Text
	var $position : Integer
	var $tokens : Collection:=[]
	
	// Split the assignment (left-hand side / right-hand side)
	$position:=Position:C15(":="; $line)
	
	If ($position>0)
		
		$assignee:=Substring:C12($line; 1; $position-1)
		$rest:=Substring:C12($line; $position+2)
		
	Else 
		
		$assignee:=""
		$rest:=$line
		
	End if 
	
	// Split the command name from its arguments
	$position:=Position:C15("("; $rest)
	
	If ($position>0)
		
		$command:=Substring:C12($rest; 1; $position-1)
		$rest:=Substring:C12($rest; $position+1)
		
	Else 
		
		$command:=$rest
		$rest:=""
		
	End if 
	
	// tokens{0} = assignee, tokens{1..n} = arguments, tokens{last} = trailing comment
	$tokens.push($assignee)
	$comment:=""
	
	If (Length:C16($rest)#0)
		
		// Peel off any trailing comment located after the closing parenthesis
		While (($rest#"") & ($rest[[Length:C16($rest)]]#")"))
			
			$comment:=$rest[[Length:C16($rest)]]+$comment
			$rest:=Substring:C12($rest; 1; Length:C16($rest)-1)
			
		End while 
		
		If (Length:C16($rest)#0)
			
			// Remove the closing parenthesis, then split the arguments
			$rest:=Substring:C12($rest; 1; Length:C16($rest)-1)
			
			While (Length:C16($rest)#0)
				
				$position:=Position:C15(";"; $rest)
				
				If ($position>0)
					
					$tokens.push(Substring:C12($rest; 1; $position-1))
					$rest:=Substring:C12($rest; $position+1)
					
				Else 
					
					$tokens.push($rest)
					$rest:=""
					
				End if 
			End while 
		End if 
	End if 
	
	// The comment is always the last token (also fixes the True/False trailing residue)
	$tokens.push($comment)
	
	// Known command: rebuild the inverted expression
	var $rule : Object:=This:C1470._rule($command; $tokens)
	
	If ($rule#Null:C1517)
		
		return This:C1470._build($tokens; $rule.assignee; $rule.command; $rule.order)
		
	End if 
	
	// Simple assignment A:=B where B is assignable → invert into B:=A
	If (($assignee#"") & (This:C1470._isAssignable($command)))
		
		return This:C1470._trim($command)+":="+This:C1470._trim($assignee)
		
	End if 
	
	// Otherwise leave the line untouched
	return $line
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return the inversion rule for a command name (or Null if none)
Function _rule($command : Text; $tokens : Collection) : Object
	
	// SELECTION TO ARRAY needs a runtime decision based on its first argument
	If ($command=Command name:C538(260))
		
		var $arg : Text:=($tokens.length>1) ? String:C10($tokens[1]) : ""
		var $order : Collection
		
		If (Position:C15("]"; $arg)=Length:C16($arg))
			
			$order:=[-3]
			
		Else 
			
			$order:=[-1]
			
		End if 
		
		return {assignee: -1; command: 261; order: $order}
		
	End if 
	
	return This:C1470.rules[$command]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Rebuild an inverted expression from the parsed tokens
Function _build($tokens : Collection; $assignee : Integer; $command : Integer; $order : Collection) : Text
	
	var $result : Text:=""
	var $i; $start; $size : Integer
	
	If ($assignee#-1)
		
		$result:=String:C10($tokens[$assignee])+":="
		
	End if 
	
	$result:=$result+Command name:C538($command)
	
	If ($order.length>0)
		
		$result:=$result+"("
		
		Case of 
				
				//______________________________________________________
			: ($order[0]<0)  // Swap every argument pair, starting at Abs($order{0})
				
				$start:=Abs:C99($order[0])
				$size:=$tokens.length-1
				$size:=$size-Num:C11(($size%2)>0)
				
				For ($i; $start; $size; 2)
					
					$result:=$result+($i>$start ? ";" : "")
					$result:=$result+String:C10($tokens[$i+1])+";"+String:C10($tokens[$i])
					
				End for 
				
				//______________________________________________________
			Else 
				
				For ($i; 0; $order.length-1)
					
					If ($order[$i]<=($tokens.length-2))
						
						$result:=$result+($i>0 ? ";" : "")+String:C10($tokens[$order[$i]])
						
					Else 
						
						$result:=$result+($i>0 ? ";" : "")+"Parameter_"+String:C10($i+3)
						
					End if 
				End for 
				
				//______________________________________________________
		End case 
		
		$result:=$result+")"
		
	End if 
	
	// Append the trailing comment token
	$result:=$result+String:C10($tokens[$tokens.length-1])
	
	return $result
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// True when the operand is a simple, assignable reference (variable, field, element, property)
Function _isAssignable($operand : Text) : Boolean
	
	var $op : Text:=This:C1470._trim($operand)
	
	If (Not:C34(Match regex:C1019("^[$A-Za-z_\\[][\\w.\\[\\]{}$]*$"; $op; 1)))
		
		return False:C215
		
	End if 
	
	// Must clearly be a reference, not a bare word that could be a method or command
	return (Position:C15("$"; $op)>0) | (Position:C15("["; $op)=1) | (Position:C15("."; $op)>0) | (Position:C15("{"; $op)>0)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Remove leading and trailing spaces and tabs
Function _trim($text : Text) : Text
	
	var $t : Text:=$text
	var $tab : Text:=Char:C90(9)
	
	// "&&" is short-circuit: $t[[1]] is never evaluated when $t is empty
	While ((Length:C16($t)>0) && (($t[[1]]=" ") || ($t[[1]]=$tab)))
		
		$t:=Substring:C12($t; 2)
		
	End while 
	
	While ((Length:C16($t)>0) && (($t[[Length:C16($t)]]=" ") || ($t[[Length:C16($t)]]=$tab)))
		
		$t:=Substring:C12($t; 1; Length:C16($t)-1)
		
	End while 
	
	return $t
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Build the data-driven command inversion table
Function _buildRules()
	
	var $spec : Collection:=[\
	{from: 10; command: 11; assignee: 1; order: [0]}; \
	{from: 11; command: 10; assignee: 1; order: [0]}; \
	{from: 52; command: 212; assignee: -1; order: [1]}; \
	{from: 212; command: 52; assignee: -1; order: [1]}; \
	{from: 76; command: 77; assignee: -1; order: [1]}; \
	{from: 77; command: 76; assignee: -1; order: [1]}; \
	{from: 78; command: 79; assignee: -1; order: [1]}; \
	{from: 79; command: 78; assignee: -1; order: [1]}; \
	{from: 80; command: 81; assignee: -1; order: [1]}; \
	{from: 81; command: 80; assignee: -1; order: [1]}; \
	{from: 90; command: 91; assignee: 1; order: [0]}; \
	{from: 91; command: 90; assignee: 1; order: [0]}; \
	{from: 119; command: 561; assignee: -1; order: [1; 2]}; \
	{from: 561; command: 119; assignee: -1; order: [1; 2]}; \
	{from: 145; command: 146; assignee: -1; order: [1]}; \
	{from: 146; command: 145; assignee: -1; order: [1]}; \
	{from: 214; command: 215; assignee: 0; order: []}; \
	{from: 215; command: 214; assignee: 0; order: []}; \
	{from: 261; command: 260; assignee: -1; order: [-1]}; \
	{from: 287; command: 288; assignee: -1; order: [2; 1; 3]}; \
	{from: 288; command: 287; assignee: -1; order: [2; 1; 3]}; \
	{from: 433; command: 434; assignee: -1; order: []}; \
	{from: 434; command: 433; assignee: -1; order: []}; \
	{from: 463; command: 464; assignee: 1; order: [0]}; \
	{from: 464; command: 463; assignee: 1; order: [0]}; \
	{from: 519; command: 520; assignee: 1; order: [0]}; \
	{from: 520; command: 463; assignee: 1; order: [0]}; \
	{from: 523; command: 524; assignee: 1; order: []}; \
	{from: 524; command: 523; assignee: -1; order: [0]}; \
	{from: 525; command: 526; assignee: -1; order: [1; 2; 3]}; \
	{from: 526; command: 525; assignee: -1; order: [1; 2; 3]}; \
	{from: 532; command: 533; assignee: -1; order: [2; 1; 3]}; \
	{from: 533; command: 532; assignee: -1; order: [2; 1; 3]}; \
	{from: 534; command: 535; assignee: -1; order: [1]}; \
	{from: 535; command: 534; assignee: -1; order: [1]}; \
	{from: 548; command: 549; assignee: 1; order: [2; 3; 4]}; \
	{from: 549; command: 548; assignee: -1; order: [0; 1; 2; 3]}; \
	{from: 550; command: 551; assignee: 1; order: [2; 3; 4]}; \
	{from: 551; command: 550; assignee: -1; order: [0; 1; 2; 3]}; \
	{from: 552; command: 553; assignee: 1; order: [2; 3; 4]}; \
	{from: 553; command: 552; assignee: -1; order: [0; 1; 2; 3]}; \
	{from: 554; command: 555; assignee: 1; order: [2; 3; 4]}; \
	{from: 555; command: 554; assignee: -1; order: [0; 1; 2; 3]}; \
	{from: 556; command: 557; assignee: 2; order: [1]}; \
	{from: 557; command: 556; assignee: -1; order: [1; 0]}; \
	{from: 559; command: 560; assignee: -1; order: [1; 2; 3]}; \
	{from: 560; command: 559; assignee: -1; order: [1; 2; 3]}; \
	{from: 565; command: 566; assignee: -1; order: [2; 1]}; \
	{from: 566; command: 565; assignee: -1; order: [2; 1]}; \
	{from: 605; command: 606; assignee: -1; order: [1; 0]}; \
	{from: 606; command: 605; assignee: 1; order: [2]}; \
	{from: 678; command: 680; assignee: -1; order: [1; 2; MAXLONG:K35:2]}; \
	{from: 680; command: 678; assignee: -1; order: [1; 2]}; \
	{from: 682; command: 692; assignee: -1; order: [2; 1; MAXLONG:K35:2]}; \
	{from: 692; command: 682; assignee: -1; order: [2; 1]}; \
	{from: 689; command: 690; assignee: -1; order: [1; 2; 3]}; \
	{from: 690; command: 689; assignee: -1; order: [1; 2; 3]}\
	]
	
	var $entry : Object
	
	For each ($entry; $spec)
		
		This:C1470.rules[Command name:C538($entry.from)]:=$entry
		
	End for each 
