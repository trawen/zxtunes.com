{include file="menu.tpl"}
 
<table valign=bottom border=0 width=100% style="padding-bottom: 8px;"><tr>

<td align=left style="padding-left: 20px;">
<h3>{if $language eq 'rus'}{$podcast.topic_rus}{else}{$podcast.topic_eng}{/if}</h3>

<table cellpadding=0 cellspacing=0 border=0><tr><td>
<img src='images/download.png'></td><td style='padding-left: 8px;'><div class="soft_copyright"><a style='COLOR: #0063b0;' href='downloads.php?id={$podcast.id}&md=podcast'><b>{$podcast.file_name}</b></a> <span style="FONT-SIZE: 0.9em;">(MP3 / {$podcast.file_size}Mb)</span> &nbsp; {$podcast.player}</div></td></tr>

<tr><td></td><td valign=top style='padding-top: 2px;'><span valign=top class="dd" style='padding-left: 8px;'>
{if $language eq 'rus'}скачиваний{else}downloads{/if}</span> {$podcast.downloads}
</td></tr></table>
</td>


<td align=right valign=top>



<table border=0 cellpadding=2 cellspacing=0 valign=bottom>
<tr><td><span class="dd">{if $language eq 'rus'}просмотры{else}views{/if}:</span> {$podcast.views} </td></tr>
 
<tr><td><div nowrap><span class="dd">{if $language eq 'rus'}дата:{else}release date:{/if}</span> &nbsp;  {$podcast.release_date}</div></td></tr>
</table>


</td></tr>

<tr><td colspan=2>





<br><br><div align='justify' style="FONT-SIZE: 1.1em;">
{if $language eq 'rus'}{$podcast.text_rus}{else}{$podcast.text_eng}{/if}
</div>

</td></tr></table>


{include file="right_strip.tpl"}


{include file="footer.tpl"}