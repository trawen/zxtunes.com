{include file="menu.tpl"}

<script src="/css/jquery.js"></script>
<script src="/css/jquery.ui.core.min.js"></script>
<script src="/css/jquery.ui.widget.min.js"></script>
<script src="/css/jquery.ui.mouse.min.js"></script>
<script src="/css/jquery.ui.sortable.min.js"></script>
<script language="javascript">
var autoplay = "{$autoplay}";
var author_name = "{$author.nickname}";
var first_track = "{$playlist[0].id}";
var user_id = "{$user_id}";
var nm_files = 1;

{if $language eq 'rus'}
var spam = "<in"+"put type='submit' style='width: 120px' name='submit' value='Отправить'>";
{else}
var spam = "<in"+"put type='submit' style='width: 120px' name='submit' value='Submit'>";
{/if}


var group_list = "<option value='0'></option>{section name=n loop=$groups}<option value='{$groups[n].id}'>{$groups[n].name}</option>{/section}<option value='777'>- создать группу  -</option></select>";

var nm_group = {$nm_groups};

{literal}

function AddGroup () {

	if (nm_group == 4) {

		alert("Хватит! Stop!");
	
	}
	else {
	
		nm_group = nm_group + 1;
	
		$("#groups").append("<select style='width: 210px' onchange='NewGroup("+nm_group+")' id='group_"+nm_group+"' name='group_"+nm_group+"'>"+group_list);
		
		$("#groups").append("&nbsp;<span class='dwns'>ex<input type='checkbox' style='border: 1px solid #ccc;' name='ex_"+nm_group+"'></span><br>");
	
	}

}

function NewGroup(nm) {

	var id = $("#group_"+nm+" option:selected").val();
	
	if (id == "777") {
	
		var name = prompt("Введите название новой группы:", "");
		
		if (name == null || !name) {
			
			$("#group_"+nm+" :first").attr("selected", "selected");
		
		}
		else{
		
			$("#group_"+nm).append( "<option value='"+name+"' selected='selected'>"+name+"</option>" );
		
		}
	
	}
	
}

function noSpam() {

	$("#spam").html(spam);

}

function FixProfileHeight() {

	var ph = $("#author_photo").height();
	var pr = $("#author_info").height();

	if (ph > pr) { $("#author_photo").height(pr); }
	noSpam();
	
}

function validateEmpty() {

	var n = validateEmpty.arguments.length;
	var args = validateEmpty.arguments;
	for(var i=0;i<n;i++) {
	
		if(document.getElementById(args[i]).value != 0 ) {
			
			document.getElementById(args[i]).className = document.getElementById(args[i]).className.replace(" error", "");

		}	

		else {

			document.getElementById(args[i]).focus();
			document.getElementById(args[i]).className += " error";
{/literal}			
			{if $language eq 'rus'}
			
				alert("Пожалуйста заполните все поля! (e-mail не публикуется)");
			{else}
				alert("Please complete all fields! (e-mail no published)");
			{/if}
			
{literal}			
			return false;

		}
	}
	return true;
}

function die() {

	$("#die").html("<span class='au1'>дата смерти: </span><input type='text' style='border: 1px solid #ccc; width: 100px;' name='dead'>");
	
}

function AddFile() {

	$("#load_track").append("<br><input style='border: 1px solid #ccc; width: 220px' type='file' name='file"+nm_files+"'>");
	nm_files = nm_files + 1;
	
}


</script> 
<script type="text/javascript" src="/css/player6.js"></script> 
{/literal}






<form method="post" enctype="multipart/form-data">
<input type="hidden" name="_csrf" value="{$csrf_token}">

<div style="font: bold 14px Verdana" class="playlist_box">
 &nbsp;{$author.nickname} → 
{if $mode eq "profile"} {if $language eq 'rus'}профиль{else}profile{/if} → {else}
<a href="/author_edit.php?id={$author.id}">{if $language eq 'rus'}профиль{else}profile{/if}</a> → 
{/if}

{if $mode eq "music"} {if $language eq 'rus'}музыка{else}music{/if} →  {else}
<a href="/author_edit.php?id={$author.id}&md=music">{if $language eq 'rus'}музыка{else}music{/if}</a> → 
{/if}

