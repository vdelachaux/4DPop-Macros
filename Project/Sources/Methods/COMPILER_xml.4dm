//%attributes = {"invisible":true,"preemptive":"capable"}
var xml_ERROR : Integer

If (False:C215)
	
	//____________________________________
	_O_C_OBJECT:C1216(xml_attributes; $0)
	_O_C_TEXT:C284(xml_attributes; $1)
	
	//____________________________________
	_O_C_OBJECT:C1216(xml_elementToObject; $0)
	_O_C_TEXT:C284(xml_elementToObject; $1)
	_O_C_BOOLEAN:C305(xml_elementToObject; $2)
	
	//____________________________________
	_O_C_OBJECT:C1216(xml_fileToObject; $0)
	_O_C_TEXT:C284(xml_fileToObject; $1)
	_O_C_BOOLEAN:C305(xml_fileToObject; $2)
	
	//____________________________________
	_O_C_COLLECTION:C1488(xml_findByName; $0)
	_O_C_TEXT:C284(xml_findByName; $1)
	_O_C_TEXT:C284(xml_findByName; $2)
	
	//____________________________________
	_O_C_OBJECT:C1216(xml_refToObject; $0)
	_O_C_TEXT:C284(xml_refToObject; $1)
	_O_C_BOOLEAN:C305(xml_refToObject; $2)
	
	//____________________________________
	_O_C_TEXT:C284(xml_encode; $0)
	_O_C_TEXT:C284(xml_encode; $1)
	
	//____________________________________
	_O_C_OBJECT:C1216(xml_findElement; $0)
	_O_C_TEXT:C284(xml_findElement; $1)
	_O_C_TEXT:C284(xml_findElement; $2)
	
	//____________________________________
End if 