//%attributes = {"invisible":true}
// ----------------------------------------------------
// Test / inspection for CODE_TO_EXECUTE_FORMULA (the "EXECUTE FORMULA" macro).
// ----------------------------------------------------
// Feeds sample 4D code lines through the transformation and returns the
// input -> output pairs. A readable report is also copied to the pasteboard.
// Usage: run the method, then paste anywhere to read it (or inspect $results).
// ----------------------------------------------------
#DECLARE() : Collection

var $samples; $results : Collection
var $sample; $output; $report : Text

$samples:=[\
"BEEP"; \
"$result:=Uppercase:C13(\"hello\")"; \
"ALERT:C41(\"Test\"; \"OK\")"; \
"// a comment line"; \
"If ($x>0)\rALERT:C41(\"positive\")\rEnd if"; \
"$sum:=$a+$b\rTRACE\r// done"]

$results:=[]

For each ($sample; $samples)
	
	$output:=CODE_TO_EXECUTE_FORMULA($sample)
	
	$results.push(New object:C1471("input"; $sample; "output"; $output))
	
	$report+="=== INPUT ===\r"+$sample+"\r=== OUTPUT ===\r"+$output+"\r\r"
	
End for each 

SET TEXT TO PASTEBOARD:C523($report)

return $results
