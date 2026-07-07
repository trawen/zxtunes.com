var shownelementid="";
var lasthiddenid="";
function hidemenu ()
{
    if (shownelementid != "") {
        document.getElementById(shownelementid).style.visibility="hidden";
    }
    lasthiddenid = shownelementid;
    shownelementid = "";
}

function showmenu (menuid)
{
    // if we've only just hidden the element, don't re-show it
    if (lasthiddenid != menuid) {
        document.getElementById(menuid).style.visibility="visible";
        shownelementid=menuid;
    }
}

function posaft(t) {
	var q = t.mypop.style;
	var x = 0;
	var y = t.offsetHeight;
	while (t) {
		x += t.offsetLeft;
		y += t.offsetTop;
		t = t.offsetParent;
	}
	q.left = x + 'px';
	q.top  = y + 'px';
}

function showpop() {
	var q = this.mypop.style;
	if (q.visibility != 'visible') {
		posaft(this);
		q.visibility = 'visible';
	} else {
		q.visibility = 'hidden';
	}
}

function chpop() {
	for (i = 1; npop > i; i++) {
//		alert('resi');
		posaft(document.getElementById('grey' + i));
	}
}

function init() {
	for (i = 1; t = document.getElementById('grey' + i); i++) {
		t.onclick = showpop;
		t.mypop = document.getElementById('pop' + i);
	}
	onresize = chpop;
	npop = i;
}

onload = init;