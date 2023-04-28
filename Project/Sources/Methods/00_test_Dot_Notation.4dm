//%attributes = {"invisible":true,"preemptive":"capable"}
C_BOOLEAN:C305($Boo_)
C_TEXT:C284($Txt_buffer;$Txt_referenceLanguage)
C_OBJECT:C1216($Obj_)


$Txt_referenceLanguage:=OB Get:C1224($Obj_;"reference";Is text:K8:3)


$Obj_:=New object:C1471
$Obj_.$test:=$Txt_buffer
OB SET:C1220($Obj_;\
"$test";"hello")
OB SET:C1220($Obj_;\
"is-compilable";False:C215)
OB SET:C1220($Obj_;\
"$test";"hello")
OB SET:C1220($Obj_;\
"is-compilable";False:C215)
OB SET:C1220($Obj_;\
"test";"hello";\
"test2";"world")
$Txt_buffer:=$Obj_.test

  //$Txt_buffer:=$Obj_.is-compilable
  //$Txt_buffer:=$Obj_.not-compilable
$Txt_buffer:=$Obj_.$test
$Txt_buffer:=$Obj_.not_compilable
$Boo_:=($Obj_.compilable#Null:C1517)
$Boo_:=OB Is defined:C1231($Obj_;"compilable")
$Boo_:=OB Is defined:C1231($Obj_;"is-compilable")
$Boo_:=OB Is defined:C1231($Obj_;"not-compilable")
$Boo_:=OB Is defined:C1231($Obj_;"$test")