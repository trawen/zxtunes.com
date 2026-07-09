{include file="menu.tpl"}
{if $md eq 1}
<link href="/css/ay_player.css?v=4" type="text/css" rel="stylesheet">
{/if}

<script type="text/javascript" src="/css/jquery.js"></script>
<script language="javascript">
var autoplay = "{$autoplay}";
var author_id = {$author.id};
var author_name = {$author_name_js};
var user_id = "{$user_id}";
{if $md eq 1}
var first_track = "{$first_track_id}";
var zxtunesPlaylist = {$playlist_js};
{else}
var first_track = 0;
var zxtunesPlaylist = [];
{/if}
	
{if $language eq 'rus'}
var spam = "<in"+"put type='submit' style='width: 120px' name='submit' value='Отправить'>";
{else}
var spam = "<in"+"put type='submit' style='width: 120px' name='submit' value='Submit'>";
{/if}

{literal}

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



</script>
{/literal}
{if $md eq 1}
<script type="text/javascript" src="/js/ay/pako_inflate.min.js"></script>
<script type="text/javascript" src="/js/ay/ayumi.js"></script>
<script type="text/javascript" src="/js/ay/fym.js"></script>
<script type="text/javascript" src="/css/ay_player.js?v=5"></script>
{/if}


 
<table width=100% border=0>
<tr>


<td rowspan=4 vAlign=top align=left width=1% style="padding-right: 16px">
<img alt="{$title}" title="{$title}" onload="FixProfileHeight()" id="author_photo" class="photo" src="/{if $author.photo}photo/{$author.id}.jpg{else}css/wanted.png{/if}">
</td>





<td rowspan=4 vAlign=top align=left><div id="author_info">

<table width=100%><tr><td><div class="author-heading"><H1><span {if $author.dead}style="border: 1px solid black; padding: 2px 9px 2px 8px"{/if}>{$author.nickname}</span></H1>{if $author.dead}<span class="author-dead">{if $language eq 'rus'}умер {$author.dead}г{else}died {$author.dead}{/if}</span>{/if}</div></td>
<td align=right style="padding-right: 16px">{if $user.login}<a href="/author_edit.php?id={$author.id}" class="dwns">редактировать<a> <img src="/images/edit.ico" style="vertical-align: middle">{/if}</td></tr></table>



 
{if $author.also}{if $language eq 'rus'}<span class="au1">другие ники: </span>
{else}<span class="au1">also known: </span>{/if}<span class="au2">{$author.also}
</span>
<br>
<br>
{/if}


<span class="au1">
{if $language eq 'rus'}имя: </span><span class="au2"> 
	{if $author.first_name and $author.last_name} {$author.first_name} {$author.last_name}
	{elseif $author.first_name} {$author.first_name}
	{elseif $author.last_name} {$author.last_name}
	{else}—{/if}
{else}name: </span><span class="au2">
	{if $author.first_name_en and $author.last_name_en} {$author.first_name_en} {$author.last_name_en}
	{elseif $author.first_name_en} {$author.first_name_en}
	{elseif $author.last_name_en} {$author.last_name_en}
	{else}—{/if}
{/if}
</span>
<br>


{if $group}
	<div style="padding-top: 1px;">
	{if $language eq 'rus'}<span class="au1">группа: </span>{else}<span class="au1">group: </span>{/if}
	{if $group}<span class="au2">{$group}</span>{else}—{/if}
	</div>



	{if $others}<div style="padding-top: 1px;"><span class="au1">
	{if $language eq 'rus'}согрупники:</span>{else}others members:</span>{/if}
	<span class="au2">{$others}</span></div><br>
	{else}<br>
	{/if}

{else}
<br>
{/if}


{if $author.city or $author.city_en or $author.country or $author.country_en}
<span class="au1">
{if $language eq 'rus'}расположение: </span><span class="au2">
  {if $author.city and $author.country}{$author.city}, {$author.country}
  {elseif $author.city}{$author.city}
  {elseif $author.country}{$author.country}
  {/if}
{else}location: </span><span class="au2">
  {if $author.city_en and $author.country_en}{$author.city_en}, {$author.country_en}
  {elseif $author.city_en}{$author.city_en}
  {elseif $author.country_en}{$author.country_en}
  {/if} 
{/if}
{if $flag}<img width=16 height=10 class="flag" src="/{$flag}">{/if}
</span>
<br>
{/if}



