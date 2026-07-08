// XML → object converter (modern rewrite of the legacy _o_xml_* methods).
// Only fileToObject() is public; the rest are private recursive helpers.

shared singleton Class constructor()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an XML document as an object: {success; value} or {success: False; errors}
Function fileToObject($path : Text; $references : Boolean) : Object
	
	var $result : Object:={success: False:C215}
	
	If (Test path name:C476($path)#Is a document:K24:1)
		
		$result.errors:=["File "+$path+" is not a document"]
		
		return $result
		
	End if 
	
	var $root : Text:=DOM Parse XML source:C719($path)
	
	If (OK#1)
		
		$result.errors:=["Failed to parse"]
		
		return $result
		
	End if 
	
	$result.success:=True:C214
	$result.value:=This:C1470._refToObject($root; $references)
	
	DOM CLOSE XML:C722($root)
	
	return $result
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an XML tree reference as an object
Function _refToObject($domRef : Text; $references : Boolean) : Object
	
	var $result : Object:={}
	var $name : Text
	
	DOM GET XML ELEMENT NAME:C730($domRef; $name)
	
	$result[$name]:=This:C1470._elementToObject($domRef; $references)
	
	return $result
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an XML element as an object (recursive)
Function _elementToObject($elementRef : Text; $references : Boolean) : Object
	
	var $result : Object:={}
	var $key; $value; $name; $child : Text
	var $i : Integer
	
	// DOM reference
	If ($references)
		
		$result["@"]:=$elementRef
		
	End if 
	
	// Attributes
	For ($i; 1; DOM Count XML attributes:C727($elementRef); 1)
		
		DOM GET XML ATTRIBUTE BY INDEX:C729($elementRef; $i; $key; $value)
		
		Case of 
				
				//______________________________________________________
			: (Length:C16($key)=0)
				
				// skip malformed node
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\d+\\.*\\d*$"; $value; 1))  // Numeric
				
				$result[$key]:=Num:C11($value; ".")
				
				//______________________________________________________
			: (Match regex:C1019("(?mi-s)^true|false$"; $value; 1))  // Boolean
				
				$result[$key]:=($value="true")
				
				//______________________________________________________
			Else   // Text
				
				$result[$key]:=$value
				
				//______________________________________________________
		End case 
		
	End for 
	
	// Value, if any
	DOM GET XML ELEMENT VALUE:C731($elementRef; $value)
	
	If (Match regex:C1019("[^\\s]+"; $value; 1))
		
		$result["$"]:=$value
		
	End if 
	
	// Children, if any
	$child:=DOM Get first child XML element:C723($elementRef; $name)
	
	If (OK=1)
		
		This:C1470._collectChildren($result; $elementRef; $child; $name; $references)
		
		$child:=DOM Get next sibling XML element:C724($child; $name)
		
		While (OK=1)
			
			If ($result[$name]=Null:C1517)  // Not treated yet
				
				This:C1470._collectChildren($result; $elementRef; $child; $name; $references)
				
			End if 
			
			$child:=DOM Get next sibling XML element:C724($child; $name)
			
		End while 
		
	End if 
	
	return $result
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Collects, into $result, every child element named $name (single object or collection)
Function _collectChildren($result : Object; $parentRef : Text; $childRef : Text; $name : Text; $references : Boolean)
	
	var $count : Integer:=DOM Count XML elements:C726($parentRef; $name)
	var $i : Integer
	
	If ($count>1)
		
		$result[$name]:=[]
		
		For ($i; 1; $count; 1)
			
			$result[$name].push(This:C1470._elementToObject(DOM Get XML element:C725($parentRef; $name; $i); $references))
			
		End for 
		
	Else 
		
		$result[$name]:=This:C1470._elementToObject($childRef; $references)
		
	End if 
