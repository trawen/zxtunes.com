{include file="menu.tpl"}
<script type="text/javascript" src="css/jquery.js"></script>
<script type="text/javascript" src="css/player6.js"></script> 
<script language="javascript">
var autoplay = "{$autoplay}";
var author_name = "{$author.nickname}";
var first_track = {$playlist[0].id};
</script>

 
<table width=100% border=0 height=100><tr><td vAlign=top align=left width=1%>
<img class="{if $author.dead}photo_dead{else}photo{/if}" src="{$scr}"></td><td >&#160;</td><td vAlign=top align=left>
<H1>{$author.nickname}</H1>


 
{if $author.also1}{if $language eq 'rus'}<span class="au1">другие ники: </span>
{else}<span class="au1">also known: </span>{/if}<span class="au2">{$author.also1}
{if $author.also2}, {$author.also2}{/if}
{if $author.also3}, {$author.also3}{/if}
{if $author.also4}, {$author.also4}{/if}
{if $author.also5}, {$author.also5}{/if}
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

 
<div style="padding-top: 1px;">
{if $language eq 'rus'}<span class="au1">группа: </span>{else}<span class="au1">group: </span>{/if}
{if $group}<span class="au2">{$group}</span>{else}—{/if}
</div>


{if $others}<div style="padding-top: 1px;"><span class="au1">
 {if $language eq 'rus'}согрупники:</span>{else}others members:</span>{/if}
 <span class="au2">{$others}</span></div><br>
{else}<br>
{/if}



<span class="au1">
{if $language eq 'rus'}расположение: </span><span class="au2">
  {if $author.city and $author.country}{$author.city}, {$author.country}
  {elseif $author.city}{$author.city}
  {elseif $author.country}{$author.country}
  {else}—{/if}
{else}location: </span><span class="au2">
  {if $author.city_en and $author.country_en}{$author.city_en}, {$author.country_en}
  {elseif $author.city_en}{$author.city_en}
  {elseif $author.country_en}{$author.country_en}
  {else}—{/if} 
{/if}
{if $flag}<img width=16 height=10 class="flag" src="{$flag}">{/if}
</span>
<br>


<div style="padding-top: 1px;">
<span class="au1">
{if $language eq 'rus'}специализация: </span>{else}specialization: </span>{/if}
<span class="au2">{$author.spec}</span>
</div>

<div style="padding-top: 1px;">
<span class="au1">
{if $language eq 'rus'}активность: </span>{else}activity: </span>{/if}
<span class="au2">
  {if $author.years_from and $author.years_to and $author.years_from eq $author.years_to }{$author.years_from}
  {elseif $author.years_from and $author.years_to}{$author.years_from}-{$author.years_to}
  {elseif $author.years_from}{$author.years_from}
  {elseif $author.years_to}{$author.years_to}
  {else}—{/if}
</span>
</div>
<br>


<span class="au1">
{if $language eq 'rus'}почта: </span>{else}e-mail: </span>{/if}
<span class="au2">
{if $author.email1} {mailto address=$author.email1 encode="javascript"}{else}—{/if}
{if $author.email2}, {mailto address=$author.email2 encode="javascript"}{/if}
</span>
<br>


<span class="au1">icq:</span>
<span class="au2">
{if $author.icq}
<img src="http://wwp.icq.com/scripts/online.dll?icq={$author.icq}&img=26" alt="status" border="0" />
{$author.icq}
{else}—{/if}
</span>
<br>


<span class="au1">
{if $language eq 'rus'}сайт: </span>{else}site: </span>{/if}
<span class="au2">
{if $author.url}<noindex><a href="http://{$author.url}" rel="nofollow">{$author.url}</a></noindex>{else}—{/if}
{if $author.url2}<noindex><a href="http://{$author.url2}" rel="nofollow">, {$author.url2}</a></noindex>{/if}
</span>
<br>
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

{if $author.dead}<br><b style="color: #d00000;">{$author.dead}</b>{/if}

</td>



<td align=right valign=top nowrap width="160">




<div>

<table><tr><td  align="right">

<div  style="font: bold 12px Verdana; padding: 4px">
{if $md eq 1}»{/if} 
<a class="m" href="author.php?id={$author.id}&md=1">{if $language eq 'rus'}Музыка{else}Music{/if}</a>
</div>

</td><td>{$author.num_tracks}</td></tr>


<tr><td  align="right">
<div style="font: bold 12px Verdana;  padding: 4px">
{if $md eq 3}»{/if} 
{if $intv[0] neq 0}
<a class="m" href="/author.php?id={$author.id}&md=3">{if $language eq 'rus'}Интервью{else}Interviews{/if}</a>
</a>
{else}
{if $language eq 'rus'}Интервью{else}Interviews{/if}
{/if}
</div>
</td><td>{$intv[0]}</td></tr>


