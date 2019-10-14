//%attributes = {}
C_LONGINT:C283($Lon_i;$Lon_id)
C_TEXT:C284($Dom_buffer;$Dom_root;$Dom_target;$Txt_buffer;$Txt_command)

ARRAY TEXT:C222($tDom_commands;0)

$Dom_root:=DOM Parse XML source:C719(Get 4D folder:C485(-1)+"fr.lproj"+Folder separator:K24:12+"4D_CommandsFR.xlf")

If (OK=1)
	
	$tDom_commands{0}:=DOM Find XML element:C864($Dom_root;"xliff/file/body/group/trans-unit";$tDom_commands)
	
	If (OK=1)
		
		$Dom_target:=DOM Create XML Ref:C861("macros")
		
		$Dom_buffer:=DOM Get XML document ref:C1088($Dom_target)
		$Dom_buffer:=DOM Append XML child node:C1080($Dom_buffer;XML DOCTYPE:K45:19;"macros SYSTEM \"http://www.4d.com/dtd/2007/macros.DTD\"")
		
		For ($Lon_i;1;Size of array:C274($tDom_commands);1)
			
			DOM GET XML ATTRIBUTE BY NAME:C728($tDom_commands{$Lon_i};"id";$Lon_id)
			
			If (OK=1)
				
				$Txt_command:=Command name:C538($Lon_id)
				
				If (OK=1)
					
					If (Length:C16($Txt_command)>0)\
						 & (Position:C15("_o_";$Txt_command)#1)\
						 & (Position:C15("_4D";$Txt_command)#1)
						
						$Dom_buffer:=DOM Find XML element:C864($tDom_commands{$Lon_i};"trans-unit/target")
						
						If (OK=1)
							
							DOM GET XML ELEMENT VALUE:C731($Dom_buffer;$Txt_buffer)
							
							If (Length:C16($Txt_buffer)>0)\
								 & (Position:C15("_o_";$Txt_buffer)#1)\
								 & ($Txt_buffer#$Txt_command)
								
								$Dom_buffer:=DOM Create XML element:C865($Dom_target;"macro";\
									"in_menu";"false";\
									"in_toolbar";"false";\
									"name";$Txt_buffer)
								
								DOM SET XML ELEMENT VALUE:C868(DOM Create XML element:C865($Dom_buffer;"text");\
									$Txt_command)
								
							End if 
						End if 
					End if 
				End if 
			End if 
		End for 
		
		DOM EXPORT TO FILE:C862($Dom_target;Get 4D folder:C485(Current resources folder:K5:16)+"FR_US.xml")
		
		DOM CLOSE XML:C722($Dom_target)
		
		SHOW ON DISK:C922(Get 4D folder:C485(Current resources folder:K5:16)+"FR_US.xml")
		
	End if 
	
	DOM CLOSE XML:C722($Dom_root)
	
End if 

