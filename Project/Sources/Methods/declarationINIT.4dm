//%attributes = {}
C_BOOLEAN:C305($Boo_2Darray;$bParamater)
C_LONGINT:C283($i;$j;$l;$Lon_appearance;$Lon_dimensions;$Lon_end_ii)
C_LONGINT:C283($Lon_firstIndice;$Lon_icon;$Lon_ignoreDeclarations;$Lon_ii;$Lon_size;$Lon_stringLength)
C_LONGINT:C283($Lon_styles;$Lon_type;$number)
C_POINTER:C301($Ptr_array)
C_TEXT:C284($t;$tLine;$Txt_patternNonLocalVariable;$Txt_patternParameter)
C_OBJECT:C1216($o;$oLine)
C_COLLECTION:C1488($cArrays;$cDirectives)

$cDirectives:=Form:C1466.settings.directives
$cArrays:=Form:C1466.settings.arrays
$Lon_ignoreDeclarations:=Num:C11(Form:C1466.preferences.options.ignoreDeclarations)

$bUseCompilerDirective:=Not:C34(Form:C1466.preferences.options.ignoreDeclarations)

ARRAY TEXT:C222(<>tTxt_lines;0)
COLLECTION TO ARRAY:C1562(Form:C1466.code;<>tTxt_lines)

  // Array size declaration with hexa : The line will not be moved ;-)
ARRAY TEXT:C222($tTxt_local;0x0000)
ARRAY TEXT:C222($tTxt_ALPHA;0x0000)
ARRAY LONGINT:C221($tLon_stringLength;0x0000)
ARRAY TEXT:C222($tTxt_BLOB;0x0000)
ARRAY TEXT:C222($tTxt_BOOLEAN;0x0000)
ARRAY TEXT:C222($tTxt_DATE;0x0000)
ARRAY TEXT:C222($tTxt_LONGINT;0x0000)
ARRAY TEXT:C222($tTxt_INTEGER;0x0000)
ARRAY TEXT:C222($tTxt_GRAPH;0x0000)
ARRAY TEXT:C222($tTxt_TIME;0x0000)
ARRAY TEXT:C222($tTxt_PICTURE;0x0000)
ARRAY TEXT:C222($tTxt_POINTER;0x0000)
ARRAY TEXT:C222($tTxt_REAL;0x0000)
ARRAY TEXT:C222($tTxt_TEXT;0x0000)
ARRAY TEXT:C222($tTxt_OBJECT;0x0000)
ARRAY TEXT:C222($tTxt_COLLECTION;0x0000)
ARRAY TEXT:C222($tTxt_VARIANT;0x0000)

ARRAY TEXT:C222($tTxt_arrayALPHA;0x0000)
ARRAY LONGINT:C221($tLon_arrayStringLength;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayALPHA_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayBOOLEAN;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayBOOLEAN_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayDATE;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayDATE_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayLONGINT;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayLONGINT_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayINTEGER;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayINTEGER_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayPICTURE;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayPICTURE_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayPOINTER;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayPOINTER_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayREAL;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayREAL_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayTEXT;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayTEXT_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayOBJECT;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayOBJECT_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayBLOB;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayBLOB_2D;0x0000)

ARRAY TEXT:C222($tTxt_arrayTIME;0x0000)
ARRAY BOOLEAN:C223($tBoo_arrayTIME_2D;0x0000)

ARRAY TEXT:C222($tTxt_exceptions;0x0000)

$number:=Form:C1466.code.length  //Size of array(<>tTxt_lines)
ARRAY LONGINT:C221(<>tLon_Line_Statut;$number)
<>tLon_Line_Statut{0}:=0

$Txt_patternParameter:="(?:\\$(?:\\d+)|(?:\\{\\d*\\})+)"

ARRAY TEXT:C222($tTxt_nonLocals;0x0000)
$Txt_patternNonLocalVariable:="[(;]([^$;)]*)[;)]"


C_BOOLEAN:C305($bCommentBlockStarted)

$oDirectives:=New object:C1471
ARRAY LONGINT:C221($aL_pos;0x0000)
ARRAY LONGINT:C221($aL_len;0x0000)

$cLines:=New collection:C1472

