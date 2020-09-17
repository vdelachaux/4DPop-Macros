//%attributes = {"invisible":true}

C_LONGINT:C283(<>list)




C_LONGINT:C283(<>b1; <>b2; <>b3; <>b4; <>b5; <>b6; <>b7; <>b8; <>b9; <>b10; <>b11; <>b12; <>b13; <>b14; <>b15)

C_LONGINT:C283(<>timerEvent)
C_TEXT:C284(<>Txt_buffer; <>Txt_method)

C_TEXT:C284(<>Txt_Title)

C_BOOLEAN:C305(<>Private_inited)

C_TEXT:C284(<>regexFilePath)

C_PICTURE:C286(<>About_Pict_Displayed)
C_LONGINT:C283(<>About_Lon_Flip; <>About_Lon_AutoHide; <>About_Lon_Image)
C_TEXT:C284(<>About_Txt_Buffer; <>About_Txt_Macro; <>About_Txt_Displayed)

C_BOOLEAN:C305(<>Boo_declarationInited)

C_TEXT:C284(<>About_Txt_Displayed)
ARRAY TEXT:C222(<>tTxt_2D_Declaration_Patterns; 0; 0)
ARRAY LONGINT:C221(<>tLon_Declaration_Types; 0)

ARRAY LONGINT:C221(<>tLon_command; 0)

ARRAY TEXT:C222(<>tTxt_lines; 0)
ARRAY LONGINT:C221(<>tLon_Line_Statut; 0)

ARRAY TEXT:C222(<>tTxt_Patterns; 0)
ARRAY TEXT:C222(<>tTxt_Directive; 0)

ARRAY BOOLEAN:C223(<>tBoo_ListBox; 0)
ARRAY TEXT:C222(<>tTxt_Comments; 0)
ARRAY TEXT:C222(<>tTxt_Labels; 0)

ARRAY TEXT:C222(M_4DPop_tTxt_Buffer; 0)

