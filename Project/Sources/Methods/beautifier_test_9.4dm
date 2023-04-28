//%attributes = {"invisible":true,"preemptive":"capable"}
//C_LONGINT($1)

//C_LONGINT($Lon_count;$Lon_parameters;$Lon_x)
//C_TEXT($Txt_that;$Txt_this)

//If (False)
//C_LONGINT(00_beautifier_test_9 ;$1)
//End if

//  //This bloc must not be modfified
//If ($Lon_parameters>=1)
//$Txt_this:=$1

//Else

//$Txt_this:="that"

//End if

//  //This bloc could be refactored
//If (($Lon_count=1) & ($Lon_x>0))
//$Txt_this:=$Txt_that  //Use Choose instead If…Else…End if

//Else

//$Txt_this:="that"

//End if

// #27-1-2015
//http://forums.4d.fr/Post/FR/15820899/1/15820923#15820900
//OBJECT SET VISIBLE(MaVariableTexte;Length(MaVariabletTxte)#0)

//If (Length(MaVariabletTxte)#0)

//  //

//End if

//OBJECT SET VISIBLE(MaVariableTexte;Length(MaVariabletTxte)#0)
//If (Length(MaVariabletTxte)#0)
//  //
//End if
