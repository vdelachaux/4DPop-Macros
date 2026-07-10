property data : Object  // per-color-scheme cache: {"light": {types; classIcon}; "dark": {…}}

// Field-type icons store (shared singleton — cs.fieldIcons.me).
// The declaration dialog shows one icon per variable type. Reading the ~15 picture
// files from /RESOURCES/Images/fieldIcons on every macro call is wasteful, so they
// are loaded ONCE per 4D session and cached here. The cache is keyed by the current
// application color scheme (light / dark) so a mid-session switch still gets the
// right variant (each scheme is built at most once).

shared singleton Class constructor()
	
	This:C1470.data:=New shared object:C1526
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Type-icon metadata map: a SPARSE collection indexed by the 4D type constant
	// (element = {name; icon; value; arrayCommand; directive}), for the current scheme
Function get types() : Collection
	
	return This:C1470._scheme().types
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Dedicated "class" icon (for object variables carrying a 4D.x / cs.x class)
Function get classIcon() : Picture
	
	return This:C1470._scheme().classIcon
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Lazily builds and caches the icon set for the current color scheme
Function _scheme() : Object
	
	var $key : Text:=(Get Application color scheme:C1763(*)="dark") ? "dark" : "light"
	
	If (This:C1470.data[$key]=Null:C1517)
		
		var $built : Object:=This:C1470._build($key="dark")
		
		Use (This:C1470.data)
			
			This:C1470.data[$key]:=OB Copy:C1225($built; ck shared:K85:29; This:C1470)
			
		End use 
		
	End if 
	
	return This:C1470.data[$key]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Reads every field icon from disk and assembles the types map + class icon
Function _build($dark : Boolean) : Object
	
	var $root : 4D:C1709.Folder:=Folder:C1567("/RESOURCES/Images/fieldIcons")
	var $suffix : Text:=$dark ? "_dark.png" : ".png"
	var $types : Collection:=[]
	var $icon : Picture
	
	READ PICTURE FILE:C678($root.file("field_00"+$suffix).platformPath; $icon)
	$types[0]:={\
		name: "undefined"; \
		icon: $icon}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is object:K8:27; "00")+$suffix).platformPath; $icon)
	$types[Is object:K8:27]:={\
		name: "object"; \
		icon: $icon; \
		value: Is object:K8:27; \
		arrayCommand: 1221; \
		directive: 1216}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is collection:K8:32; "00")+$suffix).platformPath; $icon)
	$types[Is collection:K8:32]:={\
		name: "collection"; \
		icon: $icon; \
		value: Is collection:K8:32; \
		directive: 1488}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is longint:K8:6; "00")+$suffix).platformPath; $icon)
	$types[Is longint:K8:6]:={\
		name: "integer"; \
		icon: $icon; \
		value: Is longint:K8:6; \
		arrayCommand: 221; \
		directive: 283}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is boolean:K8:9; "00")+$suffix).platformPath; $icon)
	$types[Is boolean:K8:9]:={\
		name: "boolean"; \
		icon: $icon; \
		value: Is boolean:K8:9; \
		arrayCommand: 223; \
		directive: 305}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is text:K8:3; "00")+$suffix).platformPath; $icon)
	$types[Is text:K8:3]:={\
		name: "text"; \
		icon: $icon; \
		value: Is text:K8:3; \
		arrayCommand: 222; \
		directive: 284}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is date:K8:7; "00")+$suffix).platformPath; $icon)
	$types[Is date:K8:7]:={\
		name: "date"; \
		icon: $icon; \
		value: Is date:K8:7; \
		arrayCommand: 224; \
		directive: 307}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is time:K8:8; "00")+$suffix).platformPath; $icon)
	$types[Is time:K8:8]:={\
		name: "time"; \
		icon: $icon; \
		value: Is time:K8:8; \
		arrayCommand: 1223; \
		directive: 306}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is picture:K8:10; "00")+$suffix).platformPath; $icon)
	$types[Is picture:K8:10]:={\
		name: "picture"; \
		icon: $icon; \
		value: Is picture:K8:10; \
		arrayCommand: 279; \
		directive: 286}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is variant:K8:33; "00")+$suffix).platformPath; $icon)
	$types[Is variant:K8:33]:={\
		name: "variant"; \
		icon: $icon; \
		value: Is variant:K8:33; \
		directive: 1683}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is pointer:K8:14; "00")+$suffix).platformPath; $icon)
	$types[Is pointer:K8:14]:={\
		name: "pointer"; \
		icon: $icon; \
		value: Is pointer:K8:14; \
		arrayCommand: 280; \
		directive: 301}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is BLOB:K8:12; "00")+$suffix).platformPath; $icon)
	$types[Is BLOB:K8:12]:={\
		name: "blob"; \
		icon: $icon; \
		value: Is BLOB:K8:12; \
		arrayCommand: 1222; \
		directive: 604}
	
	READ PICTURE FILE:C678($root.file("field_"+String:C10(Is real:K8:4; "00")+$suffix).platformPath; $icon)
	$types[Is real:K8:4]:={\
		name: "real"; \
		icon: $icon; \
		value: Is real:K8:4; \
		arrayCommand: 219; \
		directive: 285}
	
	// Class icon: field_class.svg embeds a light/dark media query (works on 21R3+),
	// but SVG light/dark rendering is unavailable on 21.1, so pick the explicit
	// _dark variant by color scheme (like the PNG icons). Remove field_class_dark.svg
	// once 21.1 support is dropped.
	var $classIcon : Picture
	READ PICTURE FILE:C678($root.file("field_class"+($dark ? "_dark" : "")+".svg").platformPath; $classIcon)
	
	return {types: $types; classIcon: $classIcon}
	