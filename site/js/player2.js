var pl = new Array();
var pl = [];
var cm = new Array();
var cm = [];
var id_comment = 0;
var rt = new Array();
var rt = [];
var start_time = 0;
var author_id = 0;
var last_track = 0;
var id_thanks = 0;


function getMovie() {
        var M$ =  navigator.appName.indexOf("Microsoft")!=-1
	return (M$ ? window : document)["player"]
}


/* movie name_DoFSCommand */
function BridgeMovie_DoFSCommand(command, args) {
	window[command].call(null, args)
}


// Hook for Internet Explorer.
if (navigator.appName && navigator.appName.indexOf("Microsoft") != -1 && navigator.userAgent.indexOf("Windows") != -1) {
        document.write('<script language=\"VBScript\"\>\n');
        document.write('On Error Resume Next\n');
        document.write('Sub BridgeMovie_FSCommand(ByVal command, ByVal args)\n');
        document.write('        Call BridgeMovie_DoFSCommand(command, args)\n');
        document.write('End Sub\n');
        document.write('</script\>\n');
}


function getParams(par) {

		sett = par.split(' ');
				
		$("#chip").get(0).selectedIndex = sett[0];
		$("#mixer").get(0).selectedIndex = sett[1];
		$("#quality").get(0).selectedIndex = sett[2];
		$("#stereo").get(0).selectedIndex = sett[3];
		$("#bass").get(0).selectedIndex = sett[4];
		$("#boxes").css('display', 'block');
			
};


function Rate(id) {
	
	if (!rt[id]) {
	
		$('#r'+id).removeClass('rating');
		$('#r'+id).addClass('r_off');
		var rating = $('#rn'+id).text();
		
		rating = parseInt(rating) + 1;
		$('#rn'+id).text(rating);
		rt[id] = 1;
		$.post('playing_up.php', {type: "test-request", param1: id, param2: 1}, onAjaxSuccess);
	
	}
}

function InsertComment(data) {
	
  //alert(data);
  //data = "shit!";
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

function onAjaxSuccess(data) {

   alert("Thank you! Speccy forever! ;)");

}

function AddComment(id) {
   
   //alert(id);
   
   var nick = $('#nick'+id).val();
   var email = $('#email'+id).val();
   var mess = $('#mess'+id).val();
   
   if (nick == '') {alert("Enter <Nick>");}
   if (mess == '') {alert("Enter <Message>");}
   
   
   
   if (nick) {
   
	$.post('get_comments.php', {type: "test-request", id: id, nick: nick, email: email, mess: mess}, InsertComment);
	
	var comments = $('#cm'+id).text();
	comments = parseInt(comments) + 1;
	$('#cm'+id).text(comments);
	  
	
   }
}

function NextTrack() {

	var new_track = $('#n'+last_track).text();
	var title = author_name + " - " +  $('#f'+last_track).text() + " - " + $('#t'+last_track).text();
	document.title = title;

	play(new_track);
	
	return "fym2/"+author_id+"/"+last_track+".fym";
	
}


function PreviousTrack() {
	
	var new_track = $('#p'+last_track).text();
	var title = author_name + " - " + $('#f'+new_track).text() + " - " + $('#t'+new_track).text();
	document.title = title;
	
	play(new_track);
		
	return "fym2/"+author_id+"/"+last_track+".fym";
}



function close_window() {

	var settings = "";
    
	settings = " " + $("#chip").get(0).selectedIndex;
	settings = settings + " " + $("#mixer").get(0).selectedIndex;
	settings = settings + " " + $("#quality").get(0).selectedIndex;
	settings = settings + " " + $("#stereo").get(0).selectedIndex;
	settings = settings + " " + $("#bass").get(0).selectedIndex;
	
	$("#boxes").css('display', 'none');
	
	var movie = getMovie();
	movie.getParams(settings); 
	
}

function PlayPause() {

	play(last_track);
	
}

function PlayB(nt) {
	
	//document.title = "prev -> stop: " + last_track + " -> play: "+ nt;
	var title = author_name + " - " + $('#f'+nt).text() + " - " + $('#t'+nt).text();
	document.title = title;
	
	$('#c'+nt).wrap($('#test'));
	$('#test').empty();
	
	play(nt);
	var movie = getMovie();
	movie.changePlayTrack("fym2/"+author_id+"/"+nt+".fym");
			
}

function on_h(id) {

	if (id != last_track) {
	
		$('#s'+id).addClass('over_play');
	
	}
	
	//alert("shit!");
}

function off_h(id) {

	$('#s'+id).removeClass('over_play');
//	alert("shit!");

}

function play(new_track) {
		
	if (last_track != new_track)	{
		$('#m'+last_track).removeClass('stop');
		$('#m'+last_track).addClass('play');	
				
		var now = new Date();
		var play_time = now - start_time;
				
		if (pl[last_track] && play_time > 5000) { 
		
			var downloads = $('#dw'+last_track).text();
			downloads = parseInt(downloads) + 1;
			$('#dw'+last_track).text(downloads);
			$.post('playing_up.php', {type: "test-request", param1: last_track, param2: 2});
			
		}
		
		pl[last_track] = 0;
		$('#s'+last_track).removeClass('on_play');
		
	
	}
	
	if (pl[new_track] == 1) {
	
		$('#m'+new_track).removeClass('stop');
		$('#m'+new_track).addClass('play');
		pl[new_track] = 0;
		pl[last_track] = 0;
		
	}
	else {
	
		$('#m'+new_track).removeClass('play');
		$('#m'+new_track).addClass('stop');
		pl[new_track] = 1;
		
	}
		
	last_track = new_track;
	$('#s'+last_track).removeClass('over_play');
	$('#s'+last_track).addClass('on_play');
	start_time = new Date();
	
}