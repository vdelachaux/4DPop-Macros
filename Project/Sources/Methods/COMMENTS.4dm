//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Méthode : COMMENTS
  // Created 28/10/05 par Vincent de Lachaux
  // ----------------------------------------------------
  // Modifée le 28/10/05 par Vincent de Lachaux
  // Modifie par : Vincent de Lachaux (27/01/06)
  // ----------------------------------------------------
  // Modified #18-10-2013 by Vincent de Lachaux
  // Add method's comments
  // ----------------------------------------------------
  // Description
  // Management method macros for the comments
  // ----------------------------------------------------
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

C_BOOLEAN:C305($Boo_OK;$Boo_replace)
C_LONGINT:C283($i;$Lon_end_i;$Lon_First;$Lon_index;$Lon_lines;$Lon_Offset)
C_LONGINT:C283($Lon_type;$Lon_Window;$Lon_x;$Win_hdl)
C_POINTER:C301($Ptr_table)
C_TEXT:C284($kTxt_separator;$t;$tt;$Txt_comment;$Txt_entryPoint;$Txt_form)
C_TEXT:C284($Txt_method;$Txt_object;$Txt_Replacement;$Txt_target;$Txt_Title)
C_COLLECTION:C1488($c)

ARRAY LONGINT:C221($tLon_indent;0)
ARRAY LONGINT:C221($tLon_refCount;0)
ARRAY TEXT:C222($tTxt_controlFlow;0)
ARRAY TEXT:C222($tTxt_Lines;0)

If (False:C215)
	C_TEXT:C284(COMMENTS ;$1)
	C_TEXT:C284(COMMENTS ;$2)
	C_TEXT:C284(COMMENTS ;$3)
End if 

C_TEXT:C284(<>Txt_buffer)

$Txt_entryPoint:=$1

