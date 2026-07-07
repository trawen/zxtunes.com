// WWW.ZXTUNES.COM JS-FLASH PLAYER v1.0 - stupid code by Newart / n-Discovery (C) 31.01.2010

var author_name = "";
var pl = new Array();
var pl = [];
var cm = new Array();
var cm = [];
var id_comment = 0;
var rt = new Array();
var rt = [];
var start_time = 0;
var last_track = 0;
var id_thanks = 0;
var loop = 0;
var tht =  new Array();
var volume = 1.0;
var settings = " 1 0 1 0 0";
var rnd = new Array();
var nm_rnd = 0;

tht[0] = "Thank you!";
tht[1] = "Speccy rulez!";
tht[2] = "Spectrum alive!";
tht[3] = "8-bit never die!";

$(document).ready(init);

function init()
{

	var s = getCookie('settings');
	if (s) {settings = s;} else {settings = " 1 0 1 0 0";}
	s = getCookie('volume');
	if (s) {volume = s;} else {volume = 1.0;}
	

	
	rnd[0] = first_track;
	while (1) {
	
	   var nt = $('#n'+rnd[nm_rnd]).text();
	   nm_rnd = nm_rnd + 1; 
	   if (nt == rnd[0]) {break;}
	   else {rnd[nm_rnd] = nt;}		
	   
	}
	
	if (autoplay > 0) {PlayB(autoplay);}
	
	
}



function getCookie(name) {
	var cookie = " " + document.cookie;
	var search = " " + name + "=";
	var setStr = null;
	var offset = 0;
	var end = 0;
	if (cookie.length > 0) {
		offset = cookie.indexOf(search);
		if (offset != -1) {
			offset += search.length;
			end = cookie.indexOf(";", offset)
			if (end == -1) {
				end = cookie.length;
			}
			setStr = unescape(cookie.substring(offset, end));
		}
	}
	return(setStr);
}

