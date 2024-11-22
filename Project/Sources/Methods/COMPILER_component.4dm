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
	
	C_TEXT:C284(_o_localizedControlFlow; $0)
	C_TEXT:C284(_o_localizedControlFlow; $1)
	C_POINTER:C301(_o_localizedControlFlow; $2)
	C_POINTER:C301(_o_localizedControlFlow; $3)
	
	// Private_Boo_Set_Preferences
	C_BOOLEAN:C305(_o_Preferences_Set; $0)
	C_TEXT:C284(_o_Preferences_Set; $1)
	C_TEXT:C284(_o_Preferences_Set; $2)
	
	C_LONGINT:C283(Beautifier_init; $0)
	
	// Private_SET_OPTIONS
	C_LONGINT:C283(OPTIONS_SET; ${1})
	
	// Private_Boo_Paste_Regex_Pattern
	C_BOOLEAN:C305(Private_Boo_Paste_Regex_Pattern; $0)
	
	// METHOD_ANALYSE_TO_ARRAYS
	C_TEXT:C284(METHOD_ANALYSE_TO_ARRAYS; $1)
	C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $2)
	C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $3)
	C_POINTER:C301(METHOD_ANALYSE_TO_ARRAYS; $4)
	
	// Private_Methods
	C_TEXT:C284(METHODS; $1)
	C_TEXT:C284(METHODS; $2)
	
	C_TEXT:C284(_o_Util_SPLIT_METHOD; $1)
	C_POINTER:C301(_o_Util_SPLIT_METHOD; $2)
	C_LONGINT:C283(_o_Util_SPLIT_METHOD; $3)
	
	C_LONGINT:C283(_o_util_Lon_Local_in_line; $0)
	C_TEXT:C284(_o_util_Lon_Local_in_line; $1)
	C_POINTER:C301(_o_util_Lon_Local_in_line; $2)
	C_POINTER:C301(_o_util_Lon_Local_in_line; $3)
	C_LONGINT:C283(_o_util_Lon_Local_in_line; $4)
	
	// Private_Txt_Get_Preferences
	C_TEXT:C284(Preferences_Get; $0)
	C_TEXT:C284(Preferences_Get; $1)
	
	// Private_Boo_Install_Regex
	C_BOOLEAN:C305(Install_regex; $0)
	
	C_BOOLEAN:C305(_o_Preferences; $0)
	C_TEXT:C284(_o_Preferences; $1)
	C_TEXT:C284(_o_Preferences; $2)
	C_POINTER:C301(_o_Preferences; $3)
	
	// Private_GET_OPTIONS
	C_LONGINT:C283(OPTIONS_GET; ${1})
	
	
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
	C_BOOLEAN:C305(_o_isNumeric; $0)
	C_TEXT:C284(_o_isNumeric; $1)
	
	// Str_hyphenation
	C_TEXT:C284(str_hyphenation; $0)
	C_TEXT:C284(str_hyphenation; $1)
	C_LONGINT:C283(str_hyphenation; $2)
	C_TEXT:C284(str_hyphenation; $3)
	C_TEXT:C284(str_hyphenation; $4)
	
	// Doc_gTxt_Files_And_Folders
	C_TEXT:C284(_o_Files_And_Folders; $0)
	C_TEXT:C284(_o_Files_And_Folders; $1)
	C_TEXT:C284(_o_Files_And_Folders; $2)
	C_TEXT:C284(_o_Files_And_Folders; $3)
	C_BOOLEAN:C305(_o_Files_And_Folders; $4)
	
	// Win_NOT_UNDER_TOOLBAR
	C_LONGINT:C283(win_NOT_UNDER_TOOLBAR; $0)
	
	// Win_title
	C_TEXT:C284(_o_win_title; $0)
	C_LONGINT:C283(_o_win_title; $1)
	
	// Private_Lon_Declaration_Type
	C_LONGINT:C283(Private_Lon_Declaration_Type; $0)
	C_TEXT:C284(Private_Lon_Declaration_Type; $1)
	C_POINTER:C301(Private_Lon_Declaration_Type; $2)
	
	// Private_EXTRACT_LOCAL_VARIABLES
	C_TEXT:C284(_o_EXTRACT_LOCAL_VARIABLES; $1)
	C_POINTER:C301(_o_EXTRACT_LOCAL_VARIABLES; $2)
	
End if 