<tr><td align="right">

<div style="font: bold 12px Verdana;  padding: 4px">
{if $md eq 4}»{/if} 
<a class="m" href="/author.php?id={$author.id}&md=4">{if $language eq 'rus'}Гостевая{else}Messages{/if}</a>

</div>
</td><td>{$gb[0]}</td>


</tr>
</table>


<br><br>


<table><tr><td  align="right">
<span class="dwns">{if $language eq 'rus'}просмотров{else}views{/if}</span>
</td><td>{$author.views}</td></tr>


<tr><td align="right">
<span class="dwns">{if $language eq 'rus'}обновление{else}last update{/if}</span>
</td><td>{$last_update}</td></tr>


</table>
</div>


















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

<a class="m" href="author.php?id={$author.id}&sort=year">году</a> &nbsp;&nbsp; <a class="m" href="author.php?id={$author.id}&sort=rating">рейтингу</a>
 &nbsp;&nbsp; прослушиваниям

{elseif $sort eq "rating"}

 <a class="m" href="author.php?id={$author.id}&sort=year">году</a> &nbsp;&nbsp; рейтингу
 &nbsp;&nbsp; <a class="m" href="author.php?id={$author.id}&sort=playing">прослушиваниям</a>

{else}

году &nbsp;&nbsp; <a class="m" href="author.php?id={$author.id}&sort=rating">рейтингу</a>
 &nbsp;&nbsp; <a class="m" href="author.php?id={$author.id}&sort=playing">прослушиваниям</a>

{/if}
</b>

</td>
<td align="right">треков <b>{$author.num_tracks}</b></td>



{else}


<strong style="font: bold 10pt Arial">PLAY LIST</strong> &nbsp; &nbsp; sort by &nbsp; 
<b>

{if $sort eq "playing"}

<a class="m" href="author.php?id={$author.id}&sort=year">year</a> &nbsp;&nbsp; <a class="m" href="author.php?id={$author.id}&sort=rating">rating</a>
 &nbsp;&nbsp; playings

{elseif $sort eq "rating"}

 <a class="m" href="author.php?id={$author.id}&sort=year">year</a> &nbsp;&nbsp; rating
 &nbsp;&nbsp; <a class="m" href="author.php?id={$author.id}&sort=playing">plaings</a>

{else}

year &nbsp;&nbsp; rating
 &nbsp;&nbsp; <a class="m" href="author.php?id={$author.id}&sort=playing">playings</a>

{/if}
</b>







</td>
<td align="right">tunes <b>{$author.num_tracks}</b></td>



{/if}

</tr>
</table>
</div>

<br>


<table style="padding: 8px" border=0 cellpadding=0 cellspacing=0 width='100%' >

{section name=n loop=$playlist}

{if $playlist[n].print_year}

<tr><td colspan="8" height="32" valign=middle>&nbsp; <b>{if $playlist[n].year}{$playlist[n].year}{else}n/a{/if}</b></td></tr>

{/if}

<tr style="color: #888" id="s{$playlist[n].id}">
<td></td>


<td width="26" align="center">
<div id="m{$playlist[n].id}" class="play" onclick="PlayB('{$playlist[n].id}')"></div>
<div id="n{$playlist[n].id}" style="display: none">{$playlist[n].next_id}</div>
<div id="p{$playlist[n].id}" style="display: none">{$playlist[n].prev_id}</div>
<div id="a{$playlist[n].id}" style="display: none">{$author.id}</div>
</td>

<td id="f{$playlist[n].id}"><a class='m' href='downloads.php?id={$playlist[n].id}' 
title="{if $language eq 'rus'}Скачать {else}Download {/if} {$playlist[n].filename}">{$playlist[n].filename}</a></td>
<td id="t{$playlist[n].id}" style="color: #888">{if $playlist[n].name}{$playlist[n].name}{else}&nbsp;{/if}
</td>


<td align=center style="color: #444; width: 50px"><img style="opacity: 0.5" src="css/plays.png"> <span id="dw{$playlist[n].id}">{$playlist[n].downloads}</span></td>



<td style="color: #444; width: 38px" valign=middle> &nbsp; 
<img style="opacity: 0.5;" onclick="Rate({$playlist[n].id})" id="r{$playlist[n].id}" class="{$playlist[n].rt}" src="css/hand_up.png" title="{if $language eq 'rus'}Мне нравится!{else}I Like it!{/if}"> <div style="display: inline" id="rn{$playlist[n].id}">{if $playlist[n].rating neq 0}{$playlist[n].rating}{/if}</div>
</td>

