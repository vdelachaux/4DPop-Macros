//%attributes = {}
C_BLOB:C604($x)
C_BOOLEAN:C305($b)
C_DATE:C307($d)
C_LONGINT:C283($i)
C_TIME:C306($h)
C_POINTER:C301($r)
C_TEXT:C284($t;$Txt_path)
C_OBJECT:C1216($o;$Obj_in)
C_COLLECTION:C1488($c)

If ($Obj_in=Null:C1517)
	
	$Obj_in:=New object:C1471
	
End if 

$c:=Split string:C1554($Txt_path;".")

$o:=$Obj_in

For each ($t;$c)
	
	If ($o[$t]=Null:C1517)
		
		$o[$t]:=New object:C1471
		$o:=$o[$t]
		
	End if 
End for each 

$d:=Current date:C33
$h:=Current time:C178

$r:=OBJECT Get pointer:C1124(Object current:K67:2)
SET BLOB SIZE:C606($x;0)

For ($i;1;10;1)
	$b:=True:C214
End for 