For each ($t;Form:C1466.code)
	
	$oLine:=New object:C1471(\
		"code";$t;\
		"empty";Length:C16($t)=0;\
		"comment";Position:C15("//";$t)=1)
	
	If ($oLine.empty)\
		 | ($oLine.comment)
		
		  // <NOTHING MORE TO DO>
		
	Else 
		
		If ($bCommentBlockStarted)
			
			$bCommentBlockStop:=(Match regex:C1019("(?m-si)(?!^/\\*.*)\\*/$";$t;1))
			
		Else 
			
			$bCommentBlockStarted:=(Match regex:C1019("(?m-si)^/\\*(?!.*\\*/)";$t;1))
			
		End if 
		
		Case of 
				
				  //______________________________________________________
			: ($bCommentBlockStop)
				
				$oLine.comment:=True:C214
				$bCommentBlockStarted:=False:C215
				
				  //______________________________________________________
			: ($bCommentBlockStarted)
				
				$oLine.comment:=True:C214
				
				  //______________________________________________________
			Else 
				
				$oLine.directive:=Match regex:C1019("(?m-si)((?:_O_)?C_[^(]+)\\(([^\\)]*)\\)";$t;1;$aL_pos;$aL_len)
				$oLine.withParameter:=Match regex:C1019("(?m-si)\\$(?:(?:\\d+)|(?:\\{\\d*\\})+)";$t;1)
				
				If $oLine.directive\
					 & ($oLine.withParameter | $bUseCompilerDirective)
					
					$tDirective:=Substring:C12($t;$aL_pos{1};$aL_len{1})
					$lCmd:=Form:C1466.settings.parametersDeclaration.query("comment=:1";Replace string:C233($tDirective;"_O_";"")).pop().cmd
					
					For each ($tVariable;Split string:C1554(Substring:C12($t;$aL_pos{2};$aL_len{2});";";sk ignore empty strings:K86:1+sk trim spaces:K86:2))
						
						If ($bUseCompilerDirective)
							
							If (Match regex:C1019("(?mi-s)\\$.*";$tVariable;1))  // Local
								
								If ($oDirectives[$tDirective]=Null:C1517)
									
									$oDirectives[$tDirective]:=New collection:C1472($tVariable)
									
								Else 
									
									$oDirectives[$tDirective].push($tVariable)
									
								End if 
							End if 
							
						Else 
							
							If (Match regex:C1019("(?mi-s)\\$\\{*\\d+\\}*";$tVariable;1))  // Parameter
								
								If ($oDirectives[$tDirective]=Null:C1517)
									
									$oDirectives[$tDirective]:=New collection:C1472($tVariable)
									
								Else 
									
									$oDirectives[$tDirective].push($tVariable)
									
								End if 
							End if 
						End if 
					End for each 
				End if 
				
				$oLine.arrayDeclaration:=Match regex:C1019("(?m-si)((?:_O_)?(?:ARRAY|TABLEAU)[^(]+)\\(([^\\)]*)\\)";$t;1;$aL_pos;$aL_len)
				
				If ($oLine.arrayDeclaration)
					
					$tDirective:=Substring:C12($t;$aL_pos{1};$aL_len{1})
					$lCmd:=Form:C1466.settings.arraysDeclaration.query("comment=:1";Replace string:C233($tDirective;"_O_";"")).pop().cmd
					
					$c:=Split string:C1554(Substring:C12($t;$aL_pos{2};$aL_len{2});";";sk ignore empty strings:K86:1+sk trim spaces:K86:2)
					
					If ($c.length=3)
						
						If (Match regex:C1019("^\\d+$";$c[0];1))
							
							  // Old string length
							$o:=New object:C1471(\
								"length";$c[0];\
								"name";$c[1];\
								"size";$c[2];\
								"inline";Match regex:C1019("(?mi-s)^0x|(?!0)\\d+|\\D+$";$c[2];1))
							
						Else 
							
							  // 2D array
							$o:=New object:C1471(\
								"name";$c[0];\
								"size";$c[1];\
								"row";$c[2];\
								"inline";True:C214)
							
						End if 
						
					Else 
						
						$o:=New object:C1471(\
							"name";$c[0];\
							"size";$c[1];\
							"inline";Match regex:C1019("(?mi-s)^0x|(?!0)\\d+|\\D+$";$c[1];1))
						
					End if 
					
					If ($oDirectives[$tDirective]=Null:C1517)
						
						$oDirectives[$tDirective]:=New collection:C1472($o)
						
					Else 
						
						$oDirectives[$tDirective].push($o)
						
					End if 
				End if 
				
				  //______________________________________________________
		End case 
	End if 
	
	$cLines.push($oLine)
	
