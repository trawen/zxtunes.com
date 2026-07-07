{include file="menu.tpl"}

	
 

<H3>{if $language eq 'rus'}Новости{else}News{/if}</H3>

<br><br>
<table style="padding-left:4 px;" border=0>
{section name=n loop=$news}
{cycle values=""}
<tr>
<td rowspan="2" valign=top align=left width=1% style="padding-right: 8px;">
<table><tr><td style="padding: 4px; border: 1px solid #e0e0e0; COLOR: #909090;" >{$news[n].nm}</td></tr></table></td>
<td valign=bottom align=left><div style="FONT-SIZE: 1.3em;"><b>
{if $language eq 'rus'}{$news[n].topic_rus}{else}{$news[n].topic_eng}{/if}
</div>
</td>
<td align=right><span class=d>{$news[n].update}</span> | 
<span class=d>{if $language eq 'rus'}добавил{else}posted by{/if}  <b>{$news[n].username}</b></span></td>
</tr>

<tr>
<td valign=bottom style='border-top: 1px solid #dedbd8; padding-top: 4px;' colspan=2>
<div align='justify' style="FONT-SIZE: 1.2em;" class=news>
{if $language eq 'rus'}{$news[n].text_rus}{else}{$news[n].text_eng}{/if}<br><br>
</div></td></tr>

<tr><td valign=top colspan=3 align=right></td></tr>
<tr><td><br></td></tr>
{/section}

</table>






	  

      	  
{include file="right_strip.tpl"}


{include file="footer.tpl"}