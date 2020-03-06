//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : str
  // ID[69A5F0B04405480CA4218A430C3322D9]
  // Created 14-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BLOB:C604($x)
C_BOOLEAN:C305($b)
C_LONGINT:C283($i;$l;$length;$position)
C_TEXT:C284($t;$tFiltered;$tPattern;$tResult;$tSeparator;$tt)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c;$c1)

ARRAY TEXT:C222($tTxt_keywords;0)

If (False:C215)
	C_OBJECT:C1216(str ;$0)
	C_TEXT:C284(str ;$1)
	C_OBJECT:C1216(str ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)
	
	If (Count parameters:C259>=1)
		
		$t:=$1
		
	End if 
	
	$o:=New object:C1471(\
		"";"str";\
		"length";Length:C16($t);\
		"value";$t;\
		"base64";Formula:C1597(str ("base64").value);\
		"common";Formula:C1597(str ("common";New object:C1471("with";$1;"diacritical";Bool:C1537($2))).value);\
		"concat";Formula:C1597(str ("concat";New object:C1471("item";$1;"separator";$2)).value);\
		"contains";Formula:C1597(str ("contains";New object:C1471("pattern";String:C10($1);"diacritical";Bool:C1537($2))).value);\
		"distinctLetters";Formula:C1597(str ("distinctLetters";New object:C1471("delimiter";$1)).value);\
		"equal";Formula:C1597(str ("equal";New object:C1471("with";$1)).value);\
		"fixedLength";Formula:C1597(str ("fixedLength";New object:C1471("length";$1;"filler";$2;"alignment";$3)).value);\
		"hyphenation";Formula:C1597(This:C1470.wordWrap($1));\
		"insert";Formula:C1597(str ("insert";New object:C1471("value";String:C10($1);"begin";Num:C11($2);"end";Num:C11($3))));\
		"isBoolean";Formula:C1597(str ("isBoolean").value);\
		"isDate";Formula:C1597(str ("isDate").value);\
		"isJson";Formula:C1597(Match regex:C1019("(?msi)^(?:\\{.*\\})|(?:\\[.*\\])$";This:C1470.value;1));\
		"isJsonArray";Formula:C1597(Match regex:C1019("(?msi)^\\[.*\\]$";This:C1470.value;1));\
		"isJsonObject";Formula:C1597(Match regex:C1019("(?msi)^\\{.*\\}$";This:C1470.value;1));\
		"isNum";Formula:C1597(str ("isNum").value);\
		"isStyled";Formula:C1597(str ("isStyled").value);\
		"isTime";Formula:C1597(str ("isTime").value);\
		"isUrl";Formula:C1597(str ("isUrl").value);\
		"localized";Formula:C1597(str ("localized";New object:C1471("substitution";$1)).value);\
		"lowerCamelCase";Formula:C1597(str ("lowerCamelCase").value);\
		"match";Formula:C1597(str ("match";New object:C1471("pattern";$1)).value);\
		"occurrences";Formula:C1597(Split string:C1554(This:C1470.value;String:C10($1);sk trim spaces:K86:2).length-1);\
		"quoted";Formula:C1597("\""+String:C10(This:C1470.value)+"\"");\
		"replace";Formula:C1597(str ("replace";New object:C1471("old";$1;"new";$2)).value);\
		"setText";Formula:C1597(str ("setText";New object:C1471("value";String:C10($1))));\
		"shuffle";Formula:C1597(str ("shuffle";New object:C1471("length";$1)).value);\
		"singleQuoted";Formula:C1597("'"+String:C10(This:C1470.value)+"'");\
		"spaceSeparated";Formula:C1597(str ("spaceSeparated").value);\
		"toNum";Formula:C1597(str ("filter";New object:C1471("as";"numeric")).value);\
		"trim";Formula:C1597(str ("trim";New object:C1471("pattern";$1)).value);\
		"trimLeading";Formula:C1597(str ("trimLeading";New object:C1471("pattern";$1)).value);\
		"trimTrailing";Formula:C1597(str ("trimTrailing";New object:C1471("pattern";$1)).value);\
		"truncate";Formula:C1597(str ("truncate";New object:C1471("maxChar";$1)).value);\
		"unaccented";Formula:C1597(str ("unaccented").value);\
		"uperCamelCase";Formula:C1597(str ("uperCamelCase").value);\
		"urlBase64Encode";Formula:C1597(str ("urlBase64Encode").value);\
		"urlDecode";Formula:C1597(str ("urlDecode").value);\
		"urlEncode";Formula:C1597(str ("urlEncode").value);\
		"wordWrap";Formula:C1597(str ("wordWrap";New object:C1471("length";$1)).value);\
		"xmlEncode";Formula:C1597(str ("xmlEncode").value);\
		"versionCompare";Formula:C1597(str ("versionCompare";New object:C1471("compareTo";String:C10($1);"separator";$2)).value)\
		)
	
