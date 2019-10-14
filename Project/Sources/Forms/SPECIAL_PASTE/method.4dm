  // ----------------------------------------------------
  // Method : Méthode formulaire : SPECIAL_PASTE
  // Created 30/06/08 by vdl
  // ----------------------------------------------------
  // Description
  // Form method of the "Special paste" dialog
  // ----------------------------------------------------
  // Modified #15-5-2009 by Vincent de Lachaux
  // v12 comments
  // ----------------------------------------------------
  // Modified #11-4-2013 by Vincent de Lachaux
  // added unicode paste adapted from miyako : https://github.com/miyako/4d-component-macro-unicode
  // ----------------------------------------------------
  // Modified #26-4-2013 by Vincent de Lachaux
  // multiline code for html and string
  // ----------------------------------------------------
  // Modified #23-4-2013 by Vincent de Lachaux
  // Limiting line length for Strings and comments to 80 characters
  // ----------------------------------------------------
C_LONGINT:C283($kLon_columns;$kLon_tools;$Lon_formEvent;$i;$Lon_ii;$Lon_options)
C_LONGINT:C283($Lon_specialCodePoint;$Lon_x)
C_POINTER:C301($Ptr_object)
C_TEXT:C284($t;$t;$Txt_encoded;$Txt_line;$t;$Txt_plain)
C_TEXT:C284($tt;$Txt_source)
C_COLLECTION:C1488($c)

ARRAY LONGINT:C221($tLon_lengths;0)
ARRAY LONGINT:C221($tLon_position;0)
ARRAY LONGINT:C221($tLon_specialCodePoints;0)
ARRAY TEXT:C222($tTxt_lines;0)

ARRAY LONGINT:C221($tLon_lengths;0)
ARRAY LONGINT:C221($tLon_position;0)
ARRAY LONGINT:C221($tLon_specialCodePoints;0)

$kLon_columns:=80
$kLon_tools:=8

