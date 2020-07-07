//var $l : Integer
//$l:=Selected list items(*; OBJECT Get name(Object current); *)

//Case of 

////______________________________________________________
//: ($l=0)

//Form.subset:=Form.variables

////______________________________________________________
//: ($l=-1)

//Form.subset:=Form.variables.query("parameter=true")

////______________________________________________________
//: ($l=-2)

//Form.subset:=Form.variables.query("parameter=null")

////______________________________________________________
//: ($l=-3)

//Form.subset:=Form.variables.query("type=null")

////______________________________________________________
//Else 

//Form.subset:=Form.variables.query("type=:1"; $l)

////______________________________________________________
//End case 

//LISTBOX SELECT ROW(*; "declarationList"; 0; lk remove from selection)

//Form.index:=0
//Form.current:=null

//Form.display(Form.current)

Form:C1466.filter()