<div style="padding-top: 1px;">
<span class="au1">
{if $language eq 'rus'}специализация: </span>{else}specialization: </span>{/if}
<span class="au2">{$author.spec}</span>
</div>

<br>

<div style="padding-top: 1px;">
<span class="au1">
{if $language eq 'rus'}активность: </span>{else}activity: </span>{/if}
<span class="au2">
  {if $author.years_from and $author.years_to and $author.years_from eq $author.years_to }{$author.years_from}
  {elseif $author.years_from and $author.years_to}{$author.years_from}—{$author.years_to}
  {elseif $author.years_from}{$author.years_from}
  {elseif $author.years_to}{$author.years_to}
  {else}—{/if}
</span>
</div>
<br>


{if $author.email}
	<span class="au1">
	{if $language eq 'rus'}почта: </span>{else}e-mail: </span>{/if}
	<span class="au2">
	{if $author.email} {mailto address=$author.email encode="javascript"}{else}—{/if}
	</span>
	<br>
{/if}


{if $author.site}
	<span class="au1">
	{if $language eq 'rus'}сайт: </span>{else}site: </span>{/if}
	<span class="au2">
	{if $author.site}<noindex><a href="{$author.site_url}" rel="nofollow">{$author.site_label}</a></noindex>{else}—{/if}
	</span>
	<br>
{/if}

<br>

<table cellpadding=0 cellspacing=0 border=0><tr><td>
<span class="au1">
{if $language eq 'rus'}архив музыки: </span>{else}music archive: </span>{/if}
</td><td><span class="au2">
{if $szip}<a class="m" title="{$author.nickname} music" alt="{$author.nickname} music" href="/downloads.php?id={$author.id}&md=author">{$author.nickname}.zip</a> ({$szip}Kb)</span> 
{else}—{/if}</span>
</span></td></tr>

<tr><td></td><td style='padding-top: 2px;'><span class="dwns" style='padding-left: 4px;'>
{if $language eq 'rus'}скачиваний{else}downloads{/if}</span> {$author.downloads}
</td></tr></table>



</div>
</td>
</tr>






<tr>
<td align=center valign=top nowrap width="120">

<a href='http://www.facebook.com/sharer.php?u={$author_url}' title='Добавить в Facebook' rel='nofollow' class='soc_button soc_facebook' target='_blank'></a>

<a href='http://twitter.com/share?url={$author_url}' title='Опубликовать в Twitter' rel='nofollow' class='soc_button soc_twitter' target='_blank'></a>

<a href='http://vkontakte.ru/share.php?url={$author_url}' title='Добавить в Вконтакте' class='soc_button soc_vkontakte' target='_blank'></a>

<a href='http://www.livejournal.com/update.bml?event={$author_url}' title='Опубликовать в LiveJournal' rel='nofollow' class='soc_button soc_livejournal' target='_blank'></a>

<a href='https://plusone.google.com/_/+1/confirm?hl=en&url={$author_url}' title='Google +1' rel='nofollow' class='soc_button soc_google' target='_blank'></a>

</td>
</tr>



<tr>
<td width="120" align=center style="padding-top: 4px">

<table style="padding: 10px; -webkit-border-radius: 3px; -moz-border-radius: 3px; border-radius: 3px; border: 1px solid #DDD;">


<tr>
<td align=center>
<a style="letter-spacing: 1px; font: bold 13px Arial; color: #0063B0" href="{$author_url}">{if $language eq 'rus'}Музыка{else}Music{/if}</a>
</td>
</tr>
<tr>
<td style="width: auto; padding-top: 0px;" align=center>
<span class="dwns" >{if $language eq 'rus'}треков{else}tracks{/if}</span> {$author.num_tracks}
</td>
</tr>

