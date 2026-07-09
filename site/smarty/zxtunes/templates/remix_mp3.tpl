{include file="menu.tpl"}
 
 

	<table valign=bottom border=0><tr><td valign=bottom><H3>
	{if $language eq 'rus'}Ремиксы в MP3 {else}MP3 Remixes{/if}&#160 
	
	<div class="selector" style="DISPLAY: inline; FONT-SIZE: 0.9em;">
	<a {$mode[1]} href="{$sel_link}&md=1">{if $language eq 'rus'}игры{else}games{/if}</a>
	<a {$mode[2]} href="{$sel_link}&md=2">{if $language eq 'rus'}демо{else}demo{/if}</a>
	<a {$mode[3]} href="{$sel_link}&md=3">{if $language eq 'rus'}разное{else}others{/if}</a>
	<a {$mode[0]} href="{$sel_link}&md=0">{if $language eq 'rus'}все{else}all{/if}</a>
    </div>
	</h3>
	</td></tr></table>

	

	
<table width=100% border=0><tr><td align=left>
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div></td><td align=right><div style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}треки {else}tunes {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div></td></tr></table><br>

	

	
	
<table border=0 cellpadding=6 cellspacing=0 width='100%'>
<tr height=18 bgcolor=#eeebe8>

{if $language eq 'rus'}
<td nowrap style="border-left: 1px solid #eeebe8; border-radius: 3px 0px 0px 3px"><b>Название</td>
<td nowrap><b>Автор ремейка</td>
<td nowrap><b>Композитор</td>
<td nowrap><b>Год</td>
<td><b>Комментарии</td>
<!--<td align=center nowrap><b>Добавлен</td>-->
<td align=center nowrap style="border-left: 1px solid #eeebe8; border-radius: 0px 3px 3px 0px"><b>Скачивания
</td>
{else}
<td nowrap style="border-left: 1px solid #eeebe8; border-radius: 3px 0px 0px 3px"><b>Title</b></td>
<td nowrap><b>Remix author</b></td>
<td nowrap><b>Composer</b></td>
<td nowrap><b>Year</b></td>
<td><b>Comment</b></td>
<td align=center nowrap><b>Upload</b></td>
<td align=center nowrap style="border-left: 1px solid #eeebe8; border-radius: 0px 3px 3px 0px"><b>Dwns</b></td>
{/if}
</tr>





{section name=n loop=$remixes}
<tr>
<td style='border-bottom: 1px solid #eeebe8;'>
<strong>

{if $remixes[n].original_id}

{$remixes[n].title} <a class='m' href='/downloads.php?id={$remixes[n].id}&md=remix_mp3'>MP3</a> &nbsp; <a class='m' href='/downloads.php?id={$remixes[n].original_id}'>AY</a>

{else}

{$remixes[n].title} <a class='m' href='/downloads.php?id={$remixes[n].id}&md=remix_mp3'>MP3</a>

{/if}

</strong></td>
<td style='border-bottom: 1px solid #eeebe8;'>{$remixes[n].author}</td>
<td style='border-bottom: 1px solid #eeebe8;'>

{if $remixes[n].composer_name and $remixes[n].composer_id}

	<a class='m' href='{$remixes[n].composer_id|aurl}'>{$remixes[n].composer_name}</a>
	
{elseif $remixes[n].composer_name}

	{$remixes[n].composer_name}

{else}

		—

{/if}

</td>
<td style='border-bottom: 1px solid #eeebe8;'>

{if $remixes[n].year} {$remixes[n].year} {else} — {/if}

</td>
<td style='border-bottom: 1px solid #eeebe8;'>

{if $remixes[n].comment} {$remixes[n].comment} {else} — {/if}

</td>
<!--<td align=center style='border-bottom: 1px solid #eeebe8;'>{$tbtx[n][6]}</td>-->
<td align=center style='border-bottom: 1px solid #eeebe8;'>{$remixes[n].downloads}</td>
</tr>
{/section}

</table>

  

<table width=100% border=0><tr><td align=left>
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div></td><td align=right><div style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}треки {else}tunes {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div></td></tr></table><br>
	  
	  
	  
	  
	  
     	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}