function setCookie (name, value, expires, path, domain, secure) {
      document.cookie = name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

function InsertHtmlPlayer(nt) {

	$('#pl'+nt).html("<div style='width: 380px; border-left: 28px solid white; background-color: white;'><div id='player'><p>Please, install Adobe Flash Player 10 and enable JavaScript</p><p><a href='http://www.adobe.com/go/getflashplayer'><img src='http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a></p></div></div>");

}


function InsertPlayer(tr, au) {

  var params = {

	allowScriptAccess:"sameDomain", 
	allowFullScreen:"false", 
	track1:"fym2/"+au+"/"+tr+".fym",
	volume:""+volume,
	autostart:"true",
	mixer:"YM ABC",
	movie:"player41.swf",
	quality:"high", 
	bgcolor:"#ffffff",
	loop:""+loop

  }
  swfobject.embedSWF("css/player41.swf", "player", "345", "13", "10.0", "expressInstall.swf", params, {bgcolor:params.background} );


}




function Warning() {

	alert("Warning!");
	return 2

}

function getMovie() {

    var M$ =  navigator.appName.indexOf("Microsoft")!=-1;
	return (M$ ? window : document)["player"];
}

function BridgeMovie_DoFSCommand(command, args) {
	window[command].call(null, args);
}

if (navigator.appName && navigator.appName.indexOf("Microsoft") != -1 && navigator.userAgent.indexOf("Windows") != -1) {
        document.write('<script language=\"VBScript\"\>\n');
        document.write('On Error Resume Next\n');
        document.write('Sub BridgeMovie_FSCommand(ByVal command, ByVal args)\n');
        document.write('        Call BridgeMovie_DoFSCommand(command, args)\n');
        document.write('End Sub\n');
        document.write('</script\>\n');
}


function selectText(){
       var oTextBox = document.getElementById('autoplay');
       oTextBox.focus();
       oTextBox.select();
}


function getParams(par) {

		sett = par.split(' ');
				
		$("#chip").get(0).selectedIndex = sett[0];
		$("#mixer").get(0).selectedIndex = sett[1];
		$("#quality").get(0).selectedIndex = sett[2];
		$("#stereo").get(0).selectedIndex = sett[3];
		$("#bass").get(0).selectedIndex = sett[4];
		
		 var pos = $("#player").position();

		$('#boxes').css('top',  pos.top-150);
		$('#boxes').css('left', pos.left+380);
   
		$('#autoplay').val("/author.php?id="+author_id+"&play="+last_track+"&page=all");	
   
		$('#boxes').show(); 

			
};


function Rate(id) {
	
	
		if ($('#r'+id).hasClass('rating')) {
			
			id_thanks = id;
			$('#r'+id).removeClass('rating');
			$('#r'+id).addClass('r_off');
			var rating = $('#rn'+id).text();
		
			author_id = $('#a'+id).text();
			rating = parseInt(rating) + 1;
			$('#rn'+id).text(rating);
			$.post('playing_up.php', {type: "test-request", id: id, id_author: author_id, type: 1}, OpenThanks);
			setCookie("rt"+id, "1", "Mon, 01-Jan-2011 00:00:00 GMT", "/");
		
		}
	
}

function InsertComment(data) {

  $('#c'+id_comment).html(data);

}

function Comm(id) {
		
	if (cm[id]) {
		
		$('#c'+id).hide();
		
		cm[id] = 0;
		id_comment = id;
				
	}
	else {
	
		$('#c'+id).show();
		
		cm[id] = 1;
		id_comment = id;

		$.post('get_comments.php', {type: "test-request", id: id}, InsertComment);
	
	}
		
}

function OpenThanks() {

	//alert(data);

   var pos = $("#r"+id_thanks).position();

   $('#thanks1').css('top',  pos.top-40);
   $('#thanks1').css('left', pos.left-16);
	
   var r = Math.floor(Math.random()*3)
	
   $('#thanks2').text(tht[r]);	
	
   $('#thanks1').fadeIn(1, function () {setTimeout( function () {$('#thanks1').fadeOut(500);}, 2000)}); 
   
}



function AddComment(id) {
   
   var nick = $('#nick'+id).val();
   var email = $('#email'+id).val();
   var mess = $('#mess'+id).val();
   
   if (nick == '') {alert("Enter <Nick>");}
   if (mess == '') {alert("Enter <Message>");}
   
   
   
   if (nick) {
   
	$.post('get_comments.php', {type: "test-request", id: id, nick: nick, email: email, mess: mess, id_author: author_id}, InsertComment);
	
	var comments = $('#cm'+id).text();
	comments = parseInt(comments) + 1;
	$('#cm'+id).text(comments);
	  
	
   }
}

function NextTrack() {

	pl[last_track] = 0;
	
	if (loop == 3) {var new_track = $('#p'+last_track).text();}
	else if (loop == 0) {var new_track = $('#n'+last_track).text();}
	else if (loop == 2) {
	
		while (1) {
			
			var r = Math.floor(Math.random()*nm_rnd)
			
			if (rnd[r] != last_track) {var new_track = rnd[r]; break;}
	
		}
	}
	
	
	author_id = $('#a'+new_track).text();
	
	var title = author_name + " - " +  $('#f'+new_track).text() + " - " + $('#t'+new_track).text();
	document.title = title;
	
	$('#m'+last_track).removeClass('stop');
	$('#m'+last_track).addClass('play');
	$('#pl'+last_track).empty();
	
	InsertHtmlPlayer(new_track);
	
	last_track = new_track;
	InsertPlayer(new_track, author_id);
			
}


function PreviousTrack() {
	
	var new_track = $('#p'+last_track).text();
	var title = author_name + " - " + $('#f'+new_track).text() + " - " + $('#t'+new_track).text();
	document.title = title;
	
	play(new_track);
		
	return "fym2/"+author_id+"/"+last_track+".fym";
}



function close_window() {

	settings = " " + $("#chip").get(0).selectedIndex;
	settings = settings + " " + $("#mixer").get(0).selectedIndex;
	settings = settings + " " + $("#quality").get(0).selectedIndex;
	settings = settings + " " + $("#stereo").get(0).selectedIndex;
	settings = settings + " " + $("#bass").get(0).selectedIndex;
	
	$("#boxes").css('display', 'none');
	
	var movie = getMovie();
	movie.getParams(settings); 
	setCookie("settings", settings, "Mon, 01-Jan-2011 00:00:00 GMT", "/");
	
}

function PlayPause() {

	var movie = getMovie();
	movie.getParams(settings); 
		
	if (last_track == 0) {last_track = first_track;}
	play(last_track);
	
}

function Loop(lp) {

	loop = lp;
	//alert("fuck?");
	
}

function PlayB(nt) {

	var title = author_name + " - " + $('#f'+nt).text() + " - " + $('#t'+nt).text();
	document.title = title;
	
	
	
	//alert(nt + " / " + last_track);
	
	if (nt == last_track) {
		
		var movie = getMovie();
		
		if (pl[nt] == 1) {
		
			
			movie.Pause();
			play(nt);
		
		}
		else {
		
			movie.Start();
		
		}
				
	}
	else {
					
		author_id = $('#a'+nt).text();
					
		// UPDATE NUMBER OF PLAYING	
		var now = new Date();
		var play_time = now - start_time;
				
		if (pl[last_track] && play_time > 5000) { 
		
			var downloads = $('#dw'+last_track).text();
			downloads = parseInt(downloads) + 1;
			$('#dw'+last_track).text(downloads);
			$.post('playing_up.php', {id: last_track, id_author: author_id, type: 2});
						
		}	
		
		pl[last_track] = 0;	
		//alert("InsertPlayer");	
		// INSERT PLAYER	
		$('#m'+last_track).removeClass('stop');
		$('#m'+last_track).addClass('play');	
		$('#pl'+last_track).empty();
		InsertHtmlPlayer(nt);
		last_track = nt;
		InsertPlayer(nt, author_id);
				
	}
}




function ChangeVolume(vol) {

	volume = vol;
	//document.title = vol;

}

function on_h(id) {

	if (id != last_track) {
	
		//$('#s'+id).addClass('over_play');
	
	}

}

function off_h(id) {

	//$('#s'+id).removeClass('over_play');

}

function play(new_track) {
	
	if (pl[new_track] == 1) {
	
		pl[new_track] = 0;
		$('#m'+new_track).removeClass('stop');
		$('#m'+new_track).addClass('play');
					
	}
	else {
	
		pl[new_track] = 1;
		$('#m'+new_track).removeClass('play');
		$('#m'+new_track).addClass('stop');
			
	}
		
	last_track = new_track;
	start_time = new Date();
	
}