<tr><td><br></td></tr>

<tr>
<td align=center>
<a style="letter-spacing: 1px; font: bold 13px Tahoma; color: #0063B0" href="{$author_url}?md=3">{if $language eq 'rus'}Интервью{else}Interview{/if}</a>
</td>
</tr>
<tr>
<td style="width: auto; padding-top: 0px;" align=center>
<span class="dwns">{if $language eq 'rus'}статей{else}articles{/if}</span> {$intv[0]}
</td>
</tr>

<tr><td><br></td></tr>

<tr>
<td align=center>
<a style="letter-spacing: 1px; font: bold 13px Tahoma; color: #0063B0" href="{$author_url}?md=4">{if $language eq 'rus'}Гостевая{else}Guestbook{/if}</a>
</td>
</tr>
<tr>
<td style="width: auto; padding-top: 0px;" align=center>
<span class="dwns">{if $language eq 'rus'}сообщений{else}messages{/if}</span> {$gb[0]}
</td>
</tr>

</table>

</div>
</div>

<br><div class="dwns">{$last_update}</div>

</td>
</tr>

<tr>
<td valign=bottom align=center width="120">




</td>


</tr></table>























{if $md eq 1}
{include file="flash.tpl"}	
	




	


<br><br>

<div class="playlist_box">
<table width=100%><tr><td>

{if $language eq "rus"}

<strong style="font: bold 10pt Arial">ПЛЕЙЛИСТ</strong> &nbsp; &nbsp; сортировать по &nbsp; 
<b>

{if $sort eq "playing"}

<a class="m" href="{$author_url}?sort=year">году</a> &nbsp;&nbsp; <a class="m" href="{$author_url}?sort=rating">рейтингу</a>
 &nbsp;&nbsp; прослушиваниям

{elseif $sort eq "rating"}

 <a class="m" href="{$author_url}?sort=year">году</a> &nbsp;&nbsp; рейтингу
 &nbsp;&nbsp; <a class="m" href="{$author_url}?sort=playing">прослушиваниям</a>

{else}

году &nbsp;&nbsp; <a class="m" href="{$author_url}?sort=rating">рейтингу</a>
 &nbsp;&nbsp; <a class="m" href="{$author_url}?sort=playing">прослушиваниям</a>

{/if}
</b>

</td>
<td align="right">треков <b>{$author.num_tracks}</b></td>



{else}


<strong style="font: bold 10pt Arial">PLAY LIST</strong> &nbsp; &nbsp; sort by &nbsp; 
<b>

{if $sort eq "playing"}

<a class="m" href="{$author_url}?sort=year">year</a> &nbsp;&nbsp; <a class="m" href="{$author_url}?sort=rating">rating</a>
 &nbsp;&nbsp; playings

{elseif $sort eq "rating"}

 <a class="m" href="{$author_url}?sort=year">year</a> &nbsp;&nbsp; rating
 &nbsp;&nbsp; <a class="m" href="{$author_url}?sort=playing">plaings</a>

{else}

year &nbsp;&nbsp; rating
 &nbsp;&nbsp; <a class="m" href="{$author_url}?sort=playing">playings</a>

{/if}
</b>







</td>
<td align="right">tunes <b>{$author.num_tracks}</b></td>



{/if}

</tr>
</table>
</div>

<br>


<div id="tb" class="zx-playlist">

{section name=n loop=$playlist}

<div class="zx-track-item">
<div class="zx-track-row" id="s{$playlist[n].id}" onmouseover="ShowDetails({$playlist[n].id}, 'on')" onmouseout="ShowDetails({$playlist[n].id}, 'off')">

<div class="zx-track-year">{if $playlist[n].print_year}{if $playlist[n].year}{$playlist[n].year}{else}n/a{/if}{/if}</div>

<div class="zx-track-play">
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
</div>

<div class="zx-track-title" id="f{$playlist[n].id}"><a rel="nofollow" class="m" href="/downloads.php?id={$playlist[n].id}" title="{if $language eq 'rus'}Скачать {else}Download {/if} {$playlist[n].filename}">{$playlist[n].filename}</a>{if $playlist[n].name} - {/if}<span>{$playlist[n].name}</span></div>

