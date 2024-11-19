//%attributes = {"invisible":true,"preemptive":"incapable"}
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
#DECLARE($selector : Text; $selected : Text; $code : Text)

var $t; $name; $comments; $tResult; $separator : Text
var $tSyntax; $title : Text
var $bReplace; $success : Boolean
var $i; $indx; $l; $Lon_type; $start; $Win_hdl : Integer
var $ptr : Pointer
var $o : Object
var $c : Collection

ARRAY TEXT:C222($_controlFlow; 0)
ARRAY LONGINT:C221($_indent; 0)
ARRAY LONGINT:C221($_refCount; 0)

Case of 
		
		//______________________________________________________
	: ($selector="commentBlock")
		
		SET MACRO PARAMETER:C998(Highlighted method text:K5:18; "/*\r"+$selected+"\r*/")
		
		//______________________________________________________
	: ($selector="duplicateAndComment")  // Duplicate the selected text and comment the first instance
		
		If (Length:C16($selected)=0)
			
			return 
			
		End if 
		
		$c:=Split string:C1554($selected; "\r")
		
		For each ($t; $c)
			
			If (Length:C16($t)>0)
				
				If ($i=0)
					
					$t:=kCommentMark+$t
					
				Else 
					
					If ($c[$i-1]#"@\\")
						
						$t:=kCommentMark+$t
						
					End if 
				End if 
			End if 
			
			$comments+=$t+"\r"
			$i+=1
			
		End for each 
		
		SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $comments+"\r"+$selected+kCaret)
		
		//______________________________________________________
	: ($selector="comment")
		
		Formula from string:C1601(":C1810(v1; v2; v3; v4)").call()
		
		If (v3#v4) && (v1#0)
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18; "/*\r"+$selected+"\r*/")
			return 
			
		End if 
		
		If (v1#0) && (v1#v2)
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18; "/*"+$selected+"*/")
			return 
			
		End if 
		
		SET MACRO PARAMETER:C998(Highlighted method text:K5:18; "// "+$selected)
		
		//______________________________________________________
	: ($selector="method-comment-generate")
		
		$name:=$selected  // Method path
		
		METHOD RESOLVE PATH:C1165($name; $Lon_type; $ptr; $t; $t; *)
		
		If ($Lon_type=Path project method:K72:1)
			
			METHOD GET COMMENTS:C1189($name; $comments; *)
			
			If (Path to object:C1547(Structure file:C489(*)).extension=".4DProject")  // #project mode
				
				$separator:="--------------------------------------------------\r"
				
				ARRAY TEXT:C222($_comments; 0x0000)
				ARRAY TEXT:C222($_labels; 0x0000)
				ARRAY TEXT:C222($_types; 0x0000)
				
				METHOD_ANALYSE_TO_ARRAYS($code; ->$_types; ->$_labels; ->$_comments)
				
				$tSyntax:=Choose:C955(Length:C16($_types{0})>0; Choose:C955(Length:C16($_labels{0})=0; $_types{0}; $_labels{0})+" := "+$name; $name)
				
				For ($i; 1; Size of array:C274($_types); 1)
					
					// Open parentheses or put a separator
					$tSyntax:=Choose:C955($i=1; $tSyntax+" ( "; $tSyntax+" ; ")
					
					$tSyntax:=$tSyntax+$_labels{$i}
					
					If ($i=Size of array:C274($_types))
						
						// Close the parentheses
						$tSyntax:=$tSyntax+" )"
						
					End if 
				End for 
				
				//…then describe the parameters…
				$tResult:=$tSyntax
				
				For ($i; 1; Size of array:C274($_types); 1)
					
					$tResult:=$tResult+"\r"\
						+" -> "+$_labels{$i}+" ("+$_types{$i}+")"\
						+Choose:C955(Length:C16($_comments{$i})>0; " - "+$_comments{$i}; "")
					
				End for 
				
				//…and the return for a function.
				If (Length:C16($_labels{0})>0)
					
					$tResult:=$tResult+"\r"+" <- "+$_labels{0}+" ("+$_types{0}+")"\
						+Choose:C955(Length:C16($_comments{0})>0; " - "+$_comments{0}; "")
					
				End if 
				
				$t:=$separator+$tResult
				
				If (Length:C16($comments)=0)
					
					$comments:="<!--"+$t+"-->\r"+$tSyntax
					
				Else 
					
					$comments:=_o_rgx($comments).substitute("(?si-m)<!--(.*)-->"; "<!--"+$t+"-->").result
					
				End if 
				
			Else   // #database mode
				
				$separator:="\r________________________________________________________\r"
				
				$comments:=ST Get plain text:C1092($comments)
				
				$indx:=Position:C15($separator; $comments)
				
				If ($indx>0)
					
					$comments:=Delete string:C232($comments; 1; $indx+Length:C16($separator)-1)
					
				Else 
					
					// Compatibility with older versions of separator
					$indx:=Position:C15("\r-\r"; $comments)
					
					If ($indx>0)
						
						$comments:=Delete string:C232($comments; 1; $indx+2)
						
					Else 
						
						$indx:=Position:C15("\r-"; $comments)
						
						If ($indx>0)
							
							$comments:=Delete string:C232($comments; 1; $indx+1)
							
						End if 
					End if 
				End if 
				
				$comments:=METHOD_Syntax($code; $name; "")+$separator+$comments
				
			End if 
			
			METHOD SET COMMENTS:C1193($name; $comments; *)
			
		End if 
		
		//________________________________________
	: ($selector="method")  // #18-10-2013
		
		$name:=$selected
		
		METHOD RESOLVE PATH:C1165($name; $Lon_type; $ptr; $t; $t; *)
		
		If ($Lon_type=Path project method:K72:1)
			
			METHOD GET COMMENTS:C1189($name; $comments; *)
			
			$Win_hdl:=Open form window:C675("COMMENTS"; Movable form dialog box:K39:8)
			SET WINDOW TITLE:C213($name+" - "+Localized string:C991("comments"); $Win_hdl)
			$o:=New object:C1471(\
				"text"; $comments)
			DIALOG:C40("COMMENTS"; $o)
			CLOSE WINDOW:C154
			
			If (OK=1)
				
				$comments:=$o.text
				$comments:=Replace string:C233($comments; "&lt;date/&gt;"; String:C10(Current date:C33))
				$comments:=Replace string:C233($comments; "&lt;time/&gt;"; String:C10(Current time:C178))
				$comments:=Replace string:C233($comments; "&lt;user_4D/&gt;"; Current user:C182)
				$comments:=Replace string:C233($comments; "&lt;user_os/&gt;"; Current machine:C483)
				$comments:=Replace string:C233($comments; "&lt;version_4D/&gt;"; Application version:C493(*))
				$comments:=Replace string:C233($comments; "&lt;database_name/&gt;"; Structure file:C489)
				
				METHOD SET COMMENTS:C1193($name; $comments; *)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="edit")
		
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $comments)
		
		$bReplace:=Length:C16($comments)>0
		
		$c:=Split string:C1554($comments; "\r")
		
		For each ($t; $c)
			
			$indx:=Position:C15(kCommentMark; $t)
			
			If ($indx>0)
				
				$c[$i]:=Substring:C12($t; $indx+Length:C16(kCommentMark))
				
			End if 
			
			$i:=$i+1
			
		End for each 
		
		$comments:=$c.join("\r")
		
		$l:=Open form window:C675("COMMENTS"; Movable dialog box:K34:7; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		SET MENU BAR:C67(1)
		$o:=New object:C1471(\
			"text"; $comments)
		DIALOG:C40("COMMENTS"; $o)
		CLOSE WINDOW:C154
		
		If (Bool:C1537(OK))
			
			$comments:=$o.text
			
			If (Length:C16($comments)>0)
				
				If (Position:C15("<span"; $comments)>0)
					
					$comments:=ST Get plain text:C1092($comments)
					
				End if 
				
				$c:=Split string:C1554($comments; "\r")
				$i:=0
				
				For each ($t; $c)
					
					If (Length:C16($t)>0)
						
						$c[$i]:=kCommentMark+Char:C90(Space:K15:42)+$t
						
					End if 
					
					$i:=$i+1
					
				End for each 
				
				$comments:=$c.join("\r")
				
				$comments:=Replace string:C233($comments; "<date/>"; String:C10(Current date:C33))
				$comments:=Replace string:C233($comments; "<time/>"; String:C10(Current time:C178))
				$comments:=Replace string:C233($comments; "<user_4D/>"; Current user:C182)
				$comments:=Replace string:C233($comments; "<user_os/>"; Current machine:C483)
				$comments:=Replace string:C233($comments; "<version_4D/>"; Application version:C493(*))
				$comments:=Replace string:C233($comments; "<database_name/>"; Structure file:C489)
				
				$title:=_o_win_title(Frontmost window:C447)
				
				$comments:=Replace string:C233($comments; "<method_name/>"; $title)
				$title:=Get window title:C450(Next window:C448(Frontmost window:C447))
				
				$indx:=Position:C15(" - "; $title)
				
				If ($indx>0)
					
					$title:=Delete string:C232($title; 1; $indx+2)
					
				End if 
				
				$title:=Replace string:C233($title; " *"; "")
				
				If (Position:C15(Localized string:C991("Form: "); $title)>0)
					
					$comments:=Replace string:C233($comments; "<form_name/>"; $title)
					
				End if 
				
				$comments:=$comments+kCaret
				SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $comments)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="bloc")
		
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $comments)
		
		$bReplace:=False:C215
		$success:=True:C214
		
		$c:=Split string:C1554($comments; "\r")
		
		For each ($t; $c) While ($i<MAXLONG:K35:2)
			
			Case of 
					
					//……………………………………………………………
				: (Position:C15(":"; $t)=1)  //:
					
					$indx:=Choose:C955($_indent{Size of array:C274($_indent)}=5; 50; 99)
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{2}; $t)=1)  // Else
					
					Case of 
							
							//.........................................
						: ($_indent{Size of array:C274($_indent)}=2)  // If
							
							$indx:=20
							
							//.........................................
						: ($_indent{Size of array:C274($_indent)}=5)  // Case of
							
							$indx:=50
							
							//.........................................
						Else 
							
							$indx:=99
							
							//.........................................
					End case 
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{1}; $t)=1)  // If
					
					$indx:=2
					
					//……………………………………………………………
					
				: (Position:C15($_controlFlow{3}; $t)=1)  // End if
					
					$indx:=-2
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{4}; $t)=1)  // Case of
					
					$indx:=5
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{5}; $t)=1)  // End case
					
					$indx:=-5
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{8}; $t)=1)  // For
					
					$indx:=10
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{9}; $t)=1)  // End for
					
					$indx:=-10
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{6}; $t)=1)  // While
					
					$indx:=8
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{7}; $t)=1)  // End while
					
					$indx:=-8
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{10}; $t)=1)  // Repeat
					
					$indx:=12
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{11}; $t)=1)  // Until
					
					$indx:=-12
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{12}; $t)=1)  // Use
					
					$indx:=13
					
					//……………………………………………………………
					
				: (Position:C15($_controlFlow{13}; $t)=1)  // End use
					
					$indx:=-13
					
					//……………………………………………………………
				: (Position:C15($_controlFlow{14}; $t)=1)  // For each
					
					$indx:=14
					
					//……………………………………………………………
					
				: (Position:C15($_controlFlow{15}; $t)=1)  // End for each
					
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
						 & ($_refCount{$indx/10}=1)  //Else
						
						$c[$i]:=kCommentMark+$t
						
					End if 
					
					//……………………………………………………………
				: ($indx>0)
					
					$_refCount{$indx}:=$_refCount{$indx}+1
					APPEND TO ARRAY:C911($_indent; $indx)
					
					If ($start=0)
						
						$start:=$indx
						
					End if 
					
					If ($indx=$start)\
						 & ($_refCount{$indx}=1)  // First
						
						$c[$i]:=kCommentMark+$t
						$bReplace:=True:C214
						
					End if 
					
					//……………………………………………………………
				: ($indx<0)
					
					If ($_indent{Size of array:C274($_indent)}=Abs:C99($indx))
						
						$_refCount{Abs:C99($indx)}:=$_refCount{Abs:C99($indx)}-1
						CLEAR VARIABLE:C89($_indent)
						
						If ($indx=-$start)\
							 & ($_refCount{Abs:C99($indx)}=0)  // End
							
							$c[$i]:=kCommentMark+$t
							
						End if 
						
					Else   // Error : Closing a structure not opened
						
						$success:=False:C215
						
					End if 
					
					//……………………………………………………………
			End case 
			
			$i:=Choose:C955($success; $i+1; MAXLONG:K35:2)  // Stop
			
		End for each 
		
		If ($success & $bReplace)
			
			$comments:=$c.join("\r")
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $comments)
			
		End if 
		
		//______________________________________________________
End case 