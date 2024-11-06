//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Method : Install_Resources
// Created 06/05/06 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE() : Boolean

var $OK : Boolean
var $t : Text
var $file : Object

$file:=Folder:C1567(fk user preferences folder:K87:10).folder("4DPop").file("resources.xml")
$OK:=$file.exists

If (Not:C34($OK))
	
	$t:="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\" ?>\r"+\
		"<M_4DPop>\r"+"<scomber>/9j/4AAQSkZJRgABAQEASABIAAD//gAMQXBwbGVNYXJrCv/bAIQABwUFBgUF\r"+\
		"BwYGBggHBwgKEQsKCQkKFA8PDBEYFRkZFxUXFxodJSAaHCMcFxchLCEjJygq\r"+\
		"KioZHy4xLSkxJSkqKAEHCAgKCQoTCwsTKBsXGygoKCgoKCgoKCgoKCgoKCgo\r"+\
		"KCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgo/8QBogAAAQUBAQEB\r"+\
		"AQEAAAAAAAAAAAECAwQFBgcICQoLAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUG\r"+\
		"BwgJCgsQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGh\r"+\
		"CCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RV\r"+\
		"VldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeo\r"+\
		"qaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX2\r"+\
		"9/j5+hEAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKR\r"+\
		"obHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RV\r"+\
		"VldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaan\r"+\
		"qKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3\r"+\
		"+Pn6/8AAEQgAoADNAwEiAAIRAQMRAf/aAAwDAQACEQMRAD8A+kaKKKACiiig\r"+\
		"AooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAC\r"+\
		"iiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKK\r"+\
		"KKACiiigAooooAKKKKACiiigAoopDQAUmK4qb4lafDr8+l+RI0Nuxjkul5Xe\r"+\
		"McAex3A/SutsL621G3S5tJRLDJkq4zg4OKV1ew7NK5aooFFMQUUUUAFFFFAB\r"+\
		"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\r"+\
		"flihPUTT6HCXF9LcWu2OKAO/BeNNrZ7AjtRYi6EaecMrKCXwMg7T836YrpW8\r"+\
		"Hy2jb/syTjIJw7LkD1pPIuAxSSzdWkXywcgJEpIyfrWrlFR03MLTctTUjhMd\r"+\
		"rboPlaELgAAggL0qvb6ZpUUpmh0y1SUnLOsCgknvnFDXcsJORuXtj07VB9vh\r"+\
		"MnTaT15rGM4vdG7UlsbKtGqgcAdABSgRMc4U4rM8+3kGc/1qcTQ54fA+taEX\r"+\
		"beqL4giJzj34oMMed+Ko/bYV5MnT3oOp2x4JyfTFTdl2ReCQgkjAJ603ES/d\r"+\
		"TPsKzpNWgTgBM543GmNrDkERRs3bgUncLGsMj/lmB9aY8ioMudvsMVzN14hn\r"+\
		"jkZPKfcDtIIxzVRb3UbwshRLcp6/NwfSl7zQ1ZHUyXyjlcYHcms668R21rMl\r"+\
		"vJdoksn3U7n8Kg02xuJmGXedz27Cuvh0S1aFDLAvmDv3qeTzNOZHLJeald3T\r"+\
		"W32OaFcfu7h8FGJ9gc1PaaBrd3aS29/eJDMwIE1omzbzxtyTXZx20MaqqoML\r"+\
		"0qXpRyLqLn7HFQ+AY5LaKDULm4umiYOsrzEOSO5IxVvVPBFnqunm2lllSYA7\r"+\
		"Jkc7l/xrqqKqytawueV7nztrnhrWPCV2EuIhNasflmUHY349VNdV4M8Tf2PO\r"+\
		"sM4eO3mIAUtvVc9w1esXVpBeRNDcRrIjDBVhkGuA1n4cGMtNpEu0Hk28nK/g\r"+\
		"e1YThK94m8akXpI9DhlWaMOhyp6GpK5PwjLqltD9g1OI7o8BJc53D0rqxW6v\r"+\
		"uc7WotFFFMQUUUUABphijbqgNPooApyabay/eiX8q4u/0eP+1ryPzGwGVhgn\r"+\
		"gEA4/Wu/NYGsW4jvBOBjzVAZu2RTTsFrmDa6HBKURnILcBgSK0T4PfPy3MuP\r"+\
		"9+l02J57qIIMpGcs3+FdWOlJtha2hyJ8HOes7ke7mpU8GQj7zg/Uk11VFAGD\r"+\
		"D4Vs4uo/IVeh0azixiMEj1rQooAwtX8Pw3wEsIEVxGMK/t6VzsGj3MkwSSNU\r"+\
		"ZTkgdOa7+o/KTduxzTu0GhWsLGO0iAA+fuau0UUgCiiigAooooAKKKKAE2jP\r"+\
		"SloooAKKKKACiiigAooooAKingjuIzHIMg9qlooAhhgjt1CxpgCpqKKACiii\r"+\
		"gAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKA\r"+\
		"CiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAK\r"+\
		"KKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigD// \r"+\
		"2Q==</scomber>\r"+\
		"<scombrus>/9j/4AAQSkZJRgABAQEASABIAAD//gAMQXBwbGVNYXJrCv/bAIQABwUFBgUF\r"+\
		"BwYGBggHBwgKEQsKCQkKFA8PDBEYFRkZFxUXFxodJSAaHCMcFxchLCEjJygq\r"+\
		"KioZHy4xLSkxJSkqKAEHCAgKCQoTCwsTKBsXGygoKCgoKCgoKCgoKCgoKCgo\r"+\
		"KCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgo/8QBogAAAQUBAQEB\r"+\
		"AQEAAAAAAAAAAAECAwQFBgcICQoLAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUG\r"+\
		"BwgJCgsQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGh\r"+\
		"CCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RV\r"+\
		"VldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeo\r"+\
		"qaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX2\r"+\
		"9/j5+hEAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKR\r"+\
		"obHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RV\r"+\
		"VldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaan\r"+\
		"qKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3\r"+\
		"+Pn6/8AAEQgAoQDQAwEiAAIRAQMRAf/aAAwDAQACEQMRAD8A9n8iL/nkn/fI\r"+\
		"rKXUHHiRtIk06FIDaG5iuVlyz4ZVKlNvy8sMHcc46VsVmvpszeIodTDJ5KWU\r"+\
		"luVyd25nRgemMYU9/T8ADV0W3gl1O9SSGN1SCAqrKCFJaXJA7fdH5D0rc/s+\r"+\
		"z/59IPT/AFS/4VkaF/yFr/8A697f/wBCmrfoAr/2fZf8+kH/AH6X/Cj7BZ5z\r"+\
		"9kgz/wBcx/hViigCv/Z9l/z6Qf8Afpf8KP7Psv8An0g/79L/AIVYooAr/wBn\r"+\
		"2X/PpB/36X/Cj+z7L/n0g/79L/hViigCv/Z9l/z6Qf8Afpf8KP7Psv8An0g/\r"+\
		"79L/AIVYooAr/wBn2X/PpB/36X/Cj+z7L/n0g/79L/hViigCv/Z9l/z6Qf8A\r"+\
		"fpf8KP7Psv8An0g/79L/AIVYooAr/wBn2X/PpB/36X/Cj+z7L/n0g/79L/hV\r"+\
		"iigCv/Z9l/z6Qf8Afpf8KP7Psv8An0g/79L/AIVYooAr/wBn2X/PpB/36X/C\r"+\
		"j+z7L/n0g/79L/hViigCv/Z9l/z6Qf8Afpf8KP7Psv8An0g/79L/AIVYooAr\r"+\
		"/wBn2X/PpB/36X/Cj+z7L/n0g/79L/hViigDmKwr/Xb7TtYsLSaytmtb+5Nv\r"+\
		"CY7ljccIWL+XsxtBBz83Awep21u1y1hp/iG1127vp9N0q5+0zlBetqMglitQ\r"+\
		"3yIsfkEDC8ld+GYkk+gB2Ohf8ha//wCveD/0Kat+sDQv+Qtf/wDXvb/+hTVv\r"+\
		"0AFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQ\r"+\
		"BzFYT6/cx6/baSbW1kE8jgiK83TwRhGYSyR7MKhKhc7urp1LYG7XO3mj6hqG\r"+\
		"t2N3LbWEK2Ny0iX0MrfaGi2sBHt2YAO7DfOQQMgZI2gHVaF/yFr/AP694P8A\r"+\
		"0Kat+sDQv+Qtf/8AXvb/APoU1b9ABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFA\r"+\
		"BRRRQAUUUUAFFFFABRRRQAUUUUAcxWJeeJUt/EOnaNDbGcXMzQXFwHAW2fyJ\r"+\
		"JkUjHzMyxH5RjaGUn7y5265a98EWj6ppd7YtPbi31SS/ul+33GHLxTAlU3FQ\r"+\
		"TJIpOABt3DpwQDsdC/5C1/8A9e8H/oU1b9YGhf8AIWv/APr3t/8A0Kat+gAo\r"+\
		"oooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAOYr\r"+\
		"n7XxHcXviG+0iC10/ZYyrHKz6kRcYMaPuEAiPHzgcuOh+ldBXO6ppGo6tq2n\r"+\
		"PNbWCWtheC5jvEmf7QFCn5QmzA3E7W+fBXPGThQDqtC/5C1//wBe8H/oU1b9\r"+\
		"YGhf8ha//wCve3/9CmrfoAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAC\r"+\
		"iiigAooooAKKKKACiiigDmK5+08Sy6hq0tpawWf2eOd4A017snlKHEjJFsO5\r"+\
		"VYMvLDJVugA3dBXFf8IXPBqMgtbbT1tZtZTVXvWdvtKEMHeMKEwdzBlzvHyS\r"+\
		"NxnqAd7oX/IWv/8Ar3g/9CmrfrA0L/kLX/8A172//oU1b9ABRRRQAUUUUAFF\r"+\
		"FFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAcxWBda3rVrq9pY\r"+\
		"HRrCSO7mYI8eqOZRCpG6Vo/s+BgFcjfjcyru5BrfrLstMnj13U9TuXjcTpFB\r"+\
		"aheTHEikkHjgmR3JxnICZPAAANzQv+Qtf/8AXvB/6FNW/WBoX/IWv/8Ar3t/\r"+\
		"/Qpq36ACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiig\r"+\
		"AooooA5iuU/4TRh4j/sf7Jb/APH39l8r7V/peNm7zvJ2/wCq/wBrd056/LXV\r"+\
		"1xx8L6ob4DZp5jGrf2h/ahkb7Xs37/L2bMfd/cZ3/wCr7fw0AdzoX/IWv/8A\r"+\
		"r3g/9CmrfrA0L/kLX/8A172//oU1b9ABRRRQAUUUUAFFFFABRRRQAUUUUAFF\r"+\
		"FFABRRRQAUUUUAFFFFABRRRQAUUUUAcxXLr4xdbqJp7KGLT59UfS4Zjc/vjK\r"+\
		"rMmTHtxguhxhiduGxyQvUVy194X/ALS1qG6l0jSLdY7uO5k1CHm6nEZ3RoR5\r"+\
		"Y2/ME3He3EYGORsAOx0L/kLX/wD17wf+hTVv1gaF/wAha/8A+ve3/wDQpq36\r"+\
		"ACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA\r"+\
		"4Matcf8ACSNpD2aLAbQ3MVyJss5DKrKU2/KMtwdxzjoKo/8ACUy7vtf2KP8A\r"+\
		"sn+0f7O+0faP3vmed9n3eXtxt875fvZ2/N7VoPpszeIodTDJ5KWUluVyd25n\r"+\
		"RgfTGFP6Vjf8I1qew6TmzXSP7V/tHzhI3ngfaPtPlCPZtx5ny53/AHO2aAO0\r"+\
		"0L/kLX//AF7wf+hTVv1gaF/yFr//AK97f/0Kat+gAooooAKKKKACiiigAooo\r"+\
		"oAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAPPV/h/D/2Whf4fw/9loX+\r"+\
		"H8P/AGWhf4fw/wDZaABf4fw/9loX+H8P/ZaF/h/D/wBloX+H8P8A2WgAX+H8\r"+\
		"P/ZaF/h/D/2Whf4fw/8AZaF/h/D/ANloAF/h/D/2Whf4fw/9loX+H8P/AGWh\r"+\
		"f4fw/wDZaABf4fw/9loX+H8P/ZaF/h/D/wBloX+H8P8A2WgAX+H8P/ZaF/h/\r"+\
		"D/2Whf4fw/8AZaF/h/D/ANloAF/h/D/2Whf4fw/9loX+H8P/AGWhf4fw/wDZ\r"+\
		"aABf4fw/9loX+H8P/ZaF/h/D/wBloX+H8P8A2WgAX+H8P/ZaF/h/D/2Whf4f\r"+\
		"w/8AZaF/h/D/ANloAF/h/D/2Whf4fw/9loX+H8P/AGWhf4fw/wDZaABf4fw/\r"+\
		"9loX+H8P/ZaF/h/D/wBloX+H8P8A2WgAX+H8P/ZaF/h/D/2Whf4fw/8AZaF/\r"+\
		"h/D/ANloAF/h/D/2Whf4fw/9loX+H8P/AGWhf4fw/wDZaAP/2Q==</scombrus>\r"+\
		"</M_4DPop>\r"
	
	$file.setText($t)
	$OK:=($file.getText()=$t)
	
End if 

return $OK  // True if installation succesfull