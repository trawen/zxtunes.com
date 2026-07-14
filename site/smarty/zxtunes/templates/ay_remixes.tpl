{include file="menu.tpl"}

<h2>РЕМИКСЫ</h2>

<b>
{if $type eq 1}МУЗЫКАЛЬНЫЕ ГРУППЫ{else}<a class=m href="ay_remixes.php?type=1">МУЗЫКАЛЬНЫЕ ГРУППЫ</a>{/if} / 
{if $type eq 2}ФИЛЬМЫ, МУЛЬТФИЛЬМЫ И ТВ{else}<a class=m href="ay_remixes.php?type=2">ФИЛЬМЫ, МУЛЬТФИЛЬМЫ И ТВ</a>{/if} / 
{if $type eq 3}ИГРЫ И ДЕМОСЦЕНА{else}<a class=m href="ay_remixes.php?type=3">ИГРЫ И ДЕМОСЦЕНА</a>{/if} / 
{if $type eq 4}КЛАССИКА{else}<a class=m href="ay_remixes.php?type=4">КЛАССИКА</a>{/if}
</b>

<br><br>

<table>

<tr>
<td>№</td>
<td>Исполнитель</td>
<td>Ремиксы</td>
<td>Просмотры</td>
<td>Обновления</td>
</tr>


{section name=n loop=$remixes}

{if $remixes[n].show_lit}<tr><td colspan=10>&nbsp;</td></tr>{/if}

<tr>
<td style="text-transform: uppercase"><b>{if $remixes[n].show_lit}{$remixes[n].lit}{else}&nbsp;{/if}</b></td>
<td><a class=m href="ay_remixes_play.php?id={$remixes[n].rfr_id}">{$remixes[n].rfr_article}{$remixes[n].rfr_name_ru}</a></td>
<td align="center">{$remixes[n].rfr_num_tunes}</td>
<td align="center">{$remixes[n].rfr_views}</td>
<td align="center">{$remixes[n].rfr_update}</td>
</tr>



{/section}
</table>



{include file="right_strip.tpl"}
{include file="footer.tpl"}