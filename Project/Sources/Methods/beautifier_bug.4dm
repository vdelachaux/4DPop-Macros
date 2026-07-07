//%attributes = {}
// Http://something
var $t : Text:="http://something"

DOM SET XML ATTRIBUTE:C866($t; \
"xmlns:svg"; "http://www.w3.org/2000/svg"; \
"xmlns:xlink"; "http://www.w3.org/1999/xlink"; \
"xmlns:editor"; "http://www.4d.com/2014/editor")  // Http://something

$t:="hello world"
var $x:=$t
var $z:=$x


