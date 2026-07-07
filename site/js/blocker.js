var playerId = "fymplayer";

window.blockVar = false;

blockScroll = function ()
{
	window.blockVar = true;
}

unBlockScroll = function ()
{
	window.blockVar = false;
}

checkScroll = function (event)
{
	if (window.blockVar)
	{
	if (!event)
	{
		event = window.event;
	}
	if (event.preventDefault)
	{
		event.preventDefault();
	}
	event.returnValue = false;
	}
}

get = function (id)
{
	return document.getElementById(id) || false;
}

window.onload = function ()
{
	if (get(playerId).addEventListener)
	get(playerId).addEventListener('DOMMouseScroll', checkScroll, false);
	get(playerId).onmousewheel = checkScroll;
}


function setCookie (name, value, expires, path, domain, secure) {
      document.cookie = name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
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


function showTooltip()
{

var myDiv = document.getElementById('tooltip');
var tp1 = document.getElementById('tp1');
var tp2 = document.getElementById('tp2');

if (myDiv.style.display == 'none')
{

myDiv.style.display = 'block';
tp2.style.display = 'block';
tp1.style.display = 'none';
setCookie("fym_hidden", "block", "Mon, 01-Jan-2011 00:00:00 GMT", "/");

} else {
myDiv.style.display = 'none';
tp1.style.display = 'block';
tp2.style.display = 'none';
setCookie("fym_hidden", "none", "Mon, 01-Jan-2011 00:00:00 GMT", "/");

}
return false;
}