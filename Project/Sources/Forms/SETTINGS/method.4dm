  // ----------------------------------------------------
  // Form method : SETTINGS - (4DPop Macros)
  // ID[E2F45189436B404AB8C5D63F271B7B0F]
  // Created #2-12-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($kLon_COUNT;$Lon_formEvent;$i;$Lon_options;$Lon_unused)
C_POINTER:C301($Ptr_labels;$Ptr_options)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		If (Not:C34(Preferences ("Get_Value";"beautifier-options";->$Lon_options)))  //default
			
			$Lon_options:=Beautifier_init 
			
		End if 
		
		$kLon_COUNT:=15  //14
		$Lon_unused:=1
		
		$Ptr_options:=OBJECT Get pointer:C1124(Object named:K67:5;"cb")
		$Ptr_labels:=OBJECT Get pointer:C1124(Object named:K67:5;"label")
		
		  //%W-518.5
		ARRAY BOOLEAN:C223($Ptr_options->;$kLon_COUNT)
		ARRAY TEXT:C222($Ptr_labels->;$kLon_COUNT)
		  //%W+518.5
		
		For ($i;1;$kLon_COUNT;1)
			
			$Ptr_options->{$i}:=$Lon_options ?? $i  //($i-1)
			$Ptr_labels->{$i}:=Get localized string:C991("beautifier_"+String:C10($i-1;"00"))
			
		End for 
		
		  //ARRAY LONGINT($tLon_sortOrder;$kLon_COUNT)
		  //$tLon_sortOrder{15}:=0  //Replace deprecated command
		  //$tLon_sortOrder{10}:=1  //Remove consecutive blank lines
		  //$tLon_sortOrder{1}:=2  //Remove empty lines at the begin of method
		  //$tLon_sortOrder{2}:=3  //Remove empty lines at the end of method
		  //$tLon_sortOrder{3}:=4  //Line break before branching structures
		  //$tLon_sortOrder{6}:=5  //Line break before looping structures
		  //$tLon_sortOrder{4}:=6  //Line break before and after sequential structures included
		  //$tLon_sortOrder{5}:=7  //Separation line for Case of
		  //$tLon_sortOrder{11}:=8  //A line of comments must be preceded by a line break
		  //$tLon_sortOrder{9}:=9  //Grouping closure instructions
		  //$tLon_sortOrder{8}:=10  //Add the increment for the loops
		  //$tLon_sortOrder{12}:=11  //Split test lines with "&" and "|"
		  //$tLon_sortOrder{13}:=12  //Replace comparisons to an empty string by length test
		  //$tLon_sortOrder{14}:=13  //Replace "If(test) var:=x Else var:=y End if" by "var:=Choose(test;x;y)"
		  //$tLon_sortOrder{7}:=14  //A key / value per line
		
		  //SORT ARRAY($tLon_sortOrder;$Ptr_options->;$Ptr_labels->)
		
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		$Ptr_options:=OBJECT Get pointer:C1124(Object named:K67:5;"cb")
		
		For ($i;1;Size of array:C274($Ptr_options->);1)
			
			If ($Ptr_options->{$i})
				
				$Lon_options:=$Lon_options ?+ $i  //($i-1)
				
			End if 
			
			  //$Lon_options:=$Lon_options
			
		End for 
		
		Preferences ("Set_Value";"beautifier-options";->$Lon_options)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessary ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 