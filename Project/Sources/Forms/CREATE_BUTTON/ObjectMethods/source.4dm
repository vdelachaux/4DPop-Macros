  // ----------------------------------------------------
  // Method : CREATE_BUTTON.source
  // Created 01/06/10 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_PICTURE:C286($Pic_buffer)
C_POINTER:C301($Ptr_32;$Ptr_source)

  // ----------------------------------------------------
  // Initialisations
$Ptr_source:=OBJECT Get pointer:C1124(Object current:K67:2)
$Ptr_32:=OBJECT Get pointer:C1124(Object named:K67:5;"32")

  // ----------------------------------------------------

CREATE THUMBNAIL:C679($Ptr_source->;$Pic_buffer;32;32)
COMBINE PICTURES:C987($Ptr_32->;$Pic_buffer;Vertical concatenation:K61:9;$Pic_buffer;0;32)
COMBINE PICTURES:C987($Ptr_32->;$Ptr_32->;Vertical concatenation:K61:9;$Pic_buffer;0;64)
TRANSFORM PICTURE:C988($Pic_buffer;Fade to grey scale:K61:6)
COMBINE PICTURES:C987($Ptr_32->;$Ptr_32->;Vertical concatenation:K61:9;$Pic_buffer;0;96)