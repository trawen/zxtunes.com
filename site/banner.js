//document.write ("<div align=center style='width: 100%;'><a target='_blank' href='http://vkontakte.ru/event34200122'><img style='width: 850px;' border=0 src='http://privarus.ru/consol.png'></a></div><br>");

function youtube() {


var agb = document.getElementsByTagName("a");

var num = agb.length;
  
var goths_banner = [];
var n = 0;
for(var i = 0; i < num; i++) {
  
	var a = agb[i].href;

	var ur = a.substring(0,16);
	var zxt = a.substring(0,32);
	var ad = a.substring(16);							
							
	if (ur.toLowerCase() == "http://youtu.be/" && agb[i].innerHTML == "youtube" ) {

		agb[i].innerHTML = "<iframe width='640' height='480' src='http://www.youtube.com/embed/"+ad+"?hd=2' frameborder='0' allowfullscreen></iframe>";
	
	}
	else if (zxt.toLowerCase() == "/embed.php?id=") {
	
		zxt = a.split('=');
		if (zxt) {
		
			agb[i].innerHTML = "<iframe width='630' src='"+a+"' frameborder='0' allowfullscreen></iframe>";
		
		}
	
	}
	
}

}

youtube();