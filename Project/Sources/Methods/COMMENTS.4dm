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
  // Modified #07-02-2020 by Vincent de Lachaux
  // Adapt method's comments for project mode
  // ----------------------------------------------------
  // Description
  // Management method macros for the comments
  // ----------------------------------------------------
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

C_BOOLEAN:C305($bReplace;$success)
C_LONGINT:C283($i;$indx;$l;$Lon_type;$start;$Win_hdl)
C_POINTER:C301($ptr)
C_TEXT:C284($t;$t_code;$t_name;$t_selector;$tComments;$tReplacement)
C_TEXT:C284($tResult;$tSeparator;$tSyntax;$tt;$tTitle)
C_OBJECT:C1216($o)
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

$t_selector:=$1  // Entry point

Case of 
		
		  //______________________________________________________
	: ($t_selector="commentBlock")  //
		
		SET MACRO PARAMETER:C998(Highlighted method text:K5:18;"/*\r"+$2+"\r*/")
		
		  //______________________________________________________
	: ($t_selector="duplicateAndComment")  // Duplicate the selected text and comment the first instance
		
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
	: ($t_selector="method-comment-generate")
		
		$t_name:=$2  // Method path
		$t_code:=$3  // code
		
		METHOD RESOLVE PATH:C1165($t_name;$Lon_type;$ptr;$t;$t;*)
		
		If ($Lon_type=Path project method:K72:1)
			
			METHOD GET COMMENTS:C1189($t_name;$tComments;*)
			
			If (Path to object:C1547(Structure file:C489(*)).extension=".4DProject")  // #project mode
				
				$tSeparator:="--------------------------------------------------\r"
				
				ARRAY TEXT:C222($tTxt_comments;0x0000)
				ARRAY TEXT:C222($tTxt_labels;0x0000)
				ARRAY TEXT:C222($tTxt_types;0x0000)
				
				METHOD_ANALYSE_TO_ARRAYS ($t_code;->$tTxt_types;->$tTxt_labels;->$tTxt_comments)
				
				$tSyntax:=Choose:C955(Length:C16($tTxt_types{0})>0;Choose:C955(Length:C16($tTxt_labels{0})=0;$tTxt_types{0};$tTxt_labels{0})+" := "+$t_name;$t_name)
				
				For ($i;1;Size of array:C274($tTxt_types);1)
					
					  // Open parentheses or put a separator
					$tSyntax:=Choose:C955($i=1;$tSyntax+" ( ";$tSyntax+" ; ")
					
					$tSyntax:=$tSyntax+$tTxt_labels{$i}
					
					If ($i=Size of array:C274($tTxt_types))
						
						  // Close the parentheses
						$tSyntax:=$tSyntax+" )"
						
					End if 
				End for 
				
				  //…then describe the parameters…
				$tResult:=$tSyntax
				
				For ($i;1;Size of array:C274($tTxt_types);1)
					
					$tResult:=$tResult+"\r"\
						+" -> "+$tTxt_labels{$i}+" ("+$tTxt_types{$i}+")"\
						+Choose:C955(Length:C16($tTxt_comments{$i})>0;" - "+$tTxt_comments{$i};"")
					
				End for 
				
				  //…and the return for a function.
				If (Length:C16($tTxt_labels{0})>0)
					
					$tResult:=$tResult+"\r"+" <- "+$tTxt_labels{0}+" ("+$tTxt_types{0}+")"\
						+Choose:C955(Length:C16($tTxt_comments{0})>0;" - "+$tTxt_comments{0};"")
					
				End if 
				
				$t:=$tSeparator+$tResult
				
				If (Length:C16($tComments)=0)
					
					$tComments:="<!--"+$t+"-->\r"+$tSyntax
					
				Else 
					
					$tComments:=rgx ($tComments).substitute("(?si-m)<!--(.*)-->";"<!--"+$t+"-->").result
					
				End if 
				
			Else   // #database mode
				
				$tSeparator:="\r________________________________________________________\r"
				
				$tComments:=ST Get plain text:C1092($tComments)
				
				$indx:=Position:C15($tSeparator;$tComments)
				
				If ($indx>0)
					
					$tComments:=Delete string:C232($tComments;1;$indx+Length:C16($tSeparator)-1)
					
				Else 
					
					  // Compatibility with older versions of separator
					$indx:=Position:C15("\r-\r";$tComments)
					
					If ($indx>0)
						
						$tComments:=Delete string:C232($tComments;1;$indx+2)
						
					Else 
						
						$indx:=Position:C15("\r-";$tComments)
						
						If ($indx>0)
							
							$tComments:=Delete string:C232($tComments;1;$indx+1)
							
						End if 
					End if 
				End if 
				
				$tComments:=METHOD_Syntax ($t_code;$t_name;"")+$tSeparator+$tComments
				
			End if 
			
			METHOD SET COMMENTS:C1193($t_name;$tComments;*)
			
		End if 
		
		  //________________________________________
	: ($t_selector="method")  // #18-10-2013
		
		$t_name:=$2
		
		METHOD RESOLVE PATH:C1165($t_name;$Lon_type;$ptr;$t;$t;*)
		
		If ($Lon_type=Path project method:K72:1)
			
			METHOD GET COMMENTS:C1189($t_name;$tComments;*)
			
			$Win_hdl:=Open form window:C675("COMMENTS";Movable form dialog box:K39:8)
			SET WINDOW TITLE:C213($t_name+" - "+Get localized string:C991("comments");$Win_hdl)
			$o:=New object:C1471(\
				"text";$tComments)
			DIALOG:C40("COMMENTS";$o)
			CLOSE WINDOW:C154
			
			If (OK=1)
				
				$tComments:=$o.text
				$tComments:=Replace string:C233($tComments;"&lt;date/&gt;";String:C10(Current date:C33))
				$tComments:=Replace string:C233($tComments;"&lt;time/&gt;";String:C10(Current time:C178))
				$tComments:=Replace string:C233($tComments;"&lt;user_4D/&gt;";Current user:C182)
				$tComments:=Replace string:C233($tComments;"&lt;user_os/&gt;";Current machine:C483)
				$tComments:=Replace string:C233($tComments;"&lt;version_4D/&gt;";Application version:C493(*))
				$tComments:=Replace string:C233($tComments;"&lt;database_name/&gt;";Structure file:C489)
				
				METHOD SET COMMENTS:C1193($t_name;$tComments;*)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($t_selector="edit")
		
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18;$tComments)
		
		$bReplace:=Length:C16($tComments)>0
		
		$c:=Split string:C1554($tComments;"\r")
		
		For each ($t;$c)
			
			$indx:=Position:C15(kCommentMark;$t)
			
			If ($indx>0)
				
				$c[$i]:=Substring:C12($t;$indx+Length:C16(kCommentMark))
				
			End if 
			
			$i:=$i+1
			
		End for each 
		
		$tComments:=$c.join("\r")
		
		$l:=Open form window:C675("COMMENTS";Movable dialog box:K34:7;Horizontally centered:K39:1;Vertically centered:K39:4;*)
		SET MENU BAR:C67(1)
		$o:=New object:C1471(\
			"text";$tComments)
		DIALOG:C40("COMMENTS";$o)
		CLOSE WINDOW:C154
		
		If (Bool:C1537(OK))
			
			$tComments:=$o.text
			
			If (Length:C16($tComments)>0)
				
				If (Position:C15("<span";$tComments)>0)
					
					$tComments:=ST Get plain text:C1092($tComments)
					
				End if 
				
				$c:=Split string:C1554($tComments;"\r")
				$i:=0
				
				For each ($t;$c)
					
					If (Length:C16($t)>0)
						
						$c[$i]:=kCommentMark+Char:C90(Space:K15:42)+$t
						
					End if 
					
					$i:=$i+1
					
				End for each 
				
				$tReplacement:=$c.join("\r")
				
				$tReplacement:=Replace string:C233($tReplacement;"<date/>";String:C10(Current date:C33))
				$tReplacement:=Replace string:C233($tReplacement;"<time/>";String:C10(Current time:C178))
				$tReplacement:=Replace string:C233($tReplacement;"<user_4D/>";Current user:C182)
				$tReplacement:=Replace string:C233($tReplacement;"<user_os/>";Current machine:C483)
				$tReplacement:=Replace string:C233($tReplacement;"<version_4D/>";Application version:C493(*))
				$tReplacement:=Replace string:C233($tReplacement;"<database_name/>";Structure file:C489)
				
				$tTitle:=win_title (Frontmost window:C447)
				
				$tReplacement:=Replace string:C233($tReplacement;"<method_name/>";$tTitle)
				$tTitle:=Get window title:C450(Next window:C448(Frontmost window:C447))
				
				$indx:=Position:C15(" - ";$tTitle)
				
				If ($indx>0)
					
					$tTitle:=Delete string:C232($tTitle;1;$indx+2)
					
				End if 
				
				$tTitle:=Replace string:C233($tTitle;" *";"")
				
				If (Position:C15(Get localized string:C991("Form: ");$tTitle)>0)
					
					$tReplacement:=Replace string:C233($tReplacement;"<form_name/>";$tTitle)
					
				End if 
				
				$tReplacement:=$tReplacement+kCaret
				SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$tReplacement)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($t_selector="bloc")
		
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18;$tComments)
		
		$bReplace:=False:C215
		$success:=True:C214
		
		$c:=Split string:C1554($tComments;"\r")
		
		For each ($t;$c) While ($i<MAXLONG:K35:2)
			
			Case of 
					
					  //……………………………………………………………
				: (Position:C15(":";$t)=1)  //:
					
					$indx:=Choose:C955($tLon_indent{Size of array:C274($tLon_indent)}=5;50;99)
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{2};$t)=1)  // Else
					
					Case of 
							
							  //.........................................
						: ($tLon_indent{Size of array:C274($tLon_indent)}=2)  // If
							
							$indx:=20
							
							  //.........................................
						: ($tLon_indent{Size of array:C274($tLon_indent)}=5)  // Case of
							
							$indx:=50
							
							  //.........................................
						Else 
							
							$indx:=99
							
							  //.........................................
					End case 
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{1};$t)=1)  // If
					
					$indx:=2
					
					  //……………………………………………………………
					
				: (Position:C15($tTxt_controlFlow{3};$t)=1)  // End if
					
					$indx:=-2
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{4};$t)=1)  // Case of
					
					$indx:=5
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{5};$t)=1)  // End case
					
					$indx:=-5
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{8};$t)=1)  // For
					
					$indx:=10
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{9};$t)=1)  // End for
					
					$indx:=-10
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{6};$t)=1)  // While
					
					$indx:=8
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{7};$t)=1)  // End while
					
					$indx:=-8
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{10};$t)=1)  // Repeat
					
					$indx:=12
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{11};$t)=1)  // Until
					
					$indx:=-12
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{12};$t)=1)  // Use
					
					$indx:=13
					
					  //……………………………………………………………
					
				: (Position:C15($tTxt_controlFlow{13};$t)=1)  // End use
					
					$indx:=-13
					
					  //……………………………………………………………
				: (Position:C15($tTxt_controlFlow{14};$t)=1)  // For each
					
					$indx:=14
					
					  //……………………………………………………………
					
				: (Position:C15($tTxt_controlFlow{15};$t)=1)  // End for each
					
					$indx:=-14
					
					  //……………………………………………………………
				Else 
					
					$indx:=0
					
					  //……………………………………………………………
			End case 
			
			Case of 
					
					  //……………………………………………………………
				: ($indx=99)  // Error : Else without If or Case of
					
					$success:=False:C215
					
					  //……………………………………………………………
				: ($indx>=20)
					
					If ($indx=($start*10))\
						 & ($tLon_refCount{$indx/10}=1)  //Else
						
						$c[$i]:=kCommentMark+$t
						
					End if 
					
					  //……………………………………………………………
				: ($indx>0)
					
					$tLon_refCount{$indx}:=$tLon_refCount{$indx}+1
					APPEND TO ARRAY:C911($tLon_indent;$indx)
					
					If ($start=0)
						
						$start:=$indx
						
					End if 
					
					If ($indx=$start)\
						 & ($tLon_refCount{$indx}=1)  // First
						
						$c[$i]:=kCommentMark+$t
						$bReplace:=True:C214
						
					End if 
					
					  //……………………………………………………………
				: ($indx<0)
					
					If ($tLon_indent{Size of array:C274($tLon_indent)}=Abs:C99($indx))
						
						$tLon_refCount{Abs:C99($indx)}:=$tLon_refCount{Abs:C99($indx)}-1
						CLEAR VARIABLE:C89($tLon_indent)
						
						If ($indx=-$start)\
							 & ($tLon_refCount{Abs:C99($indx)}=0)  // End
							
							$c[$i]:=kCommentMark+$t
							
						End if 
						
					Else   // Error : Closing a structure not opened
						
						$success:=False:C215
						
					End if 
					
					  //……………………………………………………………
			End case 
			
			$i:=Choose:C955($success;$i+1;MAXLONG:K35:2)  // Stop
			
		End for each 
		
		If ($success & $bReplace)
			
			$tComments:=$c.join("\r")
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$tComments)
			
		End if 
		
		  //______________________________________________________
End case 