<!--
{if $mode eq "playlist"} {if $language eq 'rus'}плей листы{else}playlists{/if} →  {else}
<a href="/author_edit.php?id={$author.id}&md=playlist">{if $language eq 'rus'}плей листы{else}playlists{/if}</a> → 
{/if}
-->

{if $mode eq "tags"} {if $language eq 'rus'}теги{else}tags{/if} →  {else}
<a href="/author_edit.php?id={$author.id}&md=tags">{if $language eq 'rus'}теги{else}tags{/if}</a> → 
{/if}

{if $mode eq "interview"} {if $language eq 'rus'}интервью{else}interviews{/if} →  {else}
<a href="/author_edit.php?id={$author.id}&md=interview">{if $language eq 'rus'}интервью{else}interviews{/if}</a> → 
{/if}

{if $mode eq "guest"} {if $language eq 'rus'}гостевая{else}guestbook{/if} {else}
<a href="/author_edit.php?id={$author.id}&md=guest">{if $language eq 'rus'}гостевая{else}guestbook{/if}</a>
{/if}
</div>

<br><br>
 
 
{if $mode eq "profile"} 
 
<table width=100% border=0>
<tr>


<td rowspan=4 vAlign=top align=center width=1% style="padding-right: 32px">

<div>
<img alt="{$title}" title="{$title}" onload="FixProfileHeight()" id="author_photo" class="{if $author.dead}photo_dead{else}photo{/if}" src="/{if $author.photo}photo/{$author.id}.jpg{else}css/wanted.png{/if}">
</div>

<br>

<div><input style="border: 1px solid #ccc; width: 220px" type="file" name="photo"></div>


<br><br><br>

{if $author.locked eq "" or $author.locked eq $user.login or $user.acess eq 777}
<span class="dwns">{if $language eq 'rus'}заблокировать доступ{else}lock{/if}</span> 
<input type="checkbox" style="border: 1px solid #ccc; height: 12px; vertical-align: middle" name="locked" {if $author.locked}checked{/if}>

<br><br><br>

<input type="submit" name="submit" value="Сохранить" style="width: 100px">

{else}

<span class="dwns">
<a class=m href="/user.php?name={$author.lock}">{$author.locked}</a> {if $language eq 'rus'} заблокировал изменения{else}blocked the changes{/if}
</span>

{/if}






</td>














<td rowspan=4 vAlign=top align=left><div id="author_info">

<span class="au1">{if $language eq 'rus'}ник:{else}nick:{/if} &nbsp;</span> <input  style="border: 1px solid #ccc; width: 270px; font: bold 14px Verdana" name="nickname" value="{$author.nickname}"> 
 &nbsp; &nbsp; &nbsp;

<br><br>

 
{if $language eq 'rus'}<span class="au1">другие ники: </span>{else}<span class="au1">also known: </span>{/if}

<span class="au2"><input title="Через запятую" style="border: 1px solid #ccc; width: 210px;" name="also" value="{$author.also}"></span>
<br>
<br>


<table cellpadding=0 cellspacing=0 border=0><tr>
<td valign=middle><span class="au1">{if $language eq 'rus'}имя: {else}name: {/if}</span>&nbsp; </td>

<td><span class="dwns">ru&nbsp; </span></td><td>
<input style="border: 1px solid #ccc; width: 100px;" name="first_name" value="{$author.first_name}"> &nbsp;
<input style="border: 1px solid #ccc; width: 150px;" name="last_name" value="{$author.last_name}">
</td>
</tr>

<tr><td></td>
<td><span class="dwns">en&nbsp; </span></td><td>
<input style="border: 1px solid #ccc; width: 100px;" name="first_name_en" value="{$author.first_name_en}"> &nbsp;
<input style="border: 1px solid #ccc; width: 150px;" name="last_name_en" value="{$author.last_name_en}">
</div>
		
</td>
</tr>	
</table>

<br>
<br>
<br>



<table cellpadding=0 cellspacing=0><tr>

<td valign=top>
<span style="padding-top: 6px" class="au1">{if $language eq 'rus'}группа: {else}group: {/if}</span>&nbsp;</td>

