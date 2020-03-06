//%attributes = {"invisible":true}
_O_C_STRING:C293(10;$a12_obsolete_alpha)
C_BLOB:C604($Blb_buffer)
C_BOOLEAN:C305($Boo_)
_O_C_INTEGER:C282($Int_old)
C_LONGINT:C283($Lon_cmd;$Lon_end;$Lon_i;$Lon_offset)
C_TEXT:C284($Txt_buffer;$Txt_command;$Txt_referenceLanguage)
C_OBJECT:C1216($o;$Obj_;$Obj_dot;$Obj_dot1;$Obj_dot3;$Obj_empty)
C_OBJECT:C1216($Obj_settings;$Obj_test)
C_COLLECTION:C1488($Col_;$Col_test)

ARRAY BLOB:C1222($tBlb_blob;0)
ARRAY TIME:C1223($tGmt_time;0)
ARRAY OBJECT:C1221($tObj_test;0)

$o:=New object:C1471
$o.$dialog:=New collection:C1472

  //$1:="hello"
  //${2}:="world"

  //$1:=$Obj_test
$Int_old:=0
$a12_obsolete_alpha:="hello"
$Obj_test:=JSON Parse:C1218("{}")
SET BLOB SIZE:C606($Blb_buffer;0)
APPEND TO ARRAY:C911($tObj_test;$Obj_test)
APPEND TO ARRAY:C911($tBlb_blob;$Blb_buffer)
APPEND TO ARRAY:C911($tGmt_time;?00:00:00?)
$Lon_cmd:=1222
ALERT:C41(Command name:C538($Lon_cmd))

For ($Lon_i;1;$Lon_end;$Lon_offset)
	
	ALERT:C41(Command name:C538($Lon_cmd))
	
End for 

For ($Lon_i;1200;2000;1)
	
	$Txt_command:=Command name:C538($Lon_i)
	
	If (OK=1)
		
		CONFIRM:C162($Txt_command)
		
		If (OK=0)
			
			SET TEXT TO PASTEBOARD:C523(String:C10($Lon_i))
			$Lon_i:=MAXLONG:K35:2-1
			
		End if 
		
	Else 
		
		$Lon_i:=MAXLONG:K35:2-1
		
	End if 
End for 

$Txt_referenceLanguage:=OB Get:C1224($Obj_;"reference";Is text:K8:3)

$Obj_:=New object:C1471
$Obj_dot1.$test:=$Txt_buffer

$Obj_dot.key:="hello"

OB SET:C1220($Obj_;\
"$test";"hello")
OB SET:C1220($Obj_;\
"is-compilable";False:C215)

OB SET:C1220($Obj_;\
"$TEST";"hello")

OB SET:C1220($Obj_;\
"is-compilable";False:C215)

  //$COMMENT
  //OB SET($Obj_COMMENT;"test";"hello";"test2";"world")

$Txt_buffer:=OB Get:C1224($Obj_;"test";Is text:K8:3)  //$x
$Txt_buffer:=OB Get:C1224($Obj_;"is-compilable";Is text:K8:3)
$Txt_buffer:=OB Get:C1224($Obj_;"not-compilable";Is text:K8:3)
$Txt_buffer:=OB Get:C1224($Obj_;"$test";Is text:K8:3)
$Txt_buffer:=OB Get:C1224($Obj_;"not_compilable";Is text:K8:3)

$Boo_:=($Obj_dot3.compilable#$Obj_empty)
$Boo_:=OB Is defined:C1231($Obj_;"compilable")
$Boo_:=OB Is defined:C1231($Obj_;"is-compilable")
$Boo_:=OB Is defined:C1231($Obj_;"not-compilable")
$Boo_:=OB Is defined:C1231($Obj_;"$test")

OB SET:C1220($Obj_settings;\
"$test";"hello";\
"test2";"world")

$Col_test:=New collection:C1472

$Col_:=New collection:C1472(1;2;3;4;5)