Else 
	
	Case of 
			
			  //=======================================================================================================
		: (This:C1470=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //=======================================================================================================
		: ($1="setText")  // Defines the contents of the string & returns the updated object string
			
			$o:=This:C1470
			$o.value:=$2.value
			$o.length:=Length:C16($o.value)
			
			  //=======================================================================================================
		Else 
			
			$o:=New object:C1471(\
				"value";"")
			
			Case of 
					
					  //______________________________________________________
				: ($1="contains")  // Returns True if the passed text is present in the string (diacritical if $2 is True)
					
					If ($2.diacritical)
						
						  // Diacritical query
						$o.value:=(Position:C15($2.pattern;This:C1470.value;*)#0)
						
					Else 
						
						$o.value:=(Position:C15($2.pattern;This:C1470.value)#0)
						
					End if 
					
					  //______________________________________________________
				: ($1="shuffle")
					
					$tPattern:="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,?;.:/=+@#&([{§!)]}-_$€*`£"
					
					If (Length:C16(This:C1470.value)=0)
						
						$t:=$tPattern*2
						
					Else 
						
						For each ($tt;Split string:C1554(This:C1470.value;""))
							
							If (Position:C15($tt;$tPattern)>0)
								
								$t:=$t+$tt
								
							End if 
						End for each 
						
						$t:=$t*2
						
					End if 
					
					$l:=Num:C11($2.length)
					$length:=Choose:C955($l=0;Choose:C955(10>Length:C16($t);Length:C16($t);10);Choose:C955($l>Length:C16($t);Length:C16($t);$l))
					
					$l:=Length:C16($t)
					
					For ($i;1;$length;1)
						
						$o.value:=$o.value+$t[[(Random:C100%($l-1+1))+1]]
						
					End for 
					
					  //______________________________________________________
				: ($1="base64")  // Returns a base64 encoded UTF-8 string
					
					CONVERT FROM TEXT:C1011(This:C1470.value;"utf-8";$x)
					BASE64 ENCODE:C895($x;$t)
					
					$o.value:=$t
					
					  //______________________________________________________
				: ($1="urlBase64Encode")  // Returns an URL-safe base64url encoded UTF-8 string
					
					$t:=This:C1470.base64()
					
					$t:=Replace string:C233($t;"+";"-";*)
					$t:=Replace string:C233($t;"/";"_";*)
					$t:=Replace string:C233($t;"=";"";*)
					
					$o.value:=$t
					
					  //______________________________________________________
				: ($1="urlEncode")  // Returns an URL encoded string
					
					  // List of safe characters
					$t:="1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz:/.?_-$(){}~&@"
					
					If (This:C1470.length>0)
						
						  // Use the UTF-8 character set for encoding
						CONVERT FROM TEXT:C1011(This:C1470.value;"utf-8";$x)
						
						  // Convert the characters
						For ($i;0;BLOB size:C605($x)-1;1)
							
							If (Position:C15(Char:C90($x{$i});$t;*)>0)
								
								  // It's a safe character, append unaltered
								$o.value:=$o.value+Char:C90($x{$i})
								
							Else 
								
								  // It's an unsafe character, append as a hex string
								$o.value:=$o.value+"%"+Substring:C12(String:C10($x{$i};"&x");5)
								
							End if 
						End for 
					End if 
					
					  //______________________________________________________
				: ($1="urlDecode")  // Returns an URL decoded string
					
					SET BLOB SIZE:C606($x;This:C1470.length+1;0)
					$t:=This:C1470.value
					
					For ($i;1;This:C1470.length;1)
						
						Case of 
								
								  //________________________________________
							: ($t[[$i]]="%")
								
								$x{$length}:=Position:C15(Substring:C12($t;$i+1;1);"123456789ABCDEF")*16\
									+Position:C15(Substring:C12($t;$i+2;1);"123456789ABCDEF")
								$i:=$i+2
								
								  //________________________________________
							Else 
								
								$x{$length}:=Character code:C91($t[[$i]])
								
								  //________________________________________
						End case 
						
						$length:=$length+1
						
					End for 
					
					  // Convert from UTF-8
					SET BLOB SIZE:C606($x;$length)
					$o.value:=Convert to text:C1012($x;"utf-8")
					
					  //______________________________________________________
				: ($1="equal")  // Returns True if the string passed is exactly the same as the value.
					
					$o.value:=New collection:C1472(This:C1470.value).equal(New collection:C1472($2.with);ck diacritical:K85:3)
					
					  //______________________________________________________
				: ($1="distinctLetters")  // Returns the list of distinct letters of the string…
					
					$c:=Split string:C1554(This:C1470.value;"").distinct().sort()
					
					If ($2.delimiter#Null:C1517)  // …as string if delimiter is passed
						
						$o.value:=$c.join(String:C10($2.delimiter))
						
					Else   // …as collection
						
						$o.value:=$c
						
					End if 
					
					  //______________________________________________________
				: ($1="fixedLength")  // Returns value as fixed length string
					
					$l:=Num:C11($2.length)
					ASSERT:C1129($l>0)
					
					If ($2.filler#Null:C1517)
						
						$t:=String:C10($2.filler)
						
					Else 
						
						  // Default is space
						$t:="*"
						
					End if 
					
					If (Num:C11($2.alignment)=Align right:K42:4)
						
						$o.value:=Substring:C12(($t*($l-This:C1470.length))+This:C1470.value;1;$l)
						
					Else 
						
						  // Default is left
						$o.value:=Substring:C12(This:C1470.value+($t*$l);1;$l)
						
					End if 
					
					  //______________________________________________________
				: ($1="uperCamelCase")  // Returns value as upper camelcase
					
					If (Length:C16(This:C1470.value)>0)
						
						If (Length:C16(This:C1470.value)>2)
							
							$t:=This:C1470.spaceSeparated()
							GET TEXT KEYWORDS:C1141($t;$tTxt_keywords)
							$c:=New collection:C1472
							
							For ($i;1;Size of array:C274($tTxt_keywords);1)
								
								$tTxt_keywords{$i}:=Lowercase:C14($tTxt_keywords{$i})
								$tTxt_keywords{$i}[[1]]:=Uppercase:C13($tTxt_keywords{$i}[[1]])
								$c.push($tTxt_keywords{$i})
								
							End for 
							
							$o.value:=$c.join()
							
						Else 
							
							$o.value:=Lowercase:C14(This:C1470.value)
							
						End if 
					End if 
					
					  //______________________________________________________
				: ($1="lowerCamelCase")  // Returns value as lower camelcase
					
					$t:=This:C1470.spaceSeparated()
					GET TEXT KEYWORDS:C1141($t;$tTxt_keywords)
					$c:=New collection:C1472
					
					For ($i;1;Size of array:C274($tTxt_keywords);1)
						
						$tTxt_keywords{$i}:=Lowercase:C14($tTxt_keywords{$i})
						
						If ($i>1)
							
							$tTxt_keywords{$i}[[1]]:=Uppercase:C13($tTxt_keywords{$i}[[1]])
							
						End if 
						
						$c.push($tTxt_keywords{$i})
						
					End for 
					
					$o.value:=$c.join()
					
					  //______________________________________________________
				: ($1="spaceSeparated")  // Returns underscored value & camelcase (lower or upper) value as space separated
					
					$t:=Replace string:C233(This:C1470.value;"_";" ")
					$c:=New collection:C1472
					COLLECTION TO ARRAY:C1562(Split string:C1554($t;"");$tTxt_keywords)
					$t:=Lowercase:C14($t)
					$l:=1
					
					For ($i;2;Size of array:C274($tTxt_keywords);1)
						
						If (Character code:C91($tTxt_keywords{$i})#Character code:C91($t[[$i]]))  // Cesure
							
							$c.push(Substring:C12($t;$l;$i-$l))
							$l:=$i
							
						End if 
					End for 
					
					$c.push(Substring:C12($t;$l))
					
					For each ($t;$c)
						
						$tResult:=$tResult+Uppercase:C13($t[[1]])+Lowercase:C14(Substring:C12($t;2))+" "
						
					End for each 
					
					$o.value:=$tResult
					
					  //______________________________________________________
				: ($1="trimLeading")\
					 | ($1="trimTrailing")  // Trims leading or trailing spaces
					
					If ($2.pattern#Null:C1517)
						
						$tPattern:="(?m-si)^(TRIM*)"
						$tPattern:=Replace string:C233($tPattern;"TRIM";String:C10($2.pattern);*)
						
					Else 
						
						$tPattern:="(?m-si)^(\\s*)"
						
					End if 
					
					$tResult:=This:C1470.value
					
					If ($1="trimLeading")
						
						  // Split & reverse
						$t:=Split string:C1554(This:C1470.value;"").reverse().join("")
						
					Else 
						
						$t:=This:C1470.value
						
					End if 
					
					If (Match regex:C1019($tPattern;$t;1;$position;$length;*))
						
						If ($1="trimLeading")
							
							  // Split & reverse
							$tResult:=Split string:C1554(Delete string:C232($t;$position;$length);"").reverse().join("")
							
						Else 
							
							$tResult:=Delete string:C232(This:C1470.value;$position;$length)
							
						End if 
					End if 
					
					$o.value:=$tResult
					
					  //______________________________________________________
				: ($1="trim")  // Trims leading & trailing spaces
					
					If ($2.pattern#Null:C1517)
						
						$tPattern:="(?m-si)^(TRIM*)"
						$tPattern:=Replace string:C233($tPattern;"TRIM";String:C10($2.pattern);*)
						
					Else 
						
						$tPattern:="(?m-si)^(\\s*)"
						
					End if 
					
					$tResult:=This:C1470.value
					
					  // trimLeading
					$t:=Split string:C1554($tResult;"").reverse().join("")
					
					If (Match regex:C1019($tPattern;$t;1;$position;$length;*))
						
						$tResult:=Split string:C1554(Delete string:C232($t;$position;$length);"").reverse().join("")
						
					End if 
					
					  // trimTrailing
					$t:=$tResult
					
					If (Match regex:C1019($tPattern;$t;1;$position;$length;*))
						
						$tResult:=Delete string:C232($t;$position;$length)
						
					End if 
					
					$o.value:=$tResult
					
					  //______________________________________________________
				: ($1="filter")
					
					Case of 
							
							  //…………………………………………………………………………………
						: (String:C10($2.as)="numeric")  // Return extract numeric
							
							$tPattern:="(?m-si)^\\D*([+-]?\\d+\\{thousand}?\\d*\\{decimal}?\\d?)\\s?\\D*$"
							$tFiltered:=This:C1470.value
							GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$t)
							$tPattern:=Replace string:C233($tPattern;"{decimal}";$t)
							
							If ($t#".")
								
								$tFiltered:=Replace string:C233($tFiltered;".";$t)
								
							End if 
							
							GET SYSTEM FORMAT:C994(Thousand separator:K60:2;$t)
							$tPattern:=Replace string:C233($tPattern;"{thousand}";$t)
							
							If (Match regex:C1019($tPattern;$tFiltered;1;$position;$length;*))
								
								$tResult:=$tResult+Substring:C12($tFiltered;1;$length)
								$tFiltered:=Delete string:C232($tFiltered;1;$length)
								
							Else 
								
								If (Length:C16($tFiltered)>0)
									
									$tResult:=$tResult+$tFiltered
									
								End if 
							End if 
							
							  //…………………………………………………………………………………
					End case 
					
					$o.value:=Num:C11($tResult)
					
					  //______________________________________________________
				: ($1="wordWrap")  // Returns a word wrapped text based on the line length given (default is 80 characters)
					
					If ($2.length#Null:C1517)
						
						$l:=Num:C11($2.length)
						ASSERT:C1129($l>0)
						
					Else 
						
						$l:=79
						
					End if 
					
					$tPattern:="^(.{1,COL}|\\S{COL,})(?:\\s[^\\S\\r\\n]*|\\Z)"
					$tPattern:=Replace string:C233($tPattern;"COL";String:C10($l);1;*)
					$tPattern:=Replace string:C233($tPattern;"COL";String:C10($l+1);1;*)
					$t:=This:C1470.value
					
					Repeat 
						
						$b:=Match regex:C1019($tPattern;$t;1;$position;$length;*)
						
						If ($b)
							
							$tResult:=$tResult+Substring:C12($t;1;$length)+"\r"
							$t:=Delete string:C232($t;1;$length)
							
						Else 
							
							If (Length:C16($t)>0)
								
								$tResult:=$tResult+$t
								
							Else 
								
								  // Remove the last carriage return
								$tResult:=Delete string:C232($tResult;Length:C16($tResult);1)
								
							End if 
						End if 
					Until (Not:C34($b))
					
					$o.value:=$tResult
					
					  //______________________________________________________
				: ($1="unaccented")  // Replace accented characters with non accented one
					
					$t:=This:C1470.value
					
					If (Length:C16($t)>0)
						
						  // Specific cases
						$t:=Replace string:C233($t;"ȼ";"c";*)
						$t:=Replace string:C233($t;"Ȼ";"C";*)
						$t:=Replace string:C233($t;"Ð";"D";*)
						$t:=Replace string:C233($t;"Đ";"D";*)
						$t:=Replace string:C233($t;"đ";"d";*)
						$t:=Replace string:C233($t;"Ħ";"H";*)
						$t:=Replace string:C233($t;"ħ";"h";*)
						$t:=Replace string:C233($t;"ı";"i";*)
						$t:=Replace string:C233($t;"Ŀ";"L";*)
						$t:=Replace string:C233($t;"Ŀ";"L";*)
						$t:=Replace string:C233($t;"ŀ";"l";*)
						$t:=Replace string:C233($t;"Ł";"L";*)
						$t:=Replace string:C233($t;"ł";"l";*)
						$t:=Replace string:C233($t;"Ŋ";"N";*)
						$t:=Replace string:C233($t;"ŋ";"n";*)
						$t:=Replace string:C233($t;"ŉ";"n";*)
						$t:=Replace string:C233($t;"n̈";"n";*)
						$t:=Replace string:C233($t;"N̈";"N";*)
						$t:=Replace string:C233($t;"Ø";"O";*)
						$t:=Replace string:C233($t;"ð";"o";*)
						$t:=Replace string:C233($t;"ø";"o";*)
						$t:=Replace string:C233($t;"Þ";"P";*)
						$t:=Replace string:C233($t;"þ";"p";*)
						$t:=Replace string:C233($t;"Ŧ";"T";*)
						$t:=Replace string:C233($t;"ŧ";"t";*)
						$tt:="abcdefghijklmnopqrstuvwxyz"
						
						For ($i;1;Length:C16($tt);1)
							
							$l:=0
							
							Repeat 
								
								$l:=Position:C15($tt[[$i]];$t;$l+1)
								
								If ($l>0)
									
									If (Position:C15($t[[$l]];Uppercase:C13($t[[$l]];*);*)>0)
										
										  // UPPERCASE
										$t[[$l]]:=Uppercase:C13($t[[$l]])
										
									Else 
										
										  // lowercase
										$t[[$l]]:=Lowercase:C14($t[[$l]])
										
									End if 
								End if 
							Until ($l=0)
						End for 
						
						  // Miscellaneous
						$t:=Replace string:C233($t;"ß";"ss";*)
						$t:=Replace string:C233($t;"Æ";"AE";*)
						$t:=Replace string:C233($t;"æ";"ae";*)
						$t:=Replace string:C233($t;"œ";"oe";*)
						$t:=Replace string:C233($t;"Œ";"OE";*)
						$t:=Replace string:C233($t;"∂";"d";*)
						$t:=Replace string:C233($t;"∆";"D";*)
						$t:=Replace string:C233($t;"ƒ";"f";*)
						$t:=Replace string:C233($t;"µ";"u";*)
						$t:=Replace string:C233($t;"π";"p";*)
						$t:=Replace string:C233($t;"∏";"P";*)
						
					End if 
					
					$o.value:=$t
					
					  //______________________________________________________
				: ($1="isBoolean")  // Returns True if text is "T/true" or "F/false"
					
					$o.value:=Match regex:C1019("(?m-is)^(?:[tT]rue|[fF]alse)$";String:C10(This:C1470.value);1)
					
					  //______________________________________________________
				: ($1="isDate")  // Returns True if the text is a date string (DOES NOT CHECK IF THE DATE IS VALID)
					
					$o.value:=Match regex:C1019("(?m-si)^\\d+/\\d+/\\d+$";String:C10(This:C1470.value);1)
					
					  //______________________________________________________
				: ($1="isNum")  // Returns True if text is a numeric
					
					GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$t)
					$o.value:=Match regex:C1019("(?m-si)^(?:\\+|-)?\\d+(?:\\.|"+$t+"\\d+)?$";String:C10(This:C1470.value);1)
					
					  //______________________________________________________
				: ($1="isTime")  // Returns True if text is a time string (DOES NOT CHECK IF THE TIME IS VALID)
					
					GET SYSTEM FORMAT:C994(Time separator:K60:11;$t)
					$o.value:=Match regex:C1019("(?m-si)^\\d+"+$t+"\\d+(?:"+$t+"\\d+)?$";String:C10(This:C1470.value);1)
					
					  //______________________________________________________
				: ($1="isUrl")  // Returns True if the text conforms to the URL grammar. (DOES NOT CHECK IF THE URL IS VALID)
					
					$o.value:=Match regex:C1019("(?m-si)^(?:(?:https?):// )?(?:localhost|127.0.0.1|(?:\\S+(?::\\S*)?@)?(?:(?!10(?:\\.\\d{1,3}){3})(?!127(?:\\.\\d{1,3}){3}"+\
						")(?!169\\.254(?:\\.\\d{1,3}){2})(?!192\\.168(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9"+\
						"]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|"+\
						"(?:(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1}-\\x{ffff}0-9]+)(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1"+\
						"}-\\x{ffff}0-9]+)*(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}]{2,}))))(?::\\d{2,5})?(?:/[^\\s]*)?$";String:C10(This:C1470.value);1)
					
					  //______________________________________________________
				: ($1="match")  // Returns True if text match given pattern
					
					$o.value:=Match regex:C1019(String:C10($2.pattern);String:C10(This:C1470.value);1)
					
					  //______________________________________________________
				: ($1="localized")  // Returns the localized string & made replacement if any
					
					$t:=Get localized string:C991(This:C1470.value)
					$o.value:=Choose:C955(OK=1;$t;This:C1470.value)  // Revert if no localization
					
					If ($2.substitution#Null:C1517)
						
						If (Value type:C1509($2.substitution)=Is collection:K8:32)
							
							Repeat 
								
								$b:=$i<$2.substitution.length
								
								If ($b)
									
									$b:=Match regex:C1019("(?m-si)(\\{[\\w\\s]+\\})";$o.value;1;$position;$length)
									
									If ($b)
										
										$t:=Get localized string:C991($2.substitution[$i])
										$t:=Choose:C955(OK=1;$t;$2.substitution[$i])
										
										If (Position:C15("</span>";$o.value)>0)  // Multistyle
											
											$t:=Replace string:C233($t;"&";"&amp;")
											$t:=Replace string:C233($t;"<";"&lt;")
											$t:=Replace string:C233($t;">";"&gt;")
											
										End if 
										
										$o.value:=Replace string:C233($o.value;Substring:C12($o.value;$position;$length);$t)
										$i:=$i+1
										
									End if 
								End if 
							Until (Not:C34($b))
							
						Else 
							
							If (Match regex:C1019("(?m-si)(\\{[\\w\\s]+\\})";$o.value;1;$position;$length))
								
								$t:=Get localized string:C991(String:C10($2.substitution))
								$t:=Choose:C955(OK=1;$t;String:C10($2.substitution))
								
								If (Position:C15("</span>";$o.value)>0)  // Multistyle
									
									$t:=Replace string:C233($t;"&";"&amp;")
									$t:=Replace string:C233($t;"<";"&lt;")
									$t:=Replace string:C233($t;">";"&gt;")
									
								End if 
								
								$o.value:=Replace string:C233($o.value;Substring:C12($o.value;$position;$length);$t)
								
							End if 
						End if 
					End if 
					
					  //______________________________________________________
				: ($1="concat")  // Concatenates the values ​​given to the original string
					
					$o.value:=This:C1470.value
					
					If ($2.item#Null:C1517)
						
						If ($2.separator=Null:C1517)
							
							  // Default is space
							$tSeparator:=Char:C90(Space:K15:42)
							
						Else 
							
							$tSeparator:=String:C10($2.separator)
							
						End if 
						
						If (Value type:C1509($2.item)=Is collection:K8:32)
							
							For each ($tt;$2.item)
								
								$t:=Get localized string:C991(String:C10($tt))
								$t:=Choose:C955(OK=1;$t;String:C10($tt))
								
								If (Position:C15($tSeparator;$t)#1)\
									 & (Position:C15($tSeparator;$o.value)#Length:C16($o.value))
									
									$o.value:=$o.value+$tSeparator
									
								End if 
								
								$o.value:=$o.value+$t
								
							End for each 
							
						Else 
							
							$t:=Get localized string:C991(String:C10($2.item))
							$t:=Choose:C955(OK=1;$t;String:C10($2.item))
							
							If (Position:C15($tSeparator;$t)#1)\
								 & (Position:C15($tSeparator;$o.value)#Length:C16($o.value))
								
								$o.value:=$o.value+$tSeparator
								
							End if 
							
							$o.value:=$o.value+$t
							
						End if 
					End if 
					
					  //______________________________________________________
				: ($1="replace")  // Returns the string after replacements
					
					$o.value:=This:C1470.value
					
					If (Value type:C1509($2.old)=Is collection:K8:32)
						
						For each ($t;$2.old)
							
							If (Asserted:C1132($i<$2.new.length;"oops"))
								
								$o.value:=Replace string:C233($o.value;$t;Choose:C955($2.new[$i]=Null:C1517;"";String:C10($2.new[$i])))
								
							End if 
							
							$i:=$i+1
							
						End for each 
						
					Else 
						
						$o.value:=Replace string:C233($o.value;String:C10($2.old);Choose:C955($2.new=Null:C1517;"";String:C10($2.new)))
						
					End if 
					
					  //______________________________________________________
				: ($1="xmlEncode")  // Returns a XML encoded string
					
					$o.value:=This:C1470.value
					
					  // Use DOM api to encode XML
					$t:=DOM Create XML Ref:C861("r")
					
					If (OK=1)
						
						DOM SET XML ATTRIBUTE:C866($t;\
							"v";$o.value)
						
						If (OK=1)
							
							DOM EXPORT TO VAR:C863($t;$tt)
							
							If (OK=1)  // Extract from result
								
								$tt:=Substring:C12($tt;Position:C15("v=\"";$tt)+3)
								$o.value:=Substring:C12($tt;1;Length:C16($tt)-4)
								
							End if 
						End if 
						
						DOM CLOSE XML:C722($t)
						
					End if 
					
					  //______________________________________________________
				: ($1="common")  // Return the longest common string
					
					  //$Txt_1:=This.value
					  //$Txt_2:=String($2.with)
					  //$Col_1:=Split string($Txt_1;" ")
					  //$Col_2:=Split string($Txt_2;" ")
					  //$Boo_diacritical:=Bool($2.diacritical)
					  //If ($Col_1.length>$Col_2.length)
					  //For each ($Txt_word;$Col_2)
					  //$t:=Choose(Length($o.value)>0;$o.value+" "+$Txt_word;$Txt_word)
					  //$Lon_position:=Choose($Boo_diacritical;Position($t;$Txt_1;*);Position($t;$Txt_1))
					  //$o.value:=Choose($Lon_position>0;$t;"")
					  // End for each
					  // Else
					  //For each ($Txt_word;$Col_1)
					  //$t:=Choose(Length($o.value)>0;$o.value+" "+$Txt_word;$Txt_word)
					  //$Lon_position:=Choose($Boo_diacritical;Position($t;$Txt_2;*);Position($t;$Txt_2))
					  //$o.value:=Choose($Lon_position>0;$t;"")
					  // End for each
					  // End if
					
					  //______________________________________________________
				: ($1="isStyled")  // Returns True if text is styled
					
					$o.value:=Match regex:C1019("(?i-ms)<span [^>]*>";String:C10(This:C1470.value);1)
					
					  //______________________________________________________
				: ($1="insert")  // Returns an object with string after insertion (value), and positions (begin & end)
					
					If ($2.end>$2.begin)  // True if text to replace
						
						  // Replace the selection with the string to insert
						$o.value:=Substring:C12(This:C1470.value;1;$2.begin-1)+$2.value+Substring:C12(This:C1470.value;$2.end)
						$o.begin:=$2.begin
						$o.end:=$2.begin+Length:C16($2.value)
						
					Else 
						
						  // Insert the chain at the insertion point
						$l:=Length:C16(This:C1470.value)  // Keep the current size
						$o.value:=Insert string:C231(This:C1470.value;$2.value;$2.begin)
						
						If ($2.begin=$l)
							
							  // We were at the end of the text and we stay
							$l:=Length:C16(This:C1470.value)+1
							
						Else 
							
							  // The insertion point is translated from the length of the inserted string
							$l:=$2.begin+Length:C16($2.value)
							
						End if 
						
						$o.begin:=$l
						$o.end:=$l
						
					End if 
					
					  //______________________________________________________
				: ($1="versionCompare")  // Compare two "string version" & return:  0 if equal, 1 if content > $1 , -1 if $1 > content
					
					$o.value:=0  // Equal
					
					$t:=Choose:C955($2.separator=Null:C1517;".";String:C10($2.separator))
					
					$c:=Split string:C1554(This:C1470.value;$t)
					$c1:=Split string:C1554($2.compareTo;$t)
					
					Case of 
							
							  //______________________________________________________
						: ($c.length>$c1.length)
							
							$c1.resize($c.length;"0")
							
							  //______________________________________________________
						: ($c1.length>$c.length)
							
							$c.resize($c1.length;"0")
							
							  //______________________________________________________
					End case 
					
					For each ($t;$c1) While ($o.value=0)
						
						Case of 
								
								  //______________________________________________________
							: (Num:C11($c[$i])>Num:C11($c1[$i]))
								
								$o.value:=1  // Content > $1
								
								  //______________________________________________________
							: (Num:C11($c[$i])<Num:C11($c1[$i]))
								
								$o.value:=-1  // $1 > content
								
								  //______________________________________________________
							Else 
								
								$i:=$i+1  // Go on
								
								  //______________________________________________________
						End case 
					End for each 
					
					  //______________________________________________________
				: ($1="truncate")  // Returns, if any, a truncated string with ellipsis character
					
					$o.value:=This:C1470.value
					
					If (This:C1470.length>$2.maxChar)
						
						$o.value:=Substring:C12($o.value;1;$2.maxChar)+"…"
						
					End if 
					
					  //______________________________________________________
				Else 
					
					ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
					
					  //______________________________________________________
			End case 
			
			  //=======================================================================================================
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End