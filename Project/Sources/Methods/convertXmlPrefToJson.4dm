//%attributes = {}
C_BLOB:C604($x)
C_LONGINT:C283($l)
C_TEXT:C284($t)
C_OBJECT:C1216($fileSettings;$o;$oBuffer;$oSettings)
C_COLLECTION:C1488($c)

$fileSettings:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.settings").original

If (Not:C34($fileSettings.exists))
	
	  // Try to get the xml format
	$o:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop/4DPop Macros.xml").original
	
	If ($o.exists)
		
		$oBuffer:=xml_fileToObject ($o.platformPath)
		
		If ($oBuffer.success)
			
			$oBuffer:=$oBuffer.value["M_4DPop"]
			
			$oSettings:=New object:C1471
			
			$oSettings.version:=New object:C1471
			
			For each ($t;$oBuffer["version"])
				
				$oSettings.version[$t]:=$oBuffer["version"][$t].$
				
			End for each 
			
			$oSettings.declaration:=New object:C1471(\
				"version";$oBuffer["declarations"]["version"];\
				"rules";$oBuffer["declarations"]["declaration"])
			
			$c:=New collection:C1472
			$c[1]:=293
			$c[2]:=604
			$c[3]:=305
			$c[4]:=307
			$c[5]:=282
			$c[6]:=283
			$c[7]:=352
			$c[8]:=306
			$c[9]:=286
			$c[10]:=301
			$c[11]:=285
			$c[12]:=284
			$c[13]:=1216
			$c[14]:=1488
			$c[15]:=1683
			$c[101]:=218
			$c[102]:=1222
			$c[103]:=223
			$c[104]:=224
			$c[105]:=220
			$c[106]:=221
			$c[108]:=1223
			$c[109]:=279
			$c[110]:=280
			$c[111]:=219
			$c[112]:=222
			$c[113]:=1221
			
			For each ($o;$oSettings.declaration.rules)
				
				$l:=$o.type
				$o.label:=Command name:C538($c[$l])+":C"+String:C10($c[$l])
				
			End for each 
			
			TEXT TO BLOB:C554($oBuffer["preferences"].options.$;$x;Mac text without length:K22:10)
			BASE64 DECODE:C896($x)
			$l:=Num:C11(BLOB to text:C555($x;Mac text without length:K22:10))
			
			$oSettings.declaration.options:=New object:C1471(\
				"methodDeclaration";$l ?? 27;\
				"oneLinePerVariable";$l ?? 28;\
				"trimEmptyLines";$l ?? 29;\
				"replaceObsoleteTypes";$l ?? 30;\
				"generateComments";$l ?? 31)
			
			TEXT TO BLOB:C554($oBuffer["preferences"].ignoreDeclarations.$;$x;Mac text without length:K22:10)
			BASE64 DECODE:C896($x)
			$oSettings.declaration.options.ignoreDeclarations:=Bool:C1537(Num:C11(BLOB to text:C555($x;Mac text without length:K22:10)))
			
			TEXT TO BLOB:C554($oBuffer["preferences"].numberOfVariablePerLine.$;$x;Mac text without length:K22:10)
			BASE64 DECODE:C896($x)
			$oSettings.declaration.options.numberOfVariablePerLine:=Num:C11(BLOB to text:C555($x;Mac text without length:K22:10))
			
			TEXT TO BLOB:C554($oBuffer["preferences"]["beautifier-options"].$;$x;Mac text without length:K22:10)
			BASE64 DECODE:C896($x)
			$l:=Num:C11(BLOB to text:C555($x;Mac text without length:K22:10))
			
			$oSettings.beautifier:=New object:C1471(\
				"replaceDeprecatedCommand";$l ?? 15;\
				"removeConsecutiveBlankLines";$l ?? 10;\
				"removeEmptyLinesAtTheBeginOfMethod";$l ?? 1;\
				"removeEmptyLinesAtTheEndOfMethod";$l ?? 2;\
				"lineBreakBeforeBranchingStructures";$l ?? 3;\
				"lineBreakBeforeLoopingStructures";$l ?? 6;\
				"lineBreakBeforeAndAfterSequentialStructuresIncluded";$l ?? 4;\
				"separationLineForCaseOf";$l ?? 5;\
				"aLineOfCommentsMustBePrecededByALineBreak";$l ?? 11;\
				"groupingClosureInstructions";$l ?? 9;\
				"addTheIncrementForTheLoops";$l ?? 8;\
				"splitTestLines";$l ?? 12;\
				"replaceComparisonsToAnEmptyStringByLengthTest";$l ?? 13;\
				"replaceIfElseEndIfByChoose";$l ?? 14;\
				"splitKeyValueLines";$l ?? 7)
			
			TEXT TO BLOB:C554($oBuffer["preferences"]["specialPasteChoice"].$;$x;Mac text without length:K22:10)
			BASE64 DECODE:C896($x)
			$oSettings.specialPast:=New object:C1471(\
				"selected";Num:C11(BLOB to text:C555($x;Mac text without length:K22:10)))
			
			TEXT TO BLOB:C554($oBuffer["preferences"]["specialPasteOptions"].$;$x;Mac text without length:K22:10)
			BASE64 DECODE:C896($x)
			$l:=Num:C11(BLOB to text:C555($x;Mac text without length:K22:10))
			$oSettings.specialPast.options:=New object:C1471(\
				"ignoreBlankLines";$l ?? 10;\
				"deleteIndentation";$l ?? 11)
			
			$fileSettings.setText(JSON Stringify:C1217($oSettings;*))
			
		Else 
			
			  // PARSING ERROR
			
		End if 
	End if 
	
Else 
	
	  // Use default settings
	$fileSettings:=File:C1566("/RESOURCES/default.settings").copyTo($fileSettings.parent;"4DPop Macros.settings")
	
End if 