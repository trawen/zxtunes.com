<!DOCTYPE html>
<html> 
<head> 
<link rel="shortcut icon" href="/favicon.ico"> 
<title>Full Tape Crack Pack</title> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 

{literal}
<style type="text/css">

body {color: #4F4; background-color: black; font: Bold 14px Verdana}
td {color: #4F4; font: Bold 14px Verdana}

.red {color: #F44}
.yel {color: #FF4}
.grn {color: #4F4}
.magn {color: #F4F}
.grey {color: #DDD}
.cian {color: #4FF}
.blue {color: #44F}


{/literal}

</style>


{literal}

<SCRIPT language=javascript src="js/jquery-1.5.2.min.js" type=text/javascript></script>

<script language="javascript">

function cover_center() {

	var p = $("#scroll");
		
	var winW = $(window).width();
	var winH = $(window).height();
	    
	var scrW = $("#cover_zoom").width();	
	var scrH = $("#cover_zoom").height();
    	
	
	if (scrW > winW) {
	
		var aspect = scrW/winW;
		scrW = winW;
		scrH = scrH / aspect;
				
	}
		
		
	if (scrH > winH) {
	
		var aspect = scrH/winH;
		scrH = winH; 
		scrW = scrW / aspect;
		
	}
	
	$("#cover_zoom").width(scrW);
	$("#cover_zoom").height(scrH);
	
	$("#X2").css('left', winW/2-scrW/2);
	$("#X2").css('top',  p.scrollTop() + (winH/2-scrH/2));
			
		
}

function img(name) {
	
	$("#X2").css('left', -5000);
	$("#X2").css('top',  -5000);
	
	$("#X2").html("<img id='cover_zoom' src='"+name+"' onLoad='cover_center()' border=0>");
	$("#X2").show();
	
}




</SCRIPT>

{/literal}

</head> 
<body id="scroll" style="background-image: url(img/made1.png)"> 

<table cellpadding=3><tr><td><img width=400 height=200 src="img/fulltape.jpg" border=0></td>
<td style="padding: 8px" align="center"><pre><div style="font: bold 27px Courier">Full Tape Crack Pack</div><span class="grey">________________________________________</span><p class="yel">Версии Игр и Софта найденные на кассетах</p></pre>

<p class="grn"><a class="cian" href="fulltape.php?go=releases">Релизы</a> › <a class="cian" href="fulltape.php?go=authors">Авторы</a> › <a class="cian" href="fulltape.php?go=covers">Обложки кассет</a> › <a class="cian" href="fulltape.php?go=logos">Логотипы подписей</a></p>

<p><a class="cian" href="fulltape.php?go=updates">Новинки</a> ‹ <a class="cian" href="fulltape.php?go=guest">Гостевая</a> ‹ <a class="cian" href="fulltape.php?go=faq">ЧаВО</a> ‹ <a class="cian" href="fulltape.php?go=info">Информация</a> ‹ <a class="cian" href="fulltape.php?go=about">О сайте</a> ‹ <a class="cian" href="hyperjump.php">
{if $check_login}Мой кабинет{else}Вход{/if}</a></p>

{if $check_login}
<br>
<p><span class="magn">Админка:</span> <a class="cian" href="fulltape_edit.php?mode=new_release"> Релизы</a> › <a class="cian" href="fulltape_edit.php?mode=new_release_title">Названия релизов</a> › <a class="cian" href="fulltape_edit.php?mode=new_author">Авторы</a> › <a class="cian" href="fulltape_edit.php?mode=new_cover">Обложки кассет</a></p>
{/if}



</td>
</tr>
</table>


<br>
<br>

