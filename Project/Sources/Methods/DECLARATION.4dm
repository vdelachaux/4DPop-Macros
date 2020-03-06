//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : DECLARATION
  // Alias zPop_o_dlg_DECLARATIONS
  // Created 20/08/02 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (29/03/06)
  // 2004 version macro
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (26/04/07)
  // v11 version
  // At the time of the conversion QFree  was not Universal and 4D regex command was not implemented.
  // All methods was recoded in 4D language.
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (23/10/07)
  // Syntaxe preferences implementation ("Get_Syntax_Preferences" Entrypoint)
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (02/11/07)
  // "Set_Syntax_Preferences" Entrypoint
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux  (08/11/07)
  // Add syntax rules preferences
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (09/11/07)
  // Arrays with a not null size or with an expressed hexadecimal size are ignored.
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux(19/03/09)
  // Add comment detection for v12
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (24/08/09)
  // Change separator for syntax separator
  // Allow to ignore compiler's directives
  // Preserve mixed non locales declaration ie. process, parameter or interprocess variables mixed with locals
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (12/05/10)
  // Destruction of incongruous newlines
  // ----------------------------------------------------
  // Modified #25-6-2013 by Vincent de Lachaux
  // v14 : Add C_OBJECT, ARRAY OBJECT, ARRAY BLOB & ARRAY TIME
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/02/14)
  // Adding option "Generate comment for tooltip"
  // ----------------------------------------------------
C_TEXT:C284($1)
C_POINTER:C301(${2})

C_BOOLEAN:C305($Boo_comments;$Boo_updateComments)
C_LONGINT:C283($i;$Lon_command;$Lon_count;$Lon_currentLength;$Lon_currentType;$Lon_error)
C_LONGINT:C283($Lon_length;$Lon_reference;$Lon_size;$Lon_type;$Lon_variablePerLine;$number)
C_TEXT:C284($Dom_node;$root;$t;$tFullMethodText;$tMethod;$tMethodCode)
C_TEXT:C284($tSelector;$tTitle;$Txt_declarations;$Txt_name)
C_OBJECT:C1216($file;$o;$oPreferences;$oSettings)
C_COLLECTION:C1488($c;$Col_settings;$Col_type)

If (False:C215)
	C_TEXT:C284(DECLARATION ;$1)
	C_POINTER:C301(DECLARATION ;${2})
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
If (Count parameters:C259=0)  // Display the dialog
	
	DECLARATION ("_init")
	
	OPTIONS_GET (27)  // ????
	
	  // Get settings
	$oSettings:=JSON Parse:C1218(File:C1566("/RESOURCES/declarations.settings").getText())
	
	$oSettings.directives:=New collection:C1472
	For each ($o;$oSettings.parametersDeclaration)
		
		$oSettings.directives.push(Parse formula:C1576(":C"+String:C10($o.cmd)))
		
	End for each 
	
	$oSettings.arrays:=New collection:C1472
	For each ($o;$oSettings.arraysDeclaration)
		
		$oSettings.arrays.push(Parse formula:C1576(":C"+String:C10($o.cmd)))
		
	End for each 
	
	  // Get user preferences
	$file:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings")
	
	If (Not:C34($file.exists))
		
		  // Use default settings
		$file:=File:C1566("/RESOURCES/default.settings").copyTo(Form:C1466.file.parent;"4DPop Macros.settings")
		
	End if 
	
	$oPreferences:=JSON Parse:C1218($file.getText()).declaration
	
	  // Get method text
	GET MACRO PARAMETER:C997(Full method text:K5:17;$tFullMethodText)
	
	  // Remove method compiler directives, if nay
	If (Match regex:C1019("(?s-mi)(?:Si|If)\\s*\\((?:Faux|False)\\).*?(?:Fin de si|End if)";$tFullMethodText;1;$pos;$len))
		
		$tFullMethodText:=Delete string:C232($tFullMethodText;$pos;$len)
		
	End if 
	
	$tTitle:=Get window title:C450(Frontmost window:C447)
	$c:=Split string:C1554($tTitle;":";sk trim spaces:K86:2)
	$tMethod:=$c[Num:C11($c.length>1)]
	
	  // Display declaration dialog
	DIALOG:C40("DECLARATIONS";New object:C1471(\
		"window";Open form window:C675("DECLARATIONS";Movable form dialog box:K39:8;*);\
		"title";$tTitle;\
		"method";$tMethod;\
		"code";Split string:C1554($tFullMethodText;"\r";sk trim spaces:K86:2);\
		"settings";$oSettings;\
		"preferences";$oPreferences;\
		"controlFlow";JSON Parse:C1218(File:C1566("/RESOURCES/controlFlow.json").getText())[Choose:C955(Command name:C538(41)="ALERT";"intl";"fr")];\
		"init";Formula:C1597(CALL FORM:C1391(This:C1470.window;"declarationINIT"));\
		"refresh";Formula:C1597(declarationUI );\
		"setType";Formula:C1597(declarationSetType )\
		))
	
	CLOSE WINDOW:C154
	
	CLEAR VARIABLE:C89(<>tTxt_lines)
	CLEAR VARIABLE:C89(<>tLon_Line_Statut)
	
