  // ----------------------------------------------------
  // Method : CREATE_BUTTON.source
  // Created 01/06/10 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_PICTURE:C286($buffer)
C_POINTER:C301($icon32;$source)

  // ----------------------------------------------------
  // Initializations
$source:=OBJECT Get pointer:C1124(Object current:K67:2)
$icon32:=OBJECT Get pointer:C1124(Object named:K67:5;"32")

  // ----------------------------------------------------

CREATE THUMBNAIL:C679($source->;$buffer;32;32)
COMBINE PICTURES:C987($icon32->;$buffer;Vertical concatenation:K61:9;$buffer;0;32)
COMBINE PICTURES:C987($icon32->;$icon32->;Vertical concatenation:K61:9;$buffer;0;64)
TRANSFORM PICTURE:C988($buffer;Fade to grey scale:K61:6)
COMBINE PICTURES:C987($icon32->;$icon32->;Vertical concatenation:K61:9;$buffer;0;96)