<div class="zx-track-time" id="t{$playlist[n].id}">{$playlist[n].time}</div>

<div class="zx-track-dl"><img style="opacity: 0.3; vertical-align: bottom" src="/css/plays.png" alt=""> <span id="dw{$playlist[n].id}">{$playlist[n].downloads}</span></div>

<div class="zx-track-format"><img src="/images/type_{if $playlist[n].format eq 0}ay.png" title="AY/YM song"{elseif $playlist[n].format eq 1}bp.png" title="Beeper song"{elseif $playlist[n].format eq 2}ts.png" title="Turbo Sound song"{elseif $playlist[n].format eq 3}dg.png" title="Digital song"{/if} alt=""></div>

</div>

<div class="zx-track-line" id="pl{$playlist[n].id}"></div>
</div>

{/section}

</div>
	  
	  
	  
	  
  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  





{elseif $md eq 3}

{if $intv[0]}

<br>
<H2>
{if $interview.int_title}{$interview.int_title}{else}

{if $language eq 'rus'}Интервью с {else}An interview with {/if}{$author.nickname}{/if}</H2>
<span class="au2">
© {if $interview.int_from_url}<noindex><a href="http://{$interview.int_from_url}" rel="nofollow">{$interview.int_author}</a></noindex>
  {else}{$interview.int_author}{/if}, {$interview.int_year}</span> &#160&#160&#160   
  {if $interview.int_sent}<span class="dd">{if $language eq 'rus'}прислал{else}sent{/if}</span>
  {if $interview.int_sent_url} <noindex><a href="http://{$interview.int_sent_url}" rel="nofollow">{$interview.int_sent}</a></noindex>
  {else} {$interview.int_sent}{/if}
  {/if}

<div align='justify' style="FONT-SIZE: 1.2em; width: 540px">{$interview.int_text}</div>
<br>

	{if $all_interview}
	<b>{if $language eq 'rus'}Также читайте:{else}Also read:{/if}</b> <br>
	<div style="font: normal 14px Verdana">
	
	
	{section name=n loop=$all_interview}

	<p><a href="{$author_url}?md=3&interview={$all_interview[n].int_id}">{$all_interview[n].int_title}</a></p>
	{/section}
	
	
	
	</div>
	{/if}

	
	
	
	
{else}




<br><br><br>

<div style="font: normal 17px Verdana; letter-spacing: 0px" align=center>
{if $language eq 'rus'}
Печально, но у {$author.nickname} всё еще нет интервью.
{else}
It is sad, but {$author.nickname} still no interviews.
{/if}
</div>







{/if}










{elseif $md eq 2}

<br>
<H3>{$author.nickname} 
{if $language eq 'rus'}не имеет альбомов.{else}no albums.{/if}</H3>



{elseif $md eq 4}
<br><br>
<table><tr>

<td style="padding-left: 32px" align=center valign=top>

<br><br><br>

<div style="font: bold 13px Verdana;">{if $language eq 'rus'}Что-нибудь cказать{else}Something to say{/if}</div>
<br>

<form method="post" enctype="multipart/form-data" onsubmit="return validateEmpty('name', 'email', 'message')">
<input type="hidden" name="_csrf" value="{$csrf_token}">

<b>
<p>
{if $language eq 'rus'}Ник или имя{else}Nickname{/if}<br> <input style="border: 1px solid #ccc; width: 150px" name="name" type="text" size="16" maxlength="15" id="name">
</p>
  
<p>
E-mail  <br> <input style="border: 1px solid #ccc; width: 150px"  name="email" type="text" size="16" maxlength="100" id="email">
</p>

<p>
{if $language eq 'rus'}Сообщение{else}Message{/if} <br> 
<textarea type="text" name="message" rows="4" style="border: 1px solid #ccc; width: 150px" id="message"></textarea>
</p>
</b>

<div  id="spam"></div>
</form>

</td>

