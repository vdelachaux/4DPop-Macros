//%attributes = {"invisible":true,"preemptive":"capable"}
  //1220
C_LONGINT:C283($Lon_height;$Lon_id;$Lon_r;$Lon_viewPortHeight;$Lon_viewPortWidth;$Lon_width)
C_LONGINT:C283($Lon_x;$Lon_y)
C_PICTURE:C286($Pic_buffer)
C_REAL:C285($Num_tx;$Num_ty)
C_TEXT:C284($Dom_canvas;$Dom_g;$Dom_rect;$Dom_root;$Svg_root;$Txt_class)
C_TEXT:C284($Txt_ID;$Txt_transform;$Txt_type)
C_OBJECT:C1216($Obj_buffer)

OB SET:C1220($Obj_buffer;\
"id";$Lon_id;\
"class";$Txt_class;\
"x";$Lon_x-(10/2);\
"y";$Lon_y)

$Dom_rect:=DOM Create XML element:C865($Dom_root;"rect";\
"id";$Lon_id;\
"class";$Txt_class;\
"x";$Lon_x-(10/2);\
"y";$Lon_y;\
"transform";$Txt_transform;\
"width";$Lon_width;\
"height";$Lon_height;\
"editor:group";"";\
"editor:object-type";$Txt_type;\
"editor:object-id";$Lon_id;\
"editor:x";$Lon_x;\
"editor:y";$Lon_y;\
"editor:width";$Lon_width;\
"editor:height";$Lon_height;\
"editor:tx";$Lon_x;\
"editor:ty";$Lon_y;\
"editor:sx";$Lon_x;\
"editor:sy";$Lon_y;\
"editor:cx";$Lon_x;\
"editor:cy";$Lon_y;\
"editor:r";$Lon_r;\
"shape-rendering";"geometricPrecision")  //test

$Dom_rect:=DOM Create XML element:C865($Dom_root;"rect";\
"id";$Lon_id;\
"class";$Txt_class;\
"x";$Lon_x-(10/2);\
"y";$Lon_y;\
"transform";$Txt_transform;\
"width";$Lon_width;\
"height";$Lon_height;\
"editor:group";"";\
"editor:object-type";$Txt_type;\
"editor:object-id";$Lon_id;\
"editor:x";$Lon_x;\
"editor:y";$Lon_y;\
"editor:width";$Lon_width;\
"editor:height";$Lon_height;\
"editor:tx";$Lon_x;\
"editor:ty";$Lon_y;\
"editor:sx";$Lon_x;\
"editor:sy";$Lon_y;\
"editor:cx";$Lon_x;\
"editor:cy";$Lon_y;\
"editor:r";$Lon_r;\
"shape-rendering";"geometricPrecision")

DOM SET XML ATTRIBUTE:C866($Dom_rect;\
"id";$Lon_id;\
"class";$Txt_class;\
"x";$Lon_x-(10/2);\
"y";$Lon_y;\
"transform";$Txt_transform)  //comment

DOM SET XML ATTRIBUTE:C866($Dom_rect;\
"id";$Lon_id;\
"class";$Txt_class;\
"x";$Lon_x;\
"y";$Lon_y;\
"transform";$Txt_transform)

DOM SET XML ATTRIBUTE:C866($Dom_rect;\
"id";$Lon_id)

SVG SET ATTRIBUTE:C1055(*;"test";"id";\
"class";$Txt_class;\
"x";$Lon_x-(10/2);\
"y";$Lon_y)

SVG SET ATTRIBUTE:C1055($Dom_root;"id";\
"class";$Txt_class;\
"x";$Lon_x-(10/2);\
"y";$Lon_y)

$Dom_rect:=DOM Create XML element:C865($Dom_root;"rect";\
"id";$Lon_id;\
"class";$Txt_class;\
"test";OB Get:C1224($Obj_buffer;"test";Is text:K8:3))

$Dom_rect:=DOM Create XML element:C865($Dom_root;"rect";\
"test";OB Get:C1224($Obj_buffer;"test";Is text:K8:3);\
"rect";"id")