<td id="groups">
{if $author_groups}
{section name=x loop=$author_groups}


<select style="width: 210px" id="group_{$author_groups[x].nm}" name="group_{$author_groups[x].nm}" onchange="NewGroup({$author_groups[x].nm})">
<option value="0"></option>
{section name=n loop=$groups}
<option value="{$groups[n].id}" {if $author_groups[x].group_id eq $groups[n].id}selected{/if}>{$groups[n].name}</option>
{/section}
<option value="777">- создать группу -</option>
</select>

<span class="dwns">
ex <input type="checkbox" style="border: 1px solid #ccc;" name="ex_{$author_groups[x].nm}" {if $author_groups[x].status}checked{/if}>
</span> &nbsp; {if $author_groups[x].nm eq 0}<input type="button" value="+" onclick="AddGroup()">{/if}<br>

<input type="hidden" name="old_group{$author_groups[x].nm}" value="{$author_groups[x].id}">

{/section}


{else}


<select style="width: 210px" id="group_0" name="group_0" onchange="NewGroup(0)">
<option value="0"></option>
{section name=n loop=$groups}
<option value="{$groups[n].id}">{$groups[n].name}</option>
{/section}
<option value="777">- создать группу -</option>
</select>

<span class="dwns"> ex<input type="checkbox" style="border: 1px solid #ccc;" name="ex_0"></span> &nbsp; <input type="button" value="+" onclick="AddGroup()" style="font: normal 11px Arial"><br>


{/if}
</td>
</tr>
</table>



<br>
<br>



<span class="au1">
{if $language eq 'rus'}расположение: {else}location: {/if}&nbsp;</span>

<select style="width: 100px" name="city">
{section name=n loop=$cityes}
<option value="{$cityes[n].city}" {if $author.city eq $cityes[n].city}selected{/if}>{$cityes[n].city}</option>
{/section}
</select>

<select style="width: 90px" name="country">
{section name=n loop=$countries}
<option value="{$countries[n].country}" {if $author.country eq $countries[n].country}selected{/if}>{$countries[n].country}</option>
{/section}
</select>

</span>
<br>
<br>
<br>



<div>
<span class="au1">{if $language eq 'rus'}специализация: {else}specialization: {/if}</span>
<span class="au2"><input title="Через запятую" style="border: 1px solid #ccc; width: 190px;" name="spec" value="{$author.spec}"></span>
</div>



<br>
<br>



<div>
<span class="au1">{if $language eq 'rus'}активность: {else}activity: {/if}</span>
<span class="au2">
<input style="border: 1px solid #ccc; width: 40px;" name="years_from" value="{$author.years_from}"> — 
<input style="border: 1px solid #ccc; width: 40px;" name="years_to" value="{$author.years_to}">
</span> 
{if $author.dead eq ""}<span class="dwns">&nbsp; &nbsp; RIP<input type="checkbox" style="border: 1px solid #ccc; height: 12px; vertical-align: middle" onclick="die()"></span>{/if}
</div>

<br>

{if $author.dead}<span class='au1'>{if $language eq 'rus'}дата смерти:{else}date of death:{/if} </span><input style='border: 1px solid #ccc; width: 100px;' name='dead' value="{$author.dead}"><br>{else}<div id="die"></div>{/if}


<br>





<table>
<tr>
<td><span class="au1">e-mail: </span></td>
<td><span class="au2"><input style="border: 1px solid #ccc; width: 130px;" name="email" value="{$author.email}"></span>
<span class="dwns">&nbsp; скрыть<input type="checkbox" style="border: 1px solid #ccc; height: 12px; vertical-align: middle" name="hide_email"></span>
</td>
</tr>


<tr>
<td><span class="au1">icq:</span></td>
<td><span class="au2"><input style="border: 1px solid #ccc; width: 130px;" name="icq" value="{$author.icq}"></span>
<span class="dwns">&nbsp; скрыть<input type="checkbox" style="border: 1px solid #ccc; height: 12px; vertical-align: middle" name="icq_email"></span>
</td>
</tr>


<tr>
<td><span class="au1">{if $language eq 'rus'}сайт: {else}site: {/if}</span></td>
<td><span class="au2"><input style="border: 1px solid #ccc; width: 130px;" name="site" value="{$author.site}"></span></td>
</tr>

