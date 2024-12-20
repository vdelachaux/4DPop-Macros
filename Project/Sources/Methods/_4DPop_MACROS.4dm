//%attributes = {"invisible":true,"shared":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Méthode : 4DPop_MACROS
// Created 24/10/05 by Vincent de Lachaux
// 4DPop Macros v 3.0
// ----------------------------------------------------
// Description
// Entry point of all macros
// ----------------------------------------------------
#DECLARE($action : Text; $text : Text; $title : Text;  ...  : Pointer)

var $t : Text
var $bottom; $height; $i; $left; $pos; $right : Integer
var $size; $tab; $top; $width; $winRef : Integer

If (Count parameters:C259>=1)
	
	If ($action#"_@")
		
		If (Storage:C1525.macros=Null:C1517)
			
			Init
			
		End if 
		
		Use (Storage:C1525.macros)
			
			Storage:C1525.macros.lastUsed:=$action
			
		End use 
	End if 
	
	$action:=Storage:C1525.macros.lastUsed
	
End if 

var $mcro : cs:C1710.macro:=cs:C1710.macro.new()
var $success : Boolean:=True:C214

If ($mcro.isMacroProcess)
	
	// MARK: Install menu bar to allow Copy - Paste
	cs:C1710.menuBar.new().defaultMinimalMenuBar().set()
	
End if 

Case of 
		
		// ______________________________________________________
	: (OB Instance of:C1731($mcro[$action]; 4D:C1709.Function))
		
		$mcro[$action]()
		
		// ______________________________________________________
	: ($action="upperCase")\
		 | ($action="lowerCase")\
		 | ($action="string_list")\
		 | ($action="resource_to_text")\
		 | ($action="text_from_resource")\
		 | ($action="backup_method")\
		 | ($action="Constant_Values")\
		 | ($action="syntax")\
		 | ($action="4D_variable_list")\
		 | ($action="lists_list")\
		 | ($action="filters_list")\
		 | ($action="methods_list")\
		 | ($action="groups_list")\
		 | ($action="groups_list")\
		 | ($action="users_list")\
		 | ($action="pictures_list")\
		 | ($action="ascii_list")\
		 | ($action="_syntax_@")\
		 | ($action="_paste_as_string")\
		 | ($action="copyWithIndentation")\
		 | ($action="camelCase")\
		 | ($action="AlphaToTextDeclaration")  // [OBSOLETE]
		
		ALERT:C41("OBSOLETE ACTION\rNo longer available or included in 4D")
		
		// ______________________________________________________
	: ($action="_paste_as_string")\
		 | ($action="_paste_in_string")\
		 | ($action="paste_html")\
		 | ($action="paste_regex_pattern")\
		 | ($action="paste_with_escape_characters")\
		 | ($action="paste_in_comment")\
		 | ($action="convert_from_utf8")\
		 | ($action="convert_to_utf8")\
		 | ($action="convert_to_html")  // [=>] moved to SpecialPaste
		
		$mcro.SpecialPaste()
		
		// ______________________________________________________
	: ($action="4d_folder")  // • Open "Macro v2" folder in the current 4D folder
		
		var $folder : Object:=Folder:C1567(fk user preferences folder:K87:10).folder("Macros v2")
		$folder.create()
		SHOW ON DISK:C922($folder.platformPath; *)
		
		// ______________________________________________________
	: ($action="method-export")  // #10-2-2016 - export the method
		
		METHODS("export"; $text)
		
		// ______________________________________________________
	: ($action="method-new")  // #v14 Create a method with the selection
		
		METHODS("new"; $mcro.highlighted)
		
		// ______________________________________________________
	: ($action="method-comments")  // Edit method's comments
		
		If (Bool:C1537(Get database parameter:C643(113)))  // Project mode
			
			ALERT:C41("Not yet available in project mode")
			
		Else 
			
			COMMENTS("method"; $text)
			
		End if 
		
		// ______________________________________________________
	: ($action="method-list")  // Display a hierarchical methods' menu
		
		METHODS("list")
		
		// ______________________________________________________
	: ($action="method-attributes")  // #v13 Set methodes attributes
		
		If (Bool:C1537(Get database parameter:C643(113)))  // Project mode
			
			ALERT:C41("Not yet available in project mode")
			
		Else 
			
			METHODS("attributes"; $text)
			
		End if 
		
		// ______________________________________________________
	: ($action="3D_button")  // #v12 Rapid 3D button génération
		
		$winRef:=Open form window:C675("CREATE_BUTTON"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		DIALOG:C40("CREATE_BUTTON")
		CLOSE WINDOW:C154
		
		// ______________________________________________________
	: ($action="edit_comment")  // • Edit comments
		
		COMMENTS("edit")
		
		// ______________________________________________________
	: ($action="about")
		
		If ($mcro.isMacroProcess)
			
			var $process : Integer:=New process:C317(Current method name:C684; 0; Current method name:C684; "about"; $text)
			
		Else 
			
			ABOUT($text)
			
		End if 
		
		// ______________________________________________________
	: ($action="_display_list@")
		
		$size:=Size of array:C274(<>tTxt_Labels)
		
		If ($size>0)
			
			ARRAY TEXT:C222(<>tTxt_Comments; $size)
			GET WINDOW RECT:C443($left; $top; $right; $bottom; Frontmost window:C447)
			$left+=60
			$top+=60
			FORM GET PROPERTIES:C674("LIST"; $width; $height)
			$winRef:=Open window:C153($left; $top; $left+$width; $top; Pop up window:K34:14)
			
			If ($action#"@not_sorted@")
				
				SORT ARRAY:C229(<>tTxt_Labels)
				
			End if 
			
			DIALOG:C40("LIST")
			
			If (OK=1)\
				 & (<>tTxt_Labels>0)
				
				Case of 
						
						// .....................................................
					: (Count parameters:C259=3)
						
						$t:=Replace string:C233($text+"%"+$title; "%"; <>tTxt_Labels{<>tTxt_Labels})
						
						// .....................................................
					: (Count parameters:C259=1)
						
						$t:=<>tTxt_Labels{<>tTxt_Labels}
						
						// .....................................................
					: ($text="*")  // Method with syntax
						
						_4DPop_MACROS("_syntax_"+<>tTxt_Labels{<>tTxt_Labels})
						$t:=<>tTxt_Labels{<>tTxt_Labels}
						
						// .....................................................
					: ($text="+")  // Return the selected value
						
						$t:=<>tTxt_Labels{<>tTxt_Labels}
						
						// .....................................................
					: ($text="id")
						
						$t:=<>tTxt_Comments{<>tTxt_Labels}
						
						// .....................................................
					: ($text="str")
						
						$t:=$mcro.highlighted+";"+String:C10(<>tTxt_Labels)+")`"+<>tTxt_Labels{<>tTxt_Labels}
						
						// .....................................................
					: ($text="STR#")
						
						$t:=<>tTxt_Comments{<>tTxt_Labels}
						$pos:=Position:C15(" - "; $t)
						$t:=Command name:C538(510)+"("+Substring:C12($t; 1; $pos-1)+";"+Substring:C12($t; $pos+3)+")`"+<>tTxt_Labels{<>tTxt_Labels}
						
						// .....................................................
					: ($text="none")
						
						$t:=""
						
						// .....................................................
					Else 
						
						$t:=Macintosh option down:C545 | Windows Alt down:C563 ? <>tTxt_Comments{<>tTxt_Labels} : <>tTxt_Labels{<>tTxt_Labels}
						$t:=Replace string:C233($text+"%"+$text; "%"; $t)
						
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
		
		// ______________________________________________________
	: ($action="_se_Placer_au_Debut")
		
		GET MACRO PARAMETER:C997(Full method text:K5:17; $t)
		SET MACRO PARAMETER:C998(Full method text:K5:17; kCaret+$t)
		
		// MARK:- All the macros below need a method
	: (Length:C16($mcro.method)=0)
		
		$success:=False:C215
		
		// ______________________________________________________
	: ($action="dot_notation")  // [IN WORKS] convert OB GET/OB SET to dot notation
		
		DOT_NOTATION($mcro.highlighted)
		
		// ______________________________________________________
	: ($action="locals_list")  // • List of local variables
		
		ARRAY TEXT:C222(<>tTxt_Labels; 0x0000)
		_o_EXTRACT_LOCAL_VARIABLES("Method"; -><>tTxt_Labels)
		$success:=(Size of array:C274(<>tTxt_Labels)>0)
		
		If ($success)
			
			If (Size of array:C274(<>tTxt_Labels)=1)  // One line
				
				SET MACRO PARAMETER:C998(Highlighted method text:K5:18; <>tTxt_Labels{1})
				
			Else 
				
				<>Txt_Title:=Localized string:C991("LocalVariables")
				_4DPop_MACROS("_display_list_not_sorted")
				
			End if 
		End if 
		
		// ______________________________________________________
	: ($action="Keywords")  // [IN WORKS] Keywords list
		
		// (method, commands, variables and more)
		
		// ______________________________________________________
	: ($action="Comment_method")  // [IN WORKS]
		
		// TODO: Create a standard comment for the method according to the declaration.
		// This comment could be past in the comment part of the explorer
		
		// MARK:- All the macros below need a selection
	: (Length:C16($mcro.highlighted)=0)
		
		$success:=False:C215
		
		// ______________________________________________________
	: ($action="copyWithoutIndentation")
		
		var $c : Collection:=Split string:C1554($mcro.highlighted; "\r")
		
		$t:=$c[0]
		
		While ($t[[1]]="\t")
			
			$tab+=1
			$t:=Delete string:C232($t; 1; 1)
			
		End while 
		
		If ($tab>0)
			
			For ($i; 0; $c.length-1; 1)
				
				$c[$i]:=Delete string:C232($c[$i]; 1; $tab)
				
			End for 
		End if 
		
		$t:=$c.join("\r")
		SET TEXT TO PASTEBOARD:C523($t)
		
		// ______________________________________________________
	: ($action="Asserted")  // #24-8-2017 - Conditional assertion
		
		$t:=Command name:C538(1132)+"("+$mcro.highlighted+";\""+kCaret+"\")"
		SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $t)
		
		// ______________________________________________________
	: ($action="compiler_directive")  // Add compiler directive around the highlighted text
		
		$t:=Request:C163("Warning reference:"; "xxx.x")
		
		If (Bool:C1537(OK))\
			 && (Length:C16($t)>0)\
			 && ($t="@.@")
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18; "    // %W-"+$t+"\r"+$mcro.highlighted+"\r//%W+"+$t)
			
		End if 
		
		// ______________________________________________________
	: ($action="googleSearch")
		
		OPEN URL:C673("www.google.fr/search?q="+$mcro.highlighted)
		
		// ______________________________________________________
	: ($action="comment_current_level")  // Comments the first and the last line of a logic block
		
		COMMENTS("bloc")
		
		// ______________________________________________________
	: ($action="invert_expression")  // Reverse expression
		
		INVERT_EXPRESSION
		
		// ______________________________________________________
	: ($action="convert_to_execute")  // EXECUTER METHODE [New v13]
		
		CODE_TO_EXECUTE
		
		// ______________________________________________________
	: ($action="convert_to_formula")  // EXECUTER FORMULE
		
		CODE_TO_EXECUTE_FORMULA
		
		// ______________________________________________________
	Else 
		
		$success:=False:C215
		
		// ______________________________________________________
End case 

If (Not:C34($success))\
 & ($action#"_@")  // Error
	
	BEEP:C151
	
End if 

If ($mcro.isMacroProcess)
	
	// Something to do?
	
End if 