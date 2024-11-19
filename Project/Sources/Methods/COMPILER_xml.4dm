//%attributes = {"invisible":true,"preemptive":"capable"}
var xml_ERROR : Integer

If (False:C215)
	
	//____________________________________
	_O_C_OBJECT:C1216(_o_xml_attributes; $0)
	_O_C_TEXT:C284(_o_xml_attributes; $1)
	
	//____________________________________
	_O_C_OBJECT:C1216(_o_xml_elementToObject; $0)
	_O_C_TEXT:C284(_o_xml_elementToObject; $1)
	_O_C_BOOLEAN:C305(_o_xml_elementToObject; $2)
	
	//____________________________________
	_O_C_OBJECT:C1216(_o_xml_fileToObject; $0)
	_O_C_TEXT:C284(_o_xml_fileToObject; $1)
	_O_C_BOOLEAN:C305(_o_xml_fileToObject; $2)
	
	//____________________________________
	_O_C_COLLECTION:C1488(_o_xml_findByName; $0)
	_O_C_TEXT:C284(_o_xml_findByName; $1)
	_O_C_TEXT:C284(_o_xml_findByName; $2)
	
	//____________________________________
	_O_C_OBJECT:C1216(_o_xml_refToObject; $0)
	_O_C_TEXT:C284(_o_xml_refToObject; $1)
	_O_C_BOOLEAN:C305(_o_xml_refToObject; $2)
	
	//____________________________________
	_O_C_TEXT:C284(_o_xml_encode; $0)
	_O_C_TEXT:C284(_o_xml_encode; $1)
	
	//____________________________________
	_O_C_OBJECT:C1216(_o_xml_findElement; $0)
	_O_C_TEXT:C284(_o_xml_findElement; $1)
	_O_C_TEXT:C284(_o_xml_findElement; $2)
	
	//____________________________________
End if 