$Dom_rect:=DOM Create XML element:C865($Dom_root;"rect";\
"class";$Txt_class;\
"choose";Choose:C955($Lon_id>0;"up";"down");\
"rect";"id")

SVG SET ATTRIBUTE:C1055(*;"test";"id";\
"class";Choose:C955($Lon_id>0;"up";"down");\
"x";$Lon_x-(10/2);\
"y";$Lon_y)

OB SET:C1220($Obj_buffer;\
"property";"value";\
"property1";"value1";\
"property2";"value2";\
"property3";"value3")

OB SET:C1220($Obj_buffer;\
"property";12-(10*2);\
"property1";"value1";\
"property2";"value2";\
"property3";"value3")  //test2

OB SET:C1220($Obj_buffer;\
"property";"value")

DOM SET XML ATTRIBUTE:C866($Dom_root;\
"version";"1.1";\
"id";"svg";\
"width";$Lon_viewPortWidth;\
"height";$Lon_viewPortHeight;\
"viewport-fill";"#0000FF";\
"viewport-fill-opacity";0)

SVG SET ATTRIBUTE:C1055(*;"test";"id";\
"class";Choose:C955($Lon_id>0;"up";"down");\
"x";$Lon_x-(10/2);\
"y";$Lon_y)

SVG SET ATTRIBUTE:C1055(*;"test";"id";\
"class";Choose:C955($Lon_id>0;"up";"down");\
"x";$Lon_x-(10/2);\
"y";$Lon_y;\
*)

SVG SET ATTRIBUTE:C1055($Pic_buffer;"id";\
"class";Choose:C955($Lon_id>0;"up";"down");\
"x";$Lon_x-(10/2);\
"y";$Lon_y)

SVG SET ATTRIBUTE:C1055($Pic_buffer;"id";\
"class";Choose:C955($Lon_id>0;"up";"down");\
"x";$Lon_x-(10/2);\
"y";$Lon_y;\
*)

DOM SET XML ATTRIBUTE:C866($Svg_root;\
"xmlns:svg";"http://www.w3.org/2000/svg";\
"xmlns:xlink";"http://www.w3.org/1999/xlink";\
"xmlns:editor";"http://www.4d.com/2014/editor")

$Dom_rect:=DOM Create XML element:C865(DOM Find XML element by ID:C1010($Dom_root;$Txt_ID);"rect";\
"class";$Txt_class;\
"choose";Choose:C955($Lon_id>0;"up";"down");\
"rect";"id")

$Dom_rect:=DOM Create XML element:C865($Dom_root;"rect";\
"id";$Lon_id;\
"class";$Txt_class;\
"test";OB Get:C1224($Obj_buffer;"test";Is text:K8:3))

$Dom_rect:=DOM Create XML element:C865($Dom_root;"rect";\
"test";OB Get:C1224($Obj_buffer;"test";Is text:K8:3);\
"rect";"id")

$Dom_rect:=DOM Create XML element:C865($Dom_root;"rect";\
"class";$Txt_class;\
"choose";Choose:C955($Lon_id>0;"up";"down");\
"rect";"id")

$Dom_g:=DOM Create XML element:C865($Dom_canvas;"g";\
"id";OB Get:C1224($Obj_buffer;"select-prefix";Is text:K8:3)+$Txt_ID;\
"transform";"translate("+String:C10($Num_tx;"&xml")+","+String:C10($Num_ty;"&xml")+")";\
"editor:object-type";"";\
"editor:object-id";"")

$Dom_g:=DOM Create XML element:C865($Dom_canvas;"g";\
"transform";"translate("+String:C10($Num_tx;"&xml")+","+String:C10($Num_ty;"&xml")+")";\
"id";$Txt_ID)

  //comment above before tests
  //DOM SET XML ATTRIBUTE($Svg_root;"xmlns:svg";"http://www.w3.org/2000/svg";"xmlns:xlink";"http://www.w3.org/1999/xlink";"xmlns:editor";"http://www.4d.com/2014/editor")

$Obj_buffer:=New object:C1471("property";"value")

$Obj_buffer:=New object:C1471("property";"value";"property2";"value")