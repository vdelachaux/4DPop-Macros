//%attributes = {"invisible":true}

var $1 : Text
C_BOOLEAN:C305($2; $3)

var $4,$5 : Collection
var $6

/* -----

C_BOOLEAN($9)

/* -----

C_BOOLEAN($8)

-----*/
-----*/

var $7,$_7 : Pointer

$_7:=->$7

ARRAY BLOB:C1222($tBlb_blob; 0)
ARRAY TIME:C1223($tGmt_time; 0x0000)

APPEND TO ARRAY:C911($tObj_test; ${10})

C_OBJECT:C1216($0)

$_text:="Hello world"

$_integer:=10
$_maxlong:=MAXLONG:K35:2

$_real:=12.5
$_radian:=Radian:K30:3

$_false:=False:C215
$_true:=True:C214

$_parse:=JSON Parse:C1218("{}")

SET BLOB SIZE:C606($_blob; 0)
APPEND TO ARRAY:C911($_object; $Obj_test)

APPEND TO ARRAY:C911($tBlb_blob; $Blb_buffer)
APPEND TO ARRAY:C911($tGmt_time; ?00:00:00?)

$_time:=?00:00:00?
$_date:=!00-00-00!

$_c:=New collection:C1472
$_cc:=New collection:C1472(1; 2; 3; 4; 5)

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

$_o:=New object:C1471
$_o1.key:="hello"
$_o2.$test:=$Txt_buffer

OB SET:C1220($_o3; \
"$test"; "hello")

OB SET:C1220($_o4; \
"is-compilable"; False:C215)

OB SET:C1220($_o5; \
"$TEST"; "hello")

$Txt_referenceLanguage:=OB Get:C1224($_o6; "reference"; Is text:K8:3)

//$COMMENT
//OB SET($Obj_COMMENT;"test";"hello";"test2";"world")

$Txt_buffer:=OB Get:C1224($Obj_; "test"; Is text:K8:3)  //$x
$Txt_buffer:=OB Get:C1224($Obj_; "is-compilable"; Is text:K8:3)
$Txt_buffer:=OB Get:C1224($Obj_; "not-compilable"; Is text:K8:3)
$Txt_buffer:=OB Get:C1224($Obj_; "$test"; Is text:K8:3)
$Txt_buffer:=OB Get:C1224($Obj_; "not_compilable"; Is text:K8:3)

$Boo_:=($Obj_dot3.compilable#$Obj_empty)
$Boo_:=OB Is defined:C1231($Obj_; "compilable")
$Boo_:=OB Is defined:C1231($Obj_; "is-compilable")
$Boo_:=OB Is defined:C1231($Obj_; "not-compilable")
$Boo_:=OB Is defined:C1231($Obj_; "$test")

OB SET:C1220($Obj_settings; \
"$test"; "hello"; \
"test2"; "world")