{include file="menu.tpl"}
 
 

	<table valign=bottom border=0><tr><td valign=bottom><H3>
	{if $language eq 'rus'}Софт {else}Software {/if}&#160 
	
	<div class="selector" style="DISPLAY: inline; FONT-SIZE: 0.9em;">
	<a {$mode[1]} href="{$sel_link}&md=1">{if $language eq 'rus'}редакторы{else}editors {/if}</a>
	<a {$mode[2]} href="{$sel_link}&md=2">{if $language eq 'rus'}проигрыватели{else}players{/if}</a>
	<a {$mode[3]} href="{$sel_link}&md=3">{if $language eq 'rus'}утилиты{else}utilities{/if}</a>
	<a {$mode[0]} href="{$sel_link}&md=0">{if $language eq 'rus'}всё{else}all{/if}</a>
    </div>
	</h3>
	</td></tr></table>

	

	
<table width=100% border=0><tr><td align=left>
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div></td><td align=right><div style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}программы {else}software {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div></td></tr></table><br>

<script type="text/javascript"><!--
ay = "03578";
music = "079";
rulez = "330";
google_ad_client = "pub-"+ay+"893"+music+"77"+rulez;
/* 728x90, создано 20.05.09 */
google_ad_slot = "8705651593";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
	
<table border=0 bgcolor=#ffffff cellpadding=2 cellspacing=0 width='100%'>
<tr cellpadding=2 bgcolor=#dedbd8>
<td style='border-bottom: 1px solid #dedbd8;' align=left nowrap>№</td>
<td style='border-bottom: 1px solid #dedbd8;' nowrap>{$tb_title[1].link}</td>
<td style='border-bottom: 1px solid #dedbd8;'>{$tb_title[2].link}</td>
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

<script type="text/javascript"><!--
ay = "03578";
music = "079";
rulez = "330";
google_ad_client = "pub-"+ay+"893"+music+"77"+rulez;
/* 728x90, создано 20.05.09 */
google_ad_slot = "8705651593";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>	  

<table width=100% border=0><tr><td align=left>
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div></td><td align=right><div style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}программы {else}software {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div></td></tr></table><br>
	  
	  

     	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}