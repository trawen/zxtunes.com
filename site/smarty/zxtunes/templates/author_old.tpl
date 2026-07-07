{include file="menu.tpl"}
 
 
<table width=100% border=0 height=100><tr><td vAlign=top align=left width=1%>
<img {if $author.dead}style="border: 4px solid black"{/if} src="{$scr}"></td><td >&#160</td><td vAlign=top align=left>
<H3>{$author.nickname}</H3>


 
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
<img src="http://web.icq.com/whitepages/online?icq={$author.icq}&img=5" width=18 height=18 align=absmiddle border=0>{$author.icq}
{else}—{/if}
</span>
<br>


<span class="au1">
{if $language eq 'rus'}сайт: </span>{else}site: </span>{/if}
<span class="au2">
{if $author.url}<noindex><a href="http://{$author.url}" rel="nofollow">www.{$author.url}</a></noindex>{else}—{/if}
{if $author.url2}<noindex><a href="http://{$author.url2}" rel="nofollow">, www.{$author.url2}</a></noindex>{/if}
</span>
<br>
<br>

<table cellpadding=0 cellspacing=0 border=0><tr><td>
<span class="au1">
{if $language eq 'rus'}архив: </span>{else}archive: </span>{/if}
</td><td><span class="au2">
{if $szip}<a class="m" href="/downloads.php?id={$author.id}&md=author">{$author.nickname}.zip</a> ({$szip}Kb)</span> 
{else}—{/if}</span>
</span></td></tr>


<tr><td></td><td style='padding-top: 2px;'><span class="dd" style='padding-left: 4px;'>
{if $language eq 'rus'}скачиваний{else}downloads{/if}</span> {$author.downloads}
</td></tr></table>

{if $author.dead}<br><b style="color: #d00000;">{$author.dead}</b>{/if}

</td>



<td align=left valign=top nowrap>




<table border=0 align=right><tr><td style='padding: 6px; border: 1px solid #eeebe8;'>
<div class="selector" align=left >

<table width=100% border=0 cellpadding=0 cellspacing=0><tr><td>
<a {$mode[1]} style="FONT-SIZE: 1.6em;" href="/author.php?id={$author.id}&md=1">
{if $language eq 'rus'}треки{else}tunes{/if}</a> </td><td style='padding-left: 4px;' valign=bottom>
<span style="FONT-SIZE: 1.4em;">{$author.num_tracks}</span><td><tr>

<tr><td>

<a {$mode[2]} style="FONT-SIZE: 1.6em;">
{if $language eq 'rus'}альбомы{else}albums{/if}</a></td><td style='padding-left: 4px;' valign=bottom>
<span style="FONT-SIZE: 1.4em;">0</span><td><tr>

<tr><td>
<a {$mode[3]} style="FONT-SIZE: 1.6em;"
{if $intv[0] neq 0}href="/author.php?id={$author.id}&md=3"{/if}>
{if $language eq 'rus'}интервью{else}interviews{/if}</a>
	
</td><td style='padding-left: 4px;' valign=bottom>
<span style="FONT-SIZE: 1.4em;">{$intv[0]}</span><td><tr>


<tr><td>
<a {$mode[4]} style="FONT-SIZE: 1.6em;" href="/author.php?id={$author.id}&md=4">
{if $language eq 'rus'}гостевая{else}guestbook{/if}</a>
</td><td style='padding-left: 4px;' valign=bottom>
<span style="FONT-SIZE: 1.4em;">{$gb[0]}</span><td><tr></table>

<br><br>
<table width=100% border=0 cellpadding=0 cellspacing=0 valign=bottom><tr><td>
<span class="dd">
{if $language eq 'rus'}просмотров{else}views{/if}</span></td><td style='padding-left: 4px;'>
 {$author.views}
 </td></tr>
 
<tr><td>
<div nowrap><span class="dd">
{if $language eq 'rus'}обновление{else}last update{/if}</span></td><td style='padding-left: 4px;'>
 {$last_update}</div>
 </td></tr></table>
 
</div>
</td></tr></table>



</td>


</tr></table>



{if $md eq 1}
	
	
	
	
	
	
	
	
<div align="right" style="padding-right: 30px">
<a href='#' onclick="showTooltip()"> <b><div id=tp1 style='display: {if $fym_hidden eq 'none'}block{else}none{/if}'>{if $language eq 'rus'}Открыть Flash проигрыватель{else}Open Flash player{/if} »</div><div id=tp2 style='display: {$fym_hidden}'>{if $language eq 'rus'}Спрятать Flash проигрыватель{else}Hide Flash player{/if} «</div></b></a>
</div>

<div id=tooltip style='display: {$fym_hidden}'>
	
