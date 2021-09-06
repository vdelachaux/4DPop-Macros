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
C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($i; $l; $Lon_bottom; $Lon_height; $Lon_left; $Lon_right)
C_LONGINT:C283($Lon_size; $Lon_top; $Lon_width; $l; $Lon_x)
C_TEXT:C284($t; $tt; $Txt_action; $Txt_converted; $Txt_Path)
C_OBJECT:C1216($o; $Obj_macro)

If (False:C215)
	C_TEXT:C284(4DPop_MACROS; $1)
	C_TEXT:C284(4DPop_MACROS; $2)
	C_TEXT:C284(4DPop_MACROS; $3)
	C_POINTER:C301(4DPop_MACROS; ${4})
End if 

// ----------------------------------------------------
// Initialisations
If (Count parameters:C259>=1)
	
	$Txt_action:=$1
	
	If ($Txt_action#"_@")
		
		If (Storage:C1525.macros=Null:C1517)
			
			Init
			
		End if 
		
		Use (Storage:C1525.macros)
			
			Storage:C1525.macros.lastUsed:=$Txt_action
			
		End use 
	End if 
	
	$Txt_action:=Storage:C1525.macros.lastUsed
	
End if 

$Obj_macro:=macro($Txt_action)

$Boo_OK:=True:C214

If ($Obj_macro.process)  // Install menu bar to allow Copy - Paste
	
	cs:C1710.menu.new().defaultMinimalMenuBar().setBar()
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Txt_action="upperCase")\
		 | ($Txt_action="lowerCase")\
		 | ($Txt_action="string_list")\
		 | ($Txt_action="resource_to_text")\
		 | ($Txt_action="text_from_resource")\
		 | ($Txt_action="backup_method")\
		 | ($Txt_action="Constant_Values")\
		 | ($Txt_action="syntax")\
		 | ($Txt_action="4D_variable_list")\
		 | ($Txt_action="lists_list")\
		 | ($Txt_action="filters_list")\
		 | ($Txt_action="methods_list")\
		 | ($Txt_action="groups_list")\
		 | ($Txt_action="groups_list")\
		 | ($Txt_action="users_list")\
		 | ($Txt_action="pictures_list")\
		 | ($Txt_action="ascii_list")\
		 | ($Txt_action="_syntax_@")\
		 | ($Txt_action="_paste_as_string")\
		 | ($Txt_action="copyWithIndentation")\
		 | ($Txt_action="camelCase")\
		 | ($Txt_action="AlphaToTextDeclaration")  // [OBSOLETE]
		
		ALERT:C41("OBSOLETE ACTION\rNo longer available or included in 4D")
		
		//______________________________________________________
	: ($Txt_action="4d_folder")  // • Open "Macro v2" folder in the current 4D folder
		
		$o:=Folder:C1567(fk user preferences folder:K87:10).folder("Macros v2")
		$o.create()
		SHOW ON DISK:C922($o.platformPath; *)
		
		//______________________________________________________
	: ($Txt_action="method-export")  // #10-2-2016 - export the method
		
		METHODS("export"; $2)
		
		//______________________________________________________
	: ($Txt_action="method-new")  //#v14 Create a method with the selection
		
		METHODS("new"; $Obj_macro.highlighted)
		
		//______________________________________________________
	: ($Txt_action="method-comments")  // Edit method's comments
		
		If (Bool:C1537(Get database parameter:C643(113)))  // Project mode
			
			ALERT:C41("Not yet available in project mode")
			
		Else 
			
			COMMENTS("method"; $2)
			
		End if 
		
		//______________________________________________________
	: ($Txt_action="method-list")  // Display a hierarchical methods' menu
		
		METHODS("list")
		
		//______________________________________________________
	: ($Txt_action="method-attributes")  //#v13 Set methodes attributes
		
		If (Bool:C1537(Get database parameter:C643(113)))  // Project mode
			
			ALERT:C41("Not yet available in project mode")
			
		Else 
			
			METHODS("attributes"; $2)
			
		End if 
		
		//______________________________________________________
	: ($Txt_action="3D_button")  //#v12 Rapid 3D button génération
		
		$l:=Open form window:C675("CREATE_BUTTON"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		DIALOG:C40("CREATE_BUTTON")
		CLOSE WINDOW:C154
		
		//______________________________________________________
	: ($Txt_action="insert_color")  //#v11 Insert a color expression
		
		$Obj_macro.color()
		
		//______________________________________________________
	: ($Txt_action="special_paste")  //#v11 Paste after transformations
		
		cs:C1710.specialPaste.new()
		
		//______________________________________________________
	: ($Txt_action="_paste_as_string")\
		 | ($Txt_action="_paste_in_string")\
		 | ($Txt_action="paste_html")\
		 | ($Txt_action="paste_regex_pattern")\
		 | ($Txt_action="paste_with_escape_characters")\
		 | ($Txt_action="paste_in_comment")\
		 | ($Txt_action="convert_from_utf8")\
		 | ($Txt_action="convert_to_utf8")\
		 | ($Txt_action="convert_to_html")  // [=>] moved to special_paste
		
		4DPop_MACROS("special_paste")
		
		//______________________________________________________
	: ($Txt_action="edit_comment")  // • Edit comments
		
		COMMENTS("edit")
		
		//______________________________________________________
	: ($Txt_action="about")
		
		If ($Obj_macro.process)
			
			If (Count parameters:C259>=2)
				
				$t:=$2
				
			End if 
			
			$Lon_x:=New process:C317(Current method name:C684; 0; Current method name:C684; "about"; $t)
			
			//SET MACRO PARAMETER(Highlighted method text;"// 4DPop Macros v 3.0")
			
		Else 
			
			ABOUT($2)
			
		End if 
		
		//______________________________________________________
	: ($Txt_action="_display_list@")
		
		C_TEXT:C284(<>Txt_Title)
		$Lon_size:=Size of array:C274(<>tTxt_Labels)
		
		If ($Lon_size>0)
			
			ARRAY TEXT:C222(<>tTxt_Comments; $Lon_size)
			GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; Frontmost window:C447)
			$Lon_left:=$Lon_left+60
			$Lon_top:=$Lon_top+60
			FORM GET PROPERTIES:C674("LIST"; $Lon_width; $Lon_height)
			$l:=Open window:C153($Lon_left; $Lon_top; $Lon_left+$Lon_width; $Lon_top; Pop up window:K34:14)
			
			If ($Txt_action#"@not_sorted@")
				
				SORT ARRAY:C229(<>tTxt_Labels)
				
			End if 
			
			DIALOG:C40("LIST")
			
			If (OK=1)\
				 & (<>tTxt_Labels>0)
				
				Case of 
						
						// .....................................................
					: (Count parameters:C259=3)
						
						$t:=Replace string:C233($2+"%"+$3; "%"; <>tTxt_Labels{<>tTxt_Labels})
						
						// .....................................................
					: (Count parameters:C259=1)
						
						$t:=<>tTxt_Labels{<>tTxt_Labels}
						
						// .....................................................
					: ($2="*")  // Method with syntax
						
						4DPop_MACROS("_syntax_"+<>tTxt_Labels{<>tTxt_Labels})
						$t:=<>tTxt_Labels{<>tTxt_Labels}
						
						// .....................................................
					: ($2="+")  // Return the selected value
						
						$t:=<>tTxt_Labels{<>tTxt_Labels}
						
						// .....................................................
					: ($2="id")
						
						$t:=<>tTxt_Comments{<>tTxt_Labels}
						
						// .....................................................
					: ($2="str")
						
						$t:=$Obj_macro.highlighted+";"+String:C10(<>tTxt_Labels)+")`"+<>tTxt_Labels{<>tTxt_Labels}
						
						// .....................................................
					: ($2="STR#")
						
						$t:=<>tTxt_Comments{<>tTxt_Labels}
						$Lon_x:=Position:C15(" - "; $t)
						$t:=Command name:C538(510)+"("+Substring:C12($t; 1; $Lon_x-1)+";"+Substring:C12($t; $Lon_x+3)+")`"+<>tTxt_Labels{<>tTxt_Labels}
						
						// .....................................................
					: ($2="none")
						
						$t:=""
						
						// .....................................................
					Else 
						
						$t:=Choose:C955(Macintosh option down:C545 | Windows Alt down:C563; <>tTxt_Comments{<>tTxt_Labels}; <>tTxt_Labels{<>tTxt_Labels})
						$t:=Replace string:C233($2+"%"+$2; "%"; $t)
						
						// .....................................................
				End case 
				
				If (Length:C16($t)>0)
					
					SET MACRO PARAMETER:C998(2; $t)
					
				End if 
			End if 
			
			CLEAR VARIABLE:C89(<>Txt_buffer)
			CLEAR VARIABLE:C89(<>Txt_Title)
			CLEAR VARIABLE:C89(<>tTxt_Labels)
			CLEAR VARIABLE:C89(<>tTxt_Comments)
			
		End if 
		
		//______________________________________________________
	: ($Txt_action="_se_Placer_au_Debut")
		
		GET MACRO PARAMETER:C997(Full method text:K5:17; $t)
		SET MACRO PARAMETER:C998(Full method text:K5:17; kCaret+$t)
		
		//______________________________________________________
	: (Length:C16($Obj_macro.method)=0)  // ******************************** All the macros below need a method *********************************
		
		$Boo_OK:=False:C215
		
		//______________________________________________________
	: ($Txt_action="dot_notation")  // [IN WORKS] convert OB GET/OB SET to dot notation
		
		DOT_NOTATION($Obj_macro.highlighted)
		
		//______________________________________________________
	: ($Txt_action="removeBlankLines")  // #17-7-2014 Removes blank lines from the selection or the full method if no text highlighted.
		
		$t:=Choose:C955(Length:C16($Obj_macro.highlighted)=0; $Obj_macro.method; $Obj_macro.highlighted)
		
		For each ($t; Split string:C1554($t; "\r"; sk ignore empty strings:K86:1))
			
			If ($t#"// ")
				
				$Txt_converted:=$Txt_converted+$t+"\r"
				
			End if 
		End for each 
		
		SET MACRO PARAMETER:C998(Choose:C955(Length:C16($Obj_macro.highlighted)=0; Full method text:K5:17; Highlighted method text:K5:18); $Txt_converted)
		
		//______________________________________________________
	: ($Txt_action="beautifier")  //#v13 Beautification
		
		If (Length:C16($Obj_macro.highlighted)=0)
			
			Beautifier($Obj_macro.method; $Obj_macro.process)
			
		Else 
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18; Beautifier($Obj_macro.highlighted))
			
		End if 
		
		//______________________________________________________
	: ($Txt_action="Choose")  // v13+ replace If(test) var:=x Else var:=y End if by var:=Choose(test;x;y)
		
		$Boo_OK:=$Obj_macro.choose().success
		
		//______________________________________________________
	: ($Txt_action="declarations")  // • Compiler Directives for local variables
		
		DECLARATION
		
		//______________________________________________________
	: ($Txt_action="locals_list")  // • List of local variables
		
		ARRAY TEXT:C222(<>tTxt_Labels; 0x0000)
		EXTRACT_LOCAL_VARIABLES("Method"; -><>tTxt_Labels)
		$Boo_OK:=(Size of array:C274(<>tTxt_Labels)>0)
		
		If ($Boo_OK)
			
			If (Size of array:C274(<>tTxt_Labels)=1)  // One line
				
				SET MACRO PARAMETER:C998(Highlighted method text:K5:18; <>tTxt_Labels{1})
				
			Else 
				
				<>Txt_Title:=Get localized string:C991("LocalVariables")
				4DPop_MACROS("_display_list_not_sorted")
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Txt_action="Keywords")  // [IN WORKS] Keywords list
		
		// (method, commands, variables and more)
		//______________________________________________________
	: ($Txt_action="Comment_method")  // [IN WORKS]
		
		// Create a standard comment for the method according to the declaration.
		// This comment could be past in the comment part of the explorer
		
		//______________________________________________________
	: (Length:C16($Obj_macro.highlighted)=0)  // ******************************* All the macros below need a selection *******************************
		
		$Boo_OK:=False:C215
		
		//______________________________________________________
	: ($Txt_action="copyWithoutIndentation")
		
		var $t : Text
		var $i; $tab : Integer
		var $Obj_macro : Object
		var $c : Collection
		
		$c:=Split string:C1554($Obj_macro.highlighted; "\r")
		
		$t:=$c[0]
		
		While ($t[[1]]="\t")
			
			$tab:=$tab+1
			$t:=Delete string:C232($t; 1; 1)
			
		End while 
		
		If ($tab>0)
			
			For ($i; 0; $c.length-1; 1)
				
				$c[$i]:=Delete string:C232($c[$i]; 1; $tab)
				
			End for 
		End if 
		
		$t:=$c.join("\r")
		SET TEXT TO PASTEBOARD:C523($t)
		
		
		//______________________________________________________
	: ($Txt_action="Asserted")  // #24-8-2017 - Conditional assertion
		
		$t:=Command name:C538(1132)+"("+$Obj_macro.highlighted+";\""+kCaret+"\")"
		SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $t)
		
		//______________________________________________________
	: ($Txt_action="compiler_directive")  // Add compiler directive around the highlighted text
		
		$t:=Request:C163("Warning reference:"; "xxx.x")
		
		If (OK=1)\
			 & (Length:C16($t)>0)
			
			If ($t="@.@")
				
				SET MACRO PARAMETER:C998(Highlighted method text:K5:18; "//%W-"+$t+"\r"+$Obj_macro.highlighted+"\r//%W+"+$t)
				
			Else 
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Txt_action="googleSearch")
		
		OPEN URL:C673("www.google.fr/search?q="+$Obj_macro.highlighted)
		
		//______________________________________________________
	: ($Txt_action="commentBlock")
		
		COMMENTS("commentBlock"; $Obj_macro.highlighted)
		
		//______________________________________________________
	: ($Txt_action="duplicateAndComment")
		
		COMMENTS("duplicateAndComment"; $Obj_macro.highlighted)
		
		//______________________________________________________
	: ($Txt_action="comment_current_level")  // Comments the first and the last line of a logic block
		
		COMMENTS("bloc")
		
		//______________________________________________________
	: ($Txt_action="paste_and_keep")  // • Paste the contents of the clipboard and copy the selection
		
		$Obj_macro.swapPasteboard()
		
		//______________________________________________________
	: ($Txt_action="convert_hexa")  // • Change the selection by Hexadecimal
		
		$Boo_OK:=str_isNumeric($Obj_macro.highlighted)
		
		If ($Boo_OK)
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18; String:C10(Num:C11($Obj_macro.highlighted); "&x")+kCaret)
			
		End if 
		
		//______________________________________________________
	: ($Txt_action="convert_decimal")  // • Change the selection by Decimal
		
		$Boo_OK:=($Obj_macro.highlighted="0x@")
		
		If ($Boo_OK)
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18; String:C10(str_gLon_Hex_To_Long($Obj_macro.highlighted))+kCaret)
			
		End if 
		
		//______________________________________________________
	: ($Txt_action="invert_expression")  // Reverse expression
		
		INVERT_EXPRESSION
		
		//______________________________________________________
	: ($Txt_action="convert_to_execute")  // EXECUTER METHODE [New v13]
		
		CODE_TO_EXECUTE
		
		//______________________________________________________
	: ($Txt_action="convert_to_formula")  // EXECUTER FORMULE
		
		CODE_TO_EXECUTE_FORMULA
		
		//______________________________________________________
	Else 
		
		$Boo_OK:=False:C215
		
		//______________________________________________________
End case 

If (Not:C34($Boo_OK))\
 & ($Txt_action#"_@")  //error
	
	BEEP:C151
	
End if 

If ($Obj_macro.process)
	
	//
	
End if 