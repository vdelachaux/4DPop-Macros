//%attributes = {"invisible":true,"preemptive":"capable"}
  //1220
C_PICTURE:C286($Pic_buffer)
C_TEXT:C284($Dom_buffer)
C_OBJECT:C1216($Obj_buffer)
C_VARIANT:C1683($v;$vv)

$v:=""
$vv:=""


OB SET:C1220($Obj_buffer;"property";"value";"property1";"value1";"property2";"valu2";"property3";"value3")

OB SET:C1220($Obj_buffer;"property";12-(10*2);"property1";"value1";"property2";"valu2";"property3";"value3")  //test2

OB SET:C1220($Obj_buffer;"property";"value")

SVG SET ATTRIBUTE:C1055(*;"toto";"id";"attribute";"value";"attribute1";"value1";"attribute2";"value2")

SVG SET ATTRIBUTE:C1055($Pic_buffer;"id";"attribute";"value";"attribute1";"value1";"attribute2";"value2")

DOM SET XML ATTRIBUTE:C866($Dom_buffer;"attribute";"value";"attribute1";"value1";"attribute2";"value2")