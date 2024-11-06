//%attributes = {"invisible":true,"preemptive":"incapable"}
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
_O_C_TEXT:C284($1)
_O_C_POINTER:C301(${2})

_O_C_BOOLEAN:C305($Boo_2Darray; $Boo_comments; $Boo_parameter; $Boo_updateComments)
_O_C_LONGINT:C283($i; $l; $Lon_appearance; $Lon_command; $Lon_count; $Lon_currentLength)
_O_C_LONGINT:C283($Lon_currentType; $Lon_dimensions; $Lon_end_ii; $Lon_error; $Lon_firstIndice; $Lon_icon)
_O_C_LONGINT:C283($Lon_ignoreDeclarations; $Lon_ii; $Lon_j; $Lon_length; $Lon_parameters; $Lon_reference)
_O_C_LONGINT:C283($Lon_size; $Lon_stringLength; $Lon_styles; $Lon_type; $Lon_variablePerLine; $Lon_version)
_O_C_LONGINT:C283($Lon_x; $number)
_O_C_POINTER:C301($Ptr_array)
_O_C_TEXT:C284($Dom_node; $Dom_root; $t; $tt; $Txt_declarations; $Txt_entryPoint)
_O_C_TEXT:C284($Txt_method; $Txt_name; $Txt_patternNonLocalVariable; $Txt_patternParameter)
_O_C_OBJECT:C1216($file; $o; $oo)
_O_C_COLLECTION:C1488($c; $cArrays; $cDirectives; $Col_settings; $Col_type)

If (False:C215)
	_O_C_TEXT:C284(_o_DECLARATION; $1)
	_O_C_POINTER:C301(_o_DECLARATION; ${2})
End if 

// ----------------------------------------------------
// Declarations
$Lon_parameters:=Count parameters:C259

// ----------------------------------------------------
If ($Lon_parameters=0)  // Display the dialog
	
	_o_DECLARATION("_init")
	OPTIONS_GET(27)
	
	$file:=File:C1566("/RESOURCES/declarations.settings")
	
	If (Asserted:C1132($file.exists; "missing file: "+$file.path))
		
		$o:=JSON Parse:C1218($file.getText())
		$o.directives:=New collection:C1472
		$o.arrays:=New collection:C1472
		
		For each ($oo; $o.parametersDeclaration)
			
			$o.directives.push(Command name:C538($oo.cmd))
			
		End for each 
		
		For each ($oo; $o.arraysDeclaration)
			
			$o.arrays.push(Command name:C538($oo.cmd))
			
		End for each 
		
		$file:=File:C1566("/RESOURCES/controlFlow.json")
		
		If (Asserted:C1132($file.exists; "missing file: "+$file.path))
			
			$c:=JSON Parse:C1218($file.getText())[Choose:C955(Command name:C538(41)="ALERT"; "intl"; "fr")]
			
		End if 
		
		If (Bool:C1537(Get database parameter:C643(Is host database a project:K37:99)))  // & Not(Shift down)
			
			$o:=cs:C1710.declaration.new().parse()
			
			If ($o.variables.length>0)
				
				$o.formWindow:=Open form window:C675("NEW_DECLARATION"; Movable form dialog box:K39:8; Horizontally centered:K39:1; At the top:K39:5; *)
				DIALOG:C40("NEW_DECLARATION"; $o)
				
				If (Bool:C1537(OK))
					
					SET MACRO PARAMETER:C998(Choose:C955($o.withSelection; Highlighted method text:K5:18; Full method text:K5:17); $o.method)
					
				End if 
				
				CLOSE WINDOW:C154
				
			Else 
				
				ALERT:C41("No local variable or parameter into the method!")
				
			End if 
			
		Else 
			
			$o:=New object:C1471(\
				"title"; Get window title:C450(Frontmost window:C447); \
				"method"; win_title(Frontmost window:C447); \
				"settings"; $o; \
				"controlFlow"; $c; \
				"refresh"; Formula:C1597(_o_DECLARATION("DISPLAY")); \
				"setType"; Formula:C1597(_o_DECLARATION("TYPE"))\
				)
			
			$l:=Open form window:C675("DECLARATIONS"; Movable form dialog box:K39:8; *)
			DIALOG:C40("DECLARATIONS"; $o)
			CLOSE WINDOW:C154
			
		End if 
		
		CLEAR VARIABLE:C89(<>tTxt_lines)
		CLEAR VARIABLE:C89(<>tLon_Line_Statut)
		
	End if 
	