</table>

<br><br>



</div>
</td>
</tr>


</table>
</form>





{elseif $mode eq "music"}

{include file="flash.tpl"}	
	




	


<br>






<div style="padding-left: 12px">
<table width=690 border=0><tr><td valign=top class="au1" style="padding-top: 8px">Загрузить треки: </td>
<td id="load_track" width=260>
<input style="border: 1px solid #ccc; width: 220px" type="file" name="file0"> &nbsp; 
<input type="button" value="+" onclick="AddFile()">
</td>
<td valign=top align=left>
 &nbsp; <input style="width: 80px" type="submit" name="submit" value="Сохранить"></td>


<td align="right">

<span class="au2">
{if $szip}<a class="m" title="{$author.nickname} music" alt="{$author.nickname} music" href="/downloads.php?id={$author.id}&md=author">{$author.nickname}.zip</a> ({$szip}Kb)
{else}—{/if}</span>


</td></tr></table>
</div>





<br><br>


<table style="padding-left: 14px; padding-top: 8px" border=0 cellpadding=0 cellspacing=0>

{section name=n loop=$playlist}

<tr style="padding: 0; margin: 0; color: #888" id="s{$playlist[n].id}"><tr><td></td>




<td width="26" align="center">
{if $playlist[n].fym eq 0}
<div id="m{$playlist[n].id}" class="play" onclick="PlayB('{$playlist[n].id}')"></div>
{elseif $playlist[n].fym eq 1}
<div class="fym_wait"></div>
{else}
<div class="fym_none"></div>
{/if}


<div id="n{$playlist[n].id}" style="display: none">{$playlist[n].next_id}</div>
<div id="p{$playlist[n].id}" style="display: none">{$playlist[n].prev_id}</div>
<div id="a{$playlist[n].id}" style="display: none">{$author.id}</div>
</td>

<td id="f{$playlist[n].id}">
<a href='downloads.php?id={$playlist[n].id}'><img src="/images/download.ico"></a> &nbsp; 

<input style="border: 1px solid #ddd; width: 110px;" name="filename_{$playlist[n].id}" value="{$playlist[n].filename}" onchange="iChange({$playlist[n].id})"> &nbsp; 

<input style="border: 1px solid #ddd; width: 400px;" name="name_{$playlist[n].id}" value="{$playlist[n].name}" onchange="iChange({$playlist[n].id})"> &nbsp; 

<input style="border: 1px solid #ddd; width: 40px;" name="year_{$playlist[n].id}" value="{$playlist[n].year}" onchange="iChange({$playlist[n].id})"> &nbsp; 

</td>





<td id="t{$playlist[n].id}">
<input style="border: 1px solid #ddd; width: 40px;" name="time_{$playlist[n].id}" value="{$playlist[n].time}" onchange="iChange({$playlist[n].id})">
</td>



<td style="width: 16px; padding-left: 4px" style="border: 1px solid #ddd;">
<select name="format_{$playlist[n].id}" onchange="iChange({$playlist[n].id})">
<option value="0" {if $playlist[n].format eq 0}selected{/if}>AY</option>
<option value="1" {if $playlist[n].format eq 1}selected{/if}>Beeper</option>
<option value="2" {if $playlist[n].format eq 2}selected{/if}>TS</option>
<option value="3" {if $playlist[n].format eq 3}selected{/if}>Digital</option>
</select>
</td>

<td>
<div type="button" style="background:url(/css/icon_options.gif); width: 18px; height: 18px; cursor: pointer;"onclick="ToolsButton(this, {$playlist[n].id})"></div>
<input name="wait_{$playlist[n].id}" value="{$playlist[n].fym}" id="wait_{$playlist[n].id}" type="hidden">
</td>

<!--<td style="color: #888; font: normal 9px Tahoma"> &nbsp;{$playlist[n].date}</td>-->

</tr>




<tr>
<td></td><td></td>
<td colspan=3 id="pl{$playlist[n].id}" style="margin-left: 32px; height: 17px; background-image: url(/line.png);  background-repeat: repeat-x">
</td>

</tr>
{/section}

