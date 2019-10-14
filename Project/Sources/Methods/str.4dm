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
C_LONGINT:C283($i;$l;$Lon_length;$Lon_position)
C_TEXT:C284($t;$tt;$Txt_filtered;$Txt_pattern;$Txt_result;$Txt_separator)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tTxt_keywords;0)

If (False:C215)
	C_OBJECT:C1216(str ;$0)
	C_TEXT:C284(str ;$1)
	C_OBJECT:C1216(str ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)
	
	If (Count parameters:C259>=1)
		
		$t:=$1
		
	End if 
	
	$o:=New object:C1471(\
		"_is";"str";\
		"value";$t;\
		"length";Length:C16($t);\
		"common";Formula:C1597(str ("common";New object:C1471("with";$1;"diacritical";Bool:C1537($2))).value);\
		"concat";Formula:C1597(str ("concat";New object:C1471("item";$1;"separator";$2)).value);\
		"contains";Formula:C1597(str ("contains";New object:C1471("pattern";String:C10($1);"diacritical";Bool:C1537($2))).value);\
		"distinctLetters";Formula:C1597(str ("distinctLetters";New object:C1471("delimiter";$1)).value);\
		"equal";Formula:C1597(str ("equal";New object:C1471("with";$1)).value);\
		"fixedLength";Formula:C1597(str ("fixedLength";New object:C1471("length";$1;"filler";$2;"alignment";$3)).value);\
		"isStyled";Formula:C1597(str ("isStyled").value);\
		"isBoolean";Formula:C1597(str ("isBoolean").value);\
		"isDate";Formula:C1597(str ("isDate").value);\
		"isJson";Formula:C1597(Match regex:C1019("(?msi)^(?:\\{.*\\})|(?:\\[.*\\])$";This:C1470.value;1));\
		"isJsonArray";Formula:C1597(Match regex:C1019("(?msi)^\\[.*\\]$";This:C1470.value;1));\
		"isJsonObject";Formula:C1597(Match regex:C1019("(?msi)^\\{.*\\}$";This:C1470.value;1));\
		"isNum";Formula:C1597(str ("isNum").value);\
		"isTime";Formula:C1597(str ("isTime").value);\
		"localized";Formula:C1597(str ("localized";New object:C1471("substitution";$1)).value);\
		"lowerCamelCase";Formula:C1597(str ("lowerCamelCase").value);\
		"match";Formula:C1597(str ("match";New object:C1471("pattern";$1)).value);\
		"occurrences";Formula:C1597(Split string:C1554(This:C1470.value;String:C10($1);sk trim spaces:K86:2).length-1);\
		"quoted";Formula:C1597("\""+String:C10(This:C1470.value)+"\"");\
		"replace";Formula:C1597(str ("replace";New object:C1471("old";$1;"new";$2)).value);\
		"setText";Formula:C1597(str ("setText";New object:C1471("value";String:C10($1))));\
		"singleQuoted";Formula:C1597("'"+String:C10(This:C1470.value)+"'");\
		"spaceSeparated";Formula:C1597(str ("spaceSeparated").value);\
		"toNum";Formula:C1597(str ("filter";New object:C1471("as";"numeric")).value);\
		"trim";Formula:C1597(str ("trim";New object:C1471("pattern";$1)).value);\
		"trimTrailing";Formula:C1597(str ("trimTrailing";New object:C1471("pattern";$1)).value);\
		"trimLeading";Formula:C1597(str ("trimLeading";New object:C1471("pattern";$1)).value);\
		"unaccented";Formula:C1597(str ("unaccented").value);\
		"uperCamelCase";Formula:C1597(str ("uperCamelCase").value);\
		"urlEncode";Formula:C1597(str ("urlEncode").value);\
		"urlDecode";Formula:C1597(str ("urlDecode").value);\
		"wordWrap";Formula:C1597(str ("wordWrap";New object:C1471("length";$1)).value);\
		"xmlEncode";Formula:C1597(str ("xmlEncode").value)\
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
				: ($1="urlEncode")  // Returns a URL encoded string
					
					  // List of safe characters
					$t:="1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz:/.?_-$(){}~&"
					
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
				: ($1="urlDecode")  // Returns a URL decoded string
					
					SET BLOB SIZE:C606($x;This:C1470.length+1;0)
					
					$t:=This:C1470.value
					
					For ($i;1;This:C1470.length;1)
						
						Case of 
								
								  //________________________________________
							: ($t[[$i]]="%")
								
								$x{$Lon_length}:=Position:C15(Substring:C12($t;$i+1;1);"123456789ABCDEF")*16\
									+Position:C15(Substring:C12($t;$i+2;1);"123456789ABCDEF")
								
								$i:=$i+2
								
								  //________________________________________
							Else 
								
								$x{$Lon_length}:=Character code:C91($t[[$i]])
								
								  //________________________________________
						End case 
						
						$Lon_length:=$Lon_length+1
						
					End for 
					
					  // Convert from UTF-8
					SET BLOB SIZE:C606($x;$Lon_length)
					
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
						
						$Txt_result:=$Txt_result+Uppercase:C13($t[[1]])+Lowercase:C14(Substring:C12($t;2))+" "
						
					End for each 
					
					$o.value:=$Txt_result
					
					  //______________________________________________________
				: ($1="trimLeading")\
					 | ($1="trimTrailing")  // Trims leading or trailing spaces
					
					If ($2.pattern#Null:C1517)
						
						$Txt_pattern:="(?m-si)^(TRIM*)"
						$Txt_pattern:=Replace string:C233($Txt_pattern;"TRIM";String:C10($2.pattern);*)
						
					Else 
						
						$Txt_pattern:="(?m-si)^(\\s*)"
						
					End if 
					
					$Txt_result:=This:C1470.value
					
					If ($1="trimLeading")
						
						  // Split & reverse
						$t:=Split string:C1554(This:C1470.value;"").reverse().join("")
						
					Else 
						
						$t:=This:C1470.value
						
					End if 
					
					If (Match regex:C1019($Txt_pattern;$t;1;$Lon_position;$Lon_length;*))
						
						If ($1="trimLeading")
							
							  // Split & reverse
							$Txt_result:=Split string:C1554(Delete string:C232($t;$Lon_position;$Lon_length);"").reverse().join("")
							
						Else 
							
							$Txt_result:=Delete string:C232(This:C1470.value;$Lon_position;$Lon_length)
							
						End if 
					End if 
					
					$o.value:=$Txt_result
					
					  //______________________________________________________
				: ($1="trim")  // Trims leading & trailing spaces
					
					If ($2.pattern#Null:C1517)
						
						$Txt_pattern:="(?m-si)^(TRIM*)"
						$Txt_pattern:=Replace string:C233($Txt_pattern;"TRIM";String:C10($2.pattern);*)
						
					Else 
						
						$Txt_pattern:="(?m-si)^(\\s*)"
						
					End if 
					
					$Txt_result:=This:C1470.value
					
					  // trimLeading
					$t:=Split string:C1554($Txt_result;"").reverse().join("")
					
					If (Match regex:C1019($Txt_pattern;$t;1;$Lon_position;$Lon_length;*))
						
						$Txt_result:=Split string:C1554(Delete string:C232($t;$Lon_position;$Lon_length);"").reverse().join("")
						
					End if 
					
					  // trimTrailing
					$t:=$Txt_result
					
					If (Match regex:C1019($Txt_pattern;$t;1;$Lon_position;$Lon_length;*))
						
						$Txt_result:=Delete string:C232($t;$Lon_position;$Lon_length)
						
					End if 
					
					$o.value:=$Txt_result
					
					  //______________________________________________________
				: ($1="filter")  //
					
					Case of 
							
							  //…………………………………………………………………………………
						: (String:C10($2.as)="numeric")
							
							$Txt_pattern:="(?m-si)^\\D*([+-]?\\d+\\{thousand}?\\d*\\{decimal}?\\d?)\\s?\\D*$"
							
							$Txt_filtered:=This:C1470.value
							
							GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$t)
							$Txt_pattern:=Replace string:C233($Txt_pattern;"{decimal}";$t)
							
							If ($t#".")
								
								$Txt_filtered:=Replace string:C233($Txt_filtered;".";$t)
								
							End if 
							
							GET SYSTEM FORMAT:C994(Thousand separator:K60:2;$t)
							$Txt_pattern:=Replace string:C233($Txt_pattern;"{thousand}";$t)
							
							If (Match regex:C1019($Txt_pattern;$Txt_filtered;1;$Lon_position;$Lon_length;*))
								
								$Txt_result:=$Txt_result+Substring:C12($Txt_filtered;1;$Lon_length)
								$Txt_filtered:=Delete string:C232($Txt_filtered;1;$Lon_length)
								
							Else 
								
								If (Length:C16($Txt_filtered)>0)
									
									$Txt_result:=$Txt_result+$Txt_filtered
									
								End if 
							End if 
							
							  //…………………………………………………………………………………
					End case 
					
					$o.value:=Num:C11($Txt_result)
					
					  //______________________________________________________
				: ($1="wordWrap")  // Returns a word wrapped text based on the line length given (default is 80 characters)
					
					If ($2.length#Null:C1517)
						
						$l:=Num:C11($2.length)
						ASSERT:C1129($l>0)
						
					Else 
						
						$l:=79
						
					End if 
					
					$Txt_pattern:="^(.{1,COL}|\\S{COL,})(?:\\s[^\\S\\r\\n]*|\\Z)"
					$Txt_pattern:=Replace string:C233($Txt_pattern;"COL";String:C10($l);1;*)
					$Txt_pattern:=Replace string:C233($Txt_pattern;"COL";String:C10($l+1);1;*)
					
					$t:=This:C1470.value
					
					Repeat 
						
						$b:=Match regex:C1019($Txt_pattern;$t;1;$Lon_position;$Lon_length;*)
						
						If ($b)
							
							$Txt_result:=$Txt_result+Substring:C12($t;1;$Lon_length)+"\r"
							$t:=Delete string:C232($t;1;$Lon_length)
							
						Else 
							
							If (Length:C16($t)>0)
								
								$Txt_result:=$Txt_result+$t
								
							Else 
								
								  // Remove the last carriage return
								$Txt_result:=Delete string:C232($Txt_result;Length:C16($Txt_result);1)
								
							End if 
						End if 
					Until (Not:C34($b))
					
					$o.value:=$Txt_result
					
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
									
									$b:=Match regex:C1019("(?m-si)(\\{[\\w\\s]+\\})";$o.value;1;$Lon_position;$Lon_length)
									
									If ($b)
										
										$t:=Get localized string:C991($2.substitution[$i])
										$t:=Choose:C955(OK=1;$t;$2.substitution[$i])
										
										If (Position:C15("</span>";$o.value)>0)  // Multistyle
											
											$t:=Replace string:C233($t;"&";"&amp;")
											$t:=Replace string:C233($t;"<";"&lt;")
											$t:=Replace string:C233($t;">";"&gt;")
											
										End if 
										
										$o.value:=Replace string:C233($o.value;Substring:C12($o.value;$Lon_position;$Lon_length);$t)
										$i:=$i+1
										
									End if 
								End if 
							Until (Not:C34($b))
							
						Else 
							
							If (Match regex:C1019("(?m-si)(\\{[\\w\\s]+\\})";$o.value;1;$Lon_position;$Lon_length))
								
								$t:=Get localized string:C991(String:C10($2.substitution))
								$t:=Choose:C955(OK=1;$t;String:C10($2.substitution))
								
								If (Position:C15("</span>";$o.value)>0)  // Multistyle
									
									$t:=Replace string:C233($t;"&";"&amp;")
									$t:=Replace string:C233($t;"<";"&lt;")
									$t:=Replace string:C233($t;">";"&gt;")
									
								End if 
								
								$o.value:=Replace string:C233($o.value;Substring:C12($o.value;$Lon_position;$Lon_length);$t)
								
							End if 
						End if 
					End if 
					
					  //______________________________________________________
				: ($1="concat")  // Concatenates the values ​​given to the original string
					
					$o.value:=This:C1470.value
					
					If ($2.item#Null:C1517)
						
						If ($2.separator=Null:C1517)
							
							  // Default is space
							$Txt_separator:=Char:C90(Space:K15:42)
							
						Else 
							
							$Txt_separator:=String:C10($2.separator)
							
						End if 
						
						If (Value type:C1509($2.item)=Is collection:K8:32)
							
							For each ($tt;$2.item)
								
								$t:=Get localized string:C991(String:C10($tt))
								$t:=Choose:C955(OK=1;$t;String:C10($tt))
								
								If (Position:C15($Txt_separator;$t)#1)\
									 & (Position:C15($Txt_separator;$o.value)#Length:C16($o.value))
									
									$o.value:=$o.value+$Txt_separator
									
								End if 
								
								$o.value:=$o.value+$t
								
							End for each 
							
						Else 
							
							$t:=Get localized string:C991(String:C10($2.item))
							$t:=Choose:C955(OK=1;$t;String:C10($2.item))
							
							If (Position:C15($Txt_separator;$t)#1)\
								 & (Position:C15($Txt_separator;$o.value)#Length:C16($o.value))
								
								$o.value:=$o.value+$Txt_separator
								
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
						
						DOM SET XML ATTRIBUTE:C866($t;"v";$o.value)
						
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
					  //: (Formula(process ).call().isPreemptif)
					
					  //_4D THROW ERROR(New object(\
																														"component";"CLAS";\
																														"code";1;\
																														"description";"The method "+String($1)+"() for class "+String(This._is)+" can't be called in preemptive mode";\
																														"something";"my bug"))
					
					  //______________________________________________________
				: ($1="isStyled")  // Returns True if text is styled
					
					  //#BYPASS THREAD-SAFE COMPATIBILITY
					$t:=Replace string:C233(String:C10(This:C1470.value);"\r\n";"\r")
					$Txt_filtered:=Formula from string:C1601(":C1092($1)").call(Null:C1517;$t)
					$Txt_result:=Formula from string:C1601(":C1116($1)").call(Null:C1517;$t)
					
					$o.value:=($Txt_result#$Txt_filtered)
					
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