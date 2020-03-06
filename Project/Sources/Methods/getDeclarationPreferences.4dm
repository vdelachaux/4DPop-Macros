//%attributes = {}
C_LONGINT:C283($i;$Lon_type;$Lon_version;$Lon_x)
C_TEXT:C284($Dom_node;$root;$t;$tt)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222(<>tTxt_2D_Declaration_Patterns;0;0)
ARRAY LONGINT:C221(<>tLon_Declaration_Types;0)

$root:=DOM Parse XML source:C719(Storage:C1525.macros.preferences.platformPath)

If (OK=1)
	
	$Dom_node:=DOM Find XML element:C864($root;"/M_4DPop/declarations")
	
	If (OK=1)
		
		  // Get the component preferences version
		If (DOM Count XML attributes:C727($Dom_node)>0)
			
			DOM GET XML ATTRIBUTE BY NAME:C728($Dom_node;"version";$Lon_version)
			
		End if 
	End if 
	
	ARRAY TEXT:C222($tTxt_declarations;0x0000)
	$tTxt_declarations{0}:=DOM Find XML element:C864($root;"/M_4DPop/declarations/declaration";$tTxt_declarations)
	
	If (OK=1)
		
		For ($i;1;Size of array:C274($tTxt_declarations);1)
			
			DOM GET XML ATTRIBUTE BY NAME:C728($tTxt_declarations{$i};"type";$t)
			
			If (OK=1)
				
				$Lon_type:=Num:C11($t)
				DOM GET XML ATTRIBUTE BY NAME:C728($tTxt_declarations{$i};"value";$t)
				
				If (OK=1)
					
					ARRAY TEXT:C222($tTxt_values;0x0000)
					
					If ($Lon_version<2)
						
						  //Update the separator
						$t:=Replace string:C233($t;",";";")
						
					End if 
					
					$c:=Split string:C1554($t;";")
					
					If ($c.length>0)
						
						$Lon_x:=$Lon_x+1
						INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns;$Lon_x;1)
						<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:=$t
						
						For each ($tt;$c)
							
							$tt:=Replace string:C233(Replace string:C233($tt;"*";".*");"?";".")
							APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x};$tt)
							
						End for each 
						
						APPEND TO ARRAY:C911(<>tLon_Declaration_Types;$Lon_type)
						
					End if 
				End if 
			End if 
		End for 
		
		  //v14 - Add new type Objects {
		If (Find in array:C230(<>tLon_Declaration_Types;113)=-1)  //ARRAY OBJECT
			
			APPEND TO ARRAY:C911(<>tLon_Declaration_Types;113)
			$Lon_x:=$Lon_x+1
			INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns;$Lon_x;1)
			<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*tObj_*"
			APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x};".*tObj_.*")
			
		End if 
		
		If (Find in array:C230(<>tLon_Declaration_Types;13)=-1)  //C_OBJECT
			
			APPEND TO ARRAY:C911(<>tLon_Declaration_Types;13)
			$Lon_x:=$Lon_x+1
			INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns;$Lon_x;1)
			<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*Obj_*"
			APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x};".*Obj_.*")
			
		End if 
		
		If (Find in array:C230(<>tLon_Declaration_Types;102)=-1)  //ARRAY BLOB
			
			APPEND TO ARRAY:C911(<>tLon_Declaration_Types;102)
			$Lon_x:=$Lon_x+1
			INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns;$Lon_x;1)
			<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*tBlb_*"
			APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x};".*tBlb_.*")
			
		End if 
		
		If (Find in array:C230(<>tLon_Declaration_Types;108)=-1)  //ARRAY TIME
			
			APPEND TO ARRAY:C911(<>tLon_Declaration_Types;108)
			$Lon_x:=$Lon_x+1
			INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns;$Lon_x;1)
			<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*tGmt_*"
			APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x};".*tGmt_.*")
			
		End if   //}
		
		  // 21-6-2017 - C_COLLECTION {
		If (Find in array:C230(<>tLon_Declaration_Types;14)=-1)
			
			APPEND TO ARRAY:C911(<>tLon_Declaration_Types;14)
			$Lon_x:=$Lon_x+1
			INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns;$Lon_x;1)
			<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*Col_*"
			APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x};".*Col_.*")
			
		End if 
		  //}
		
		  // 25-9-2019 - C_VARIANT {
		If (Find in array:C230(<>tLon_Declaration_Types;15)=-1)
			
			APPEND TO ARRAY:C911(<>tLon_Declaration_Types;15)
			$Lon_x:=$Lon_x+1
			INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns;$Lon_x;1)
			<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*Var_*"
			APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x};".*Var_.*")
			
		End if 
		  //}
		
		SORT ARRAY:C229(<>tLon_Declaration_Types;<>tLon_command;<>tTxt_2D_Declaration_Patterns;<)
		
	End if 
	
	DOM CLOSE XML:C722($root)
	
End if 