//%attributes = {"invisible":true,"preemptive":"capable"}
C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (Shift down:C543)
	
	DOCUMENT:=Select folder:C670("Select the target folder:";8858;Package open:K24:8+Use sheet window:K24:11)
	
Else 
	
	$t:=Select document:C905(8858;"";"Select the target file:";Use sheet window:K24:11)
	
End if 

If (Bool:C1537(OK))
	
	If (Test path name:C476(DOCUMENT)=Is a document:K24:1)
		
		$o:=File:C1566(DOCUMENT;fk platform path:K87:2)
		
	Else 
		
		$o:=Folder:C1567(DOCUMENT;fk platform path:K87:2)
		
	End if 
	
	$t:=Select folder:C670("Select the destination folder:";8859;Package open:K24:8+Use sheet window:K24:11)
	
	If (Bool:C1537(OK))
		
		$o.createAlias(Folder:C1567($t;fk platform path:K87:2);$o.fullName;fk symbolic link:K87:4)
		
	End if 
End if 