If (False:C215)
	
	
	If (False:C215)
		C_OBJECT:C1216(declaration_UI; $0)
		C_TEXT:C284(declaration_UI; $1)
		C_OBJECT:C1216(declaration_UI; $2)
	End if 
	
	C_TEXT:C284(codeForCollection; $0)
	C_COLLECTION:C1488(codeForCollection; $1)
	C_TEXT:C284(codeForCollection; $2)
	
	C_TEXT:C284(codeForObject; $0)
	C_OBJECT:C1216(codeForObject; $1)
	C_TEXT:C284(codeForObject; $2)
	
	C_OBJECT:C1216(macro; $0)
	C_TEXT:C284(macro; $1)
	C_OBJECT:C1216(macro; $2)
	
	C_TEXT:C284(localizedControlFlow; $0)
	C_TEXT:C284(localizedControlFlow; $1)
	C_POINTER:C301(localizedControlFlow; $2)
	C_POINTER:C301(localizedControlFlow; $3)
	
	C_TEXT:C284(DOT_NOTATION; $1)
	
	// Private_Boo_Get_Resource
	C_BOOLEAN:C305(Get_resource; $0)
	C_TEXT:C284(Get_resource; $1)
	C_TEXT:C284(Get_resource; $2)
	C_POINTER:C301(Get_resource; $3)
	
	// Private_Boo_Install_Resources
	C_BOOLEAN:C305(Install_resources; $0)
	
	// Private_Txt_Get_Version
	C_TEXT:C284(Get_Version; $0)
	C_TEXT:C284(Get_Version; $1)
	
	// Private_Boo_Set_Preferences
	C_BOOLEAN:C305(_o_Preferences_Set; $0)
	C_TEXT:C284(_o_Preferences_Set; $1)
	C_TEXT:C284(_o_Preferences_Set; $2)
	
	C_LONGINT:C283(Beautifier_init; $0)
	
	// Private_SET_OPTIONS
	C_LONGINT:C283(OPTIONS_SET; ${1})
	
	// Private_Boo_Paste_Regex_Pattern
	C_BOOLEAN:C305(Private_Boo_Paste_Regex_Pattern; $0)
	
	// METHOD_Syntax
	C_TEXT:C284(METHOD_Syntax; $0)
	C_TEXT:C284(METHOD_Syntax; $1)
	C_TEXT:C284(METHOD_Syntax; $2)
	C_TEXT:C284(METHOD_Syntax; $3)
	
	// METHOD_ANALYSE_TO_ARRAYS
	C_TEXT:C284(METHOD_ANALYSE_TO_ARRAYS; $1)
	C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $2)
	C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $3)
	C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $4)
	
	// Private_Methods
	C_TEXT:C284(METHODS; $1)
	C_TEXT:C284(METHODS; $2)
	
	C_TEXT:C284(Util_SPLIT_METHOD; $1)
	C_POINTER:C301(Util_SPLIT_METHOD; $2)
	C_LONGINT:C283(Util_SPLIT_METHOD; $3)
	
	C_LONGINT:C283(util_Lon_Local_in_line; $0)
	C_TEXT:C284(util_Lon_Local_in_line; $1)
	C_POINTER:C301(util_Lon_Local_in_line; $2)
	C_POINTER:C301(util_Lon_Local_in_line; $3)
	C_LONGINT:C283(util_Lon_Local_in_line; $4)
	
	// Private_Txt_Get_Preferences
	C_TEXT:C284(Preferences_Get; $0)
	C_TEXT:C284(Preferences_Get; $1)
	
	// Private_Boo_Install_Regex
	C_BOOLEAN:C305(Install_regex; $0)
	
	C_BOOLEAN:C305(Preferences; $0)
	C_TEXT:C284(Preferences; $1)
	C_TEXT:C284(Preferences; $2)
	C_POINTER:C301(Preferences; $3)
	
	C_TEXT:C284(doc_SET_TYPE_AND_CREATOR; $1)
	C_TEXT:C284(doc_SET_TYPE_AND_CREATOR; $2)
	C_TEXT:C284(doc_SET_TYPE_AND_CREATOR; $3)
	
	// BEAUTIFIER
	C_TEXT:C284(Beautifier; $0)
	C_TEXT:C284(Beautifier; $1)
	C_BOOLEAN:C305(Beautifier; $2)
	
	C_LONGINT:C283(beautifier_Next_semicolon; $0)
	C_TEXT:C284(beautifier_Next_semicolon; $1)
	
	C_TEXT:C284(beautifier_Split_key_value; $0)
	C_TEXT:C284(beautifier_Split_key_value; $1)
	C_LONGINT:C283(beautifier_Split_key_value; $2)
	
	// Private_GET_OPTIONS
	C_LONGINT:C283(OPTIONS_GET; ${1})
	
	// 4DPop_MACROS
	C_POINTER:C301(4DPop_MACROS; ${4})
	C_TEXT:C284(4DPop_MACROS; $1)
	C_TEXT:C284(4DPop_MACROS; $2)
	C_TEXT:C284(4DPop_MACROS; $3)
	
	// M_4DPOP_OBOO_INIT
	C_BOOLEAN:C305(Init; $0)
	C_TEXT:C284(Init; $1)
	
	// Private_Encode_Text
	C_TEXT:C284(Text_Encode; $0)
	C_TEXT:C284(Text_Encode; $1)
	C_TEXT:C284(Text_Encode; $2)
	
	// Private_Decode_Text
	C_TEXT:C284(Text_Decode; $0)
	C_TEXT:C284(Text_Decode; $1)
	C_TEXT:C284(Text_Decode; $2)
	
	// COMMENTS
	C_TEXT:C284(COMMENTS; $1)
	C_TEXT:C284(COMMENTS; $2)
	C_TEXT:C284(COMMENTS; $3)
	
	// Private_INVERT_EXPRESSION
	C_TEXT:C284(INVERT_EXPRESSION; $0)
	C_LONGINT:C283(INVERT_EXPRESSION; ${3})
	C_LONGINT:C283(INVERT_EXPRESSION; $1)
	C_LONGINT:C283(INVERT_EXPRESSION; $2)
	C_LONGINT:C283(INVERT_EXPRESSION; $3)
	C_LONGINT:C283(INVERT_EXPRESSION; $4)
	C_LONGINT:C283(INVERT_EXPRESSION; $5)
	C_LONGINT:C283(INVERT_EXPRESSION; $6)
	
	// Str_gBoo_IsNumeric
	C_BOOLEAN:C305(str_isNumeric; $0)
	C_TEXT:C284(str_isNumeric; $1)
	
	// Doc_gTxt_Add_Folder_To_Path
	C_TEXT:C284(doc_gTxt_Add_Folder_To_Path; $0)
	C_TEXT:C284(doc_gTxt_Add_Folder_To_Path; $1)
	C_TEXT:C284(doc_gTxt_Add_Folder_To_Path; $2)
	C_BOOLEAN:C305(doc_gTxt_Add_Folder_To_Path; $3)
	
	// Doc_gTxt_Add_DocumentToFolder
	C_TEXT:C284(doc_gTxt_Add_DocumentToFolder; $0)
	C_TEXT:C284(doc_gTxt_Add_DocumentToFolder; $1)
	C_TEXT:C284(doc_gTxt_Add_DocumentToFolder; $2)
	
	// PRIVATE_4DPOP_ABOUT
	C_TEXT:C284(ABOUT; $1)
	
	// Str_FindBalencingChar
	C_LONGINT:C283(str_FindBalencingChar; $0)
	C_POINTER:C301(str_FindBalencingChar; $1)
	C_TEXT:C284(str_FindBalencingChar; $2)
	C_TEXT:C284(str_FindBalencingChar; $3)
	C_LONGINT:C283(str_FindBalencingChar; $4)
	
	// Str_gLon_Hex_To_Long
	C_LONGINT:C283(str_gLon_Hex_To_Long; $0)
	C_TEXT:C284(str_gLon_Hex_To_Long; $1)
	
	// Str_hyphenation
	C_TEXT:C284(str_hyphenation; $0)
	C_TEXT:C284(str_hyphenation; $1)
	C_LONGINT:C283(str_hyphenation; $2)
	C_TEXT:C284(str_hyphenation; $3)
	C_TEXT:C284(str_hyphenation; $4)
	
	// Doc_gTxt_Files_And_Folders
	C_TEXT:C284(doc_gTxt_Files_And_Folders; $0)
	C_TEXT:C284(doc_gTxt_Files_And_Folders; $1)
	C_TEXT:C284(doc_gTxt_Files_And_Folders; $2)
	C_TEXT:C284(doc_gTxt_Files_And_Folders; $3)
	C_BOOLEAN:C305(doc_gTxt_Files_And_Folders; $4)
	
	// Doc_gTxt_Resolve_Alias
	C_TEXT:C284(doc_gTxt_Resolve_Alias; $0)
	C_TEXT:C284(doc_gTxt_Resolve_Alias; $1)
	
	// Win_NOT_UNDER_TOOLBAR
	C_LONGINT:C283(win_NOT_UNDER_TOOLBAR; $0)
	
	// Win_title
	C_TEXT:C284(win_title; $0)
	C_LONGINT:C283(win_title; $1)
	
	// Private_Lon_Declaration_Type
	C_LONGINT:C283(Private_Lon_Declaration_Type; $0)
	C_TEXT:C284(Private_Lon_Declaration_Type; $1)
	C_POINTER:C301(Private_Lon_Declaration_Type; $2)
	
	// Private_EXTRACT_LOCAL_VARIABLES
	C_TEXT:C284(EXTRACT_LOCAL_VARIABLES; $1)
	C_POINTER:C301(EXTRACT_LOCAL_VARIABLES; $2)
	
	C_TEXT:C284(SETTINGS; $1)
	
	C_POINTER:C301(4DPop_MACROS_SETTINGS; $1)
	
End if 