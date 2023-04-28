//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Method : Install_Regex
  // Created 06/05/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_BOOLEAN:C305($0)

C_BOOLEAN:C305($Boo_OK)
C_TEXT:C284($t)
C_OBJECT:C1216($file)

If (False:C215)
	C_BOOLEAN:C305(Install_regex ;$0)
End if 

$file:=Folder:C1567(fk user preferences folder:K87:10).folder("4DPop").file("regex.xml")
$Boo_OK:=$file.exists

If (Not:C34($Boo_OK))
	
	  // Create the file
	$t:="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\" ?>\r"\
		+"<!-- 4DPop by vincent de lachaux  vincent@de-lachaux.net -->\r"\
		+"<M_4DPop>\r"\
		+"    <REGEX>\r"\
		+"        <patterns>\r"\
		+" \r"\
		+"            <pattern Name=\"Macro_Attributes\">\r"\
		+"                <![CDATA[\r"\
		+"                    (<_* macro[^s] [^>]*? name=\"%\" [^>]*? >)\r"\
		+"                    (.*?)\r"\
		+"                    (</_* macro>)\r"\
		+"                ]]>\r"\
		+"            </pattern>\r"\
		+" \r"\
		+"            <pattern Name=\"Get_Macro\">\r"\
		+"                <![CDATA[\r"\
		+" \r"\
		+"                    <$1>[\\r\\s\\t\\n]*</$1>\r"\
		+" \r"\
		+"                    (?: (?=<_* macro[^s] [^>]*? name=\"%\" [^>]*? >))\r"\
		+"                    (?: (?= [^>]*? (\\sname=\"([^\"]*)\") ) )?              (?# 1 - 2 = String)\r"\
		+"                    (?: (?= [^>]*? (\\sin_menu=\"([^\"]*)\") ) )?           (?# 3 - 4 = True|False)\r"\
		+"                    (?: (?= [^>]*? (\\stype_ahead=\"([^\"]*)\") ) )?        (?# 5 - 6 = true|false)\r"\
		+"                    (?: (?= [^>]*? (\\stype_ahead_text=\"([^\"]*)\") ) )?   (?# 7 - 8 = String)\r"\
		+"                      (?: (?:[^>]*?) (?:\\2 | \\4 | \\6 | \\8)* )?\r"\
		+"                      (?: (?:[^>]*?) (?:\\2 | \\4 | \\6 | \\8)* )?\r"\
		+"                      (?: (?:[^>]*?) (?:\\2 | \\4 | \\6 | \\8)* )?\r"\
		+"                      (?: (?:[^>]*?) (?:\\2 | \\4 | \\6 | \\8)* )?\r"\
		+"                    (?: <(_)*macro[^s] )?                               (?# 9 = _ if disabled)\r"\
		+"                    (?: <!--(.*?)-->)?\r"\
		+"                    (?: [^>]*? >) $1\r"\
		+"                    (?: <text> $1)?\r"\
		+"                    (?: (?= .*? <method> (.*?) </method> $1) )?         (?# 10 = MethodName)\r"\
		+"                    \\r*(.*?)?                                           (?# 11 = MacroText)\r"\
		+"                    (?: </text> $1)?\r"\
		+"                    </_* macro> $1\r"\
		+"                ]]>\r"\
		+"            </pattern>\r"\
		+" \r"\
		+"            <pattern Name=\"Comment_si\">\r"\
		+"                <![CDATA[\r"\
		+"                    ((^(\\t*)%1\\s*\\([^\\r]*?\\r)+((.*?\\r)*?)(\\r*\\3%2[^$]*$)+)+\r"\
		+"                ]]>\r"\
		+"            </pattern>\r"\
		+" \r"\
		+"            <pattern Name=\"Method_Parsing\">\r"\
		+"                <![CDATA[\r"\
		+" \r"\
		+"                    <$1>[-:=+#*/%&\\\\^?<>\\xB2\\xB3!\\xA0|\\xCA;(){}\\[\\]\\r\\t]</$1>       (?# 4D Delimitors)\r"\
		+"                    \r"\
		+"                    [\\t\\n\\s\\xCA]*                                                   (?# Empty line or grigri)\r"\
		+"                    (?:\r"\
		+"                        (?: `+ [^\\r]+ \\r)                                           (?# Comment)\r"\
		+"                        |\r"\
		+"                        (?: \r"\
		+"                            $1*                                                     (?# Start with delimitor)\r"\
		+"                            (?:\r"\
		+"                               \r"\
		+"                                (?: \\x22 (?: \\\\\\x22 | [^\\x22])* \\x22 )+             (?# Text)\r"\
		+"                            )\r"\
		+"                            $1+                                                     (?# Stop with delimitor)\r"\
		+"                        )\r"\
		+"                        |\r"\
		+"                        (?: \r"\
		+"                            ^ | $1*?                                                (?# New line or delimitor)\r"\
		+"                        )\r"\
		+"                        (?: \r"\
		+"                            [\\d,:/`]*                                               (?# Numeric & grigri)\r"\
		+"                            |\r"\
		+"                            0x.*?                                                   (?# Hexa)\r"\
		+"                            |\r"\
		+"                            \\x22.*?\\x22                                             (?# Text)\r"\
		+"                            |\r"\
		+"                            ((?: \\$ {\\d*}) | .*?)                                   (?# Entity)\r"\
		+"                        )\r"\
		+"                        (?:\r"\
		+"                            $ | $1+                                                 (?# End of line or delimitor)\r"\
		+"                        )\r"\
		+"                     )\r"\
		+"                ]]>\r"\
		+"            </pattern>\r"\
		+" \r"\
		+"            <pattern Name=\"Get_Locals\">\r"\
		+"                <![CDATA[\r"\
		+" \r"\
		+"                    <$1>[-:=+#*/%&\\\\^?<>\\xB2\\xB3!\\xA0|\\xCA;(){}\\[\\]\\r\\t]</$1>       (?# 4D Delimitors)\r"\
		+"                    \r"\
		+"                    [\\t\\n\\s\\xCA]*                                                   (?# Empty line or grigri)\r"\
		+"                    (?:\r"\
		+"                        (?: `+ [^\\r]+ \\r)                                           (?# Comment)\r"\
		+"                        |\r"\
		+"                        (?: \r"\
		+"                            $1*                                                     (?# Start with delimitor)\r"\
		+"                            (?:\r"\
		+"                               \r"\
		+"                                (?: \\x22 (?: \\\\\\x22 | [^\\x22])* \\x22 )+             (?# Text)\r"\
		+"                            )\r"\
		+"                            $1+                                                     (?# Stop with delimitor)\r"\
		+"                        )\r"\
		+"                        |\r"\
		+"                        (?: \r"\
		+"                            ^ | $1*?                                                (?# New line or delimitor)\r"\
		+"                        )\r"\
		+"                        (?: \r"\
		+"                            [\\d,:/`]*                                               (?# Numeric & grigri)\r"\
		+"                            |\r"\
		+"                            0x.*?                                                   (?# Hexa)\r"\
		+"                            |\r"\
		+"                            \\x22.*?\\x22                                             (?# Text)\r"\
		+"                            |\r"\
		+"                            ((?: \\$ {\\d*}) | \\$ [[:alnum:]_]{1,31})                 (?# Parameter or local)\r"\
		+"                        )\r"\
		+"                        (?:\r"\
		+"                            $ | $1+                                                 (?# End of line or delimitor)\r"\
		+"                        )\r"\
		+"                     )\r"\
		+"                ]]>\r"\
		+"            </pattern>\r"\
		+" \r"\
		+"            <pattern Name=\"Get_Parameters\">\r"\
		+"                <![CDATA[\r"\
		+"                    (?: `+ [^\\r]+ \\r*)\r"\
		+"                    |\r"\
		+"                    (C_[^(]*) \\( ( \\$ {*\\d+}* ;*)+ \\) (?: `+ ([^\\r]+) \\r*)?\r"\
		+"                ]]>\r"\
		+"            </pattern>\r"\
		+" \r"\
		+"        </patterns>\r"\
		+" \r"\
		+"    </REGEX>\r"\
		+" \r"\
		+"</M_4DPop>\r"
	
	$file.setText($t)
	$Boo_OK:=($file.getText()=$t)
	
End if 

$0:=$Boo_OK  // True if installation succesfull