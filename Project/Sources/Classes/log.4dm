property _file : 4D:C1709.File
property method : Text

property timestamp:=True:C214
property start:=Milliseconds:C459
property _logsFolder : 4D:C1709.Folder:=Folder:C1567("/LOGS/"; *)

shared singleton Class constructor($target)
	
	If ($target#Null:C1517)
		
		This:C1470.file:=$target
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
shared Function set file($target)
	
	Case of 
			//______________________________________________________
		: (Value type:C1509($target)=Is object:K8:27)\
			 && (OB Instance of:C1731($target; 4D:C1709.File))
			
			This:C1470._file:=$target
			
			//______________________________________________________
		: (Value type:C1509($target)=Is text:K8:3)
			
			This:C1470._file:=File:C1566("/LOGS/"+$target; *)
			
			//______________________________________________________
		Else 
			
			// FIXME:ERROR
			
			//______________________________________________________
	End case 
	
	This:C1470._file.create()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function echo($message : Text)
	
	Try
		
		var $handle:=This:C1470._file.open("append")
		$handle.writeLine(This:C1470.timestamp ? String:C10(Milliseconds:C459-This:C1470.start; "000 000")+"\t"+$message : $message)
		
	Catch
		
		Try(File:C1566("/LOGS/fault_logging.json").setText(JSON Stringify:C1217(Last errors:C1799)))
		
	End try
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function critical($message : Text)
	
	This:C1470.echo("💣 - "+$message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function error($message : Text)
	
	This:C1470.echo("❌ - "+$message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function warning($message : Text)
	
	This:C1470.echo("⚠️ - "+$message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function event($message : Text)
	
	This:C1470.echo("➡️ - "+$message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function trace($message : Text)
	
	This:C1470.echo("📌 - "+$message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function verbose($message : Text)
	
	This:C1470.echo("👀 - "+$message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function list($message : Text)
	
	This:C1470.echo(" ⎿ "+$message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function in($message : Text)
	
	This:C1470.echo("← "+$message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function out($message : Text)
	
	This:C1470.echo("→ "+$message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function delete($message : Text)
	
	This:C1470.echo("⌦ "+$message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function clear()
	
	This:C1470._file.delete()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
shared Function startMethod($method : Text)
	
	This:C1470.method:=$method
	This:C1470.out("Start-"+This:C1470.mode+" "+$method)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function stopMethod($method : Text)
	
	$method:=$method || This:C1470.method
	This:C1470.in("End-"+This:C1470.mode+" "+$method)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get mode() : Text
	
	return Is compiled mode:C492(*) ? "Compiled" : "Interpreted"