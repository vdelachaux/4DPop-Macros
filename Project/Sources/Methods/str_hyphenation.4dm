//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : str_hyphenation
  // Database: 4DPop Macros
  // ID[AC75BA24967246A39ECDD666C346965D]
  // Created #26-4-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_LONGINT:C283($2)
C_TEXT:C284($3)
C_TEXT:C284($4)

C_LONGINT:C283($Lon_columns;$Lon_i;$Lon_parameters;$Lon_x)
C_TEXT:C284($Txt_delimitors;$Txt_in;$Txt_out;$Txt_separator;$Txt_tempo)

If (False:C215)
	C_TEXT:C284(str_hyphenation ;$0)
	C_TEXT:C284(str_hyphenation ;$1)
	C_LONGINT:C283(str_hyphenation ;$2)
	C_TEXT:C284(str_hyphenation ;$3)
	C_TEXT:C284(str_hyphenation ;$4)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Txt_in:=$1
	
	If ($Lon_parameters>=2)
		
		$Lon_columns:=$2
		
		If ($Lon_parameters>=3)
			
			$Txt_separator:=$3
			
			If ($Lon_parameters>=4)
				
				$Txt_delimitors:=$4
				
			End if 
		End if 
	End if 
	
	  //default values
	$Lon_columns:=Choose:C955($Lon_columns<=0;80;$Lon_columns)
	$Txt_separator:=Choose:C955(Length:C16($Txt_separator)=0;"\r";$Txt_separator)
	$Txt_delimitors:=Choose:C955(Length:C16($Txt_delimitors)=0;" -\r\n\t";$Txt_delimitors)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_in:=Replace string:C233($Txt_in;"\r\n";"\r")
$Txt_in:=Replace string:C233($Txt_in;"\n";"\r")

Repeat 
	
	If (Length:C16($Txt_in)<=$Lon_columns)
		
		$Txt_out:=$Txt_out+$Txt_in
		CLEAR VARIABLE:C89($Txt_in)
		
	Else 
		
		$Txt_tempo:=Substring:C12($Txt_in;1;$Lon_columns)
		$Lon_x:=Position:C15("\r";$Txt_tempo)
		
		Case of 
				
				  //___________________________________________________
			: ($Lon_x>0)
				
				  //line feed
				$Txt_tempo:=Substring:C12($Txt_in;1;$Lon_x)
				$Txt_out:=$Txt_out+$Txt_tempo
				
				  //___________________________________________________
			: (Position:C15($Txt_in[[$Lon_columns]];$Txt_delimitors)>0)
				
				  //Well cut
				$Txt_tempo:=Substring:C12($Txt_in;1;$Lon_columns)
				$Txt_out:=$Txt_out+$Txt_tempo+$Txt_separator
				
				  //___________________________________________________
			: (Position:C15($Txt_in[[$Lon_columns-1]];$Txt_delimitors)>0)
				
				  //Almost good
				$Txt_tempo:=Substring:C12($Txt_in;1;$Lon_columns-1)
				$Txt_out:=$Txt_out+$Txt_tempo+$Txt_separator
				
				  //___________________________________________________
			: (Position:C15($Txt_in[[$Lon_columns+1]];$Txt_delimitors)>0)
				
				  //Almost good
				$Txt_tempo:=Substring:C12($Txt_in;1;$Lon_columns+1)
				$Txt_out:=$Txt_out+$Txt_tempo+$Txt_separator
				
				  //___________________________________________________
			Else 
				
				  //Find the right cut
				For ($Lon_i;$Lon_columns;1;-1)
					
					$Lon_x:=Position:C15($Txt_tempo[[$Lon_i]];$Txt_delimitors)
					
					If ($Lon_x>0)
						
						$Txt_tempo:=Substring:C12($Txt_tempo;1;$Lon_i)
						$Txt_out:=$Txt_out+$Txt_tempo+$Txt_separator
						
						$Lon_i:=0
						
					End if 
				End for 
				
				  //___________________________________________________
		End case 
		
		$Txt_in:=Replace string:C233($Txt_in;$Txt_tempo;"";1)
		
	End if 
Until (Length:C16($Txt_in)=0)

$0:=$Txt_out

  // ----------------------------------------------------
  // End 