<td>
<table style="padding-left:50 px;" width=520 border=0>

{section name=n loop=$guestbook}
<tr>
<td valign=bottom align=left>
<div style="FONT-SIZE: 1.2em; padding-left: 3px;">
<b>{$guestbook[n].user_name|h}</b>

{if $guestbook[n].site}<a href="http://{$guestbook[n].site|h}" rel="nofollow"><img border=0 src="/css/links_ico.png"></a>{/if}
</div>
</td>
<td nowrap align=right style="padding-right: 3px" class=d>{$guestbook[n].update}</td>
</tr>

<tr>
<td valign=bottom style='border-top: 1px solid #dedbd8;' colspan=2>
<div align='justify' style="FONT-SIZE: 1.2em; padding-left: 3px; padding-right: 3px; padding-top: 2px">{$guestbook[n].message|h}</div></td>
</tr>
<tr><td colspan=2><br></td></tr>
{/section}

</table>
</td>

</tr>
</table>



{/if}





	  

      	  
{include file="right_strip.tpl"}
{include file="footer.tpl"}

{if $md eq 1}
{literal}
<div id="zx_ay_player_wrap" class="zx-ay-player-wrap">
<div class="zx-ay-player-inner">
<table id="player"><tr><td>
<table>
<tr id="pbody">
<td class="p_control_left">
<button id="b_play" class="b_control b_play" onclick="togglePlay(); return false;"><span class="icon"></span></button>
<button class="b_control b_prev" onclick="PreviousTrack(); return false;"><span class="icon"></span></button>
<button class="b_control b_next" onclick="NextTrack(); return false;"><span class="icon"></span></button>
</td>
<td class="p_body">
<div class="track_text"><span id="track_name">FYM Player</span><span id="track_time" class="track_time" onclick="toggleTime(); return false;">0:00</span></div>
<div class="timeline" onclick="changeProgress(event); return false;"><div id="track_progress_left" class="timeline0"></div><div id="track_progress_right" class="timeline1"></div></div>
</td>
<td class="p_control_right">
<button id="b_shuffle" class="b_control b_shuffle" onclick="playShuffle(); return false;"><span class="icon"></span></button>
<button id="b_repeat" class="b_control b_repeat" onclick="playRepeat(); return false;"><span class="icon"></span></button>
<button class="b_control b_setup" onclick="showOptions(); return false;"><span class="icon"></span></button>
</td>
</tr>
</table>
</td></tr></table>
</div>
</div>

<div id="zx_ay_options" class="popup__overlay">
<div class="popup">
<form action="#" method="POST" onsubmit="return false;">
<table class="popup_table" id="mix">
<tr class="popup_table_header">
<td class="popup_table_header_text" colspan="3"><p>Options</p></td>
<td class="popup_table_header_button"><a href="#" onclick="hideOptions(); return false;">X</a></td>
</tr>
<tr><td colspan="4">Channels mixing:</td></tr>
<tr>
<td>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ym_abc" value="0" checked><label for="ym_abc">YM ABC</label>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ym_acb" value="1"><label for="ym_acb">YM ACB</label>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ym_bac" value="2"><label for="ym_bac">YM BAC</label>
</td>
<td>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ym_bca" value="3"><label for="ym_bca">YM BCA</label>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ym_cab" value="4"><label for="ym_cab">YM CAB</label>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ym_cba" value="5"><label for="ym_cba">YM CBA</label>
</td>
<td>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ay_abc" value="6"><label for="ay_abc">AY ABC</label>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ay_acb" value="7"><label for="ay_acb">AY ACB</label>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ay_bac" value="8"><label for="ay_bac">AY BAC</label>
</td>
<td>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ay_bca" value="9"><label for="ay_bca">AY BCA</label>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ay_cab" value="10"><label for="ay_cab">AY CAB</label>
<input onclick="changeMixing(this);" type="radio" name="channels" id="ay_cba" value="11"><label for="ay_cba">AY CBA</label>
</td>
</tr>
</table>
</form>
</div>
</div>
{/literal}
{/if}

