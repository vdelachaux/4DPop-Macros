//%attributes = {"invisible":true,"preemptive":"capable"}
var $1 : Text
var $2; $3 : Boolean

//APPEND TO ARRAY($tObj_test; ${10}->)

var $4; $5 : Collection
var $6

/* -----

C_BOOLEAN($9)

/* -----

C_BOOLEAN($8)

-----*/
-----*/

$_pathToObject:=Path to object:C1547($_x)

var $7; $_pointer : Pointer

$_pointer:=->$7

var $0 : Object

For ($i; 1; Count parameters:C259; 1)
	
	$v:=${$i}
	
End for 

$_form:=Form:C1466

$_text:="Hello world"

$_integer:=10
$_maxlong:=MAXLONG:K35:2

$_real:=12.5
$_radian:=Radian:K30:3

$_false:=False:C215
$_true:=True:C214
$_Unknown:=TrueMethod

$_parse:=JSON Parse:C1218("{}")

$_time:=?00:00:00?
$_date:=!00-00-00!

$_collection:=New collection:C1472

For ($_compteur; $_debut; $_fin; $_pas)
	
	$_commandName:=Command name:C538($_compteur)
	
	If (OK=1)
		
		CONFIRM:C162($_commandName)
		
		If (OK=0)
			
			SET TEXT TO PASTEBOARD:C523(String:C10($_compteur))
			$_stop:=MAXLONG:K35:2-1
			
		End if 
		
	Else 
		
		$_compteur:=MAXLONG:K35:2-1
		
	End if 
End for 

var $_variant : Variant
var $_variantWithoutType

$_o:=New object:C1471()
$_o1.key:=$_o
$_o2.$test:=$Txt_buffer

OB SET:C1220($_o3; \
"$test"; "hello")

OB SET:C1220($_o4; \
"is-compilable"; False:C215)

OB SET:C1220($_o5; \
"$TEST"; "hello")

SET BLOB SIZE:C606($_blob; 0)
APPEND TO ARRAY:C911($_object; $Obj_test)

ARRAY LONGINT:C221($_arrayInteger; 0x0000)

ARRAY BLOB:C1222($_arrayBlob; 0; 0)
$_arrayBlob{0}{0}:=$_blob

ARRAY TIME:C1223($_arrayTime; 0)
APPEND TO ARRAY:C911($_arrayTime; ?00:00:00?)


$Txt_referenceLanguage:=OB Get:C1224($_o6; "reference"; Is text:K8:3)

//COMMENT
//OB SET($Obj_COMMENT;"test";"hello";"test2";"world")

$Txt_buffer:=OB Get:C1224($object; "test"; Is text:K8:3)  //$x

$Boo_:=($_dot.compilable#$Obj_empty)
$_b:=OB Is defined:C1231($Obj_; "compilable")

OB SET:C1220($_settings; \
"$test"; "hello"; \
"test2"; "world")
