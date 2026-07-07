// ----------------------------------------------------
// Method : Méthode formulaire : M4DPop_About
// Created 27/01/06 by Vincent de Lachaux
// ----------------------------------------------------
var $e:=FORM Event:C1606

Case of 
		
		// ______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		If (Form:C1466.flip=180)
			
			If (Form:C1466.image=3002)
				
				SET TIMER:C645(0)
				Form:C1466.macro:="<macros>\r"+Char:C90(0)+"  <macro>\r   <text>\r     <method>4DPop"
				Form:C1466.macro+="</method>\r    </text>\r    </macro>\r</macros>"+"\r"
				Form:C1466.buffer:=Form:C1466.macro
				
				If (Form:C1466.displayed=Form:C1466.buffer)
					
					Form:C1466.flip:=-1
					OBJECT SET VISIBLE:C603(*; "Titles_2@"; True:C214)
					SET TIMER:C645(500)
					
				Else 
					
					If (Length:C16(Form:C1466.displayed)=0)
						
						Form:C1466.displayed:=Substring:C12(Form:C1466.buffer; 1; Position:C15("\r"; Form:C1466.buffer))
						SET TIMER:C645(20)
						
					Else 
						
						Form:C1466.buffer:=Substring:C12(Form:C1466.buffer; Length:C16(Form:C1466.displayed)+2)
						
						If (Length:C16(Form:C1466.buffer)=0)
							
							Form:C1466.displayed:=Form:C1466.macro
							Form:C1466.flip:=-(1+Num:C11(Form:C1466.autoHide))
							OBJECT SET VISIBLE:C603(*; "Titles_2@"; True:C214)
							SET TIMER:C645(200)
							
						Else 
							
							Form:C1466.displayed+=Substring:C12(Form:C1466.buffer; 1; Position:C15("\r"; Form:C1466.buffer))
							SET TIMER:C645(20)
							
						End if 
					End if 
				End if 
				
			Else 
				
				Form:C1466.flip:=-1
				SET TIMER:C645(200)
				
			End if 
			
		Else 
			
			Case of 
					
					// .....................................................
				: (Form:C1466.flip=-2)
					
					CANCEL:C270
					
					// .....................................................
				: (Form:C1466.flip=-1)
					
					Form:C1466.flip:=0
					OBJECT SET VISIBLE:C603(*; "Titles_2@"; False:C215)
					Form:C1466.displayed:=""
					SET TIMER:C645(-1)
					
					// .....................................................
			End case 
			
			If (Form:C1466.flip=0)
				
				OBJECT SET VISIBLE:C603(*; "Titles@"; False:C215)
				Form:C1466.flip:=2
				
			Else 
				
				If (Form:C1466.flip>0)
					
					var $offset:=(205/2)*Abs:C99(Cos:C18(Form:C1466.flip*Pi:K30:1/180))
					OBJECT MOVE:C664(*; "_Background"; (205/2)-$offset; 0; (205/2)+$offset; 160; *)
					Form:C1466.flip+=2
					
					If (Form:C1466.flip=90)
						
						If (Form:C1466.image=3000)
							
							Form:C1466.image:=3002
							Form:C1466.picture:=getResource("scombrus"; "PICT")
							
						Else 
							
							Form:C1466.image:=3000
							Form:C1466.picture:=getResource("scomber"; "PICT")
							
						End if 
						
						OBJECT SET VALUE:C1742("_Background"; Form:C1466.picture)
						
					End if 
					
					If (Form:C1466.flip>=180)
						
						OBJECT MOVE:C664(*; "_Background"; 0; 0; 205; 160; *)
						OBJECT SET VISIBLE:C603(*; "Titles_1@"; (Form:C1466.image=3000))
						Form:C1466.flip:=180
						
					End if 
				End if 
			End if 
		End if 
		
		// ______________________________________________________
	: ($e.code=On Load:K2:1)
		
		OBJECT SET VALUE:C1742("_Background"; Form:C1466.picture)
		
		SET TIMER:C645(50)
		
		// ______________________________________________________
End case 