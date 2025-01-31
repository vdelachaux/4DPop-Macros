//%attributes = {}

//$line:="$o:=New object(\\\r\"property1\"; 1;\\\r\"property2\"; 2)"

/* 

$o:=New object(\
"property1"; 1; \
"property2"; 2)

A tranfomer en 

$o : Object:={\
property1: "value1"; \
property2: "value2"; \
property3: "value3"; \
property4: "value4"; \
property5: "value5"}

*/

/* 
remplacer New object( par {
pour chque clef/valeur : 
 - supprimer le premier guillemet
 - remplacer "; par :
remplacer le ) final par }

*/

var $o:=New object:C1471(\
"x"; 0; \
"y"; 0; \
"width"; "auto"; \
"height"; "auto")


$o:=New object:C1471("x"; 0; "y"; 0; "width"; "auto"; "height"; "auto")