End for each 


If (False:C215)
	
	  //==============================================================================================================
	  //                                                    WIP
	  //==============================================================================================================
	
	Form:C1466.lines:=New collection:C1472
	
	For each ($tLine;Form:C1466.code)
		
		$o:=New object:C1471(\
			"text";$tLine;\
			"status";Choose:C955(Length:C16($tLine);1;Choose:C955(Position:C15(kCommentMark;$tLine)=1;2;0))\
			)
		
		$Lon_size:=-1
		CLEAR VARIABLE:C89($Lon_dimensions)
		CLEAR VARIABLE:C89($Ptr_array)
		
		$bParamater:=Match regex:C1019("(?m-si)\\$(?:(?:\\d+)|(?:\\{\\d*\\})+)";$tLine;1)
		
		Rgx_ExtractText ($Txt_patternNonLocalVariable;$tLine;"1";->$tTxt_nonLocals)
		
		$l:=Find in array:C230($tTxt_nonLocals;Form:C1466.method+" ")
		
		If ($l>0)
			
			DELETE FROM ARRAY:C228($tTxt_nonLocals;$l;1)
			
		End if 
		
		$tTxt_nonLocals:=0
		
		For ($j;Size of array:C274($tTxt_nonLocals);1;-1)
			
			If (str_isNumeric ($tTxt_nonLocals{$j}))
				
				DELETE FROM ARRAY:C228($tTxt_nonLocals;$j;1)
				
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
			: ($tLine="/*@")  //start comment block
				
				  //______________________________________________________
			: ($tLine="@*/")  //stop comment block
				
				  //______________________________________________________
			: (Match regex:C1019("(?m-si)"+Form:C1466.controlFlow[0]+"\\s*\\("+Command name:C538(215)+"\\)";$tLine;1))  // If (False)
				
				If ($o.status=0)
					
					$o.status:=-1
					
					<>tLon_Line_Statut{0}:=1
					
				End if 
				
				  //______________________________________________________
				
			: (Match regex:C1019("(?m-si)"+Form:C1466.controlFlow[2];$tLine;1))  // End if
				
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

