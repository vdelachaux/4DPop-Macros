//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Méthode : 4DPop_MACROS
  // Created 24/10/05 by Vincent de Lachaux
  // 4DPop Macros v 3.0
  // ----------------------------------------------------
  // Description
  // Entry point of all 4DPop's macros
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (12/05/10)
  // v12
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)
C_POINTER:C301(${4})

C_BLOB:C604($x)
C_LONGINT:C283($l;$Lon_bottom;$Lon_height;$Lon_left;$Lon_right;$Lon_size)
C_LONGINT:C283($Lon_top;$Lon_width;$Lon_x)
C_TEXT:C284($t;$tMacro;$Txt_converted)
C_OBJECT:C1216($o;$oMacro)

If (False:C215)
	C_TEXT:C284(4DPop_MACROS ;$1)
	C_TEXT:C284(4DPop_MACROS ;$2)
	C_TEXT:C284(4DPop_MACROS ;$3)
	C_POINTER:C301(4DPop_MACROS ;${4})
End if 

  // ----------------------------------------------------
  // Initialisations
If (Count parameters:C259>=1)
	
	$tMacro:=$1
	
	If ($tMacro#"_@")
		
		If (Storage:C1525.macros=Null:C1517)
			
			Init 
			
		End if 
		
		Use (Storage:C1525.macros)
			
			Storage:C1525.macros.lastUsed:=$tMacro
			
		End use 
	End if 
	
	$tMacro:=Storage:C1525.macros.lastUsed
	
End if 

$oMacro:=macro ($tMacro;$2)

If ($oMacro.process)
	
	If (New collection:C1472(\
		"declarations";\
		"edit_comment";\
		"method-new";\
		"compiler_directive").indexOf()#-1)
		
		  // Install menu bar to allow Copy - Paste
		menu .append(":xliff:CommonMenuFile";menu \
			.append(":xliff:CommonClose";"closeWindow").shortcut("W")\
			.append(":xliff:CommonMenuItemQuit").action(ak quit:K76:61).shortcut("Q"))\
			.append(":xliff:CommonMenuEdit";menu .edit())\
			.setBar()
		
	End if 
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($tMacro="upperCase")\
		 | ($tMacro="lowerCase")\
		 | ($tMacro="string_list")\
		 | ($tMacro="resource_to_text")\
		 | ($tMacro="text_from_resource")\
		 | ($tMacro="backup_method")\
		 | ($tMacro="Constant_Values")\
		 | ($tMacro="syntax")\
		 | ($tMacro="4D_variable_list")\
		 | ($tMacro="lists_list")\
		 | ($tMacro="filters_list")\
		 | ($tMacro="methods_list")\
		 | ($tMacro="groups_list")\
		 | ($tMacro="groups_list")\
		 | ($tMacro="users_list")\
		 | ($tMacro="pictures_list")\
		 | ($tMacro="ascii_list")\
		 | ($tMacro="_syntax_@")\
		 | ($tMacro="_paste_as_string")\
		 | ($tMacro="copyWithIndentation")\
		 | ($tMacro="camelCase")  // [OBSOLETE]
		
		ALERT:C41("OBSOLETE ACTION\rNo longer available or included in 4D")
		
		  //______________________________________________________
	: ($tMacro="4d_folder")  // • Open "Macro v2" folder in the current 4D folder
		
		$o:=Folder:C1567(fk user preferences folder:K87:10).folder("Macros v2")
		$o.create()
		SHOW ON DISK:C922($o.platformPath;*)
		
		  //______________________________________________________
	: ($tMacro="method-export")  // #10-2-2016 - export the method
		
		METHODS ("export";$2)
		
		  //______________________________________________________
	: ($tMacro="method-new")  //#v14 Create a method with the selection
		
		METHODS ("new";$oMacro.highlighted)
		
		  //______________________________________________________
	: ($tMacro="method-comments")  // Edit method's comments
		
		If (Bool:C1537(Get database parameter:C643(113)))  // Project mode
			
			ALERT:C41("Not yet available in project mode")
			
		Else 
			
			COMMENTS ("method";$2)
			
		End if 
		
		  //______________________________________________________
	: ($tMacro="method-list")  // Display a hierarchical methods' menu
		
		METHODS ("list")
		
		  //______________________________________________________
	: ($tMacro="method-attributes")  //#v13 Set methodes attributes
		
		METHODS ("attributes";$2)
		
		  //______________________________________________________
	: ($tMacro="3D_button")  //#v12 Rapid 3D button génération
		
		$l:=Open form window:C675("CREATE_BUTTON";Plain form window:K39:10;Horizontally centered:K39:1;Vertically centered:K39:4;*)
		DIALOG:C40("CREATE_BUTTON")
		CLOSE WINDOW:C154
		
		  //______________________________________________________
	: ($tMacro="insert_color")  //#v11 Insert a color expression
		
		$oMacro.color()
		
		  //______________________________________________________
	: ($tMacro="special_paste")  //#v11 Paste after transformations
		
		$l:=Open form window:C675("SPECIAL_PASTE";Movable form dialog box:K39:8;Horizontally centered:K39:1;Vertically centered:K39:4;*)
		DIALOG:C40("SPECIAL_PASTE")
		
		CLEAR VARIABLE:C89(<>Txt_buffer)
		
		  //______________________________________________________
	: ($tMacro="_paste_as_string")\
		 | ($tMacro="_paste_in_string")\
		 | ($tMacro="paste_html")\
		 | ($tMacro="paste_regex_pattern")\
		 | ($tMacro="paste_with_escape_characters")\
		 | ($tMacro="paste_in_comment")  // [=>] moved to special_paste
		
		4DPop_MACROS ("special_paste")
		
		  //______________________________________________________
	: ($tMacro="edit_comment")  // • Edit comments
		
		COMMENTS ("edit")
		
		  //______________________________________________________
	: ($tMacro="about")
		
		If ($oMacro.process)
			
			If (Count parameters:C259>=2)
				
				$t:=$2
				
			End if 
			
			$Lon_x:=New process:C317(Current method name:C684;0;Current method name:C684;"about";$t)
			
			  //SET MACRO PARAMETER(Highlighted method text;"// 4DPop Macros v 3.0")
			
		Else 
			
			ABOUT ($2)
			
		End if 
		
		  //______________________________________________________
	: ($tMacro="_display_list@")
		
		C_TEXT:C284(<>Txt_Title)
		$Lon_size:=Size of array:C274(<>tTxt_Labels)
		
		If ($Lon_size>0)
			
			ARRAY TEXT:C222(<>tTxt_Comments;$Lon_size)
			GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Frontmost window:C447)
			$Lon_left:=$Lon_left+60
			$Lon_top:=$Lon_top+60
			FORM GET PROPERTIES:C674("LIST";$Lon_width;$Lon_height)
			$l:=Open window:C153($Lon_left;$Lon_top;$Lon_left+$Lon_width;$Lon_top;Pop up window:K34:14)
			
			If ($tMacro#"@not_sorted@")
				
				SORT ARRAY:C229(<>tTxt_Labels)
				
			End if 
			
			DIALOG:C40("LIST")
			
			If (OK=1)\
				 & (<>tTxt_Labels>0)
				
				Case of 
						
						  // .....................................................
						  //----------------------------------------
					: (Count parameters:C259=3)
						
						$t:=Replace string:C233($2+"%"+$3;"%";<>tTxt_Labels{<>tTxt_Labels})
						
						  // .....................................................
						  //----------------------------------------
					: (Count parameters:C259=1)
						
						$t:=<>tTxt_Labels{<>tTxt_Labels}
						
						  // .....................................................
						  //----------------------------------------
					: ($2="*")  // Method with syntax
						
						4DPop_MACROS ("_syntax_"+<>tTxt_Labels{<>tTxt_Labels})
						$t:=<>tTxt_Labels{<>tTxt_Labels}
						
						  // .....................................................
						  //----------------------------------------
					: ($2="+")  // Return the selected value
						
						$t:=<>tTxt_Labels{<>tTxt_Labels}
						
						  // .....................................................
						  //----------------------------------------
					: ($2="id")
						
						$t:=<>tTxt_Comments{<>tTxt_Labels}
						
						  // .....................................................
						  //----------------------------------------
					: ($2="str")
						
						$t:=$oMacro.highlighted+";"+String:C10(<>tTxt_Labels)+")`"+<>tTxt_Labels{<>tTxt_Labels}
						
						  // .....................................................
						  //----------------------------------------
					: ($2="STR#")
						
						$t:=<>tTxt_Comments{<>tTxt_Labels}
						$Lon_x:=Position:C15(" - ";$t)
						$t:=Command name:C538(510)+"("+Substring:C12($t;1;$Lon_x-1)+";"+Substring:C12($t;$Lon_x+3)+")`"+<>tTxt_Labels{<>tTxt_Labels}
						
						  // .....................................................
						  //----------------------------------------
					: ($2="none")
						
						$t:=""
						
						  // .....................................................
						  //----------------------------------------
					Else 
						
						$t:=Choose:C955(Macintosh option down:C545 | Windows Alt down:C563;<>tTxt_Comments{<>tTxt_Labels};<>tTxt_Labels{<>tTxt_Labels})
						$t:=Replace string:C233($2+"%"+$2;"%";$t)
						
						  // .....................................................
						
						  //----------------------------------------
				End case 
				
				If (Length:C16($t)>0)
					
					SET MACRO PARAMETER:C998(2;$t)
					
				End if 
			End if 
			
			CLEAR VARIABLE:C89(<>Txt_buffer)
			CLEAR VARIABLE:C89(<>Txt_Title)
			CLEAR VARIABLE:C89(<>tTxt_Labels)
			CLEAR VARIABLE:C89(<>tTxt_Comments)
			
		End if 
		
		  //______________________________________________________
	: ($tMacro="_se_Placer_au_Debut")
		
		GET MACRO PARAMETER:C997(Full method text:K5:17;$t)
		SET MACRO PARAMETER:C998(Full method text:K5:17;kCaret+$t)
		
		  //______________________________________________________
	: (Length:C16($oMacro.method)=0)  // ******************************** All the macros below need a method *********************************
		
		$oMacro.success:=False:C215
		
		  //______________________________________________________
	: ($tMacro="dot_notation")  // [IN WORKS] convert OB GET/OB SET to dot notation
		
		DOT_NOTATION ($oMacro.highlighted)
		
		  //______________________________________________________
	: ($tMacro="removeBlankLines")  // #17-7-2014 Removes blank lines from the selection or the full method if no text highlighted.
		
		$t:=Choose:C955(Length:C16($oMacro.highlighted)=0;$oMacro.method;$oMacro.highlighted)
		
		For each ($t;Split string:C1554($t;"\r";sk ignore empty strings:K86:1))
			
			If ($t#"// ")
				
				$Txt_converted:=$Txt_converted+$t+"\r"
				
			End if 
		End for each 
		
		SET MACRO PARAMETER:C998(Choose:C955(Length:C16($oMacro.highlighted)=0;Full method text:K5:17;Highlighted method text:K5:18);$Txt_converted)
		
		  //______________________________________________________
	: ($tMacro="beautifier")  //#v13 Beautification
		
		If (Length:C16($oMacro.highlighted)=0)
			
			Beautifier ($oMacro.method;$oMacro.process)
			
		Else 
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18;Beautifier ($oMacro.highlighted))
			
		End if 
		
		  //______________________________________________________
	: ($tMacro="Choose")  // v13+ replace If(test) var:=x Else var:=y End if by var:=Choose(test;x;y)
		
		$oMacro.choose().success
		
		  //______________________________________________________
	: ($tMacro="declarations")  // • Compiler Directives for local variables
		
		DECLARATION 
		
		  //______________________________________________________
	: ($tMacro="locals_list")  // • List of local variables
		
		ARRAY TEXT:C222(<>tTxt_Labels;0x0000)
		EXTRACT_LOCAL_VARIABLES ("Method";-><>tTxt_Labels)
		$oMacro.success:=(Size of array:C274(<>tTxt_Labels)>0)
		
		If ($oMacro.success)
			
			If (Size of array:C274(<>tTxt_Labels)=1)  // One line
				
				SET MACRO PARAMETER:C998(Highlighted method text:K5:18;<>tTxt_Labels{1})
				
			Else 
				
				<>Txt_Title:=Get localized string:C991("LocalVariables")
				4DPop_MACROS ("_display_list_not_sorted")
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($tMacro="Keywords")  // [IN WORKS] Keywords list
		
		  // (method, commands, variables and more)
		  //______________________________________________________
	: ($tMacro="Comment_method")  // [IN WORKS]
		
		  // Create a standard comment for the method according to the declaration.
		  // This comment could be past in the comment part of the explorer
		  //______________________________________________________
	: ($tMacro="convert_from_utf8")  // • "S√©lectioner un texte UTF8 pour obtenir sa traduction en texte"
		
		If (Length:C16($oMacro.highlighted)=0)
			
			  // Get pasteboard
			$t:=Get text from pasteboard:C524
			
		Else 
			
			$t:=$oMacro.highlighted
			
		End if 
		
		$oMacro.success:=(Length:C16($t)>0)
		
		If ($oMacro.success)
			
			$t:=Replace string:C233($t;"\\";"")
			$Txt_converted:=Text_Decode ($t;"UTF-8")
			
			If (Length:C16($Txt_converted)>0)
				
				4DPop_MACROS ("_paste_as_string";$Txt_converted)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($tMacro="convert_to_utf8")  // • Sélectioner un texte accentué pour obtenir sa traduction en UTF-8
		
		If (Length:C16($oMacro.highlighted)=0)
			
			  // Get pasteboard
			$t:=Get text from pasteboard:C524
			
		Else 
			
			$t:=$oMacro.highlighted
			
		End if 
		
		$oMacro.success:=(Length:C16($t)>0)
		
		If ($oMacro.success)
			
			$t:=Replace string:C233($t;"\\";"")
			$Txt_converted:=Text_Encode ($t;"UTF-8")
			
			If (Length:C16($Txt_converted)>0)
				
				4DPop_MACROS ("_paste_as_string";$Txt_converted)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($tMacro="convert_to_html")  // Sélectioner un texte accentué pour obtenir sa traduction en code HTML
		
		$oMacro.success:=(Length:C16($oMacro.highlighted)>0)
		
		If ($oMacro.success)
			
			$t:=$oMacro.highlighted
			$Txt_converted:="<!--4DVAR $t-->"
			TEXT TO BLOB:C554($Txt_converted;$x;Mac text without length:K22:10)
			PROCESS 4D TAGS:C816($x;$x)
			$Txt_converted:=BLOB to text:C555($x;Mac text without length:K22:10)
			4DPop_MACROS ("_paste_as_string";$Txt_converted)
			
		End if 
		
		  //______________________________________________________
	: ($tMacro="AlphaToTextDeclaration")  // Replace C_ALPHA(xx;… by C_TEXTE(…
		
		$t:=$oMacro.method
		Rgx_SubstituteText (Command name:C538(293)+"\\([^;]*;";Command name:C538(284)+"(";->$t)
		SET MACRO PARAMETER:C998(Full method text:K5:17;$t)
		
		  //______________________________________________________
	: (Length:C16($oMacro.highlighted)=0)  // ******************************* All the macros below need a selection *******************************
		
		$oMacro.success:=False:C215
		
		  //______________________________________________________
	: ($tMacro="Asserted")  // #24-8-2017 - Conditional assertion
		
		$t:=Command name:C538(1132)+"("+$oMacro.highlighted+";\""+kCaret+"\")"
		SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$t)
		
		  //______________________________________________________
	: ($tMacro="compiler_directive")  // Add compiler directive around the highlighted text
		
		$t:=Request:C163("Warning reference:";"xxx.x")
		
		If (OK=1)\
			 & (Length:C16($t)>0)
			
			If ($t="@.@")
				
				SET MACRO PARAMETER:C998(Highlighted method text:K5:18;"//%W-"+$t+"\r"+$oMacro.highlighted+"\r//%W+"+$t)
				
			Else 
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($tMacro="googleSearch")
		
		OPEN URL:C673("www.google.fr/search?q="+$oMacro.highlighted)
		
		  //______________________________________________________
	: ($tMacro="commentBlock")
		
		COMMENTS ("commentBlock";$oMacro.highlighted)
		
		  //______________________________________________________
	: ($tMacro="duplicateAndComment")
		
		COMMENTS ("duplicateAndComment";$oMacro.highlighted)
		
		  //______________________________________________________
	: ($tMacro="comment_current_level")  // Comments the first and the last line of a logic block
		
		COMMENTS ("bloc")
		
		  //______________________________________________________
	: ($tMacro="paste_and_keep")  // • Paste the contents of the clipboard and copy the selection
		
		$oMacro.swapPasteboard()
		
		  //______________________________________________________
	: ($tMacro="convert_hexa")  // • Change the selection by Hexadecimal
		
		$oMacro.success:=str_isNumeric ($oMacro.highlighted)
		
		If ($oMacro.success)
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18;String:C10(Num:C11($oMacro.highlighted);"&x")+kCaret)
			
		End if 
		
		  //______________________________________________________
	: ($tMacro="convert_decimal")  // • Change the selection by Decimal
		
		$oMacro.success:=($oMacro.highlighted="0x@")
		
		If ($oMacro.success)
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18;String:C10(str_gLon_Hex_To_Long ($oMacro.highlighted))+kCaret)
			
		End if 
		
		  //______________________________________________________
	: ($tMacro="invert_expression")  // Reverse expression
		
		INVERT_EXPRESSION 
		
		  //______________________________________________________
	: ($tMacro="convert_to_execute")  // EXECUTER METHODE [New v13]
		
		CODE_TO_EXECUTE 
		
		  //______________________________________________________
	: ($tMacro="convert_to_formula")  // EXECUTER FORMULE
		
		CODE_TO_EXECUTE_FORMULA 
		
		  //______________________________________________________
		
	Else 
		
		$oMacro.success:=False:C215
		
		  //______________________________________________________
End case 

If (Not:C34($oMacro.success))\
 & ($tMacro#"_@")  // Error
	
	BEEP:C151
	
End if 

If ($oMacro.process)
	
	  //
	
End if 