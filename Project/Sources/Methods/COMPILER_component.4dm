//%attributes = {"invisible":true,"preemptive":"incapable"}
var <>list : Integer

var <>b1; <>b2; <>b3; <>b4; <>b5; <>b6; <>b7; <>b8; <>b9; <>b10; <>b11; <>b12; <>b13; <>b14; <>b15 : Integer

var <>timerEvent : Integer
var <>Txt_buffer; <>Txt_method : Text

var <>Txt_Title : Text

var <>regexFilePath : Text

var <>About_Pict_Displayed : Picture
var <>About_Lon_Flip; <>About_Lon_AutoHide; <>About_Lon_Image : Integer
var <>About_Txt_Buffer; <>About_Txt_Macro; <>About_Txt_Displayed : Text

var <>Boo_declarationInited : Boolean

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

var v1; v2; v3; v4 : Variant

If (False:C215)
	
	
	_O_C_TEXT:C284(codeForCollection; $0)
	
	_O_C_COLLECTION:C1488(codeForCollection; $1)
	_O_C_TEXT:C284(codeForCollection; $2)
	
	_O_C_TEXT:C284(codeForObject; $0)
	_O_C_OBJECT:C1216(codeForObject; $1)
	_O_C_TEXT:C284(codeForObject; $2)
	
	// C_OBJECT(macro; $0)
	// C_TEXT(macro; $1)
	// C_OBJECT(macro; $2)
	
	_O_C_TEXT:C284(_o_localizedControlFlow; $0)
	_O_C_TEXT:C284(_o_localizedControlFlow; $1)
	_O_C_POINTER:C301(_o_localizedControlFlow; $2)
	_O_C_POINTER:C301(_o_localizedControlFlow; $3)
	
	_O_C_TEXT:C284(DOT_NOTATION; $1)
	
	// Private_Boo_Get_Resource
	_O_C_BOOLEAN:C305(Get_resource; $0)
	_O_C_TEXT:C284(Get_resource; $1)
	_O_C_TEXT:C284(Get_resource; $2)
	_O_C_POINTER:C301(Get_resource; $3)
	
	// Private_Boo_Install_Resources
	_O_C_BOOLEAN:C305(Install_resources; $0)
	
	// Private_Txt_Get_Version
	_O_C_TEXT:C284(Get_Version; $0)
	_O_C_TEXT:C284(Get_Version; $1)
	
	// Private_Boo_Set_Preferences
	_O_C_BOOLEAN:C305(_o_Preferences_Set; $0)
	_O_C_TEXT:C284(_o_Preferences_Set; $1)
	_O_C_TEXT:C284(_o_Preferences_Set; $2)
	
	_O_C_LONGINT:C283(Beautifier_init; $0)
	
	// Private_SET_OPTIONS
	_O_C_LONGINT:C283(OPTIONS_SET; ${1})
	
	// Private_Boo_Paste_Regex_Pattern
	_O_C_BOOLEAN:C305(Private_Boo_Paste_Regex_Pattern; $0)
	
	// METHOD_Syntax
	_O_C_TEXT:C284(METHOD_Syntax; $0)
	_O_C_TEXT:C284(METHOD_Syntax; $1)
	_O_C_TEXT:C284(METHOD_Syntax; $2)
	_O_C_TEXT:C284(METHOD_Syntax; $3)
	
	// METHOD_ANALYSE_TO_ARRAYS
	_O_C_TEXT:C284(METHOD_ANALYSE_TO_ARRAYS; $1)
	_O_C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $2)
	_O_C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $3)
	_O_C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $4)
	
	// Private_Methods
	_O_C_TEXT:C284(METHODS; $1)
	_O_C_TEXT:C284(METHODS; $2)
	
	_O_C_TEXT:C284(Util_SPLIT_METHOD; $1)
	_O_C_POINTER:C301(Util_SPLIT_METHOD; $2)
	_O_C_LONGINT:C283(Util_SPLIT_METHOD; $3)
	
	_O_C_LONGINT:C283(util_Lon_Local_in_line; $0)
	_O_C_TEXT:C284(util_Lon_Local_in_line; $1)
	_O_C_POINTER:C301(util_Lon_Local_in_line; $2)
	_O_C_POINTER:C301(util_Lon_Local_in_line; $3)
	_O_C_LONGINT:C283(util_Lon_Local_in_line; $4)
	
	// Private_Txt_Get_Preferences
	_O_C_TEXT:C284(Preferences_Get; $0)
	_O_C_TEXT:C284(Preferences_Get; $1)
	
	// Private_Boo_Install_Regex
	_O_C_BOOLEAN:C305(Install_regex; $0)
	
	_O_C_BOOLEAN:C305(_o_Preferences; $0)
	_O_C_TEXT:C284(_o_Preferences; $1)
	_O_C_TEXT:C284(_o_Preferences; $2)
	_O_C_POINTER:C301(_o_Preferences; $3)
	
	// BEAUTIFIER
	_O_C_TEXT:C284(_o_Beautifier; $0)
	_O_C_TEXT:C284(_o_Beautifier; $1)
	_O_C_BOOLEAN:C305(_o_Beautifier; $2)
	
	_O_C_LONGINT:C283(_o_beautifier_Next_semicolon; $0)
	_O_C_TEXT:C284(_o_beautifier_Next_semicolon; $1)
	
	_O_C_TEXT:C284(_o_beautifier_Split_key_value; $0)
	_O_C_TEXT:C284(_o_beautifier_Split_key_value; $1)
	_O_C_LONGINT:C283(_o_beautifier_Split_key_value; $2)
	
	// Private_GET_OPTIONS
	_O_C_LONGINT:C283(OPTIONS_GET; ${1})
	
	// COMMENTS
	_O_C_TEXT:C284(COMMENTS; $1)
	_O_C_TEXT:C284(COMMENTS; $2)
	_O_C_TEXT:C284(COMMENTS; $3)
	
	// Private_INVERT_EXPRESSION
	_O_C_TEXT:C284(INVERT_EXPRESSION; $0)
	_O_C_LONGINT:C283(INVERT_EXPRESSION; ${3})
	_O_C_LONGINT:C283(INVERT_EXPRESSION; $1)
	_O_C_LONGINT:C283(INVERT_EXPRESSION; $2)
	_O_C_LONGINT:C283(INVERT_EXPRESSION; $3)
	_O_C_LONGINT:C283(INVERT_EXPRESSION; $4)
	_O_C_LONGINT:C283(INVERT_EXPRESSION; $5)
	_O_C_LONGINT:C283(INVERT_EXPRESSION; $6)
	
	// Str_gBoo_IsNumeric
	_O_C_BOOLEAN:C305(_o_isNumeric; $0)
	_O_C_TEXT:C284(_o_isNumeric; $1)
	
	// PRIVATE_4DPOP_ABOUT
	_O_C_TEXT:C284(ABOUT; $1)
	
	// Str_gLon_Hex_To_Long
	_O_C_LONGINT:C283(str_gLon_Hex_To_Long; $0)
	_O_C_TEXT:C284(str_gLon_Hex_To_Long; $1)
	
	// Str_hyphenation
	_O_C_TEXT:C284(str_hyphenation; $0)
	_O_C_TEXT:C284(str_hyphenation; $1)
	_O_C_LONGINT:C283(str_hyphenation; $2)
	_O_C_TEXT:C284(str_hyphenation; $3)
	_O_C_TEXT:C284(str_hyphenation; $4)
	
	// Doc_gTxt_Files_And_Folders
	_O_C_TEXT:C284(_o_Files_And_Folders; $0)
	_O_C_TEXT:C284(_o_Files_And_Folders; $1)
	_O_C_TEXT:C284(_o_Files_And_Folders; $2)
	_O_C_TEXT:C284(_o_Files_And_Folders; $3)
	_O_C_BOOLEAN:C305(_o_Files_And_Folders; $4)
	
	// Win_NOT_UNDER_TOOLBAR
	_O_C_LONGINT:C283(win_NOT_UNDER_TOOLBAR; $0)
	
	// Win_title
	_O_C_TEXT:C284(win_title; $0)
	_O_C_LONGINT:C283(win_title; $1)
	
	// Private_Lon_Declaration_Type
	_O_C_LONGINT:C283(Private_Lon_Declaration_Type; $0)
	_O_C_TEXT:C284(Private_Lon_Declaration_Type; $1)
	_O_C_POINTER:C301(Private_Lon_Declaration_Type; $2)
	
	// Private_EXTRACT_LOCAL_VARIABLES
	_O_C_TEXT:C284(_o_EXTRACT_LOCAL_VARIABLES; $1)
	_O_C_POINTER:C301(_o_EXTRACT_LOCAL_VARIABLES; $2)
	
End if 