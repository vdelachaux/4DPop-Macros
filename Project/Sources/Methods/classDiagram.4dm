//%attributes = {}
var $key; $code; $name : Text
var $i; $j : Integer
var $attribute; $classes; $class : Object
var $c : Collection
var $regex : cs:C1710.regex

ARRAY TEXT:C222($methods; 0)

METHOD GET PATHS:C1163(Path class:K72:19; $methods; *)

$regex:=cs:C1710.regex.new()
$classes:=New object:C1471

For ($i; 1; Size of array:C274($methods); 1)
	
	$name:=Delete string:C232($methods{$i}; 1; 8)
	
	If ($name#"@Entity") && ($name#"DataStore")
		
		METHOD GET CODE:C1190($methods{$i}; $code; *)
		
		$class:=New object:C1471
		
		If ($regex.setPattern("(?m-si)Class extends\\s([[:alpha:]][[:alnum:]]*)").setTarget($code).match())
			
			$class.extend:=$regex.matches[1].data
			
		End if 
		
		$c:=$regex.setPattern("(?m-si)(?!.*[gs]et)Function ([[:alpha:]][^[:blank:]($]*)(?:\\(.*\\))(?:[^$]*)").extract(1)
		
		If ($c.length>0)
			
			$class.functions:=$c
			
		End if 
		
		// Public attributes (not starting with an underscore)
		$c:=$regex.setPattern("(?mi-s)This\\.(?!_)([^[:blank:]\\.]*):").extract(1)
		
		If ($c.length>0)
			
			$class.attributes:=New collection:C1472
			
			For ($j; 0; $c.length-1; 1)
				
				If ($class.attributes.query("name = :1"; $c[$j]).pop()=Null:C1517)
					
					$attribute:=New object:C1471(\
						"name"; $c[$j])
					
					//If ($regex.setPattern("(?mi-s)This\\."+$attribute.name+"\\.").match())
					//$attribute.type:="Object"
					//End if
					
					$class.attributes.push($attribute)
					
				End if 
			End for 
		End if 
		
		// Computed attributes
		$c:=$regex.setPattern("(?mi-s)Function\\sget\\s([[:alpha:]][^[:blank:]($]*)\\(\\)\\s:\\s([[:alpha:]]*)").extract("1 2")
		
		If ($c.length>0)
			
			$class.attributes:=$class.attributes || New collection:C1472
			
			For ($j; 0; $c.length-1; 2)
				
				$attribute:=New object:C1471(\
					"name"; $c[$j]; \
					"type"; $c[$j+1]; \
					"computed"; True:C214; \
					"writable"; $regex.setPattern("(?mi-s)Function set "+$c[$j]).match())
				
				$class.attributes.push($attribute)
				
			End for 
		End if 
		
		$classes[$name]:=$class
		
	End if 
End for 

For each ($key; $classes)
	
	$class:=$classes[$key]
	
	If ($class.extend#Null:C1517)
		
		$classes[$class.extend].childs:=$classes[$class.extend].childs || New object:C1471
		$classes[$class.extend].childs[$key]:=$class
		
		//OB REMOVE($class; "extend")
		
	End if 
End for each 