<tr><td colspan=10 align=center>

<input type=submit name="submit" value="Сохранить" style="width: 100px">

</tr></tr>

</table>
	  
<input type="text" id="changes" name="changes">
	  
</form>
	  
	  
	  
	  








{elseif $mode eq "playlist"}

{include file="flash.tpl"}	







<span class="au1">Создать плейлист:

<select>
<option value=0>Подборка треков</option>
<option value=1>Альбом</option>
</select>

Название: <input style="border: 1px solid #ddd; width: 100px;" name="name">

</span>

<br><br>

<table><tr><td valign=top>

<div id="playlist1" class="connectedSortable" style="width: 320px">
{section name=n loop=$playlist}

<div id="s_{$playlist[n].id}">
<div style="width: 320px; border: 0px solid black; height: 20px">

<div style="width: 26px; float: left; height: 22px" align="center">
<div id="m{$playlist[n].id}" class="play" onclick="PlayB('{$playlist[n].id}')"></div>
<div id="n{$playlist[n].id}" style="display: none">{$playlist[n].next_id}</div>
<div id="p{$playlist[n].id}" style="display: none">{$playlist[n].prev_id}</div>
<div id="a{$playlist[n].id}" style="display: none">{$author.id}</div>
</div>

<div id="f{$playlist[n].id}" style="white-space: nowrap; height: 20px; color: black; width: 250px; overflow: hidden; float: left">
        <div class="long_link_box">
            <div class="long_link">
    <a class='m' href='downloads.php?id={$playlist[n].id}'>{$playlist[n].filename}</a>
{if $playlist[n].name} - {/if}{$playlist[n].name}
            </div>
            <div class="long_link_hidder">&nbsp;</div>
        </div>
</div>


<div id="t{$playlist[n].id}" style="padding-left: 8px; float: left; height: 20px; color: #777; font: normal 10px Arial; width: 32px">{$playlist[n].time}</div>

</div>

<div id="pl{$playlist[n].id}" class="play_line" style="margin-left: 29px; width: 250px"></div>
</div>
{/section}
</div>

</td>
<td width=20> &nbsp;</td><td style="width: 1px; background: #ddd; padding: 0px; margin:0px"><td width=20> &nbsp;</td>

<td valign=top>


<div id="playlist2" class="connectedSortable" >
<div style="width: 320px; height: 32px; border: 0px solid #ccc"></div>
</div>


</td></tr></table>


<br><br>


<input type="text" size="70" id="test-log" />






{elseif $mode eq "tags"}

{include file="flash.tpl"}	









<div style="padding: 16px">
{section name=n loop=$playlist}

<div id="s_{$playlist[n].id}">
<div style="height: 22px;">

<div style="width: 50px; height: 22px; float: left; font: bold 12px Verdana">{$playlist[n].print_year}</div>

<div style="width: 26px; float: left; height: 22px" align="center">
<div id="m{$playlist[n].id}" class="play" onclick="PlayB('{$playlist[n].id}')"></div>
<div id="n{$playlist[n].id}" style="display: none">{$playlist[n].next_id}</div>
<div id="p{$playlist[n].id}" style="display: none">{$playlist[n].prev_id}</div>
<div id="a{$playlist[n].id}" style="display: none">{$author.id}</div>
</div>

<div id="f{$playlist[n].id}" style="white-space: nowrap; height: 22px; color: black; width: 450px; overflow: hidden; float: left">
        <div class="long_link_box">
            <div class="long_link">
    <a class='m' href='downloads.php?id={$playlist[n].id}'>{$playlist[n].filename}</a>
{if $playlist[n].name} - {/if}{$playlist[n].name}
            </div>
            <div class="long_link_hidder">&nbsp;</div>
        </div>
</div>


<div id="t{$playlist[n].id}" style="padding-left: 8px; float: left; height: 22px; color: #777; font: normal 10px Arial; width: 32px">{$playlist[n].time}</div>


<div style="float: left; height: 22px;"><input style="font: normal 9px Arial; padding: 0px 2px 0px 2px;" type="button" value="+" class="AddTagButton" onclick="AddTagButton(this, {$playlist[n].id})"></div>

</div>