<div id="fymplayer">
		<p>Please, install Adobe Flash Player 10 and enable JavaScript</p>
		<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a></p>
	</div>
{literal}
	<script type="text/javascript">
		var params = {
{/literal}
			path:"fym/{$id_fym}",
			file:"{$id_fym}.xml",
			background:"#ffffff",
			title:"#202020",
			buttons:"#202020",
			position:"#707070",
			volume:"#707070",
			options:"#A0A0A0",
			scroll:"#202020",
			line:"#D0D0D0",
			channelsText:"#404040",
			channelsBackground:"#E4E4E4",
			channelsOutline:"#808080",
			spectrumBack:"#F0F0F0",
			spectrumLeft:"#604040",
			spectrumRight:"#404060",
			listGroup:"#404040",
			listTrackBackground:"#000000",
			listTrackText:"#202020",
			listTrackSeparator:"#808080",
			listTrackSeparatorChar:" "
{literal}
		}
{/literal}
		swfobject.embedSWF("fymplayer.swf", "fymplayer", "730", "{$nmtrpl}", "10.0", "expressInstall.swf", {literal}params, {bgcolor:params.background} );
	</script>
{/literal}
	
	
</div>
	
<table width=100% border=0><tr><td align=left>
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div></td><td align=right><div style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}треков {else}tunes {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div></td></tr></table><br>

<noindex>
<!-- <script type="text/javascript"><!--
ay = "03578";
music = "079";
rulez = "330";
google_ad_client = "pub-"+ay+"893"+music+"77"+rulez;
/* 728x90, создано 20.05.09 */
google_ad_slot = "8705651593";
google_ad_width = 728;
google_ad_height = 90;
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script> -->
</noindex>
	
	
<table border=0 bgcolor=#ffffff cellpadding=2 cellspacing=0 width='100%'>
<tr cellpadding=2 bgcolor=#dedbd8>
<td style='border-bottom: 1px solid #dedbd8;' align=left nowrap>№</td>
<td style='border-bottom: 1px solid #dedbd8;' nowrap>{$tb_title[1].link}</td>
<td style='border-bottom: 1px solid #dedbd8;' nowrap>{$tb_title[2].link}</td>
<td style='border-bottom: 1px solid #dedbd8;' align=center nowrap>{$tb_title[3].link}</td>
<td style='border-bottom: 1px solid #dedbd8;' align=center nowrap>{$tb_title[4].link}</td>
<td style='border-bottom: 1px solid #dedbd8;' align=center nowrap>{$tb_title[5].link}</td>
<td style='border-bottom: 1px solid #dedbd8;' align=center nowrap>{$tb_title[6].link}</td>
</tr>

{section name=n loop=$tbtx}
{cycle values=""}
<tr>
<td style='border-bottom: 1px solid #dedbd8;'><div style="COLOR: #909090;">{$tbtx[n][0]}&#160</div></td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][1]}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][2]}</td>
<td align=center style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][3]}</td>
<td align=center style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][4]}</td>
<td align=center style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][5]}</td>
<td align=center style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][6]}</td>
</tr>
{/section}

</table>
	  
	  

	  

<table width=100% border=0><tr><td align=left>
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div></td><td align=right><div style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}треков {else}tunes {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div></td></tr></table><br>




{elseif $md eq 3}

{if $intv[0]}

<br>
<H3>
{if $interview.title}{$interview.title}{else}

{if $language eq 'rus'}Интервью с {else}An interview with {/if}{$author.nickname}{/if}</H3>
<span class="au2">
© {if $interview.from_url}<noindex><a href="http://{$interview.from_url}" rel="nofollow">{$interview.author}</a></noindex>
  {else}{$interview.author}{/if}, {$interview.year}</span> &#160&#160&#160   
  {if $interview.sent}<span class="dd">{if $language eq 'rus'}прислал{else}sent{/if}</span>
  {if $interview.sent_url} <noindex><a href="http://{$interview.sent_url}" rel="nofollow">{$interview.sent}</a></noindex>
  {else} {$interview.sent}{/if}
  {/if}

<div align='justify' style="FONT-SIZE: 1.2em;">{$interview.text}</div>
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
{cycle values=""}
<tr>
<td rowspan="2" valign=middle align=left width=1% style="padding-right: 8px;">
<table><tr><td style="padding: 4px; border: 1px solid #e0e0e0; COLOR: #909090;" >{$guestbook[n].nm}</tr></table></td>
<td valign=bottom align=left><div style="FONT-SIZE: 1.2em;">{if $guestbook[n].user_email}
{mailto extra='class="m"' address=$guestbook[n].user_email text=$guestbook[n].user_name|h encode="javascript"}
{else}<b>{$guestbook[n].user_name|h}</b>{/if}<noindex>
{if $guestbook[n].site}<a href="http://{$guestbook[n].site|h}" rel="nofollow"><img border=0 style="padding-left: 8px;" src="images/home.png"></a>{/if}</noindex>
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