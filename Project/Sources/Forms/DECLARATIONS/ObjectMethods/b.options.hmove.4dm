  // ----------------------------------------------------
  // Method : Méthode objet : M_4Pop_Declarations.bOptions
  // Created 08/11/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Populate the syntaxe rules listbox
  // ----------------------------------------------------
C_LONGINT:C283($i;$Lon_Best_Width;$Lon_Height;$Lon_number;$Lon_Width)

$Lon_number:=Size of array:C274(<>tLon_Declaration_Types)

ARRAY TEXT:C222(<>tTxt_Directive;$Lon_number)
ARRAY TEXT:C222(<>tTxt_Patterns;$Lon_number)

For ($i;1;$Lon_number;1)
	
	Case of 
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}<100)
			
			<>Txt_buffer:=Form:C1466.settings.directives[<>tLon_Declaration_Types{$i}-1]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=101)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[0]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=103)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[1]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=104)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[2]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=105)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[3]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=106)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[4]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=109)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[5]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=110)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[6]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=111)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[7]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=112)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[8]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=113)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[9]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=102)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[10]
			
			  //______________________________________________________
		: (<>tLon_Declaration_Types{$i}=108)
			
			<>Txt_buffer:=Form:C1466.settings.arrays[11]
			
			  //________________________________________
	End case 
	
	<>tTxt_Patterns{$i}:=<>tTxt_2D_Declaration_Patterns{$i}{0}
	<>tTxt_Directive{$i}:=<>Txt_buffer
	
	OBJECT GET BEST SIZE:C717(<>Txt_buffer;$Lon_Width;$Lon_Height)
	
	If ($Lon_Width>$Lon_Best_Width)
		
		$Lon_Best_Width:=$Lon_Width
		
	End if 
End for 

LISTBOX SET COLUMN WIDTH:C833(<>tTxt_Directive;$Lon_Best_Width+8)

OBJECT SET ENTERABLE:C238(*;"variableNumber";Not:C34(Storage:C1525.macros.preferences.options ?? 28))