For ($i;1;$number;1)
	
	$Lon_size:=-1
	
	CLEAR VARIABLE:C89($Lon_dimensions)
	CLEAR VARIABLE:C89($Ptr_array)
	
	$tLine:=<>tTxt_lines{$i}
	$bParamater:=Match regex:C1019("(?m-si)\\$(?:(?:\\d+)|(?:\\{\\d*\\})+)";$tLine;1)
	Rgx_ExtractText ($Txt_patternNonLocalVariable;$tLine;"1";->$tTxt_nonLocals)
	
	$l:=Find in array:C230($tTxt_nonLocals;Form:C1466.method+" ")
	
	If ($l>0)
		
		DELETE FROM ARRAY:C228($tTxt_nonLocals;$l;1)
		
	End if 
	
	$tTxt_nonLocals:=0
	
	For ($j;Size of array:C274($tTxt_nonLocals);1;-1)
		
		If (str_isNumeric ($tTxt_nonLocals{$j}))
			
			DELETE FROM ARRAY:C228($tTxt_nonLocals;$j;1)
			
		End if 
	End for 
	
	$Lon_end_ii:=Size of array:C274($tTxt_nonLocals)
	
	Case of 
			
			  //______________________________________________________
		: (Length:C16($tLine)=0)  //Empty line
			
			<>tLon_Line_Statut{$i}:=1
			
			  //______________________________________________________
		: (Position:C15(kCommentMark;$tLine)=1)  // Commented line (v11+)
			
			<>tLon_Line_Statut{$i}:=2
			
			  //______________________________________________________
		: (Match regex:C1019("(?m-si)"+Form:C1466.controlFlow[0]+"\\s*\\("+Command name:C538(215)+"\\)";$tLine;1))  //If (False)
			
			If (<>tLon_Line_Statut{0}=0)
				
				<>tLon_Line_Statut{$i}:=-1
				<>tLon_Line_Statut{0}:=1
				
			End if 
			
			  //______________________________________________________
		: (Match regex:C1019("(?m-si)"+Form:C1466.controlFlow[2];$tLine;1))  // End if
			
			If (<>tLon_Line_Statut{0}=1)
				
				For ($j;$i-1;1;-1)
					
					Case of 
							
							  //………………………………
						: (<>tLon_Line_Statut{$j}=3)  //C_xxxx
							
							  //One more
							
							  //………………………………
						: (<>tLon_Line_Statut{$j}=-1)  //If (False)
							
							<>tLon_Line_Statut{0}:=2
							<>tLon_Line_Statut{$i}:=-1
							
							  //………………………………
						Else 
							
							<>tLon_Line_Statut{0}:=0
							
							  //………………………………
					End case 
					
					$j:=$j*Num:C11(<>tLon_Line_Statut{0}=1)
					
				End for 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[5];$tLine)=1)  // C_LONGINT
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[5]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_LONGINT;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_LONGINT>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[5]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[5];$tLine)=1)  // ARRAY LONGINT
			
			$Ptr_array:=->$tTxt_arrayLONGINT
			$tLine:=Replace string:C233($tLine;$cArrays[5]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[11];$tLine)=1)  // C_TEXT
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[11]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_TEXT;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_TEXT>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[11]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[10];$tLine)=1)  //TABLEAU TEXTE
			
			$Ptr_array:=->$tTxt_arrayTEXT
			$tLine:=Replace string:C233($tLine;$cArrays[10]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[2];$tLine)=1)  // C_BOOLEAN
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[2]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_BOOLEAN;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_BOOLEAN>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[2]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[2];$tLine)=1)  //TABLEAU BOOLEEN
			
			$Ptr_array:=->$tTxt_arrayBOOLEAN
			$tLine:=Replace string:C233($tLine;$cArrays[2]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[1];$tLine)=1)  // C_BLOB
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[1]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_BLOB;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_BLOB>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[1]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[1];$tLine)=1)  // //ARRAY BLOB
			
			$Ptr_array:=->$tTxt_arrayBLOB
			$tLine:=Replace string:C233($tLine;$cArrays[1]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[3];$tLine)=1)  // C_DATE
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[3]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_DATE;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_DATE>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[3]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[3];$tLine)=1)  //TABLEAU DATE
			
			$Ptr_array:=->$tTxt_arrayDATE
			$tLine:=Replace string:C233($tLine;$cArrays[3]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[7];$tLine)=1)  // C_TIME
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[7]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_TIME;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_TIME>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[7]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[6];$tLine)=1)  //ARRAY TIME
			
			$Ptr_array:=->$tTxt_arrayTIME
			$tLine:=Replace string:C233($tLine;$cArrays[6]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[9];$tLine)=1)  // C_POINTER
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[9]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_POINTER;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_POINTER>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[9]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[8];$tLine)=1)  //TABLEAU POINTEUR
			
			$Ptr_array:=->$tTxt_arrayPOINTER
			$tLine:=Replace string:C233($tLine;$cArrays[8]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[8];$tLine)=1)  // C_PICTURE
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[8]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_PICTURE;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_PICTURE>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[8]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[7];$tLine)=1)  //TABLEAU IMAGE
			
			$Ptr_array:=->$tTxt_arrayPICTURE
			$tLine:=Replace string:C233($tLine;$cArrays[7]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[12];$tLine)=1)  // C_OBJECT
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[12]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_OBJECT;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_OBJECT>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[12]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[11];$tLine)=1)  //ARRAY OBJECT
			
			$Ptr_array:=->$tTxt_arrayOBJECT
			$tLine:=Replace string:C233($tLine;$cArrays[11]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[10];$tLine)=1)  // C_REAL
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[10]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_REAL;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_REAL>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[10]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[9];$tLine)=1)  //TABLEAU REEL
			
			$Ptr_array:=->$tTxt_arrayREAL
			$tLine:=Replace string:C233($tLine;$cArrays[9]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[0];$tLine)=1)  // C_STRING
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[0]+"(";"";1)
				$Lon_stringLength:=util_Lon_Local_in_line ($tLine;->$tTxt_ALPHA;->$tTxt_local;$Lon_ignoreDeclarations)
				
				$Lon_stringLength:=$Lon_stringLength+(255*Num:C11($Lon_stringLength=0))
				
				For ($j;1;Size of array:C274($tTxt_ALPHA)-Size of array:C274($tLon_stringLength);1)
					
					APPEND TO ARRAY:C911($tLon_stringLength;$Lon_stringLength)
					
				End for 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_ALPHA>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[0]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[0];$tLine)=1)  //TABLEAU ALPHA
			
			$Ptr_array:=->$tTxt_arrayALPHA
			$tLine:=Replace string:C233($tLine;$cArrays[0]+"(";"";1)
			
			$Lon_stringLength:=util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			APPEND TO ARRAY:C911($tLon_arrayStringLength;Choose:C955($Lon_stringLength=0;255;$Lon_stringLength))
			
			  //______________________________________________________
		: (Position:C15($cDirectives[4];$tLine)=1)  // C_INTEGER
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[4]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_INTEGER;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_INTEGER>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[4]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cArrays[4];$tLine)=1)  //TABLEAU ENTIER
			
			$Ptr_array:=->$tTxt_arrayINTEGER
			$tLine:=Replace string:C233($tLine;$cArrays[4]+"(";"";1)
			
			util_Lon_array_declaration ($tLine;$Ptr_array;->$tTxt_local;->$Lon_size;->$Boo_2Darray)
			
			If ($Ptr_array->>0)
				
				<>tLon_Line_Statut{$i}:=3
				
			Else 
				
				If (Length:C16($Ptr_array->{0})>0)
					
					APPEND TO ARRAY:C911($tTxt_exceptions;$Ptr_array->{0})
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[6];$tLine)=1)  // C_GRAPH (obsolete)
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[6]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_GRAPH;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_GRAPH>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[6]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[13];$tLine)=1)  // C_COLLECTION
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[13]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_COLLECTION;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_COLLECTION>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[13]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		: (Position:C15($cDirectives[14];$tLine)=1)  // C_VARIANT
			
			If ($Lon_ignoreDeclarations=0) | $bParamater
				
				$tLine:=Replace string:C233($tLine;$cDirectives[14]+"(";"";1)
				util_Lon_Local_in_line ($tLine;->$tTxt_VARIANT;->$tTxt_local;$Lon_ignoreDeclarations)
				<>tLon_Line_Statut{$i}:=3*Num:C11((Size of array:C274($tTxt_local)>0) & ($tTxt_VARIANT>0) & ($Lon_end_ii=0))
				
			Else 
				
				<>tLon_Line_Statut{$i}:=3*Num:C11($Lon_end_ii=0)
				
			End if 
			
			If (<>tLon_Line_Statut{$i}#3)
				
				<>tTxt_lines{$i}:=$cDirectives[14]+"("
				
				For ($Lon_ii;1;$Lon_end_ii;1)
					
					<>tTxt_lines{$i}:=<>tTxt_lines{$i}+$tTxt_nonLocals{$Lon_ii}+(";"*Num:C11($Lon_ii<$Lon_end_ii))
					
				End for 
				
				<>tTxt_lines{$i}:=<>tTxt_lines{$i}+")"
				
			End if 
			
			  //______________________________________________________
		Else 
			
			util_Lon_Local_in_line ($tLine;->$tTxt_local)
			
			  //______________________________________________________
	End case 
	
	If (Not:C34(Is nil pointer:C315($Ptr_array)) & $bParamater)
		
		If (<>tLon_Line_Statut{$i}=3)
			
			<>tLon_Line_Statut{$i}:=0
			CLEAR VARIABLE:C89($Ptr_array->)
			CLEAR VARIABLE:C89($tTxt_local)
			
		End if 
	End if 
End for 

$number:=Size of array:C274($tTxt_local)
ARRAY LONGINT:C221($tLon_sortOrder;$number)

If ($number>0)
	
	  //Put first the parameters with indirection
	For ($i;1;$number;1)
		
		$tLon_sortOrder{$i}:=2*Num:C11(Position:C15("{";$tTxt_local{$i})>0)
		
		If (str_isNumeric (Replace string:C233(Replace string:C233(Substring:C12($tTxt_local{$i};2);"{";"");"}";"")))
			
			  //
			
		Else 
			
			$tLon_sortOrder{$i}:=20
			
		End if 
	End for 
	
	MULTI SORT ARRAY:C718($tLon_sortOrder;>;$tTxt_local;>)
	
	$Lon_firstIndice:=MAXINT:K35:1
	$tTxt_local:=Find in array:C230($tTxt_local;"${@")
	
	If ($tTxt_local>0)
		
		$Lon_firstIndice:=Num:C11($tTxt_local{$tTxt_local})
		
	End if 
	
	If (Is a list:C621((Form:C1466.list)->))
		
		CLEAR LIST:C377((Form:C1466.list)->;*)
		
	End if 
	
	(Form:C1466.list)->:=New list:C375
	
	For ($i;1;$number;1)
		
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
			: (Find in array:C230($tTxt_exceptions;$t)>0)
				
				  //…………………………………………………………………………………
			Else 
				
				APPEND TO LIST:C376((Form:C1466.list)->;$t;$i)
				
				Case of 
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_ALPHA;$t)>0)
						
						$Lon_type:=1
						SET LIST ITEM PARAMETER:C986((Form:C1466.list)->;$i;"size";$tLon_stringLength{Find in array:C230($tTxt_ALPHA;$t)})
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayALPHA;$t)>0)
						
						$Lon_type:=101
						SET LIST ITEM PARAMETER:C986((Form:C1466.list)->;$i;"size";$tLon_arrayStringLength{Find in array:C230($tTxt_arrayALPHA;$t)})
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_BLOB;$t)>0)
						
						$Lon_type:=2
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayBLOB;$t)>0)
						
						$Lon_type:=102
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_BOOLEAN;$t)>0)
						
						$Lon_type:=3
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayBOOLEAN;$t)>0)
						
						$Lon_type:=103
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_DATE;$t)>0)
						
						$Lon_type:=4
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayDATE;$t)>0)
						
						$Lon_type:=104
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_INTEGER;$t)>0)
						
						$Lon_type:=5
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayINTEGER;$t)>0)
						
						$Lon_type:=105
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_LONGINT;$t)>0)
						
						$Lon_type:=6
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayLONGINT;$t)>0)
						
						$Lon_type:=106
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_GRAPH;$t)>0)
						
						$Lon_type:=7
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_TIME;$t)>0)
						
						$Lon_type:=8
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayTIME;$t)>0)
						
						$Lon_type:=108
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_PICTURE;$t)>0)
						
						$Lon_type:=9
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayPICTURE;$t)>0)
						
						$Lon_type:=109
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_OBJECT;$t)>0)
						
						$Lon_type:=13
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_COLLECTION;$t)>0)
						
						$Lon_type:=14  //C_COLLECTION
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_VARIANT;$t)>0)
						
						$Lon_type:=15  //C_VARIANT
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayOBJECT;$t)>0)
						
						$Lon_type:=113
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_POINTER;$t)>0)
						
						$Lon_type:=10
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayPOINTER;$t)>0)
						
						$Lon_type:=110
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_REAL;$t)>0)
						
						$Lon_type:=11
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayREAL;$t)>0)
						
						$Lon_type:=111
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_TEXT;$t)>0)
						
						$Lon_type:=12
						
						  //______________________________________________________
					: (Find in array:C230($tTxt_arrayTEXT;$t)>0)
						
						$Lon_type:=112
						
						  //______________________________________________________
					Else 
						
						$Lon_type:=Private_Lon_Declaration_Type ($t;->$Lon_size)
						
						  //_o_C_STRING @ _o_ARRAY_STRING
						If ($Lon_type=1)\
							 | ($Lon_type=101)
							
							SET LIST ITEM PARAMETER:C986((Form:C1466.list)->;$i;"size";Choose:C955($Lon_size=0;255;$Lon_size))
							
						End if 
						
						  //______________________________________________________
				End case 
				
				SET LIST ITEM PARAMETER:C986((Form:C1466.list)->;$i;"name";$t)  //keep the current name
				
				  // Type change
				Case of 
						
						  //………………………………………………
					: (Not:C34(Form:C1466.preferences.options.replaceObsoleteTypes))\
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
				
				$Lon_type:=$Lon_type+(1000*Num:C11(($t="${@") | (str_isNumeric (Substring:C12($t;2)))))
				SET LIST ITEM PARAMETER:C986((Form:C1466.list)->;$i;"type";$Lon_type)
				
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
				
				SET LIST ITEM PROPERTIES:C386((Form:C1466.list)->;$i;False:C215;$Lon_styles;"path:/RESOURCES/Images/types/field_"+String:C10($Lon_type)+".png")
				
		End case 
	End for 
	
	GET LIST PROPERTIES:C632((Form:C1466.list)->;$Lon_appearance;$Lon_icon)
	SET LIST PROPERTIES:C387((Form:C1466.list)->;$Lon_appearance;$Lon_icon;20)
	
	  // Select the first variable
	SELECT LIST ITEMS BY POSITION:C381((Form:C1466.list)->;1)
	
End if 

OBJECT SET VISIBLE:C603(*;"spinner";False:C215)
(OBJECT Get pointer:C1124(Object named:K67:5;"spinner"))->:=0

Form:C1466.refresh()

  //______________________________________________________