Case of 
		
		  //______________________________________________________
	: ($Txt_entryPoint="duplicateAndComment")  // Duplicate the selected text and comment the first instance
		
		If (Length:C16($2)>0)
			
			$c:=Split string:C1554($2;"\r")
			
			For each ($tt;$c)
				
				If (Length:C16($tt)>0)
					
					If ($i=0)
						
						$tt:=kCommentMark+$tt
						
					Else 
						
						If ($c[$i-1]#"@\\")
							
							$tt:=kCommentMark+$tt
							
						End if 
					End if 
				End if 
				
				$t:=$t+$tt+"\r"
				$i:=$i+1
				
			End for each 
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$t+"\r"+$2+kCaret)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_entryPoint="method-comment-generate")
		
		$Txt_target:=$2  //method path
		$Txt_method:=$3  // code
		
		$kTxt_separator:="\r________________________________________________________\r"
		
		METHOD RESOLVE PATH:C1165($Txt_target;$Lon_type;$Ptr_table;$Txt_object;$Txt_form;*)
		
		If ($Lon_type=Path project method:K72:1)
			
			METHOD GET COMMENTS:C1189($Txt_target;$Txt_comment;*)
			
			$Txt_comment:=ST Get plain text:C1092($Txt_comment)
			
			$Lon_x:=Position:C15($kTxt_separator;$Txt_comment)
			
			If ($Lon_x>0)
				
				$Txt_comment:=Delete string:C232($Txt_comment;1;$Lon_x+Length:C16($kTxt_separator)-1)
				
			Else 
				
				  // Compatibility with older versions of separator
				$Lon_x:=Position:C15("\r-\r";$Txt_comment)
				
				If ($Lon_x>0)
					
					$Txt_comment:=Delete string:C232($Txt_comment;1;$Lon_x+2)
					
				Else 
					
					$Lon_x:=Position:C15("\r-";$Txt_comment)
					
					If ($Lon_x>0)
						
						$Txt_comment:=Delete string:C232($Txt_comment;1;$Lon_x+1)
						
					End if 
				End if 
			End if 
			
			$Txt_comment:=METHOD_Syntax ($Txt_method;$Txt_target;"")+$kTxt_separator+$Txt_comment
			
			METHOD SET COMMENTS:C1193($Txt_target;$Txt_comment;*)
			
		End if 
		
		  //______________________________________________________
		  //http://forums.4d.fr/Post/FR/13647702/1/13647703#13647703
		  //________________________________________
	: ($Txt_entryPoint="method")  // #18-10-2013
		
		$Txt_target:=$2
		
		METHOD RESOLVE PATH:C1165($Txt_target;$Lon_type;$Ptr_table;$Txt_object;$Txt_form;*)
		
		If ($Lon_type=Path project method:K72:1)
			
			METHOD GET COMMENTS:C1189($Txt_target;<>Txt_buffer;*)
			$Win_hdl:=Open form window:C675("COMMENTS";Movable form dialog box:K39:8)
			SET WINDOW TITLE:C213($Txt_target+" - "+Get localized string:C991("comments");$Win_hdl)
			DIALOG:C40("COMMENTS")
			CLOSE WINDOW:C154
			
			If (OK=1)
				
				<>Txt_buffer:=Replace string:C233(<>Txt_buffer;"&lt;date/&gt;";String:C10(Current date:C33))
				<>Txt_buffer:=Replace string:C233(<>Txt_buffer;"&lt;time/&gt;";String:C10(Current time:C178))
				<>Txt_buffer:=Replace string:C233(<>Txt_buffer;"&lt;user_4D/&gt;";Current user:C182)
				<>Txt_buffer:=Replace string:C233(<>Txt_buffer;"&lt;user_os/&gt;";Current machine:C483)
				<>Txt_buffer:=Replace string:C233(<>Txt_buffer;"&lt;version_4D/&gt;";Application version:C493(*))
				<>Txt_buffer:=Replace string:C233(<>Txt_buffer;"&lt;database_name/&gt;";Structure file:C489)
				
				METHOD SET COMMENTS:C1193($Txt_target;<>Txt_buffer;*)
				
				CLEAR VARIABLE:C89(<>Txt_buffer)
				
			End if 
			
		Else 
			
			BEEP:C151
			
		End if 
		
		  //______________________________________________________
	: ($Txt_entryPoint="edit")
		
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18;<>Txt_buffer)
		
		$Boo_replace:=Length:C16(<>Txt_buffer)>0
		
		If (Rgx_SplitText ("\\r\\n|\\r|\\n";<>Txt_buffer;->$tTxt_Lines;0)=0)
			
			CLEAR VARIABLE:C89(<>Txt_buffer)
			
			For ($i;1;Size of array:C274($tTxt_Lines);1)
				
				$Lon_x:=Position:C15(kCommentMark;$tTxt_Lines{$i})
				
				If ($Lon_x>0)
					
					$tTxt_Lines{$i}:=Substring:C12($tTxt_Lines{$i};$Lon_x+Length:C16(kCommentMark))
					
				End if 
				
				<>Txt_buffer:=<>Txt_buffer+$tTxt_Lines{$i}+"\r"
				
			End for 
		End if 
		
		$Lon_Window:=Open form window:C675("COMMENTS";Movable dialog box:K34:7;Horizontally centered:K39:1;Vertically centered:K39:4;*)
		SET MENU BAR:C67(1)
		DIALOG:C40("COMMENTS")
		CLOSE WINDOW:C154
		
		If (OK=1)
			
			If (Length:C16(<>Txt_buffer)>0)
				
				If (Position:C15("<span";<>Txt_buffer)>0)
					
					<>Txt_buffer:=ST Get plain text:C1092(<>Txt_buffer)
					
				End if 
				
				If (Rgx_SplitText ("\\r\\n|\\r|\\n";<>Txt_buffer;->$tTxt_Lines;0)=0)
					
					$t:=""
					
					$Lon_end_i:=Size of array:C274($tTxt_Lines)
					
					For ($i;1;$Lon_end_i;1)
						
						$t:=$tTxt_Lines{$i}
						
						$Txt_Replacement:=$Txt_Replacement\
							+Choose:C955(Length:C16($t)>0;kCommentMark;"")+Char:C90(Space:K15:42)+$t\
							+Choose:C955($i<($Lon_end_i-Num:C11($Boo_replace));"\r";"")
						
					End for 
					
					$Txt_Replacement:=Replace string:C233($Txt_Replacement;"<date/>";String:C10(Current date:C33))
					$Txt_Replacement:=Replace string:C233($Txt_Replacement;"<time/>";String:C10(Current time:C178))
					$Txt_Replacement:=Replace string:C233($Txt_Replacement;"<user_4D/>";Current user:C182)
					$Txt_Replacement:=Replace string:C233($Txt_Replacement;"<user_os/>";Current machine:C483)
					$Txt_Replacement:=Replace string:C233($Txt_Replacement;"<version_4D/>";Application version:C493(*))
					$Txt_Replacement:=Replace string:C233($Txt_Replacement;"<database_name/>";Structure file:C489)
					
					  //$Txt_Title:=Get window title(Frontmost window)
					  //$Lon_x:=Position(" - ";$Txt_Title)
					  //If ($Lon_x>0)
					  //$Txt_Title:=Delete string($Txt_Title;1;$Lon_x+2)
					  //End if
					
					$Txt_Title:=win_title (Frontmost window:C447)
					
					$Txt_Replacement:=Replace string:C233($Txt_Replacement;"<method_name/>";$Txt_Title)
					$Txt_Title:=Get window title:C450(Next window:C448(Frontmost window:C447))
					
					$Lon_x:=Position:C15(" - ";$Txt_Title)
					
					If ($Lon_x>0)
						
						$Txt_Title:=Delete string:C232($Txt_Title;1;$Lon_x+2)
						
					End if 
					
					$Txt_title:=Replace string:C233($Txt_title;" *";"")
					
					If (Position:C15(Get localized string:C991("Form: ");$Txt_Title)>0)
						
						$Txt_Replacement:=Replace string:C233($Txt_Replacement;"<form_name/>";$Txt_Title)
						
					End if 
				End if 
				
				$Txt_Replacement:=$Txt_Replacement+kCaret
				SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$Txt_Replacement)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_entryPoint="bloc")
		
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18;<>Txt_buffer)
		
		If (Length:C16(<>Txt_buffer)>0)
			
			If (Rgx_SplitText ("\\r\\n|\\r|\\n";<>Txt_buffer;-><>tTxt_lines;0 ?+ 11)=0)
				
				localizedControlFlow ("";->$tTxt_controlFlow)
				ARRAY LONGINT:C221($tLon_refCount;Size of array:C274($tTxt_controlFlow))
				
				$Boo_replace:=False:C215
				$Boo_OK:=True:C214
				$Lon_lines:=Size of array:C274(<>tTxt_lines)
				
				For ($i;1;$Lon_lines;1)
					
					Case of 
							
							  //……………………………………………………………
						: (Position:C15(":";<>tTxt_lines{$i})=1)  //:
							
							$Lon_index:=Choose:C955($tLon_indent{Size of array:C274($tLon_indent)}=5;50;99)
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{2};<>tTxt_lines{$i})=1)  //Else
							
							Case of 
									
									  //.....................................................
								: ($tLon_indent{Size of array:C274($tLon_indent)}=2)  //If
									
									$Lon_index:=20
									
									  //.....................................................
								: ($tLon_indent{Size of array:C274($tLon_indent)}=5)  //Case of
									
									$Lon_index:=50
									
									  //.....................................................
								Else 
									
									$Lon_index:=99
									
									  //.....................................................
							End case 
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{1};<>tTxt_lines{$i})=1)  //If
							
							$Lon_index:=2
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{3};<>tTxt_lines{$i})=1)  //End if
							
							$Lon_index:=-2
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{4};<>tTxt_lines{$i})=1)  //Case of
							
							$Lon_index:=5
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{5};<>tTxt_lines{$i})=1)  //End case
							
							$Lon_index:=-5
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{8};<>tTxt_lines{$i})=1)  //For
							
							$Lon_index:=10
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{9};<>tTxt_lines{$i})=1)  //End for
							
							$Lon_index:=-10
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{6};<>tTxt_lines{$i})=1)  //While
							
							$Lon_index:=8
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{7};<>tTxt_lines{$i})=1)  //End while
							
							$Lon_index:=-8
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{10};<>tTxt_lines{$i})=1)  //Repeat
							
							$Lon_index:=12
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{11};<>tTxt_lines{$i})=1)  //Until
							
							$Lon_index:=-12
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{12};<>tTxt_lines{$i})=1)  //Use
							
							$Lon_index:=13
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{13};<>tTxt_lines{$i})=1)  //End use
							
							$Lon_index:=-13
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{14};<>tTxt_lines{$i})=1)  //For each
							
							$Lon_index:=14
							
							  //……………………………………………………………
						: (Position:C15($tTxt_controlFlow{15};<>tTxt_lines{$i})=1)  //End for each
							
							$Lon_index:=--14
							
							  //……………………………………………………………
						Else 
							
							$Lon_index:=0
							
							  //……………………………………………………………
					End case 
					
					Case of 
							
							  //……………………………………………………………
						: ($Lon_index=99)  //Errorr : Else without If or Case of
							
							$Boo_OK:=False:C215
							
							  //……………………………………………………………
						: ($Lon_index>=20)
							
							If ($Lon_index=($Lon_First*10))\
								 & ($tLon_refCount{$Lon_index/10}=1)  //Else
								
								<>tTxt_lines{$i}:=kCommentMark+<>tTxt_lines{$i}
								
							End if 
							
							  //……………………………………………………………
						: ($Lon_index>0)
							
							$tLon_refCount{$Lon_index}:=$tLon_refCount{$Lon_index}+1
							APPEND TO ARRAY:C911($tLon_indent;$Lon_index)
							
							If ($Lon_First=0)
								
								$Lon_First:=$Lon_index
								
							End if 
							
							If ($Lon_index=$Lon_First)\
								 & ($tLon_refCount{$Lon_index}=1)  //First
								
								<>tTxt_lines{$i}:=kCommentMark+<>tTxt_lines{$i}
								$Boo_replace:=True:C214
								
							End if 
							
							  //……………………………………………………………
						: ($Lon_index<0)
							
							If ($tLon_indent{Size of array:C274($tLon_indent)}=Abs:C99($Lon_index))
								
								$tLon_refCount{Abs:C99($Lon_index)}:=$tLon_refCount{Abs:C99($Lon_index)}-1
								CLEAR VARIABLE:C89($tLon_indent)
								
								If ($Lon_index=-$Lon_First)\
									 & ($tLon_refCount{Abs:C99($Lon_index)}=0)  //End
									
									<>tTxt_lines{$i}:=kCommentMark+<>tTxt_lines{$i}+""
									
								End if 
								
							Else   //Error : Closing a structure not opened
								
								$Boo_OK:=False:C215
								
							End if 
							
							  //……………………………………………………………
					End case 
					
					If (Not:C34($Boo_OK))  //Stop
						
						$i:=$Lon_lines+1
						
					End if 
				End for 
				
				If ($Boo_OK & $Boo_replace)
					
					$Lon_Offset:=0
					
					<>Txt_buffer:=""
					
					For ($i;1;$Lon_lines;1)
						
						<>Txt_buffer:=<>Txt_buffer+<>tTxt_lines{$i}+("\r"*Num:C11($i#$Lon_lines))
						
					End for 
					
					SET MACRO PARAMETER:C998(Highlighted method text:K5:18;<>Txt_buffer)
					
				Else 
					
					BEEP:C151
					
				End if 
			End if 
		End if 
		
		  //______________________________________________________
End case 