<div class="tags" id="tgs_{$playlist[n].id}" style="padding-left: 80">{$playlist[n].tags}</div>



<div id="pl{$playlist[n].id}" class="play_line" style="width: 450px"></div>
</div>
{/section}
</div>


</form>

















{/if}


	  

      	  
{include file="right_strip.tpl"}
{include file="footer.tpl"}

{literal}
<div id="player_full" style="position: fixed; left: 32px; top: 600px; border: 8px solid black; border-radius: 3px; opacity: 1; background: black; color: white; display: none">

<table style="font: normal 15px Arial">
<tr>
<td style="display: inline-block; width: 100px">
 
 
 
<div id="full_play" style="border: 1px solid black; width: 8px; height: 10px; background-image: url(/css/full_play.png?i=2); background-position: -8px 0px; opacity: 1; cursor: pointer; float: left;" onmouseover="$(this).css('opacity', '1')" onmouseout="$(this).css('opacity', '1')" onclick="PlayFull()"></div>

<div style="width: 6px; height: 10px; float: left;"></div>
 
<div id="full_prev" style="border: 1px solid black; width: 10px; height: 10px; background-image: url(/css/full_play.png); background-position: -16px 0px; opacity: 0.7; cursor: pointer; float: left;" onmouseover="$(this).css('opacity', '1')" onmouseout="$(this).css('opacity', '0.7')" onclick="PreviousTrack()"></div>

<div style="width: 6px; height: 10px; float: left;"></div>

<div id="full_repeat" style="border: 1px solid black; width: 13px; height: 11px; background-image: url(/css/full_play.png); background-position: -26px 0px; opacity: 0.7; float: left;" onmouseover="$(this).css('opacity', '0.8')" onmouseout="$(this).css('opacity', '0.7')"></div>

<div style="width: 6px; height: 10px; float: left;"></div>

<div id="full_next" style="border: 1px solid black; width: 10px; height: 10px; background-image: url(/css/full_play.png);  background-position: -41px 0px; opacity: 0.7; cursor: pointer; float: left;" onmouseover="$(this).css('opacity', '1')" onmouseout="$(this).css('opacity', '0.7')" onclick="NextTrack()"></div>


<div style="width: 6px; height: 10px; float: left;"></div>

<div id="full_add" style="border: 1px solid black; width: 13px; height: 11px; background-image: url(/css/full_play.png?c=65);  background-position: -52px 0px; opacity: 0.7; cursor: pointer; float: left;" onmouseover="$(this).css('opacity', '1')" onmouseout="$(this).css('opacity', '0.7')" onclick="Add2Playlist()"></div>
  

</td>
<td id="player_full_name" style="padding-left: 12px; color: white; opacity: 1"></td>
<td id="player_full_time" style="padding-left: 16px; color: white; opacity: 1"></td>

<td style="padding-left: 32px">
<div id="social_suxx" class="soc_share"></div>
</td>

</tr>
</table>

</div>



<div id="tags" style="position: absolute; display: none;">
<div style="background:url(/css/arr.png);  ; background-repeat: no-repeat; padding-left: 8px; "><div style="border: 1px solid #ccc; padding: 16px; -webkit-border-radius: 3px; -moz-border-radius: 3px; border-radius: 3px; width: 150px; line-height: 20px; background: #FFF" align=center>


<div style="font: bold 12px Verdana">Добавить тег &nbsp; <span style='cursor: pointer;color:red' onclick="$('#tags').hide()">x</span></div><br>


<div id="ins_tags"></div>
<br>
<div><input type="button" value="новый" onclick="NewTag()"></div>

</div>

</div>
</div>



<div id="tools" style="position: absolute; display: none;">
<div style="background:url(/css/arr.png);  ; background-repeat: no-repeat; padding-left: 8px; "><div style="border: 1px solid #ccc; padding: 16px; -webkit-border-radius: 3px; -moz-border-radius: 3px; border-radius: 3px; width: 150px; line-height: 20px; background: #FFF" align=center>


<div style="font: bold 12px Verdana">Инструментарий &nbsp; <span style='cursor: pointer;color:red' onclick="$('#tools').hide()">x</span></div><br>


<span onclick="Compile()" style="cursor:pointer">Компилировать</span> &nbsp;  &nbsp; 