$Lon_formEvent:=Form event code:C388

Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		ARRAY TEXT:C222(<>tTxt_Labels;0)
		
		$Ptr_object:=(OBJECT Get pointer:C1124(Object named:K67:5;"ID"))
		
		For ($i;1;$kLon_tools;1)
			
			APPEND TO ARRAY:C911(<>tTxt_Labels;Get localized string:C991("as_"+String:C10($i)))
			APPEND TO ARRAY:C911($Ptr_object->;$i)
			
		End for 
		
		Preferences ("Get_Value";"specialPasteChoice";-><>tTxt_Labels)
		<>tTxt_Labels:=Choose:C955((<>tTxt_Labels>Size of array:C274(<>tTxt_Labels)) | (<>tTxt_Labels<=0);1;<>tTxt_Labels)
		
		LISTBOX SELECT ROW:C912(*;"lstb.menu";<>tTxt_Labels;lk replace selection:K53:1)
		
		Preferences ("Get_Value";"specialPasteOptions";->$Lon_options)
		
		$Ptr_object:=OBJECT Get pointer:C1124(Object named:K67:5;"option_2")
		$Ptr_object->:=Num:C11($Lon_options ?? 10)
		
		$Ptr_object:=OBJECT Get pointer:C1124(Object named:K67:5;"option_1")
		$Ptr_object->:=Num:C11($Lon_options ?? 11)
		
		$t:=Get file from pasteboard:C976(1)
		
		If (OK=1)
			
			Form:C1466.original:=$t
			LISTBOX SELECT ROW:C912(*;"lstb.menu";5;lk replace selection:K53:1)
			
		Else 
			
			Form:C1466.original:=Get text from pasteboard:C524
			
		End if 
		
		Form:C1466.text:=Form:C1466.original
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Validate:K2:3)
		
		SET MACRO PARAMETER:C998(Highlighted method text:K5:18;Form:C1466.text+kCaret)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		If (<>tTxt_Labels#5)
			
			$i:=<>tTxt_Labels
			Preferences ("Set_Value";"specialPasteChoice";->$i)
			
		End if 
		
		If (OBJECT Get pointer:C1124(Object named:K67:5;"option_2")->=1)
			
			$Lon_options:=$Lon_options ?+ 10
			
		End if 
		
		If (OBJECT Get pointer:C1124(Object named:K67:5;"option_1")->=1)
			
			$Lon_options:=$Lon_options ?+ 11
			
		End if 
		
		Preferences ("Set_Value";"specialPasteOptions";->$Lon_options)
		
		CLEAR VARIABLE:C89(<>tTxt_Labels)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		If (<>tTxt_Labels{<>tTxt_Labels}#<>tTxt_Labels{0})
			
			Form:C1466.text:=Form:C1466.original
			
			Case of 
					
					  //………………………………………………………………………………………………………
				: (<>tTxt_Labels<4)
					
					OBJECT SET TITLE:C194(*;"option_1";Get localized string:C991("deleteIndentation"))
					OBJECT SET ENABLED:C1123(*;"option_1";True:C214)
					
					OBJECT SET TITLE:C194(*;"option_2";Get localized string:C991("ignoreBlankLines"))
					OBJECT SET ENABLED:C1123(*;"option_2";True:C214)
					
					  //………………………………………………………………………………………………………
				: (<>tTxt_Labels=5)
					
					OBJECT SET TITLE:C194(*;"option_1";Get localized string:C991("relative"))
					OBJECT SET ENABLED:C1123(*;"option_1";True:C214)
					
					OBJECT SET TITLE:C194(*;"option_2";Get localized string:C991("posix"))
					OBJECT SET ENABLED:C1123(*;"option_2";True:C214)
					
					  //………………………………………………………………………………………………………
				Else 
					
					OBJECT SET ENABLED:C1123(*;"option_1";False:C215)
					OBJECT SET ENABLED:C1123(*;"option_2";False:C215)
					
					  //………………………………………………………………………………………………………
			End case 
			
			If (OBJECT Get pointer:C1124(Object named:K67:5;"option_2")->=1)
				
				$Lon_options:=$Lon_options ?+ 10
				
			End if 
			
			If (OBJECT Get pointer:C1124(Object named:K67:5;"option_1")->=1)
				
				$Lon_options:=$Lon_options ?+ 11
				
			End if 
			
			Case of 
					
					  //………………………………………………………………………………………………………
				: (OK=0)
					
					  // BEEP
					
					  //………………………………………………………………………………………………………
				: (<>tTxt_Labels=1)  // STRING
					
					Form:C1466.text:=Replace string:C233(Form:C1466.original;"\\";"\\"*2)
					Form:C1466.text:=Replace string:C233(Form:C1466.text;Char:C90(Double quote:K15:41);"\\\"")
					Form:C1466.text:=Replace string:C233(Form:C1466.text;Char:C90(Carriage return:K15:38);"\\r")
					Form:C1466.text:=Replace string:C233(Form:C1466.text;Char:C90(Line feed:K15:40);"\\n")
					Form:C1466.text:=Replace string:C233(Form:C1466.text;Char:C90(Tab:K15:37);"\\t")
					
					Form:C1466.text:="\""+Replace string:C233(str_hyphenation (Form:C1466.text;$kLon_columns;"\\\r+");"\\\r+";"\"\\\r+\"")+"\""
					
					  //………………………………………………………………………………………………………
				: (<>tTxt_Labels=2)  // COMMENTS
					
					Form:C1466.text:=""
					$t:=Replace string:C233(Form:C1466.original;"\r\n";"\r")
					$t:=Replace string:C233($t;"\n";"\r")
					
					$c:=Split string:C1554($t;"\r";sk trim spaces:K86:2)
					
					For each ($t;$c)
						
						If ($Lon_options ?? 11)
							
							  // Delete indentation
							$t:=Replace string:C233($t;"\t";"")
							
						Else 
							
							$t:=Replace string:C233($t;"\t";"    ")
							
						End if 
						
						If ($Lon_options ?? 10)
							
							If (Length:C16($t)#0)
								
								Form:C1466.text:=Form:C1466.text+kCommentMark+str_hyphenation ($t;$kLon_columns;"\r"+kCommentMark)+"\r"
								
							End if 
							
						Else 
							
							Form:C1466.text:=Form:C1466.text+kCommentMark+str_hyphenation ($t;$kLon_columns;"\r"+kCommentMark)+"\r"
							
						End if 
					End for each 
					
					  //………………………………………………………………………………………………………
				: (<>tTxt_Labels=3)  // HTML
					
					$t:=Replace string:C233(Form:C1466.original;"\r\n";"\r")
					$t:=Replace string:C233($t;"\n";"\r")
					
					$c:=Split string:C1554($t;"\r";sk trim spaces:K86:2)
					
					Form:C1466.text:="$Txt_HTML:="
					
					For each ($t;$c)
						
						$t:=Replace string:C233($t;"\\";"\\"*2)
						$t:=Replace string:C233($t;"\"";"\\\"")
						
						If ($Lon_options ?? 11)
							
							  // Delete indentation
							$t:=Replace string:C233($t;"\t";"")
							
						Else 
							
							$t:=Replace string:C233($t;"\t";"    ")
							
						End if 
						
						If ($Lon_options ?? 10)
							
							If (Length:C16($t)#0)
								
								Form:C1466.text:=Form:C1466.text+Choose:C955($i=1;"";"\\\r+\"")+$t+"\""
								
							End if 
							
						Else 
							
							Form:C1466.text:=Form:C1466.text+Choose:C955($i=1;"";"\\\r+\"")+$t+"\""
							
						End if 
					End for each 
					
					  //………………………………………………………………………………………………………
				: (<>tTxt_Labels=4)  // PATTERN REGEX
					
					$t:=Form:C1466.original
					
					  // To use a literal backslash in a pattern, precede it with a backslash ("\\").
					$t:=Replace string:C233($t;Char:C90(92);Char:C90(92)*2)
					
					  // The backslash character  followed by a special character, it takes away any special meaning that character may have.
					  // This use of backslash as an escape character applies both inside and outside character classes.
					  // This escaping enables the usage of characters like *, +, (, { as literals in a pattern.
					$t:=Replace string:C233($t;"*";"\\*")
					$t:=Replace string:C233($t;"+";"\\+")
					$t:=Replace string:C233($t;"(";"\\(")
					$t:=Replace string:C233($t;")";"\\)")
					$t:=Replace string:C233($t;"{";"\\{")
					$t:=Replace string:C233($t;"}";"\\}")
					
					$t:=Replace string:C233($t;Char:C90(Space:K15:42);"\\s")
					$t:=Replace string:C233($t;Char:C90(Carriage return:K15:38);"\\r")
					$t:=Replace string:C233($t;Char:C90(Line feed:K15:40);"\\n")
					$t:=Replace string:C233($t;Char:C90(Tab:K15:37);"\\t")
					$t:=Replace string:C233($t;" ";"\\xCA")
					
					If ($t[[1]]#"\"")
						
						$t:="\""+$t
						
					End if 
					
					If ($t[[Length:C16($t)]]#"\"")
						
						$t:=$t+"\""
						
					End if 
					
					Form:C1466.text:=$t
					
					  //………………………………………………………………………………………………………
				: (<>tTxt_Labels=5)  // PATHNAME
					
					$t:=Get file from pasteboard:C976(1)
					
					If (OK=1)
						
						$tt:=Get 4D folder:C485(Current resources folder:K5:16;*)
						
						If ($Lon_options ?? 10)  // POSIX
							
							$t:=Convert path system to POSIX:C1106($t)
							$tt:=Convert path system to POSIX:C1106($tt)
							
						End if 
						
						If ($Lon_options ?? 11)  // Relative
							
							If (Position:C15($tt;$t;*)=1)
								
								$t:=Delete string:C232($t;1;Length:C16($tt))
								
							End if 
						End if 
						
						Form:C1466.text:="\""+$t+"\""
						
					End if 
					
					  //………………………………………………………………………………………………………
				: (<>tTxt_Labels=6)  // INSERT IN TEXT
					
					If (Length:C16(Form:C1466.original)>0)
						
						Form:C1466.text:="\"+"+Form:C1466.original+"+\""
						
					End if 
					
					  //………………………………………………………………………………………………………
				: (<>tTxt_Labels=7)  // UNICODE (adapted from Miyako)
					
					$t:=Form:C1466.original
					Form:C1466.text:=""
					
					$i:=1
					
					ARRAY LONGINT:C221($tLon_position;0x0000)
					ARRAY LONGINT:C221($tLon_lengths;0x0000)
					ARRAY LONGINT:C221($tLon_specialCodePoints;0x0000)
					
					While (Match regex:C1019("([!-~]+)|([^!-~]+)";$t;$i;$tLon_position;$tLon_lengths))
						
						If ($tLon_lengths{1}#0)
							
							$Txt_plain:=Substring:C12($t;$tLon_position{1};$tLon_lengths{1})
							$Txt_encoded:=$Txt_encoded+Choose:C955($Txt_encoded="";"";"+")+Choose:C955($Txt_plain="";"";"\"")+$Txt_plain+Choose:C955($Txt_plain="";"";"\"")
							
							$i:=$tLon_position{1}+$tLon_lengths{1}
							
						Else 
							
							$Txt_source:=Substring:C12($t;$tLon_position{2};$tLon_lengths{2})
							
							For ($Lon_ii;1;Length:C16($Txt_source);1)
								
								$Lon_specialCodePoint:=Character code:C91(Substring:C12($Txt_source;$Lon_ii;1))
								
								If (Find in array:C230($tLon_specialCodePoints;$Lon_specialCodePoint)=-1)
									
									APPEND TO ARRAY:C911($tLon_specialCodePoints;$Lon_specialCodePoint)
									
								End if 
								
								$Lon_x:=($Lon_x+1)*Num:C11($Lon_x<5)
								$Txt_encoded:=$Txt_encoded+Choose:C955($Lon_x=5;"\\\r";"")+Choose:C955($Txt_encoded="";"";"+")+"$ICU_"+Substring:C12(String:C10($Lon_specialCodePoint;"&x");3;4)
								
							End for 
							
							$i:=$tLon_position{2}+$tLon_lengths{2}
							
						End if 
					End while 
					
					For ($i;1;Size of array:C274($tLon_specialCodePoints);1)
						
						Form:C1466.text:=Form:C1466.text\
							+"$ICU_"+Substring:C12(String:C10($tLon_specialCodePoints{$i};"&x");3;4)\
							+":="+Command name:C538(90)+"(0x"+Substring:C12(String:C10($tLon_specialCodePoints{$i};"&x");3;4)+")"\
							+"\r"
						
					End for 
					
					Form:C1466.text:=Form:C1466.text+"\r$Txt_unicode:="+$Txt_encoded+"\r"
					
					  //………………………………………………………………………………………………………
				: (<>tTxt_Labels=8)  // TOKENIZED
					
					$t:=Form:C1466.original
					
					If (Length:C16(Form:C1466.original)>0)
						
						Form:C1466.text:=""
						
						$c:=Split string:C1554(Form:C1466.original;"\r")
						
						For each ($t;$c)
							
							If (Length:C16($t)>0)
								
								Form:C1466.text:=Form:C1466.text+"\r"+Parse formula:C1576($t;Formula out with tokens:K88:3)
								
							End if 
						End for each 
						
						  // Remove first carriage return
						Form:C1466.text:=Delete string:C232(Form:C1466.text;1;1)
						
					End if 
					
					  //………………………………………………………………………………………………………
				Else 
					
					<>tTxt_Labels:=Find in array:C230(<>tTxt_Labels;<>tTxt_Labels{0})
					
					  //………………………………………………………………………………………………………
			End case 
			
			<>tTxt_Labels{0}:=<>tTxt_Labels{<>tTxt_Labels}
			
		End if 
		
		Form:C1466.text:=Form:C1466.text
		
		  //______________________________________________________
	Else 
		
		TRACE:C157
		
		  //______________________________________________________
End case 