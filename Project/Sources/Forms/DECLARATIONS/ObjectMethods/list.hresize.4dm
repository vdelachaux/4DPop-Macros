C_LONGINT:C283($Lon_error;$Lon_formEvent;$Lon_i;$Lon_reference;$Lon_styles;$Lon_type)
C_LONGINT:C283($Lst_variables)
C_TEXT:C284($Mnu_context;$Txt_buffer;$Txt_label;$Txt_pattern)

$Lon_formEvent:=Form event code:C388
$Lst_variables:=Self:C308->

Case of 
		  //______________________________________________________
	: ($Lon_formEvent=On Selection Change:K2:29)
		
		Form:C1466.refresh()
		
		  //______________________________________________________
	: ($Lon_formEvent=On Double Clicked:K2:5)
		
		GET LIST ITEM PARAMETER:C985($Lst_variables;*;"type";$Lon_type)
		
		If ($Lon_type<1000)
			
			EDIT ITEM:C870(*;OBJECT Get name:C1087(Object current:K67:2))
			
		End if 
		
		  //______________________________________________________
	: (Contextual click:C713)
		
		If (Contextual click:C713)
			
			$Mnu_context:=Create menu:C408
			
			APPEND MENU ITEM:C411($Mnu_context;"Renommer")
			SET MENU ITEM PARAMETER:C1004($Mnu_context;-1;"rename")
			GET LIST ITEM PARAMETER:C985($Lst_variables;*;"type";$Lon_type)
			
			If ($Lon_type>=1000)
				
				DISABLE MENU ITEM:C150($Mnu_context;-1)
				
			End if 
			
			APPEND MENU ITEM:C411($Mnu_context;"-")
			
			APPEND MENU ITEM:C411($Mnu_context;"Effacer")
			SET MENU ITEM PARAMETER:C1004($Mnu_context;-1;"erase")
			
			$Txt_buffer:=Dynamic pop up menu:C1006($Mnu_context)
			RELEASE MENU:C978($Mnu_context)
			
			Case of 
					  //______________________________________________________
				: ($Txt_buffer="rename")
					
					EDIT ITEM:C870(*;OBJECT Get name:C1087(Object current:K67:2))
					
					  //______________________________________________________
				: ($Txt_buffer="erase")
					
					SET LIST ITEM PARAMETER:C986($Lst_variables;*;"type";0)
					
					Form:C1466.refresh()
					
					  //______________________________________________________
			End case 
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Data Change:K2:15)
		
		GET LIST ITEM:C378($Lst_variables;*;$Lon_reference;$Txt_label)
		
		If (Rgx_MatchText ("^\\$[\\w\\d\\s]{1,31}$";$Txt_label)=-1)
			
			ALERT:C41(Get localized string:C991("DeclarationtheNameOfALocalVariableAlwaysStartsWithADollarSign"))
			
		Else 
			
			GET LIST ITEM PARAMETER:C985($Lst_variables;$Lon_reference;"name";$Txt_buffer)
			
			If ($Txt_label#$Txt_buffer) | (Position:C15($Txt_label;$Txt_buffer;*)#1)
				
				  //Look if a variable with the same name already exist
				ARRAY LONGINT:C221($tLon_buffer;0x0000)
				$tLon_buffer{0}:=Find in list:C952($Lst_variables;$Txt_label;0;$tLon_buffer;*)
				
				OK:=Num:C11(Size of array:C274($tLon_buffer)=1)
				
				If (OK=0)  //If yes: confirm
					
					CONFIRM:C162(Get localized string:C991("DeclarationthisVariableIsAlreadyUsedInThisMethod"))
					
					If (OK=1)  //If OK: delete other occurrences
						
						For ($Lon_i;1;Size of array:C274($tLon_buffer);1)
							
							If ($tLon_buffer{$Lon_i}#$Lon_reference)
								
								DELETE FROM LIST:C624($Lst_variables;$tLon_buffer{$Lon_i})
								
							End if 
						End for 
					End if 
				End if 
				
				If (OK=1)
					
					  //This pattern don't replace in the comments
					  //Turn around ACI0078383 {
					  //$Txt_pattern:="(?<!//.*)(\\$\\b%\\b)"
					$Txt_pattern:="(?<!//"+(".{0,10}"*10)+")(\\$\\b%\\b)"
					  //}
					$Txt_pattern:=Replace string:C233($Txt_pattern;"%";Substring:C12($Txt_buffer;2))
					
					For ($Lon_i;1;Size of array:C274(<>tTxt_lines);1)
						
						$Lon_error:=Rgx_SubstituteText ($Txt_pattern;$Txt_label;-><>tTxt_lines{$Lon_i})
						
					End for 
					
					SET LIST ITEM PARAMETER:C986($Lst_variables;$Lon_reference;"name";$Txt_label)
					
					  //Determine the variable's type
					$Lon_type:=Private_Lon_Declaration_Type ($Txt_label)
					SET LIST ITEM PARAMETER:C986($Lst_variables;$Lon_reference;"type";$Lon_type)
					
					Case of 
							
							  //--------------------------------------
						: ($Lon_type>100)
							
							$Lon_type:=$Lon_type-100
							$Lon_styles:=Bold:K14:2+Underline:K14:4
							
							  //--------------------------------------
						: ($Lon_type=0)
							
							$Lon_styles:=Italic:K14:3
							
							  //--------------------------------------
						Else 
							
							$Lon_styles:=Bold:K14:2
							
							  //--------------------------------------
					End case 
					
					SET LIST ITEM PROPERTIES:C386($Lst_variables;$Lon_reference;False:C215;$Lon_styles;"path:/RESOURCES/Images/types/field_"+String:C10($Lon_type)+".png")
					
					Form:C1466.refresh()
					
				End if 
			End if 
		End if 
		
		  //______________________________________________________
End case 