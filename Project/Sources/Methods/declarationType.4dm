//%attributes = {}
var $0 : Integer
var $1 : Text

Case of 
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C283"); $1)=1)\
		 | (Position:C15(Parse formula:C1576(":C221"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Integer"; $1; 1)
		
		$0:=Is longint:K8:6
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C284"); $1)=1)\
		 | (Position:C15(Parse formula:C1576(":C222"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Text"; $1; 1)
		
		$0:=Is text:K8:3
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C285"); $1)=1)\
		 | (Position:C15(Parse formula:C1576(":C219"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Real"; $1; 1)
		
		$0:=Is real:K8:4
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C286"); $1)=1)\
		 | (Position:C15(Parse formula:C1576(":C279"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Picture"; $1; 1)
		
		$0:=Is picture:K8:10
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C301"); $1)=1)\
		 | (Position:C15(Parse formula:C1576(":C280"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Pointer"; $1; 1)
		
		$0:=Is pointer:K8:14
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C305"); $1)=1)\
		 | (Position:C15(Parse formula:C1576(":C223"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Boolean"; $1; 1)
		
		$0:=Is boolean:K8:9
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C306"); $1)=1)\
		 | (Position:C15(Parse formula:C1576(":C1223"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Time"; $1; 1)
		
		$0:=Is time:K8:8
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C307"); $1)=1)\
		 | (Position:C15(Parse formula:C1576(":C224"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Date"; $1; 1)
		
		$0:=Is date:K8:7
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C604"); $1)=1)\
		 | (Position:C15(Parse formula:C1576(":C1222"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Blob"; $1; 1)
		
		$0:=Is BLOB:K8:12
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C1216"); $1)=1)\
		 | (Position:C15(Parse formula:C1576(":C1221"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Object"; $1; 1)
		
		$0:=Is object:K8:27
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C1488"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Collection"; $1; 1)
		
		$0:=Is collection:K8:32
		
		//______________________________________________________
	: (Position:C15(Parse formula:C1576(":C1683"); $1)=1)\
		 | Match regex:C1019("(?mi-s)\\s*:\\s*Variant"; $1; 1)
		
		$0:=Is variant:K8:33
		
		//______________________________________________________
	: (Position:C15("var"; $1)=1)
		
		$0:=Is variant:K8:33
		
		//______________________________________________________
End case 