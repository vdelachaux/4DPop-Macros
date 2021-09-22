//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : Preferences
// Created 05/05/06 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
var $0 : Boolean
var $1 : Text
var $2 : Text
var $3 : Pointer

If (False:C215)
	C_BOOLEAN:C305(Preferences; $0)
	C_TEXT:C284(Preferences; $1)
	C_TEXT:C284(Preferences; $2)
	C_POINTER:C301(Preferences; $3)
End if 

var $Dom_node; $Dom_root; $t; $Txt_EntryPoint; $Txt_key; $Txt_property : Text
var $l; $Lon_Parameters : Integer
var $Ptr_value : Pointer
var $x : Blob
var $o; $Obj_preferences; $Obj_shared; $Obj_xml : Object
var $src; $tgt : 4D:C1709.File
var $folder : 4D:C1709.Folder

$Lon_Parameters:=Count parameters:C259

If ($Lon_Parameters>=1)
	
	$Txt_EntryPoint:=$1  // Entry point
	
	If ($Lon_Parameters>=2)
		
		$Txt_key:=$2  // Name of the preferences
		
		If ($Lon_Parameters>=3)
			
			$Ptr_value:=$3  // Value of the preference
			
		End if 
	End if 
End if 

OK:=Num:C11(Storage:C1525.macros#Null:C1517)

If (OK=0)
	
	$folder:=Folder:C1567(fk user preferences folder:K87:10).folder("4DPop")
	$folder.create()
	
	$tgt:=$folder.file("4DPop Preferences.xml")
	
	If ($tgt.original#Null:C1517)
		
		$tgt:=$tgt.original
		
	End if 
	
	If (Not:C34($tgt.exists))  // Let's try with a old file
		
		$src:=$folder.file("4DPop Macros.xml")
		
		If ($src.exists)
			
			$Obj_xml:=xml_fileToObject($src.platformPath)
			
			If ($Obj_xml.value.M_4DPop#Null:C1517)
				
				$src.copyTo($tgt.parent; "4DPop Preferences.xml")
				$src.delete()
				
			End if 
		End if 
	End if 
	
	If (Not:C34($tgt.exists))  // Let's try with a very old preference file...
		
		$src:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop v11/preferences.xml")
		
		If ($src.exists)
			
			$src.copyTo($tgt.parent; "4DPop Preferences.xml")
			
		End if 
	End if 
	
	If (Not:C34($tgt.exists))  // Create default preferences
		
		$src:=Folder:C1567(fk resources folder:K87:11).file("preferences.template")
		$src.copyTo($tgt.parent; "4DPop Preferences.xml")
		
	End if 
	
	Use (Storage:C1525)
		
		Storage:C1525.macros:=New shared object:C1526("lastUsed"; "")
		
		Use (Storage:C1525.macros)
			
			Storage:C1525.macros.preferences:=New shared object:C1526
			
			If ($tgt.exists)
				
				Use (Storage:C1525.macros.preferences)
					
					Storage:C1525.macros.preferences.platformPath:=$tgt.platformPath
					
				End use 
				
				OK:=Num:C11(Preferences("load"))
				
			Else 
				
				ALERT:C41(Get localized string:C991("File not found.")+" : \""+$tgt.path+"\"")
				
			End if 
		End use 
	End use 
End if 

$Obj_preferences:=Storage:C1525.macros.preferences

Case of 
		
		//______________________________________________________
	: (OK=0)
		
		//______________________________________________________
	: ($Txt_EntryPoint="Init")
		
		// <NOTHING MORE TO DO>
		
		//______________________________________________________
	: ($Txt_EntryPoint="load")
		
		$Obj_xml:=xml_fileToObject($Obj_preferences.platformPath)
		OK:=Num:C11($Obj_xml.success)
		
		If (OK=1)
			
			$Obj_xml:=$Obj_xml.value.M_4DPop
			
			Use ($Obj_preferences)
				
				For each ($Txt_property; $Obj_xml.preferences)
					
					If ($Obj_xml.preferences[$Txt_property].$#Null:C1517)
						
						$t:=$Obj_xml.preferences[$Txt_property].$
						TEXT TO BLOB:C554($t; $x; Mac text without length:K22:10)
						BASE64 DECODE:C896($x)
						$t:=BLOB to text:C555($x; Mac text without length:K22:10)
						SET BLOB SIZE:C606($x; 0)
						
						$Obj_preferences[$Txt_property]:=Choose:C955(str_isNumeric($t); Num:C11($t); $t)
						
					End if 
				End for each 
			End use 
			
			Use (Storage:C1525.macros)
				
				Storage:C1525.macros.declarations:=New shared object:C1526
				
			End use 
			
			Use (Storage:C1525.macros.declarations)
				
				Storage:C1525.macros.declarations.version:=$Obj_xml.declarations.version
				
				Storage:C1525.macros.declarations.declaration:=New shared collection:C1527
				
				For each ($o; $Obj_xml.declarations.declaration)
					
					$Obj_shared:=New shared object:C1526
					
					Use ($Obj_shared)
						
						For each ($Txt_property; $o)
							
							$Obj_shared[$Txt_property]:=$o[$Txt_property]
							
						End for each 
						
						Storage:C1525.macros.declarations.declaration.push($Obj_shared)
						
					End use 
				End for each 
			End use 
		End if 
		
		//______________________________________________________
	: ($Txt_EntryPoint="Get_Value")
		
		$Dom_root:=DOM Parse XML source:C719(String:C10($Obj_preferences.platformPath))
		
		If (OK=1)
			
			$Dom_node:=DOM Find XML element:C864($Dom_root; "/M_4DPop/preferences/"+$Txt_key)
			
			If (OK=1)
				
				DOM GET XML ELEMENT VALUE:C731($Dom_node; $t)
				
			End if 
			
			DOM CLOSE XML:C722($Dom_root)
			
			TEXT TO BLOB:C554($t; $x; Mac text without length:K22:10)
			BASE64 DECODE:C896($x)
			$t:=BLOB to text:C555($x; Mac text without length:K22:10)
			SET BLOB SIZE:C606($x; 0)
			
			Case of 
					
					//…………………………………………………………
				: (OK=0)
					
					//…………………………………………………………
				: ($Txt_key="@_file")
					
					OK:=Num:C11(Test path name:C476($t)=Is a document:K24:1)
					
					//…………………………………………………………
				: ($Txt_key="@_folder")
					
					OK:=Num:C11(Test path name:C476($t)=Is a folder:K24:2)
					
					//…………………………………………………………
				: ($Txt_key="@_path")
					
					OK:=Num:C11(Test path name:C476($t)#-43)
					
					//…………………………………………………………
			End case 
			
			If (OK=1)
				
				$Ptr_value->:=Choose:C955(str_isNumeric($t); Num:C11($t); $t)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Txt_EntryPoint="Set_Value")  // Set a preference value
		
		$Dom_root:=DOM Parse XML source:C719($Obj_preferences.platformPath)
		
		If (OK=1)
			
			$Dom_node:=DOM Find XML element:C864($Dom_root; "/M_4DPop/preferences/"+$Txt_key)
			
			If (OK=0)
				
				$Dom_node:=DOM Create XML element:C865($Dom_root; "/M_4DPop/preferences/"+$Txt_key)
				
			End if 
			
			If (OK=1)
				
				$l:=Type:C295($Ptr_value->)
				
				If ($l=Is real:K8:4)\
					 | ($l=Is integer:K8:5)\
					 | ($l=Is longint:K8:6)\
					 | ($l=Is date:K8:7)\
					 | ($l=Is time:K8:8)
					
					$t:=String:C10($Ptr_value->)
					
				Else 
					
					$t:=$Ptr_value->
					
				End if 
				
				TEXT TO BLOB:C554($t; $x; Mac text without length:K22:10)
				BASE64 ENCODE:C895($x)
				$t:=BLOB to text:C555($x; Mac text without length:K22:10)
				SET BLOB SIZE:C606($x; 0)
				
				DOM SET XML ELEMENT VALUE:C868($Dom_node; $t)
				
				If (OK=1)
					
					DOM EXPORT TO FILE:C862($Dom_root; $Obj_preferences.platformPath)
					
				End if 
			End if 
			
			DOM CLOSE XML:C722($Dom_root)
			
			Preferences("load")
			
		End if 
		
		//______________________________________________________
End case 

$0:=(OK=1)
