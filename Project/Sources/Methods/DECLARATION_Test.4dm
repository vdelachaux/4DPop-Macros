//%attributes = {"invisible":true}
//C_BLOB($Blb_buffer)
//C_BOOLEAN($Boo_)
//C_LONGINT($Int_old;$Lon_cmd;$Lon_end;$Lon_i;$Lon_offset)
//C_TEXT($Txt_buffer;$Txt_command;$Txt_referenceLanguage)
//C_OBJECT($Obj_;$Obj_dot;$Obj_dot1;$Obj_dot3;$Obj_empty;$Obj_settings)
//C_OBJECT($Obj_test)
//C_COLLECTION($Col_;$c)
//C_TEXT($a12_obsolete_alpha)

ARRAY BLOB:C1222($tBlb_blob; 0)
ARRAY TIME:C1223($tGmt_time; 0x0000)

//ARRAY OBJECT($tObj_test;0)

C_COLLECTION:C1488
var $1 : Text
$1:="hello"

//${3}:="world"
C_BOOLEAN:C305($2; $3)

APPEND TO ARRAY:C911($tObj_test; ${10})

$_integer:=10
$_maxlong:=MAXLONG:K35:2

$_real:=12.5
$_radian:=Radian:K30:3

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
	
	ALERT:C41(Command name:C538($Lon_cmd))
	
End for 

For ($Lon_i; 1200; 2000; 1)
	
	$Txt_command:=Command name:C538($Lon_i)
	
	If (OK=1)
		
		CONFIRM:C162($Txt_command)
		
		If (OK=0)
			
			SET TEXT TO PASTEBOARD:C523(String:C10($Lon_i))
			$_stop:=MAXLONG:K35:2-1
			
		End if 
		
	Else 
		
		$Lon_i:=MAXLONG:K35:2-1
		
	End if 
End for 

$Txt_referenceLanguage:=OB Get:C1224($Obj_; "reference"; Is text:K8:3)

$_o:=New object:C1471
$_o1.key:="hello"
$_o2.$test:=$Txt_buffer

OB SET:C1220($_o3; \
"$test"; "hello")
OB SET:C1220($_o4; \
"is-compilable"; False:C215)

OB SET:C1220($_o5; \
"$TEST"; "hello")

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