Else 
	
	$tSelector:=$1  //{Action} [TYPE,DISPLAY,SAVE,INIT]
	
	Case of 
			
			  //______________________________________________________
		: ($tSelector="SAVE")
			
			  // Close the dialog
			CANCEL:C270
			
			If (Is a list:C621((Form:C1466.list)->))
				
				$number:=Count list items:C380((Form:C1466.list)->;*)
				
				If ($number>0)
					
					Preferences ("Get_Value";"numberOfVariablePerLine";->$Lon_variablePerLine)
					
					ARRAY TEXT:C222($tTxt_Names;$number)
					ARRAY LONGINT:C221($tLon_Declaration_Types;$number)
					ARRAY LONGINT:C221($tLon_Sizes;$number)
					ARRAY LONGINT:C221($tLon_sortOrder;$number)
					
					For ($i;1;$number;1)
						
						GET LIST ITEM:C378((Form:C1466.list)->;$i;$Lon_reference;$tTxt_Names{$i})
						GET LIST ITEM PARAMETER:C985((Form:C1466.list)->;$Lon_reference;"type";$tLon_Declaration_Types{$i})
						GET LIST ITEM PARAMETER:C985((Form:C1466.list)->;$Lon_reference;"size";$tLon_Sizes{$i})
						
						$Txt_name:=$tTxt_Names{$i}
						
						Case of 
								
								  //………………………………
							: ($tLon_Declaration_Types{$i}=0)  // Not declared
								
								$tLon_sortOrder{$i}:=MAXLONG:K35:2
								
								  //………………………………
							: ($tLon_Declaration_Types{$i}>1000)  // Parameters
								
								$tLon_sortOrder{$i}:=Choose:C955(Position:C15("{";$Txt_name)>0;0;-100+Num:C11($Txt_name))
								
								  //………………………………
							: ($tLon_Declaration_Types{$i}>100)  // Arrays
								
								$tLon_sortOrder{$i}:=1000+$tLon_Sizes{$i}
								
								  //………………………………
							Else 
								
								$tLon_sortOrder{$i}:=100+$tLon_Sizes{$i}
								
								  //………………………………
						End case 
					End for 
					
					MULTI SORT ARRAY:C718($tLon_sortOrder;>;$tLon_Declaration_Types;>;$tLon_Sizes;>;$tTxt_Names;>)
					
					$o:=Form:C1466.settings
					$Col_settings:=$o.parametersDeclaration.combine($o.arraysDeclaration).combine($o.variablesDeclaration)
					$Col_type:=$o.parametersDeclaration.extract("type").combine($o.arraysDeclaration.extract("type")).combine($o.variablesDeclaration.extract("type"))
					
					For ($i;1;$number;1)
						
						$Txt_name:=$tTxt_Names{$i}
						$Lon_type:=$tLon_Declaration_Types{$i}
						$Lon_size:=$tLon_Sizes{$i}
						
						If ($Lon_type#$Lon_currentType)\
							 | (($Lon_type=1) & ($Lon_size#$Lon_currentLength))\
							 | ($Lon_type>100)\
							 | ($Lon_count=$Lon_variablePerLine)
							
							$Lon_count:=1
							
							If (Length:C16($t)>0)
								
								If ($t[[Length:C16($t)]]#"\r")
									
									If (Length:C16($t)>2)
										
										If ($t[[Length:C16($t)-1]]#")")
											
											$t:=$t+")"
											
										End if 
										
										If ($t[[Length:C16($t)]]#"\r")
											
											$t:=$t+"\r"
											
										End if 
									End if 
								End if 
							End if 
							
							If ($Lon_type#$Lon_currentType)\
								 & ($Lon_type>100)\
								 & ($Lon_currentType<100)\
								 & ($Lon_currentType#0)
								
								$t:=$t+"\r"
								
							End if 
							
							$Lon_currentType:=$Lon_type
							$Lon_currentLength:=$tLon_Sizes{$i}
							
							Case of 
									
									  //________________________________________________________________________________
								: ($Lon_currentType>1000)
									
									If (Length:C16($t)>2)
										
										If ($t[[Length:C16($t)-1]]#")")
											
											$t:=$t+")"
											
										End if 
										
										If ($t[[Length:C16($t)]]#"\r")
											
											$t:=$t+"\r"
											
										End if 
									End if 
									
									$Lon_command:=$Col_settings.query("type = :1";$Lon_currentType)[0].cmd
									
									If ($Lon_command=293)  // C_STRING
										
										$t:=$t+Command name:C538($Lon_command)+"("+String:C10($tLon_Sizes{$i})+";"+$Txt_name+")"+"\r"
										$Txt_declarations:=$Txt_declarations+Command name:C538($Lon_command)+"("+Form:C1466.method+";"+String:C10($tLon_Sizes{$i})
										$Txt_declarations:=$Txt_declarations+";"+$Txt_name+")"+"\r"
										
									Else 
										
										$t:=$t+Command name:C538($Lon_command)+"("+$Txt_name+")"+"\r"
										$Txt_declarations:=$Txt_declarations+Command name:C538($Lon_command)+"("+Form:C1466.method+";"+$Txt_name+")"+"\r"
										
									End if 
									
									If ($i<$number)
										
										If ($tLon_Declaration_Types{$i+1}<1000)
											
											$t:=$t+"\r"
											
										End if 
									End if 
									
									$Lon_command:=-1
									
									  //________________________________________________________________________________
								: ($Lon_currentType=1000)
									
									  // Trim
									
									  //________________________________________________________________________________
								: ($Lon_currentType>100)
									
									$Lon_command:=$Col_settings.query("type = :1";$Lon_currentType)[0].cmd
									
									$t:=Choose:C955($Lon_command=218;$t+Command name:C538($Lon_command)+"("+String:C10($tLon_Sizes{$i})+";"+$Txt_name+";0)"+"\r";$t+Command name:C538($Lon_command)+"("+$Txt_name+";0)"+"\r")
									
									If ($i<$number)
										
										If ($tLon_Declaration_Types{$i+1}<100)
											
											$t:=$t+"\r"
											
										End if 
										
									Else 
										
										$t:=$t+"\r"
										
									End if 
									
									$Lon_command:=-1
									
									  //________________________________________________________________________________
								: ($Lon_currentType>1)
									
									$Lon_command:=$Col_settings.query("type = :1";$Lon_currentType)[0].cmd
									
									  //________________________________________________________________________________
								: ($Lon_currentType=1)
									
									If (Length:C16($t)>0)
										
										If ($t[[Length:C16($t)]]#"\r")
											
											If (Length:C16($t)>2)
												
												If ($t[[Length:C16($t)-1]]#")")
													
													$t:=$t+")"
													
												End if 
												
												If ($t[[Length:C16($t)]]#"\r")
													
													$t:=$t+"\r"
													
												End if 
											End if 
										End if 
									End if 
									
									$t:=$t+Command name:C538(293)+"("+String:C10($tLon_Sizes{$i})+";"+$Txt_name
									
									  // ----------------------------------------
								Else 
									
									$t:=$t+"\r\r"
									
									  //________________________________________________________________________________
							End case 
							
							If ($Lon_command>0)
								
								$t:=$t+Command name:C538($Lon_command)+"("+$Txt_name
								
							End if 
							
						Else 
							
							If ($Lon_type#0)
								
								$t:=$t+";"+$Txt_name
								$Lon_count:=$Lon_count+1
								
							End if 
						End if 
						
						$Lon_command:=0
						$Lon_currentType:=$Lon_currentType*Num:C11(Not:C34(Storage:C1525.macros.preferences.options ?? 28))
						
					End for 
					
					$Lon_length:=Length:C16($t)
					
					If ($Lon_length>0)
						
						If ($t[[$Lon_length]]#"\r")
							
							If ($Lon_length>2)
								
								If ($t[[$Lon_length-1]]#")")
									
									$t:=$t+")"
									$Lon_length:=$Lon_length+1
									
								End if 
								
								If ($t[[$Lon_length]]#"\r")
									
									$t:=$t+"\r"
									
								End if 
							End if 
						End if 
					End if 
					
					Case of 
							
							  //______________________________________________________
						: (Length:C16($Txt_declarations)=0)
							
							  // Nothing to do
							
							  //______________________________________________________
						: (Not:C34(Storage:C1525.macros.preferences.options ?? 27))
							
							  // Nothing to do
							
							  //______________________________________________________
						: (Position:C15(Get localized string:C991("Method");Form:C1466.title)#1)
							
							  // Not a project method
							
							  //______________________________________________________
						Else 
							
							  // Project method
							$Txt_declarations:=Form:C1466.controlFlow[0]+"("+Command name:C538(215)+")"+"\r"+$Txt_declarations
							$Txt_declarations:=$Txt_declarations+Form:C1466.controlFlow[2]+"\r"
							$t:=$t+"\r\r"+$Txt_declarations
							
							$Boo_updateComments:=(Storage:C1525.macros.preferences.options ?? 31)
							
							  //______________________________________________________
					End case 
					
					$t:=$t+kCaret
					
					  // Always insert at the beginning of the method
					$Boo_comments:=True:C214
					$number:=Size of array:C274(<>tTxt_lines)
					
					For ($i;1;$number;1)
						
						If ($Boo_comments)
							
							$Boo_comments:=(<>tLon_Line_Statut{$i}=2)
							
						End if 
						
						If ($Boo_comments)
							
							$tMethodCode:=$tMethodCode+<>tTxt_lines{$i}+("\r"*Num:C11($i<$number))
							
						Else 
							
							If (Length:C16($t)>0)
								
								$tMethodCode:=$tMethodCode+$t
								$t:=""
								
							End if 
							
							If (<>tLon_Line_Statut{$i}=-1)\
								 & (<>tLon_Line_Statut{0}>0)
								
								If ($i<$number)
									
									$i:=$i+Num:C11(<>tLon_Line_Statut{$i+1}=-1)
									<>tLon_Line_Statut{0}:=<>tLon_Line_Statut{0}-1
									
								End if 
								
							Else 
								
								If (<>tLon_Line_Statut{$i}#3)
									
									If ($i=1)
										
										$tMethodCode:=$tMethodCode+("\r"*Num:C11($i<$number))
										
									End if 
									
									$tMethodCode:=Choose:C955(Length:C16(<>tTxt_lines{$i})=0;\
										$tMethodCode+Choose:C955(Position:C15(kCaret;$tMethodCode)#(Length:C16($tMethodCode)-8);"\r";"");\
										$tMethodCode+<>tTxt_lines{$i}+Choose:C955($i<$number;"\r";""))
									
								End if 
							End if 
						End if 
					End for 
					
					$Lon_error:=Rgx_SubstituteText ("\\r(\\r"+kCaret+")";"\\1";->$tMethodCode)
					
					If (Storage:C1525.macros.preferences.options ?? 29)  // Trim multiple empty lines
						
						$Lon_error:=Rgx_SubstituteText ("[\\r\\n]{2,}";"\r\r";->$tMethodCode)
						$Lon_error:=Rgx_SubstituteText ("(\\r*)$";"";->$tMethodCode)
						
					End if 
					
					SET MACRO PARAMETER:C998(Full method text:K5:17;$tMethodCode)
					
					If ($Boo_updateComments)  // Generate method comments for tips
						
						COMMENTS ("method-comment-generate";Form:C1466.method;$tMethodCode)
						
					End if 
				End if 
			End if 
			
			  //______________________________________________________
		: ($tSelector="_init")
			
			  //menu .append(":xliff:CommonMenuFile";menu \
				.append(":xliff:CommonClose";"closeWindow").shortcut("W")\
				.append(":xliff:CommonMenuItemQuit").action(ak quit).shortcut("Q"))\
				.append(":xliff:CommonMenuEdit";menu .editMenu())\
				.setBar()
			
			Compiler_ 
			
			If (Not:C34(<>Boo_declarationInited)) | (Structure file:C489=Structure file:C489(*))
				
				<>Boo_declarationInited:=True:C214
				
				ARRAY LONGINT:C221(<>tLon_command;32)
				
				  //PARAMETERS
				<>tLon_command{1}:=293  //C_STRING
				<>tLon_command{2}:=604  //C_BLOB
				<>tLon_command{3}:=305  //C_BOOLEAN
				<>tLon_command{4}:=307  //C_DATE
				<>tLon_command{5}:=282  //C_INTEGER
				<>tLon_command{6}:=283  //C_LONGINT
				<>tLon_command{7}:=352  //C_GRAPH
				<>tLon_command{8}:=306  //C_TIME
				<>tLon_command{9}:=286  //C_PICTURE
				<>tLon_command{10}:=301  //C_POINTER
				<>tLon_command{11}:=285  //C_REAL
				<>tLon_command{12}:=284  //C_TEXT
				
				  //ARRAYS
				<>tLon_command{13}:=218  //ARRAY STRING
				<>tLon_command{14}:=223  //ARRAY BOOLEAN
				<>tLon_command{15}:=224  //ARRAY DATE
				<>tLon_command{16}:=220  //ARRAY INTEGER
				<>tLon_command{17}:=221  //ARRAY LONGINT
				<>tLon_command{18}:=279  //ARRAY PICTURE
				<>tLon_command{19}:=280  //ARRAY POINTER
				<>tLon_command{20}:=219  //ARRAY REAL
				<>tLon_command{21}:=222  //ARRAY TEXT
				
				  //VARIABLES
				<>tLon_command{22}:=604  //C_BLOB
				<>tLon_command{23}:=305  //C_BOOLEAN
				<>tLon_command{24}:=307  //C_DATE
				<>tLon_command{25}:=282  //C_INTEGER
				<>tLon_command{26}:=283  //C_LONGINT
				<>tLon_command{27}:=352  //C_GRAPH
				<>tLon_command{28}:=306  //C_TIME
				<>tLon_command{29}:=286  //C_PICTURE
				<>tLon_command{30}:=301  //C_POINTER
				<>tLon_command{31}:=285  //C_REAL
				<>tLon_command{32}:=284  //C_TEXT
				
				  //C_OBJECT (33)
				APPEND TO ARRAY:C911(<>tLon_command;1216)
				
				  //ARRAY OBJECT (34)
				APPEND TO ARRAY:C911(<>tLon_command;1221)
				
				  //ARRAY BLOB (35)
				APPEND TO ARRAY:C911(<>tLon_command;1222)
				
				  //ARRAY TIME (36)
				APPEND TO ARRAY:C911(<>tLon_command;1223)
				
				  // 21-6-2017
				APPEND TO ARRAY:C911(<>tLon_command;1488)
				
			End if 
			
			getDeclarationPreferences 
			
			  //______________________________________________________
		: ($tSelector="Set_Syntax_Preferences")
			
			If (Count parameters:C259>=3)
				
				$root:=DOM Parse XML source:C719(Storage:C1525.macros.preferences.platformPath)
				
				If (OK=1)
					
					$Dom_node:=DOM Find XML element:C864($root;"/M_4DPop/declarations")
					
					If (OK=1)
						
						DOM SET XML ATTRIBUTE:C866($Dom_node;"version";2)
						
						ARRAY TEXT:C222($tTxt_declarations;0x0000)
						$tTxt_declarations{0}:=DOM Find XML element:C864($root;"/M_4DPop/declarations/declaration";$tTxt_declarations)
						
						If (OK=1)
							
							For ($i;1;Size of array:C274($tTxt_declarations);1)
								
								DOM REMOVE XML ELEMENT:C869($tTxt_declarations{$i})
								
							End for 
							
							For ($i;1;Size of array:C274($2->);1)
								
								$tTxt_declarations{0}:=DOM Create XML element:C865($Dom_node;"declaration";"type";String:C10($2->{$i});"value";$3->{$i})
								
							End for 
							
							$root:=xml_cleanup ($root)
							
							DOM EXPORT TO FILE:C862($root;Storage:C1525.macros.preferences.platformPath)
							
						End if 
					End if 
					
					DOM CLOSE XML:C722($root)
					
				End if 
			End if 
			
			  //______________________________________________________
	End case 
End if 