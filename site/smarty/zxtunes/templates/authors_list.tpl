{include file="menu.tpl"}
 


	<table border=0>
	<tr> 
    <td rowspan="2" vAlign=top style="PADDING-RIGHT: 0.4em;">

	<span vAlign=top style="FONT-WEIGHT: normal; FONT-SIZE: 1.9em; MARGIN: 0px 0px 0.5em"> {$au} </span>
	<span vAlign=top style="FONT-SIZE: 1.4em; DISPLAY: inline;">{$per} </span>
	<span vAlign=top style="FONT-WEIGHT: normal; FONT-SIZE: 1.9em; MARGIN: 0px 0px 2.5em; COLOR: #f09200;">
	{$srt}</span>
{*    <span class="dd" style="DISPLAY: inline;">{$kolvo}</span> *}
	
	<td>{$alfavit}</td>
    </tr>
	</table> 
	
<table width=100% border=0><tr><td align=left>
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div></td><td align=right><div style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}музыкантов {else}musicians {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div></td></tr></table><br>

	
<table border=0 bgcolor=#ffffff cellpadding=2 cellspacing=0 width='100%'>
<tr cellpadding=2 bgcolor=#dedbd8>
<td style='border-bottom: 1px solid #dedbd8;'>{$tb_title[0].link}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tb_title[1].link}</td>
<td style='border-bottom: 1px solid #dedbd8;' nowrap>{$tb_title[2].link}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tb_title[3].link}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tb_title[4].link}</td>
<td style='border-bottom: 1px solid #dedbd8;' nowrap>{$tb_title[5].link}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tb_title[6].link}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tb_title[7].link}</td>
<td style='border-bottom: 1px solid #dedbd8;' align=center nowrap>{$tb_title[8].link}</td>
<td style='border-bottom: 1px solid #dedbd8;' align=center nowrap>{$tb_title[9].link}</td>
<td style='border-bottom: 1px solid #dedbd8;' align=center nowrap>{$tb_title[10].link}</td> 
<td style='border-bottom: 1px solid #dedbd8;' align=center nowrap>{$tb_title[11].link}</td>
</tr>

{section name=n loop=$tbtx}
{cycle values=""}
<tr>
<td style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][0]}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][1]}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][2]}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][3]}</td>
<td align=center style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][4]}</td>
<td align=center style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][5]}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][6]}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][7]}</td>
<td align=center style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][8]}</td>
<td align=center style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][9]}</td>
<td align=center style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][10]}</td>
<td align=center style='border-bottom: 1px solid #dedbd8;'>{$tbtx[n][11]}</td>
</tr>
{/section}

</table>
	  

  
	  
<br>
<table width=100% border=0><tr><td align=left>
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 12px;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div></td><td align=right><div style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}музыкантов {else}musicians {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div></td></tr></table><br>
	  



	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}