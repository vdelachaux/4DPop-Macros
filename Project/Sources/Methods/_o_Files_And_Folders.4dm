//%attributes = {"invisible":true}
// ----------------------------------------------------
// Méthode : x_gTxt_Files_And_Folders_Hdl
// Created 08/12/00 par Vincent de Lachaux
// ----------------------------------------------------
// Description
// Traitements divers avec les chemins d'accès
// ----------------------------------------------------
//Point d'entrée :
//- "Get_Parent_Path" : Retourne le chemin du dossier parent du dernier fichier ou dossier du chemin $2
//- "Get_File_Name" : Retourne le nom du dossier ou du fichier du chemin $2
//- "Get_Short_File_Name" : Retourne le nom d'un fichier sans son extension
//- "Get_Extension" : Retourne l'extension d'un fichier
//- "Add_Folder" : Ajoute un dossier au chemin $2 et le crée si $4 est vrai et le chemin $2 valide
//- "Add_File" : Ajoute un fichier au chemin $2
// ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)
C_BOOLEAN:C305($4)

C_BOOLEAN:C305($Boo_Create)
C_LONGINT:C283($Lon_i; $Lon_Parameters)
C_TEXT:C284($Txt_Directory_Symbol; $Txt_Entrypoint; $Txt_Extension_Symbol; $Txt_FileOrFolderName; $Txt_Path; $Txt_Result; $Txt_System)

If (False:C215)
	C_TEXT:C284(_o_Files_And_Folders; $0)
	C_TEXT:C284(_o_Files_And_Folders; $1)
	C_TEXT:C284(_o_Files_And_Folders; $2)
	C_TEXT:C284(_o_Files_And_Folders; $3)
	C_BOOLEAN:C305(_o_Files_And_Folders; $4)
End if 

$Lon_Parameters:=Count parameters:C259
$Txt_System:=System folder:C487
$Txt_Directory_Symbol:=$Txt_System[[Length:C16($Txt_System)]]
$Txt_Extension_Symbol:="."

If ($Lon_Parameters>0)
	
	$Txt_Entrypoint:=$1
	
	If ($Lon_Parameters>1)
		
		$Txt_Path:=$2
		
		If ($Lon_Parameters>2)
			
			$Txt_FileOrFolderName:=$3
			
			If ($Lon_Parameters>3)
				
				$Boo_Create:=$4
				
			End if 
		End if 
	End if 
End if 

Case of 
		
		//______________________________________________________
	: (Length:C16($Txt_Entrypoint)=0)
		
		ALERT:C41(Get localized string:C991("A parameter was expected."))  //Il manque un paramètre.
		
		//______________________________________________________
	: (Length:C16($Txt_Path)=0)
		
		ALERT:C41(Get localized string:C991("A parameter was expected."))  //Il manque un paramètre.
		
		//______________________________________________________
	: ($Txt_Entrypoint="Get_Parent_Path")  // Return parent path for a file or a folder
		
		If ($Txt_Path[[Length:C16($Txt_Path)]]=$Txt_Directory_Symbol)
			
			$Txt_Path:=Substring:C12($Txt_Path; 1; Length:C16($Txt_Path)-1)
			
		End if 
		
		For ($Lon_i; Length:C16($Txt_Path); 1; -1)
			
			If ($Txt_Path[[$Lon_i]]=$Txt_Directory_Symbol)
				
				$Txt_Result:=Substring:C12($Txt_Path; 1; $Lon_i)
				$Lon_i:=0
				
			End if 
		End for 
		
		//______________________________________________________
	: ($Txt_Entrypoint="Get_File_Name")  // Return file or folder name
		
		If ($Txt_Path[[Length:C16($Txt_Path)]]=$Txt_Directory_Symbol)
			
			$Txt_Path:=Substring:C12($Txt_Path; 1; Length:C16($Txt_Path)-1)
			
		End if 
		
		For ($Lon_i; Length:C16($Txt_Path); 1; -1)
			
			If ($Txt_Path[[$Lon_i]]=$Txt_Directory_Symbol)
				
				$Txt_Result:=Substring:C12($Txt_Path; $Lon_i+1)
				$Lon_i:=0
				
			End if 
		End for 
		
		//______________________________________________________
	: ($Txt_Entrypoint="Get_Short_File_Name")  // Return file name without extension
		
		For ($Lon_i; Length:C16($Txt_Path); 1; -1)
			
			If ($Txt_Path[[$Lon_i]]=$Txt_Extension_Symbol)
				
				$Txt_Result:=Substring:C12($Txt_Path; 1; $Lon_i-1)
				$Lon_i:=0
				
			End if 
		End for 
		
		//______________________________________________________
	: ($Txt_Entrypoint="Get_Extension")  // Return file  extension
		
		For ($Lon_i; Length:C16($Txt_Path); 1; -1)
			
			If ($Txt_Path[[$Lon_i]]=$Txt_Extension_Symbol)
				
				$Txt_Result:=Substring:C12($Txt_Path; $Lon_i+1)
				$Lon_i:=0
				
			End if 
		End for 
		
		//______________________________________________________
	: ($Txt_Entrypoint="Add_Folder")  // Append a folder to a path
		
		If ($Txt_Path[[Length:C16($Txt_Path)]]#$Txt_Directory_Symbol)
			
			$Txt_Path:=$Txt_Path+$Txt_Directory_Symbol
			
		End if 
		
		$Txt_Result:=$Txt_Path+$Txt_FileOrFolderName+$Txt_Directory_Symbol
		
		If ($Boo_Create)
			
			If (Test path name:C476($Txt_Path)=Is a folder:K24:2)
				
				If (Test path name:C476($Txt_Result)#Is a folder:K24:2)
					
					CREATE FOLDER:C475($Txt_Result)
					
				End if 
			End if 
		End if 
		
		//______________________________________________________
	: ($Txt_Entrypoint="Add_File")  // Append a file to a path
		
		If ($Txt_Path[[Length:C16($Txt_Path)]]#$Txt_Directory_Symbol)
			
			$Txt_Path:=$Txt_Path+$Txt_Directory_Symbol
			
		End if 
		
		$Txt_Result:=$Txt_Path+$Txt_FileOrFolderName
		
		//______________________________________________________
	: ($Txt_Entrypoint="Unix")
		
		$Txt_Result:=Replace string:C233($Txt_Path; $Txt_Directory_Symbol; "/")
		
		//______________________________________________________
	: ($Txt_Entrypoint="Without_Volume")
		
		$Txt_Result:=$Txt_Path
		$Lon_i:=Position:C15($Txt_Directory_Symbol; $Txt_System)
		
		If ($Lon_i>0)
			
			$Txt_System:=Substring:C12($Txt_System; 1; $Lon_i)
			$Txt_Result:=Replace string:C233($Txt_Path; $Txt_System; ""; 1)
			
		End if 
		
		//______________________________________________________
	Else 
		
		ALERT:C41(Get localized string:C991("Syntax error."))  //Syntax error.
		TRACE:C157
		
		//______________________________________________________
End case 

$0:=$Txt_Result