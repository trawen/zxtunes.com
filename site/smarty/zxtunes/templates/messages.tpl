{include file="menu.tpl"}

<H3>{if $language eq 'rus'}Гостевые сообщения - полный список{else}Guest messages - the full list{/if}</H3>




<br><br>
<table style="padding-left:16 px;" width=80% border=0>
{section name=n loop=$messages}
{cycle values=""}
<tr>
<td rowspan="2" valign=middle align=left width=1% style="padding-right: 8px;">
<table><tr><td style="padding: 4px; border: 1px solid #e0e0e0; COLOR: #909090;" >{$messages[n].nm}</tr></table></td>
<td valign=bottom align=left><div style="FONT-SIZE: 1.2em;">{if $messages[n].user_email}
{mailto extra='class="m"' address=$messages[n].user_email text=$messages[n].user_name encode="javascript"}
{else}<b>{$messages[n].user_name}</b>{/if}<noindex>
{if $messages[n].site}<a href="http://{$messages[n].site}" rel="nofollow"><img border=0 style="padding-left: 8px;" src="images/home.png"></a>{/if}</noindex>
</div>
</td>
<td align=right><span class=d>{$messages[n].update}</span></td>
</tr>

<tr>
<td valign=bottom style='border-top: 1px solid #dedbd8;' colspan=2>
<div align='justify' style="FONT-SIZE: 1.2em;">{$messages[n].message}</div></td>
</tr>
<tr><td><br></td></tr>
{/section}



</td></tr>
</table>


	  

      	  
{include file="right_strip.tpl"}
{include file="footer.tpl"}