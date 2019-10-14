  // ----------------------------------------------------
  // Method : Méthode formulaire : M4DPop_About
  // Created 27/01/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // 
  // ----------------------------------------------------
C_LONGINT:C283($Lon_Event)
C_REAL:C285($Num_Offset)

$Lon_Event:=Form event code:C388

Case of 
		  //______________________________________________________
	: ($Lon_Event=On Timer:K2:25)
		
		If (<>About_Lon_Flip=180)
			If (<>About_Lon_Image=3002)
				SET TIMER:C645(0)
				<>About_Txt_Macro:="<macros>\r"+Char:C90(0)+"  <macro>\r   <text>\r     <method>4DPop"
				<>About_Txt_Macro:=<>About_Txt_Macro+"</method>\r    </text>\r    </macro>\r</macros>"+"\r"
				<>About_Txt_Buffer:=<>About_Txt_Macro
				If (<>About_Txt_Displayed=<>About_Txt_Buffer)
					<>About_Lon_Flip:=-1
					OBJECT SET VISIBLE:C603(*;"Titles_2@";True:C214)
					SET TIMER:C645(500)
				Else 
					If (Length:C16(<>About_Txt_Displayed)=0)
						<>About_Txt_Displayed:=Substring:C12(<>About_Txt_Buffer;1;Position:C15("\r";<>About_Txt_Buffer))
						SET TIMER:C645(20)
					Else 
						<>About_Txt_Buffer:=Substring:C12(<>About_Txt_Buffer;Length:C16(<>About_Txt_Displayed)+2)
						If (Length:C16(<>About_Txt_Buffer)=0)
							<>About_Txt_Displayed:=<>About_Txt_Macro
							<>About_Lon_Flip:=-(1+Num:C11(<>About_Lon_AutoHide#0))
							OBJECT SET VISIBLE:C603(*;"Titles_2@";True:C214)
							SET TIMER:C645(200)
						Else 
							<>About_Txt_Displayed:=<>About_Txt_Displayed+Substring:C12(<>About_Txt_Buffer;1;Position:C15("\r";<>About_Txt_Buffer))
							SET TIMER:C645(20)
						End if 
					End if 
				End if 
			Else 
				<>About_Lon_Flip:=-1
				SET TIMER:C645(200)
			End if 
			
		Else 
			
			Case of 
					  //.....................................................    
				: (<>About_Lon_Flip=-2)
					CANCEL:C270
					  //.....................................................  
				: (<>About_Lon_Flip=-1)
					<>About_Lon_Flip:=0
					OBJECT SET VISIBLE:C603(*;"Titles_2@";False:C215)
					<>About_Txt_Displayed:=""
					SET TIMER:C645(-1)
					  //.....................................................  
			End case 
			
			If (<>About_Lon_Flip=0)
				
				OBJECT SET VISIBLE:C603(*;"Titles@";False:C215)
				<>About_Lon_Flip:=2
				
			Else 
				
				If (<>About_Lon_Flip>0)
					$Num_Offset:=(205/2)*Abs:C99(Cos:C18(<>About_Lon_Flip*Pi:K30:1/180))
					OBJECT MOVE:C664(*;"_Background";(205/2)-$Num_Offset;0;(205/2)+$Num_Offset;160;*)
					<>About_Lon_Flip:=<>About_Lon_Flip+2
					
					If (<>About_Lon_Flip=90)
						If (<>About_Lon_Image=3000)
							<>About_Lon_Image:=3002
							Get_resource ("scombrus";"PICT";-><>About_Pict_Displayed)
						Else 
							<>About_Lon_Image:=3000
							Get_resource ("scomber";"PICT";-><>About_Pict_Displayed)
						End if 
					End if 
					
					If (<>About_Lon_Flip>=180)
						OBJECT MOVE:C664(*;"_Background";0;0;205;160;*)
						OBJECT SET VISIBLE:C603(*;"Titles_1@";(<>About_Lon_Image=3000))
						<>About_Lon_Flip:=180
					End if 
					
				End if 
				
			End if 
			
		End if 
		  //______________________________________________________
	: ($Lon_Event=On Load:K2:1)
		
		C_PICTURE:C286(<>About_Pict_Displayed)
		
		C_LONGINT:C283(<>About_Lon_Flip;<>About_Lon_Image)
		C_TEXT:C284(<>About_Txt_Displayed)
		
		<>About_Txt_Displayed:=""
		<>About_Lon_Flip:=180  //Flip
		<>About_Lon_Image:=3000  //Nº image
		
		OBJECT SET VISIBLE:C603(*;"Titles_2@";False:C215)
		
		Get_resource ("scomber";"PICT";-><>About_Pict_Displayed)
		<>Txt_buffer:="4DPop Macros v"+Get_Version 
		
		SET TIMER:C645(50)
		  //______________________________________________________
	: ($Lon_Event=On Unload:K2:2)
		<>About_Pict_Displayed:=<>About_Pict_Displayed*0
		  //______________________________________________________
End case 
