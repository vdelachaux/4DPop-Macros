//%attributes = {"invisible":true,"preemptive":"capable"}
////%W-518.1
//COPY ARRAY($icons; $3->)
////%W+518.1


//comment

var $i : Integer  //tset
var $i2 : Integer:=2
var $i3:=2
var $o : cs:C1710.beautifier
//var $i : Integer
var $beautifier : cs:C1710.beautifier:=cs:C1710.beautifier.new()

$i:=2
$o:=cs:C1710.beautifier.new()

var $z

var $macro:=cs:C1710.macro.new()

If ($macro.isMacroProcess)
	
	// MARK: Install menu bar to allow Copy - Paste
	cs:C1710.menuBar.new().defaultMinimalMenuBar().set()
	
End if 


/*
//comment

var $i : Integer  //tset
var $i2 : Integer:=2
var $i3:=2
var $o : cs.beautifier
//var $i : Integer
var $beautifier : cs.beautifier:=cs.beautifier.new()

$i:=2
$o:=cs.beautifier.new()
*/

//var $1 : Text
//var $2; $3 : Boolean

////APPEND TO ARRAY($tObj_test; ${10}->)

//var $4; $5 : Collection
//var $6

///* -----

//C_BOOLEAN($9)

///* -----

//C_BOOLEAN($8)

//-----*/
//-----*/

//$_pathToObject:=Path to object($_x)

//var $7; $_pointer : Pointer

//$_pointer:=->$7

//var $0 : Object

//For ($i; 1; Count parameters; 1)

//$v:=${$i}

//End for

//$_form:=Form

//$_text:="Hello world"

//$_integer:=10
//$_maxlong:=MAXLONG

//$_real:=12.5
//$_radian:=Radian

//$_false:=False
//$_true:=True
//$_Unknown:=TrueMethod

//$_parse:=JSON Parse("{}")

//$_time:=?00:00:00?
//$_date:=!00-00-00!

//$_collection:=New collection

//For ($_compteur; $_debut; $_fin; $_pas)

//$_commandName:=Command name($_compteur)

//If (OK=1)

//CONFIRM($_commandName)

//If (OK=0)

//SET TEXT TO PASTEBOARD(String($_compteur))
//$_stop:=MAXLONG-1

//End if

//Else

//$_compteur:=MAXLONG-1

//End if
//End for

//var $_variant : Variant
//var $_variantWithoutType

//$_o:=New object()
//$_o1.key:=$_o
//$_o2.$test:=$Txt_buffer

//OB SET($_o3; \
"$test"; "hello")

//OB SET($_o4; \
"is-compilable"; False)

//OB SET($_o5; \
"$TEST"; "hello")

//SET BLOB SIZE($_blob; 0)
//APPEND TO ARRAY($_object; $Obj_test)

//ARRAY LONGINT($_arrayInteger; 0x0000)

//ARRAY BLOB($_arrayBlob; 0; 0)
//$_arrayBlob{0}{0}:=$_blob

//ARRAY TIME($_arrayTime; 0)
//APPEND TO ARRAY($_arrayTime; ?00:00:00?)

//$Txt_referenceLanguage:=OB Get($_o6; "reference"; Is text)

////COMMENT
////OB SET($Obj_COMMENT;"test";"hello";"test2";"world")

//$Txt_buffer:=OB Get($object; "test"; Is text)  //$x

//$Boo_:=($_dot.compilable#$Obj_empty)
//$_b:=OB Is defined($Obj_; "compilable")

//OB SET($_settings; \
"$test"; "hello"; \
"test2"; "world")

/*
//comment

var $i : Integer  //tset
var $i2 : Integer:=2
var $i3:=2
var $o : cs.beautifier
//var $i : Integer
var $beautifier : cs.beautifier:=cs.beautifier.new()

$i:=2
$o:=cs.beautifier.new()
*/

//var $1 : Text
//var $2; $3 : Boolean

////APPEND TO ARRAY($tObj_test; ${10}->)

//var $4; $5 : Collection
//var $6

///* -----

//C_BOOLEAN($9)

///* -----

//C_BOOLEAN($8)

//-----*/
//-----*/

//$_pathToObject:=Path to object($_x)

//var $7; $_pointer : Pointer

//$_pointer:=->$7

//var $0 : Object

//For ($i; 1; Count parameters; 1)

//$v:=${$i}

//End for

//$_form:=Form

//$_text:="Hello world"

//$_integer:=10
//$_maxlong:=MAXLONG

//$_real:=12.5
//$_radian:=Radian

//$_false:=False
//$_true:=True
//$_Unknown:=TrueMethod

//$_parse:=JSON Parse("{}")

//$_time:=?00:00:00?
//$_date:=!00-00-00!

//$_collection:=New collection

//For ($_compteur; $_debut; $_fin; $_pas)

//$_commandName:=Command name($_compteur)

//If (OK=1)

//CONFIRM($_commandName)

//If (OK=0)

//SET TEXT TO PASTEBOARD(String($_compteur))
//$_stop:=MAXLONG-1

//End if

//Else

//$_compteur:=MAXLONG-1

//End if
//End for

//var $_variant : Variant
//var $_variantWithoutType

//$_o:=New object()
//$_o1.key:=$_o
//$_o2.$test:=$Txt_buffer

//OB SET($_o3; \
"$test"; "hello")

//OB SET($_o4; \
"is-compilable"; False)

//OB SET($_o5; \
"$TEST"; "hello")

//SET BLOB SIZE($_blob; 0)
//APPEND TO ARRAY($_object; $Obj_test)

//ARRAY LONGINT($_arrayInteger; 0x0000)

//ARRAY BLOB($_arrayBlob; 0; 0)
//$_arrayBlob{0}{0}:=$_blob

//ARRAY TIME($_arrayTime; 0)
//APPEND TO ARRAY($_arrayTime; ?00:00:00?)

//$Txt_referenceLanguage:=OB Get($_o6; "reference"; Is text)

////COMMENT
////OB SET($Obj_COMMENT;"test";"hello";"test2";"world")

//$Txt_buffer:=OB Get($object; "test"; Is text)  //$x

//$Boo_:=($_dot.compilable#$Obj_empty)
//$_b:=OB Is defined($Obj_; "compilable")

//OB SET($_settings; \
"$test"; "hello"; \
"test2"; "world")