Else 
	
	$Txt_entryPoint:=$1  //{Action} [TYPE,DISPLAY,SAVE,INIT]
	
	Case of 
			
			//______________________________________________________
		: ($Txt_entryPoint="TYPE")
			
			GET LIST ITEM:C378((Form:C1466.list)->; *; $Lon_reference; $t)
			
			$Lon_type:=Num:C11(OBJECT Get name:C1087(Object current:K67:2))\
				+(100*(OBJECT Get pointer:C1124(Object named:K67:5; "array.NotParameter"))->)\
				+(1000*Num:C11(Match regex:C1019("(?m-si)\\$(?:(?:\\d+)|(?:\\{\\d*\\})+)"; $t; 1)))
			
			SET LIST ITEM PARAMETER:C986((Form:C1466.list)->; $Lon_reference; "type"; $Lon_type)
			
			If ($Lon_type=1)\
				 | ($Lon_type=101)\
				 | ($Lon_type=1001)  // String [COMPATIBILITY]
				
				GET LIST ITEM PARAMETER:C985((Form:C1466.list)->; $Lon_reference; "size"; $t)
				(OBJECT Get pointer:C1124(Object named:K67:5; "Alpha_Length"))->:=$t
				
			End if 
			
			Form:C1466.refresh()
			
			//______________________________________________________
		: ($Txt_entryPoint="DISPLAY")
			
			GET LIST ITEM:C378((Form:C1466.list)->; *; $Lon_reference; $Txt_name)
			
			If ($Lon_reference>0)
				
				If (Macintosh option down:C545 | Windows Alt down:C563) & Shift down:C543  //Delete typing
					
					SET LIST ITEM PARAMETER:C986((Form:C1466.list)->; $Lon_reference; "type"; 0)
					
					For ($i; 1; 14; 1)
						
						Get pointer:C304("<>b"+String:C10($i))->:=0
						
					End for 
				End if 
				
				GET LIST ITEM PARAMETER:C985((Form:C1466.list)->; $Lon_reference; "type"; $Lon_type)
				$Lon_type:=Abs:C99($Lon_type)
				
				Case of 
						
						//--------------------------------------
					: ($Lon_type>1000)
						
						$Lon_type:=$Lon_type-1000
						$Lon_styles:=Bold:K14:2+Italic:K14:3
						
						(OBJECT Get pointer:C1124(Object named:K67:5; "var.NotParameter"))->:=1
						(OBJECT Get pointer:C1124(Object named:K67:5; "array.NotParameter"))->:=0
						
						OBJECT SET ENABLED:C1123(*; "NotInArray_@"; False:C215)
						OBJECT SET ENABLED:C1123(*; "@.NotParameter"; False:C215)
						
						//--------------------------------------
					: ($Lon_type>100)
						
						$Lon_type:=$Lon_type-100
						$Lon_styles:=Bold:K14:2+Underline:K14:4
						
						(OBJECT Get pointer:C1124(Object named:K67:5; "var.NotParameter"))->:=0
						(OBJECT Get pointer:C1124(Object named:K67:5; "array.NotParameter"))->:=1
						
						OBJECT SET ENABLED:C1123(*; "NotInArray_@"; False:C215)
						OBJECT SET ENABLED:C1123(*; "@.NotParameter"; True:C214)
						
						//--------------------------------------
					: ($Lon_type=0)
						
						$Lon_styles:=Italic:K14:3
						
						//--------------------------------------
					Else 
						
						$Lon_styles:=Bold:K14:2
						
						(OBJECT Get pointer:C1124(Object named:K67:5; "var.NotParameter"))->:=1
						(OBJECT Get pointer:C1124(Object named:K67:5; "array.NotParameter"))->:=0
						
						OBJECT SET ENABLED:C1123(*; "NotInArray_@"; True:C214)
						
						//--------------------------------------
				End case 
				
				SET LIST ITEM PROPERTIES:C386((Form:C1466.list)->; $Lon_reference; False:C215; $Lon_styles; "path:/RESOURCES/Images/types/field_"+String:C10($Lon_type)+".png")
				
				If (Match regex:C1019("(?m-si)\\$(?:(?:\\d+)|(?:\\{\\d*\\})+)"; $Txt_name; 1))
					
					(OBJECT Get pointer:C1124(Object named:K67:5; "var.NotParameter"))->:=1
					(OBJECT Get pointer:C1124(Object named:K67:5; "array.NotParameter"))->:=0
					OBJECT SET ENABLED:C1123(*; "@.NotParameter"; False:C215)
					
				Else 
					
					OBJECT SET ENABLED:C1123(*; "@.NotParameter"; True:C214)
					
				End if 
				
				If ($Lon_type=1)
					
					GET LIST ITEM PARAMETER:C985((Form:C1466.list)->; $Lon_reference; "size"; $t)
					(OBJECT Get pointer:C1124(Object named:K67:5; "Alpha_Length"))->:=$t
					
				Else 
					
					If ($Lon_type=7)
						
						OBJECT SET ENABLED:C1123(*; "array.@"; False:C215)
						
					End if 
				End if 
				
				For ($i; 1; 15; 1)
					
					(Get pointer:C304("<>b"+String:C10($i)))->:=Num:C11($i=$Lon_type)
					
				End for 
				
			Else 
				
				//No line selected
				
			End if 
			
			(OBJECT Get pointer:C1124(Object named:K67:5; "spinner"))->:=0
			OBJECT SET VISIBLE:C603(*; "spinner"; False:C215)
			
			//______________________________________________________
		: ($Txt_entryPoint="SAVE")
			
			// Close the dialog
			CANCEL:C270
			
			If (Is a list:C621((Form:C1466.list)->))
				
				$number:=Count list items:C380((Form:C1466.list)->; *)
				
				If ($number>0)
					
					_o_Preferences("Get_Value"; "numberOfVariablePerLine"; ->$Lon_variablePerLine)
					
					ARRAY TEXT:C222($tTxt_Names; $number)
					ARRAY LONGINT:C221($tLon_Declaration_Types; $number)
					ARRAY LONGINT:C221($tLon_Sizes; $number)
					ARRAY LONGINT:C221($tLon_sortOrder; $number)
					
					For ($i; 1; $number; 1)
						
						GET LIST ITEM:C378((Form:C1466.list)->; $i; $Lon_reference; $tTxt_Names{$i})
						GET LIST ITEM PARAMETER:C985((Form:C1466.list)->; $Lon_reference; "type"; $tLon_Declaration_Types{$i})
						GET LIST ITEM PARAMETER:C985((Form:C1466.list)->; $Lon_reference; "size"; $tLon_Sizes{$i})
						
						$Txt_name:=$tTxt_Names{$i}
						
						Case of 
								
								//………………………………
							: ($tLon_Declaration_Types{$i}=0)  // Not declared
								
								$tLon_sortOrder{$i}:=MAXLONG:K35:2
								
								//………………………………
							: ($tLon_Declaration_Types{$i}>1000)  // Parameters
								
								$tLon_sortOrder{$i}:=Choose:C955(Position:C15("{"; $Txt_name)>0; 0; -100+Num:C11($Txt_name))
								
								//………………………………
							: ($tLon_Declaration_Types{$i}>100)  // Arrays
								
								$tLon_sortOrder{$i}:=1000+$tLon_Sizes{$i}
								
								//………………………………
							Else 
								
								$tLon_sortOrder{$i}:=100+$tLon_Sizes{$i}
								
								//………………………………
						End case 
					End for 
					
					MULTI SORT ARRAY:C718($tLon_sortOrder; >; $tLon_Declaration_Types; >; $tLon_Sizes; >; $tTxt_Names; >)
					
					$o:=Form:C1466.settings
					$Col_settings:=$o.parametersDeclaration.combine($o.arraysDeclaration).combine($o.variablesDeclaration)
					$Col_type:=$o.parametersDeclaration.extract("type").combine($o.arraysDeclaration.extract("type")).combine($o.variablesDeclaration.extract("type"))
					
					For ($i; 1; $number; 1)
						
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
									
									$Lon_command:=$Col_settings.query("type = :1"; $Lon_currentType)[0].cmd
									
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
									
									$Lon_command:=$Col_settings.query("type = :1"; $Lon_currentType)[0].cmd
									
									$t:=Choose:C955($Lon_command=218; $t+Command name:C538($Lon_command)+"("+String:C10($tLon_Sizes{$i})+";"+$Txt_name+";0)"+"\r"; $t+Command name:C538($Lon_command)+"("+$Txt_name+";0)"+"\r")
									
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
									
									$Lon_command:=$Col_settings.query("type = :1"; $Lon_currentType)[0].cmd
									
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
						: (Position:C15(Localized string:C991("Method"); Form:C1466.title)#1)
							
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
					
					For ($i; 1; $number; 1)
						
						If ($Boo_comments)
							
							$Boo_comments:=(<>tLon_Line_Statut{$i}=2)
							
						End if 
						
						If ($Boo_comments)
							
							$Txt_method:=$Txt_method+<>tTxt_lines{$i}+("\r"*Num:C11($i<$number))
							
						Else 
							
							If (Length:C16($t)>0)
								
								$Txt_method:=$Txt_method+$t
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
										
										$Txt_method:=$Txt_method+("\r"*Num:C11($i<$number))
										
									End if 
									
									$Txt_method:=Choose:C955(Length:C16(<>tTxt_lines{$i})=0; \
										$Txt_method+Choose:C955(Position:C15(kCaret; $Txt_method)#(Length:C16($Txt_method)-8); "\r"; ""); \
										$Txt_method+<>tTxt_lines{$i}+Choose:C955($i<$number; "\r"; ""))
									
								End if 
							End if 
						End if 
					End for 
					
					$Lon_error:=_o_Rgx_SubstituteText("\\r(\\r"+kCaret+")"; "\\1"; ->$Txt_method)
					
					If (Storage:C1525.macros.preferences.options ?? 29)  // Trim multiple empty lines
						
						$Lon_error:=_o_Rgx_SubstituteText("[\\r\\n]{2,}"; "\r\r"; ->$Txt_method)
						$Lon_error:=_o_Rgx_SubstituteText("(\\r*)$"; ""; ->$Txt_method)
						
					End if 
					
					SET MACRO PARAMETER:C998(Full method text:K5:17; $Txt_method)
					
					If ($Boo_updateComments)  // Generate method comments for tips
						
						COMMENTS("method-comment-generate"; Form:C1466.method; $Txt_method)
						
					End if 
				End if 
			End if 
			
			//______________________________________________________
		: ($Txt_entryPoint="INIT")
			
			$cDirectives:=Form:C1466.settings.directives
			$cArrays:=Form:C1466.settings.arrays
			
			_o_Preferences("Get_Value"; "ignoreDeclarations"; ->$Lon_ignoreDeclarations)
			
			If ($Lon_parameters>=3)
				
				$t:=$2->
				$Txt_method:=$3->
				
			Else 
				
				GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $t)
				GET MACRO PARAMETER:C997(Full method text:K5:17; $Txt_method)
				
			End if 
			
			// Split_Method
			ARRAY TEXT:C222(<>tTxt_lines; 0)
			
			$c:=Split string:C1554($Txt_method; "\r"; sk trim spaces:K86:2)
			COLLECTION TO ARRAY:C1562($c; <>tTxt_lines)
			
			Form:C1466.lines:=New collection:C1472
			
			// Array size declaration with hexa : The line will not be moved ;-)
			ARRAY TEXT:C222($tTxt_local; 0x0000)
			ARRAY TEXT:C222($tTxt_ALPHA; 0x0000)
			ARRAY LONGINT:C221($tLon_stringLength; 0x0000)
			ARRAY TEXT:C222($tTxt_BLOB; 0x0000)
			ARRAY TEXT:C222($tTxt_BOOLEAN; 0x0000)
			ARRAY TEXT:C222($tTxt_DATE; 0x0000)
			ARRAY TEXT:C222($tTxt_LONGINT; 0x0000)
			ARRAY TEXT:C222($tTxt_INTEGER; 0x0000)
			ARRAY TEXT:C222($tTxt_GRAPH; 0x0000)
			ARRAY TEXT:C222($tTxt_TIME; 0x0000)
			ARRAY TEXT:C222($tTxt_PICTURE; 0x0000)
			ARRAY TEXT:C222($tTxt_POINTER; 0x0000)
			ARRAY TEXT:C222($tTxt_REAL; 0x0000)
			ARRAY TEXT:C222($tTxt_TEXT; 0x0000)
			ARRAY TEXT:C222($tTxt_OBJECT; 0x0000)
			ARRAY TEXT:C222($tTxt_COLLECTION; 0x0000)
			ARRAY TEXT:C222($tTxt_VARIANT; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayALPHA; 0x0000)
			ARRAY LONGINT:C221($tLon_arrayStringLength; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayALPHA_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayBOOLEAN; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayBOOLEAN_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayDATE; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayDATE_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayLONGINT; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayLONGINT_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayINTEGER; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayINTEGER_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayPICTURE; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayPICTURE_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayPOINTER; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayPOINTER_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayREAL; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayREAL_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayTEXT; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayTEXT_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayOBJECT; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayOBJECT_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayBLOB; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayBLOB_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_arrayTIME; 0x0000)
			ARRAY BOOLEAN:C223($tBoo_arrayTIME_2D; 0x0000)
			
			ARRAY TEXT:C222($tTxt_exceptions; 0x0000)
			
			$number:=$c.length  //Size of array(<>tTxt_lines)
			ARRAY LONGINT:C221(<>tLon_Line_Statut; $number)
			<>tLon_Line_Statut{0}:=0
			
			$Txt_patternParameter:="(?:\\$(?:\\d+)|(?:\\{\\d*\\})+)"
			
			ARRAY TEXT:C222($tTxt_nonLocals; 0x0000)
			$Txt_patternNonLocalVariable:="[(;]([^$;)]*)[;)]"
			
			If (False:C215)
				
				//==============================================================================================================
				//                                                    WIP
				//==============================================================================================================
				
				For each ($t; $c)
					
					$o:=New object:C1471(\
						"text"; $t; \
						"status"; Choose:C955(Length:C16($t); 1; Choose:C955(Position:C15(kCommentMark; $t)=1; 2; 0))\
						)
					
					$Lon_size:=-1
					CLEAR VARIABLE:C89($Lon_dimensions)
					CLEAR VARIABLE:C89($Ptr_array)
					
					$Boo_parameter:=Match regex:C1019("(?m-si)\\$(?:(?:\\d+)|(?:\\{\\d*\\})+)"; $t; 1)
					
					_o_Rgx_ExtractText($Txt_patternNonLocalVariable; $t; "1"; ->$tTxt_nonLocals)
					
					$l:=Find in array:C230($tTxt_nonLocals; Form:C1466.method+" ")
					
					If ($l>0)
						
						DELETE FROM ARRAY:C228($tTxt_nonLocals; $l; 1)
						
					End if 
					
					$tTxt_nonLocals:=0
					
					For ($Lon_j; Size of array:C274($tTxt_nonLocals); 1; -1)
						
						If (_o_isNumeric($tTxt_nonLocals{$Lon_j}))
							
							DELETE FROM ARRAY:C228($tTxt_nonLocals; $Lon_j; 1)
							
						End if 
					End for 
					
					$Lon_end_ii:=Size of array:C274($tTxt_nonLocals)
					
					Case of 
							
							//______________________________________________________
						: ($o.status=1)  // Empty line
							
							// <NOTHING MORE TO DO>
							
							//______________________________________________________
						: ($o.status=2)  // Commented line
							
							//______________________________________________________
						: (Match regex:C1019("(?m-si)"+Form:C1466.controlFlow[0]+"\\s*\\("+Command name:C538(215)+"\\)"; $t; 1))  // If (False)
							
							If ($o.status=0)
								
								$o.status:=-1
								
								<>tLon_Line_Statut{0}:=1
								
							End if 
							
							//______________________________________________________
							
						: (Match regex:C1019("(?m-si)"+Form:C1466.controlFlow[2]; $t; 1))  // End if
							
							If (<>tLon_Line_Statut{0}=1)
								
								$l:=Form:C1466.lines.extract("status").lastIndexOf(-1)
								
								If ($l#-1)
									
									<>tLon_Line_Statut{0}:=2
									Form:C1466.lines[$l].status:=-1
									
								End if 
							End if 
							
							//______________________________________________________
						Else 
							
							// A "Case of" statement should never omit "Else"
							
							//______________________________________________________
					End case 
					
					Form:C1466.lines.push($o)
					
				End for each 
				
				<>tLon_Line_Statut{0}:=0
				
			End if 
			//==============================================================================================================
			
			For ($i; 1; $number; 1)
				
				$Lon_size:=-1
				CLEAR VARIABLE:C89($Lon_dimensions)
				CLEAR VARIABLE:C89($Ptr_array)
				
				$t:=<>tTxt_lines{$i}
				
				$Boo_parameter:=(_o_Rgx_MatchText($Txt_patternParameter; $t)=0)
				
				_o_Rgx_ExtractText($Txt_patternNonLocalVariable; $t; "1"; ->$tTxt_nonLocals)
				
				$l:=Find in array:C230($tTxt_nonLocals; Form:C1466.method+" ")
				
				If ($l>0)
					
					DELETE FROM ARRAY:C228($tTxt_nonLocals; $l; 1)
					
				End if 
				
				$tTxt_nonLocals:=0
				
				For ($Lon_j; Size of array:C274($tTxt_nonLocals); 1; -1)
					
					If (_o_isNumeric($tTxt_nonLocals{$Lon_j}))
						
						DELETE FROM ARRAY:C228($tTxt_nonLocals; $Lon_j; 1)
						
					End if 
				End for 
				
				$Lon_end_ii:=Size of array:C274($tTxt_nonLocals)
				
				Case of 
						
						//______________________________________________________
					: (Length:C16($t)=0)  //Empty line
						
						<>tLon_Line_Statut{$i}:=1
						
						//______________________________________________________
					: (Position:C15(kCommentMark; $t)=1)  // Commented line (v11+)
						
						<>tLon_Line_Statut{$i}:=2
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)"+Form:C1466.controlFlow[0]+"\\s*\\("+Command name:C538(215)+"\\)"; $t; 1))  //If (False)
						
						If (<>tLon_Line_Statut{0}=0)
							
							<>tLon_Line_Statut{$i}:=-1
							<>tLon_Line_Statut{0}:=1
							
						End if 
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)"+Form:C1466.controlFlow[2]; $t; 1))  // If (False)
						
						If (<>tLon_Line_Statut{0}=1)
							
							For ($Lon_j; $i-1; 1; -1)
								
								Case of 
										
										//………………………………
									: (<>tLon_Line_Statut{$Lon_j}=3)  //C_xxxx
										
										//One more
										
										//………………………………
									: (<>tLon_Line_Statut{$Lon_j}=-1)  //If (False)
										
										<>tLon_Line_Statut{0}:=2
										<>tLon_Line_Statut{$i}:=-1
										
										//………………………………
									Else 
										
										<>tLon_Line_Statut{0}:=0
										
										//………………………………
								End case 
								
								$Lon_j:=$Lon_j*Num:C11(<>tLon_Line_Statut{0}=1)
								
							End for 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[5]; $t)=1)  // C_LONGINT
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[5]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_LONGINT; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_LONGINT>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[5]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[5]; $t)=1)  // ARRAY LONGINT
						
						$Ptr_array:=->$tTxt_arrayLONGINT
						$t:=Replace string:C233($t; $cArrays[5]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[11]; $t)=1)  // C_TEXT
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[11]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_TEXT; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_TEXT>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[11]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[10]; $t)=1)  //TABLEAU TEXTE
						
						$Ptr_array:=->$tTxt_arrayTEXT
						$t:=Replace string:C233($t; $cArrays[10]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[2]; $t)=1)  // C_BOOLEAN
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[2]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_BOOLEAN; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_BOOLEAN>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[2]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[2]; $t)=1)  //TABLEAU BOOLEEN
						
						$Ptr_array:=->$tTxt_arrayBOOLEAN
						$t:=Replace string:C233($t; $cArrays[2]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[1]; $t)=1)  // C_BLOB
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[1]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_BLOB; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_BLOB>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[1]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[1]; $t)=1)  // //ARRAY BLOB
						
						$Ptr_array:=->$tTxt_arrayBLOB
						$t:=Replace string:C233($t; $cArrays[1]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[3]; $t)=1)  // C_DATE
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[3]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_DATE; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_DATE>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[3]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[3]; $t)=1)  //TABLEAU DATE
						
						$Ptr_array:=->$tTxt_arrayDATE
						$t:=Replace string:C233($t; $cArrays[3]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[7]; $t)=1)  // C_TIME
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[7]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_TIME; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_TIME>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[7]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[6]; $t)=1)  //ARRAY TIME
						
						$Ptr_array:=->$tTxt_arrayTIME
						$t:=Replace string:C233($t; $cArrays[6]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[9]; $t)=1)  // C_POINTER
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[9]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_POINTER; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_POINTER>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[9]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[8]; $t)=1)  //TABLEAU POINTEUR
						
						$Ptr_array:=->$tTxt_arrayPOINTER
						$t:=Replace string:C233($t; $cArrays[8]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[8]; $t)=1)  // C_PICTURE
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[8]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_PICTURE; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_PICTURE>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[8]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[7]; $t)=1)  //TABLEAU IMAGE
						
						$Ptr_array:=->$tTxt_arrayPICTURE
						$t:=Replace string:C233($t; $cArrays[7]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[12]; $t)=1)  // C_OBJECT
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[12]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_OBJECT; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_OBJECT>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[12]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[11]; $t)=1)  //ARRAY OBJECT
						
						$Ptr_array:=->$tTxt_arrayOBJECT
						$t:=Replace string:C233($t; $cArrays[11]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[10]; $t)=1)  // C_REAL
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[10]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_REAL; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_REAL>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[10]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[9]; $t)=1)  //TABLEAU REEL
						
						$Ptr_array:=->$tTxt_arrayREAL
						$t:=Replace string:C233($t; $cArrays[9]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[0]; $t)=1)  // C_STRING
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[0]+"("; ""; 1)
							$Lon_stringLength:=util_Lon_Local_in_line($t; ->$tTxt_ALPHA; ->$tTxt_local; $Lon_ignoreDeclarations)
							
							$Lon_stringLength:=$Lon_stringLength+(255*Num:C11($Lon_stringLength=0))
							
							For ($Lon_j; 1; Size of array:C274($tTxt_ALPHA)-Size of array:C274($tLon_stringLength); 1)
								
								APPEND TO ARRAY:C911($tLon_stringLength; $Lon_stringLength)
								
							End for 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_ALPHA>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[0]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[0]; $t)=1)  //TABLEAU ALPHA
						
						$Ptr_array:=->$tTxt_arrayALPHA
						$t:=Replace string:C233($t; $cArrays[0]+"("; ""; 1)
						
						$Lon_stringLength:=_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						APPEND TO ARRAY:C911($tLon_arrayStringLength; Choose:C955($Lon_stringLength=0; 255; $Lon_stringLength))
						
						//______________________________________________________
					: (Position:C15($cDirectives[4]; $t)=1)  // C_INTEGER
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[4]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_INTEGER; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_INTEGER>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[4]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cArrays[4]; $t)=1)  //TABLEAU ENTIER
						
						$Ptr_array:=->$tTxt_arrayINTEGER
						$t:=Replace string:C233($t; $cArrays[4]+"("; ""; 1)
						
						_o_array_declaration($t; $Ptr_array; ->$tTxt_local; ->$Lon_size; ->$Boo_2Darray)
						
						If ($Ptr_array->>0)
							
							<>tLon_Line_Statut{$i}:=3
							
						Else 
							
							If (Length:C16($Ptr_array->{0})>0)
								
								APPEND TO ARRAY:C911($tTxt_exceptions; $Ptr_array->{0})
								
							End if 
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[6]; $t)=1)  // C_GRAPH (obsolete)
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[6]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_GRAPH; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_GRAPH>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[6]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[13]; $t)=1)  // C_COLLECTION
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[13]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_COLLECTION; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_COLLECTION>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[13]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					: (Position:C15($cDirectives[14]; $t)=1)  // C_VARIANT
						
						If ($Lon_ignoreDeclarations=0) | $Boo_parameter
							
							$t:=Replace string:C233($t; $cDirectives[14]+"("; ""; 1)
							util_Lon_Local_in_line($t; ->$tTxt_VARIANT; ->$tTxt_local; $Lon_ignoreDeclarations)
							<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_VARIANT>0) & ($Lon_end_ii=0))
							
						Else 
							
							<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
							
						End if 
						
						If (<>tLon_Line_Statut{$i}#3)
							
							<>tTxt_lines{$i}:=$cDirectives[14]+"("
							
							For ($Lon_ii; 1; $Lon_end_ii; 1)
								
								<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
								
							End for 
							
							<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
							
						End if 
						
						//______________________________________________________
					Else 
						
						util_Lon_Local_in_line($t; ->$tTxt_local)
						
						//______________________________________________________
				End case 
				
				If (Not:C34(Is nil pointer:C315($Ptr_array)) & $Boo_parameter)
					
					If (<>tLon_Line_Statut{$i}=3)
						
						<>tLon_Line_Statut{$i}:=0
						CLEAR VARIABLE:C89($Ptr_array->)
						CLEAR VARIABLE:C89($tTxt_local)
						
					End if 
				End if 
			End for 
			
			$number:=Size of array:C274($tTxt_local)
			ARRAY LONGINT:C221($tLon_sortOrder; $number)
			
			If ($number>0)
				
				//Put first the parameters with indirection
				For ($i; 1; $number; 1)
					
					$tLon_sortOrder{$i}:=2*Num:C11(Position:C15("{"; $tTxt_local{$i})>0)
					
					If (_o_isNumeric(Replace string:C233(Replace string:C233(Substring:C12($tTxt_local{$i}; 2); "{"; ""); "}"; "")))
						
						//
						
					Else 
						
						$tLon_sortOrder{$i}:=20
						
					End if 
				End for 
				
				MULTI SORT ARRAY:C718($tLon_sortOrder; >; $tTxt_local; >)
				
				$Lon_firstIndice:=MAXINT:K35:1
				$tTxt_local:=Find in array:C230($tTxt_local; "${@")
				
				If ($tTxt_local>0)
					
					$Lon_firstIndice:=Num:C11($tTxt_local{$tTxt_local})
					
				End if 
				
				If (Is a list:C621((Form:C1466.list)->))
					
					CLEAR LIST:C377((Form:C1466.list)->; *)
					
				End if 
				
				(Form:C1466.list)->:=New list:C375
				
				For ($i; 1; $number; 1)
					
					CLEAR VARIABLE:C89($Lon_type)
					
					$t:=$tTxt_local{$i}
					
					If ($tLon_sortOrder{$i}=0)  //Parameter
						
						$tLon_sortOrder{0}:=Num:C11($t)
						
					Else 
						
						$tLon_sortOrder{0}:=-1
						
					End if 
					
					Case of 
							
							//…………………………………………………………………………………
						: ($tLon_sortOrder{0}>=$Lon_firstIndice)
							
							//…………………………………………………………………………………
						: (Find in array:C230($tTxt_exceptions; $t)>0)
							
							//…………………………………………………………………………………
						Else 
							
							APPEND TO LIST:C376((Form:C1466.list)->; $t; $i)
							
							Case of 
									
									//______________________________________________________
								: (Find in array:C230($tTxt_ALPHA; $t)>0)
									
									$Lon_type:=1
									SET LIST ITEM PARAMETER:C986((Form:C1466.list)->; $i; "size"; $tLon_stringLength{Find in array:C230($tTxt_ALPHA; $t)})
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayALPHA; $t)>0)
									
									$Lon_type:=101
									SET LIST ITEM PARAMETER:C986((Form:C1466.list)->; $i; "size"; $tLon_arrayStringLength{Find in array:C230($tTxt_arrayALPHA; $t)})
									
									//______________________________________________________
								: (Find in array:C230($tTxt_BLOB; $t)>0)
									
									$Lon_type:=2
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayBLOB; $t)>0)
									
									$Lon_type:=102
									
									//______________________________________________________
								: (Find in array:C230($tTxt_BOOLEAN; $t)>0)
									
									$Lon_type:=3
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayBOOLEAN; $t)>0)
									
									$Lon_type:=103
									
									//______________________________________________________
								: (Find in array:C230($tTxt_DATE; $t)>0)
									
									$Lon_type:=4
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayDATE; $t)>0)
									
									$Lon_type:=104
									
									//______________________________________________________
								: (Find in array:C230($tTxt_INTEGER; $t)>0)
									
									$Lon_type:=5
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayINTEGER; $t)>0)
									
									$Lon_type:=105
									
									//______________________________________________________
								: (Find in array:C230($tTxt_LONGINT; $t)>0)
									
									$Lon_type:=6
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayLONGINT; $t)>0)
									
									$Lon_type:=106
									
									//______________________________________________________
								: (Find in array:C230($tTxt_GRAPH; $t)>0)
									
									$Lon_type:=7
									
									//______________________________________________________
								: (Find in array:C230($tTxt_TIME; $t)>0)
									
									$Lon_type:=8
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayTIME; $t)>0)
									
									$Lon_type:=108
									
									//______________________________________________________
								: (Find in array:C230($tTxt_PICTURE; $t)>0)
									
									$Lon_type:=9
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayPICTURE; $t)>0)
									
									$Lon_type:=109
									
									//______________________________________________________
								: (Find in array:C230($tTxt_OBJECT; $t)>0)
									
									$Lon_type:=13
									
									//______________________________________________________
								: (Find in array:C230($tTxt_COLLECTION; $t)>0)
									
									$Lon_type:=14  //C_COLLECTION
									
									//______________________________________________________
								: (Find in array:C230($tTxt_VARIANT; $t)>0)
									
									$Lon_type:=15  //C_VARIANT
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayOBJECT; $t)>0)
									
									$Lon_type:=113
									
									//______________________________________________________
								: (Find in array:C230($tTxt_POINTER; $t)>0)
									
									$Lon_type:=10
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayPOINTER; $t)>0)
									
									$Lon_type:=110
									
									//______________________________________________________
								: (Find in array:C230($tTxt_REAL; $t)>0)
									
									$Lon_type:=11
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayREAL; $t)>0)
									
									$Lon_type:=111
									
									//______________________________________________________
								: (Find in array:C230($tTxt_TEXT; $t)>0)
									
									$Lon_type:=12
									
									//______________________________________________________
								: (Find in array:C230($tTxt_arrayTEXT; $t)>0)
									
									$Lon_type:=112
									
									//______________________________________________________
								Else 
									
									$Lon_type:=Private_Lon_Declaration_Type($t; ->$Lon_size)
									
									//_o_C_STRING @ _o_ARRAY_STRING
									If ($Lon_type=1)\
										 | ($Lon_type=101)
										
										SET LIST ITEM PARAMETER:C986((Form:C1466.list)->; $i; "size"; Choose:C955($Lon_size=0; 255; $Lon_size))
										
									End if 
									
									//______________________________________________________
							End case 
							
							SET LIST ITEM PARAMETER:C986((Form:C1466.list)->; $i; "name"; $t)  //keep the current name
							
							// Type change
							Case of 
									
									//………………………………………………
								: (Not:C34(Storage:C1525.macros.preferences.options ?? 30))\
									 & (Num:C11(Application version:C493)>=1800)
									
									// Option: Don't declare variables Alpha as Text
									// or
									// OBSOLETE TYPES
									
									//………………………………………………
								: ($Lon_type=1)  // _O_C_STRING
									
									$Lon_type:=12  // TEXT
									
									//………………………………………………
								: ($Lon_type=5)  // _o_C_INTEGER
									
									$Lon_type:=6  // LONGINT
									
									//………………………………………………
								: ($Lon_type=101)  // _O_ARRAY STRING
									
									$Lon_type:=112  // ARRAY TEXT
									
									//………………………………………………
							End case 
							
							$Lon_type:=$Lon_type+(1000*Num:C11(($t="${@") | (_o_isNumeric(Substring:C12($t; 2)))))
							SET LIST ITEM PARAMETER:C986((Form:C1466.list)->; $i; "type"; $Lon_type)
							
							// Set styles
							Case of 
									
									//--------------------------------------
								: ($Lon_type>1000)
									
									$Lon_type:=$Lon_type-1000
									$Lon_styles:=Bold:K14:2+Italic:K14:3
									
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
							
							SET LIST ITEM PROPERTIES:C386((Form:C1466.list)->; $i; False:C215; $Lon_styles; "path:/RESOURCES/Images/types/field_"+String:C10($Lon_type)+".png")
							
					End case 
				End for 
				
				GET LIST PROPERTIES:C632((Form:C1466.list)->; $Lon_appearance; $Lon_icon)
				SET LIST PROPERTIES:C387((Form:C1466.list)->; $Lon_appearance; $Lon_icon; 20)
				
				// Select the first variable
				SELECT LIST ITEMS BY POSITION:C381((Form:C1466.list)->; 1)
				
			End if 
			
			OBJECT SET VISIBLE:C603(*; "spinner"; False:C215)
			(OBJECT Get pointer:C1124(Object named:K67:5; "spinner"))->:=0
			
			Form:C1466.refresh()
			
			//______________________________________________________
		: ($Txt_entryPoint="_init")
			
			cs:C1710.menuBar.new().defaultMinimalMenuBar().set()
			
			Compiler_
			
			If (Not:C34(<>Boo_declarationInited)) | (Structure file:C489=Structure file:C489(*))
				
				<>Boo_declarationInited:=True:C214
				
				ARRAY LONGINT:C221(<>tLon_command; 32)
				
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
				APPEND TO ARRAY:C911(<>tLon_command; 1216)
				
				//ARRAY OBJECT (34)
				APPEND TO ARRAY:C911(<>tLon_command; 1221)
				
				//ARRAY BLOB (35)
				APPEND TO ARRAY:C911(<>tLon_command; 1222)
				
				//ARRAY TIME (36)
				APPEND TO ARRAY:C911(<>tLon_command; 1223)
				
				// 21-6-2017
				APPEND TO ARRAY:C911(<>tLon_command; 1488)
				
			End if 
			
			_o_DECLARATION("Get_Syntax_Preferences")
			
			//______________________________________________________
		: ($Txt_entryPoint="Get_Syntax_Preferences")
			
			ARRAY TEXT:C222(<>tTxt_2D_Declaration_Patterns; 0; 0)
			ARRAY LONGINT:C221(<>tLon_Declaration_Types; 0)
			
			$Dom_root:=DOM Parse XML source:C719(Storage:C1525.macros.preferences.platformPath)
			
			If (OK=1)
				
				$Dom_node:=DOM Find XML element:C864($Dom_root; "/M_4DPop/declarations")
				
				If (OK=1)
					
					// Get the component preferences version
					If (DOM Count XML attributes:C727($Dom_node)>0)
						
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_node; "version"; $Lon_version)
						
					End if 
				End if 
				
				ARRAY TEXT:C222($tTxt_declarations; 0x0000)
				$tTxt_declarations{0}:=DOM Find XML element:C864($Dom_root; "/M_4DPop/declarations/declaration"; $tTxt_declarations)
				
				If (OK=1)
					
					For ($i; 1; Size of array:C274($tTxt_declarations); 1)
						
						DOM GET XML ATTRIBUTE BY NAME:C728($tTxt_declarations{$i}; "type"; $t)
						
						If (OK=1)
							
							$Lon_type:=Num:C11($t)
							DOM GET XML ATTRIBUTE BY NAME:C728($tTxt_declarations{$i}; "value"; $t)
							
							If (OK=1)
								
								ARRAY TEXT:C222($tTxt_values; 0x0000)
								
								If ($Lon_version<2)
									
									//Update the separator
									$t:=Replace string:C233($t; ","; ";")
									
								End if 
								
								$c:=Split string:C1554($t; ";")
								
								If ($c.length>0)
									
									$Lon_x:=$Lon_x+1
									INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns; $Lon_x; 1)
									<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:=$t
									
									For each ($tt; $c)
										
										$tt:=Replace string:C233(Replace string:C233($tt; "*"; ".*"); "?"; ".")
										APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x}; $tt)
										
									End for each 
									
									APPEND TO ARRAY:C911(<>tLon_Declaration_Types; $Lon_type)
									
								End if 
							End if 
						End if 
					End for 
					
					//v14 - Add new type Objects {
					If (Find in array:C230(<>tLon_Declaration_Types; 113)=-1)  //ARRAY OBJECT
						
						APPEND TO ARRAY:C911(<>tLon_Declaration_Types; 113)
						$Lon_x:=$Lon_x+1
						INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns; $Lon_x; 1)
						<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*tObj_*"
						APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x}; ".*tObj_.*")
						
					End if 
					
					If (Find in array:C230(<>tLon_Declaration_Types; 13)=-1)  //C_OBJECT
						
						APPEND TO ARRAY:C911(<>tLon_Declaration_Types; 13)
						$Lon_x:=$Lon_x+1
						INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns; $Lon_x; 1)
						<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*Obj_*"
						APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x}; ".*Obj_.*")
						
					End if 
					
					If (Find in array:C230(<>tLon_Declaration_Types; 102)=-1)  //ARRAY BLOB
						
						APPEND TO ARRAY:C911(<>tLon_Declaration_Types; 102)
						$Lon_x:=$Lon_x+1
						INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns; $Lon_x; 1)
						<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*tBlb_*"
						APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x}; ".*tBlb_.*")
						
					End if 
					
					If (Find in array:C230(<>tLon_Declaration_Types; 108)=-1)  //ARRAY TIME
						
						APPEND TO ARRAY:C911(<>tLon_Declaration_Types; 108)
						$Lon_x:=$Lon_x+1
						INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns; $Lon_x; 1)
						<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*tGmt_*"
						APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x}; ".*tGmt_.*")
						
					End if   //}
					
					// 21-6-2017 - C_COLLECTION {
					If (Find in array:C230(<>tLon_Declaration_Types; 14)=-1)
						
						APPEND TO ARRAY:C911(<>tLon_Declaration_Types; 14)
						$Lon_x:=$Lon_x+1
						INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns; $Lon_x; 1)
						<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*Col_*"
						APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x}; ".*Col_.*")
						
					End if 
					//}
					
					// 25-9-2019 - C_VARIANT {
					If (Find in array:C230(<>tLon_Declaration_Types; 15)=-1)
						
						APPEND TO ARRAY:C911(<>tLon_Declaration_Types; 15)
						$Lon_x:=$Lon_x+1
						INSERT IN ARRAY:C227(<>tTxt_2D_Declaration_Patterns; $Lon_x; 1)
						<>tTxt_2D_Declaration_Patterns{$Lon_x}{0}:="*Var_*"
						APPEND TO ARRAY:C911(<>tTxt_2D_Declaration_Patterns{$Lon_x}; ".*Var_.*")
						
					End if 
					//}
					
					SORT ARRAY:C229(<>tLon_Declaration_Types; <>tLon_command; <>tTxt_2D_Declaration_Patterns; <)
					
				End if 
				
				DOM CLOSE XML:C722($Dom_root)
				
			End if 
			
			//______________________________________________________
		: ($Txt_entryPoint="Set_Syntax_Preferences")
			
			If ($Lon_parameters>=3)
				
				$Dom_root:=DOM Parse XML source:C719(Storage:C1525.macros.preferences.platformPath)
				
				If (OK=1)
					
					$Dom_node:=DOM Find XML element:C864($Dom_root; "/M_4DPop/declarations")
					
					If (OK=1)
						
						DOM SET XML ATTRIBUTE:C866($Dom_node; "version"; 2)
						
						ARRAY TEXT:C222($tTxt_declarations; 0x0000)
						$tTxt_declarations{0}:=DOM Find XML element:C864($Dom_root; "/M_4DPop/declarations/declaration"; $tTxt_declarations)
						
						If (OK=1)
							
							For ($i; 1; Size of array:C274($tTxt_declarations); 1)
								
								DOM REMOVE XML ELEMENT:C869($tTxt_declarations{$i})
								
							End for 
							
							For ($i; 1; Size of array:C274($2->); 1)
								
								$tTxt_declarations{0}:=DOM Create XML element:C865($Dom_node; "declaration"; "type"; String:C10($2->{$i}); "value"; $3->{$i})
								
							End for 
							
							$Dom_root:=xml_cleanup($Dom_root)
							
							DOM EXPORT TO FILE:C862($Dom_root; Storage:C1525.macros.preferences.platformPath)
							
						End if 
					End if 
					
					DOM CLOSE XML:C722($Dom_root)
					
				End if 
			End if 
			
			//______________________________________________________
	End case 
End if 