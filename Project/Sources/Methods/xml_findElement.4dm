//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : xml_findElement
  // Database: 4D Mobile Express
  // ID[42201DC36CAD45BDB841D1B8A31AC0D0]
  // Created #1-8-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Wrapper for DOM Find XML element to catch errors.
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_reference;$Txt_methodOnError;$Txt_xpath)
C_OBJECT:C1216($Obj_result)

If (False:C215)
	C_OBJECT:C1216(xml_findElement ;$0)
	C_TEXT:C284(xml_findElement ;$1)
	C_TEXT:C284(xml_findElement ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Dom_reference:=$1
	$Txt_xpath:=$2
	
	$Obj_result:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_methodOnError:=Method called on error:C704

  // TRY (
ON ERR CALL:C155("xml_NO_ERROR")
xml_ERROR:=0
  //) {

$Obj_result.reference:=DOM Find XML element:C864($Dom_reference;$Txt_xpath)
$Obj_result.success:=((OK=1) & (xml_ERROR#0) & \
($Obj_result.reference#"00000000000000000000000000000000") & ($Obj_result.reference#""))

  // } CATCH {
If (xml_ERROR#0)
	$Obj_result.error:=xml_ERROR
End if 
ON ERR CALL:C155($Txt_methodOnError)
  // }

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End