<td style="color: #444;" valign=middle> &nbsp; 
<img style="opacity: 0.5" onclick="Comm({$playlist[n].id})" class="rating" src="css/comments.png" title="{if $language eq 'rus'}Добавить комментарий{else}Add Comment{/if}"> 
<div style="display: inline; color: #{if $playlist[n].comments}0063B0{else}444{/if}" id="cm{$playlist[n].id}">{if $playlist[n].comments neq 0}{$playlist[n].comments}{/if}</div>
</td>

</tr>
<tr><td></td><td colspan="7" id="c{$playlist[n].id}" class="comment_off"></td></tr>
<tr><td></td><td colspan="7" id="pl{$playlist[n].id}" class="plln" style="height: 13px"></td></tr>
{/section}

</table>
	  
	  
	  
	  
  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  





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

	<p><a href="/author.php?id={$author.id}&md=3&interview={$all_interview[n].int_id}">{$all_interview[n].int_title}</a></p>
	{/section}
	
	
	
	</div>
	{/if}
{else}

<br>
<H3>{$author.nickname} 
{if $language eq 'rus'}не имеет интервью.{else}no interviews.{/if}</H3>

{/if}










{elseif $md eq 2}

<br>
<H3>{$author.nickname} 
{if $language eq 'rus'}не имеет альбомов.{else}no albums.{/if}</H3>



{elseif $md eq 4}
<br><br>
<table style="padding-left:16 px;" width=80% border=0>
{section name=n loop=$guestbook}
<tr>
<td rowspan="2" valign=middle align=left width=1% style="padding-right: 8px;">
<table><tr><td style="padding: 4px; border: 1px solid #e0e0e0; COLOR: #909090;" >{$guestbook[n].nm}</tr></table></td>
<td valign=bottom align=left><div style="FONT-SIZE: 1.2em;">{if $guestbook[n].user_email}
{mailto extra='class="m"' address=$guestbook[n].user_email text=$guestbook[n].user_name|h encode="javascript"}
{else}<b>{$guestbook[n].user_name|h}</b>{/if}<noindex>
{if $guestbook[n].site}<a href="http://{$guestbook[n].site|h}" rel="nofollow"><img style="padding: 1px; background-color: white; border: 1px solid #CCC" src="images/home.png"></a>{/if}</noindex>
</div>
</td>
<td align=right><span class=d>{$guestbook[n].update}</span></td>
</tr>

<tr>
<td valign=bottom style='border-top: 1px solid #dedbd8;' colspan=2>
<div align='justify' style="FONT-SIZE: 1.2em;">{$guestbook[n].message|h}</div></td>
</tr>
<tr><td><br></td></tr>
{/section}




<a name="message"></a>
<tr><td colspan=5><br><br>
<table>
<form method="POST" action="sendinfo.php">
<input type="hidden" name="_csrf" value="{$csrf_token}">

{if $ert}<tr><td></td><td style="COLOR: red;">{$ert}<br></td></tr>{/if}




<tr><td></td><td valign=top><div style="FONT-SIZE: 1.4em;"> 
<b>{if $language eq 'rus'}- Поболтаем?{else}- Let's chat?{/if}</b></div><br></td><td>

<tr><td valign=top><b>{if $language eq 'rus'}имя{else}name{/if}:</b> *</td><td>
<input type="text" name="user_name" value="{$user_name}" maxlength="64" size="20"></td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}почта{else}e-mail{/if}:</b></td><td>
<input type="text" name="user_email" value="{$user_email}" maxlength="64" size="20"></td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}сайт{else}site{/if}:</b></td><td>
<input type="text" name="user_site" value="{$user_site}" maxlength="64" size="20"></td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}сообщение{else}message{/if}:</b> *</td>
<td><textarea type="text" name="message" cols="65" rows="5" style="font-family: arial; font-size: 11px">{$message}</textarea></td></tr>





<tr>
<td><img src="confirm_code.php?cc={$cc}" alt="" title="">*</td><td>
<input type="text" class="post" style="width: 90px" name="confirm_code" size="6" maxlength="6" value="">&nbsp&nbsp&nbsp<input type="submit" name="submit" value="{if $language eq 'rus'}отправить{else}submit{/if}"></td>
</tr>
<tr><td></td><td colspan=2><br>* <b>- {if $language eq 'rus'}обязательно{else}necessarily{/if}</b></td></tr>
<input type="hidden" name="mode" value="guestbook">
<input type="hidden" name="id" value="{$id}">
<input type="hidden" name="confirm_id" value="{$cc}">

</form>
</table>

</td></tr>
</table>




{/if}





	  

      	  
{include file="right_strip.tpl"}
{include file="footer.tpl"}