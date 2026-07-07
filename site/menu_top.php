<!DOCTYPE HTML PUBLIC "-//W3C//DTD.php 4.0 Transitional//EN">
<html><head><title>www.zxtunes.com</title>
<a name="begin"></a>
<meta name="keywords" content="chipmusic, spectrum music, remixes, music from games, music from demo, ym2149, ay-3-8910, ay-3-8912, articles, tutorials, beeper, zx-spectrum, spectrum, sinclair, speccy, спектрум, ремиксы, игры, музыка" />
<meta  name="description" content="zxtunes.com - all music of zx spectrum, music from games, music from artist, music from demo, remixes, beeper music, digital music, tracker music">
<META NAME="ROBOTS" content="ALL">
<link rel="icon" href="favicon.ico" type="image/x-icon">
<meta content="vyacheslav kalinin/newart - e-mail: vtcd@mail.ru" name="designer">
<meta content="vyacheslav kalinin/newart - e-mail: vtcd@mail.ru" name="author">
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<meta content="MSHTML 5.00.2614.3500" name="generator">
<SCRIPT language=javascript1.5 src="js/topmenu.js" type=text/javascript></SCRIPT>

<?php if ($tinymce) {
echo '<script type="text/javascript" src="js/tiny_mce/tiny_mce.js"></script>
<script language="javascript" type="text/javascript">



tinyMCE.init({
	mode : "textareas",
	theme : "advanced",

	theme_advanced_buttons1_add : "fontselect,fontsizeselect",

	theme_advanced_toolbar_location : "top",
	theme_advanced_toolbar_align : "left",
	theme_advanced_statusbar_location : "bottom",
	theme_advanced_resizing : true

});




</script>';
}
?>


</head>

<style type="text/css">

.big {font-size: 15px; font-weight: bold;}
.big2 {font-family: Arial; font-size: 17px !important;}
.titm {font-size: 13px !important;}
.time {font-size: 9px;}
.upd {font-size: 10px;}
.tx12 {font-size: 12px;}
.tx14 {font-size: 14px;}

.b14a{font-size: 14px; font-weight: bold; font-family: Arial;}
.b13a{font-size: 13px; font-weight: bold; font-family: Arial;}
.b12a{font-size: 12px; font-weight: bold; font-family: Arial;}
.b11a{font-size: 11px; font-weight: bold; font-family: Arial;}

.n14a{font-size: 14px; font-family: Arial;}
.n13a{font-size: 13px; font-family: Arial;}
.n12a{font-size: 12px; font-family: Arial;}
.n11a{font-size: 11px; font-family: Arial;}

.menu {
	BORDER-RIGHT: gray 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: gray 1px solid; PADDING-LEFT: 5px; Z-INDEX: 10; BACKGROUND: #f8f8f8; VISIBILITY: hidden; PADDING-BOTTOM: 5px; BORDER-LEFT: gray 1px solid; PADDING-TOP: 5px; BORDER-BOTTOM: gray 1px solid; POSITION: absolute
}
.content_title {font-weight: bold;}

html,body{margin:0;padding:0}

div#header h1{height:80px;line-height:80px;margin:0;
  padding-left:10px;background: #EEE;color: #79B30B}
div#content p{line-height:1.4}
div#navigation{background:#FFFFFF}
div#extra{background:#FFFFFF}
div#footer{background: #333;color: #FFF}
div#footer p{margin:0;padding:5px 10px}

div#wrapper{float:left;width:100%}
div#content{margin: 0 15%; height:700px; border-left: 1px solid black; border-right: 1px solid black}
div#navigation{float:left;width:15%;margin-left:-100%; height:700px; }
div#extra{float:left;width:15%;margin-left:-15%; height:700px;}
div#footer{clear:left;width:100%}

</style>

<body onclick="hidemenu()">

<?php
echo '<table><tr><td nowrarp align=left width=29%>
<img src="images/zxtunes.png" border=0></td><td width=29% align=center nowrap>
<a href="http://antiquetoy.untergrund.net/"><img src="images/atoy_banner2.gif" border=0></a></td><td width=29% align=right>
<img src="images/progress.png" border=0></td><td align="right"> &#160&#160&#160&#160 ';
if ($_SESSION['username']) {echo "Hello, <b>".h($_SESSION['username'])."</b>";}
else {echo '<a href="/login.php">Log in...</a>';}

echo '
</td></tr></table>
<table><tr>
<td class="titm">News</td>
<td>.</td> 
<td class="titm"><a href="/software_list.php" class="titm">Software</a></td>
<td>.</td>
<td class="titm">Hardware</td>
<td>.</td>
<td class="titm">Articles</td>
<td>.</td>
<td class="titm"><a href="/statistics.php" class="titm">Statistics</a></td>
<td>.</td>
<td class="titm">FAQ</td>
<td>.</td>
<td class="titm">Forum</td>
<td>.</td>
<td class="titm">Links</td>
<td>&nbsp&nbsp&nbsp:&nbsp&nbsp&nbsp</td>
<td class="titm"><a href="/authors_list.php" class="titm">Authors</a></td>
<td>.</td>
<td class="titm">Games</td>
<td>.</td>
<td class="titm">Demos</td>
<td>.</td>
<td class="titm">Press</td>
<td>.</td>
<td class="titm">Parties</td>
<td>.</td>
<td class="titm">Remixes</td>
<td>.</td>
<td class="titm">Digital</td>
<td>.</td>
<td class="titm">Beeper</td>
<td width=100% valign=down align=right>online: ';

$zp = mysqli_query($db,"SELECT * FROM online "); 
if (!$zp) {echo mysql_error();}
echo mysqli_num_rows($zp)."</td></tr></table>";

?>