</div>

</div>
</div>






<script language="javascript">
{/literal}
	
	var insert_id = 0;
	var tags = "{section name=n loop=$tags}<span style='cursor: pointer' onclick='InsertTag("+q()+"{$tags[n].name}"+q()+","+q()+"{$tags[n].id}"+q()+")'>{$tags[n].name}</span> &nbsp; {/section}";

	
{literal}	
		 $("#playlist1, #playlist2").sortable({ 
			connectWith: ".connectedSortable", 
			update : function () { 
			$("input#test-log").val($('#playlist2').sortable('serialize')); 
			} 
		 }).disableSelection(); 
	
	
	
	
	
	function q () {return unescape("%22");}
	
	function strpos (haystack, needle, offset) {
		var i = (haystack+'').indexOf(needle, (offset || 0));
		return i;// === -1 ? false : i;
	}

	function str_replace (search, replace, subject, count) {

    var i = 0,
        j = 0,
        temp = '',
        repl = '',
        sl = 0,
        fl = 0,
        f = [].concat(search),
        r = [].concat(replace),
        s = subject,
        ra = Object.prototype.toString.call(r) === '[object Array]',
        sa = Object.prototype.toString.call(s) === '[object Array]';
    s = [].concat(s);
    if (count) {
        this.window[count] = 0;
    }
 
    for (i = 0, sl = s.length; i < sl; i++) {
        if (s[i] === '') {
            continue;
        }
        for (j = 0, fl = f.length; j < fl; j++) {
            temp = s[i] + '';
            repl = ra ? (r[j] !== undefined ? r[j] : '') : r[0];
            s[i] = (temp).split(f[j]).join(repl);
            if (count && s[i] !== temp) {
                this.window[count] += (temp.length - s[i].length) / f[j].length;
				}
			}
		}
		return sa ? s : s[0];
	}
	
	function DeleteTag (e, id, i_id) {
	
		
		if (prompt("Для удаления введите delete:") == "delete") {
			
			var atg = $("#tgh_"+i_id).val();
			atg = str_replace( "<"+id+">", "", atg, 1 );
			$('#tgh_'+i_id).val(atg);
			$(e).hide();
			$.post('new_tag.php', {type: "del", id_track: i_id, id_tag: id}, Test);	
		}
	
	}
	
	function Test(data) {
		
		//alert(data);
	
	}
	
	function InsertTag (name, id, i_id) {
	
		var atg = $("#tgs_"+insert_id).html();
				
		if ( strpos(atg, ">"+name+" <", 0) == -1) {
				
			$('#tgs_'+insert_id).append("<span onclick='DeleteTag(this, "+id+", "+insert_id+")'>"+name+" <span style='cursor: pointer;color:red'><sup>x</sup></span>&nbsp; &nbsp; </span>");
			$.post('new_tag.php', {type: "add", id_track: insert_id, id_tag: id}, Test);
			
		}
	
	}
	
	function AddTagButton (e, id) {
	
		insert_id = id;
		var x = e.offsetLeft + 40;
		var y = e.offsetTop + 75;
	   		
	
		$('#tags').css('left', x);
		$('#tags').css('top', y);
		$('#ins_tags').html(tags);
		$('#tags').show();
		
	}
	
	
    function NewTag () {
	
		var name = prompt("Название тега:");
		if (name) {$.post('new_tag.php', {type: "new", name: name}, CreateTag);}
		
	}
	
	function CreateTag (data) {
	
		if (data) {tags = data; $('#ins_tags').html(tags);}
			
	}
	
	function ToolsButton (e, id) {
		  	  		
		insert_id = id;
		var p = $(e);		
		var offset = p.offset();		
				
		$('#tools').css('left', offset.left+18);
		$('#tools').css('top', offset.top-2);
		$('#tools').show();
		
	}
	
	function Compile() {
	
		$("#m"+insert_id).removeClass("play").addClass("fym_wait");
		$("#wait_"+insert_id).val(1);
		iChange(insert_id);
		
	}
	
	function iChange(id) {
	
		$("#changes").val( $("#changes").val() +id+"|" );
	
	}
	
</script>
{/literal}