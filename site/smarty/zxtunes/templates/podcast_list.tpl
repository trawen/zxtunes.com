{include file="menu.tpl"}
 
 

<H3>{if $language eq 'rus'}Подкасты о спектрумовской музыке{else}ZX Spectrum music podcasts{/if}</h3>
		

	
	
	
<table border=0 cellpadding=6 cellspacing=0 width='100%' >
<tr height=18 bgcolor=#eeebe8>
{if $language eq 'rus'}
<td nowrap style="border-left: 1px solid #eeebe8; border-radius: 3px 0px 0px 3px"><b>Название</b></td>
<td nowrap><b>Синопсис</b></td>
<td nowrap><b>Дата</b></td>
<td nowrap style="border-left: 1px solid #eeebe8; border-radius: 0px 3px 3px 0px"><b>Прочитано</b></td>
</tr>
{else}
<td nowrap style="border-left: 1px solid #eeebe8; border-radius: 3px 0px 0px 3px"><b>Title</b></td>
<td nowrap><b>Synopsis</b></td>
<td nowrap><b>Date</b></td>
<td nowrap style="border-left: 1px solid #eeebe8; border-radius: 0px 3px 3px 0px"><b>Reads</b></td>
</tr>
{/if}


{section name=n loop=$tbtx}

<tr>
<td style='border-bottom: 1px solid #eeebe8;' valign=middle nowrap>{$tbtx[n][1]}</td>

<td style='border-bottom: 1px solid #eeebe8;' align=justify>
{if $language eq 'rus'}{$tbtx[n].sample_rus}{else}{$tbtx[n].sample_eng}{/if} &nbsp;
<a class=d style="color: red;" href="/podcast.php?id={$tbtx[n].id}">
{if $language eq 'rus'}читать {else}read {/if}</a>→<br><br>
</td>

<td style='border-bottom: 1px solid #eeebe8;' valign=middle nowrap>&nbsp;{$tbtx[n][3]}&nbsp;</td>
<td style='border-bottom: 1px solid #eeebe8;' valign=middle align=center>{$tbtx[n][4]}</td>
</tr>
{/section}

</table>
	  
	  

  

     	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}