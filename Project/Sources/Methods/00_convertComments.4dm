//%attributes = {}
C_LONGINT:C283($l)
C_TEXT:C284($kTxt_separator;$t;$tComment;$tContent;$tMarkDown;$tPlainText)
C_TEXT:C284($tSyntax)
C_OBJECT:C1216($folderTarget;$o)

$t:=Select folder:C670("Select the comment folder";8858)

$kTxt_separator:="\r________________________________________________________\r"

If (OK=1)
	
	$folderTarget:=Folder:C1567($t;fk platform path:K87:2).parent.folder("Methods")
	$folderTarget.create()
	
	For each ($o;Folder:C1567($t;fk platform path:K87:2).files())
		
		CLEAR VARIABLE:C89($tSyntax)
		
		$tContent:=$o.getText()
		$tPlainText:=ST Get plain text:C1092($tContent)
		
		$l:=Position:C15($kTxt_separator;$tPlainText)
		
		If ($l>0)
			
			  // Extract syntax
			$tSyntax:=Substring:C12($tPlainText;1;$l-1)
			
			  // Extract description
			$tComment:=Delete string:C232($tPlainText;1;$l+Length:C16($kTxt_separator)-1)
			
		Else 
			
			  // Compatibility with older versions of separator
			$l:=Position:C15("\r-\r";$tPlainText)
			
			If ($l>0)
				
				  // Extract syntax
				$tSyntax:=Substring:C12($tPlainText;1;$l-1)
				
				  // Extract description
				$tComment:=Delete string:C232($tPlainText;1;$l+2)
				
			Else 
				
				$tComment:=$tPlainText
				
			End if 
		End if 
		
		  // Method names in bold
		Rgx_SubstituteText ("(?m-si)\\s*((?:\\d*\\w*_)+\\w*)\\s*";" **\\1** ";->$tComment;0)
		
		  // Special characters
		$tComment:=Replace string:C233($tComment;"<";"&lt;")
		$tComment:=Replace string:C233($tComment;">";"&gt;")
		$tComment:=Replace string:C233($tComment;"_";"\\_")
		
		  // Carriage erturn
		$tComment:=Replace string:C233($tComment;"\r";"\r<br/>")
		
		$tMarkDown:="<!-- "+$tSyntax+"-->\n## Description\n"+$tComment
		
		$folderTarget.file($o.name+".md").setText($tMarkDown)
		
	End for each 
End if 