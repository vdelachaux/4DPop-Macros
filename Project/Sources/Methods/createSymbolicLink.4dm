//%attributes = {"invisible":true,"preemptive":"capable"}
var $pathname : Text
var $src : Object

If (Shift down:C543)
	
	DOCUMENT:=Select folder:C670("Select the target folder:"; 8858; Package open:K24:8+Use sheet window:K24:11)
	
Else 
	
	$pathname:=Select document:C905(8858; ""; "Select the target file:"; Use sheet window:K24:11)
	
End if 

If (Bool:C1537(OK))
	
	$src:=Test path name:C476(DOCUMENT)=Is a document:K24:1\
		 ? File:C1566(DOCUMENT; fk platform path:K87:2)\
		 : Folder:C1567(DOCUMENT; fk platform path:K87:2)
	
	$pathname:=Select folder:C670("Select the destination folder:"; 8859; Package open:K24:8+Use sheet window:K24:11)
	
	If (Bool:C1537(OK))
		
		$src.createAlias(Folder:C1567($pathname; fk platform path:K87:2); $src.fullName; fk symbolic link:K87:4)
		
	End if 
End if 
