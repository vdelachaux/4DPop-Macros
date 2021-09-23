//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : Get_resource
// Created 06/05/06 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
//----------------------------------------------------
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_POINTER:C301($3)

C_BLOB:C604($Blb_Value)
C_BOOLEAN:C305($Boo_OK)
C_POINTER:C301($Ptr_Value)
C_TEXT:C284($Txt_Buffer; $Txt_Name; $Txt_Path; $Txt_Type; $a16_Node; $a16_Root)

If (False:C215)
	C_BOOLEAN:C305(Get_resource; $0)
	C_TEXT:C284(Get_resource; $1)
	C_TEXT:C284(Get_resource; $2)
	C_POINTER:C301(Get_resource; $3)
End if 

$Txt_Name:=$1
$Txt_Type:=$2
$Ptr_Value:=$3

$Txt_Path:=_o_Files_And_Folders("Add_Folder"; Get 4D folder:C485; "4DPop v11"; True:C214)
$Txt_Path:=_o_Files_And_Folders("Add_File"; $Txt_Path; "resources.xml")

$a16_Root:=DOM Parse XML source:C719($Txt_Path)
$Boo_OK:=(OK=1)

If ($Boo_OK)
	
	$a16_Node:=DOM Find XML element:C864($a16_Root; "/M_4DPop/"+$Txt_Name)
	$Boo_OK:=(OK=1)
	
	If ($Boo_OK)
		
		DOM GET XML ELEMENT VALUE:C731($a16_Node; $Txt_Buffer)
		$Boo_OK:=(OK=1)
		
	End if 
	
	DOM CLOSE XML:C722($a16_Root)
	
	If ($Boo_OK)
		
		TEXT TO BLOB:C554($Txt_Buffer; $Blb_Value; Mac text without length:K22:10)
		$Boo_OK:=(OK=1)
		
		If ($Boo_OK)
			
			BASE64 DECODE:C896($Blb_Value)
			$Boo_OK:=(OK=1)
			
			If ($Boo_OK)
				
				Case of 
						
						//______________________________________________________
					: ($Txt_Type="PICT")
						
						BLOB TO PICTURE:C682($Blb_Value; $Ptr_Value->)
						$Boo_OK:=(OK=1)
						
						//______________________________________________________
					Else 
						
						$Boo_OK:=False:C215
						
						//______________________________________________________
				End case 
			End if 
			
			SET BLOB SIZE:C606($Blb_Value; 0)
			
		End if 
	End if 
End if 

$0:=$Boo_OK