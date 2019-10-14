//%attributes = {}
C_OBJECT:C1216($o;$oo)

$o:=Folder:C1567(fk user preferences folder:K87:10).folder("4DPop")
$o.create()

$o:=$o.file("4DPop Macros.test")

If (Not:C34($o.exists))
	
	$oo:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop v11/test.xml")
	
	If ($oo.exists)
		
		$oo.copyTo($o.parent;"4DPop Macros.test")
		
	End if 
	
End if 