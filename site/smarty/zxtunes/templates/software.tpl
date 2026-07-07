{include file="menu.tpl"}
 

	<table valign=bottom border=0 width=100% style="padding-bottom: 8px;"><tr><td valign=bottom><H3>
	{if $language eq 'rus'}Софт {else}Software {/if}&#160 
	
	<div class="selector" style="DISPLAY: inline; FONT-SIZE: 0.9em;">
	<a {$mode[1]} href="{$sel_link}?md=1">{if $language eq 'rus'}редакторы{else}editors {/if}</a>
	<a {$mode[2]} href="{$sel_link}?md=2">{if $language eq 'rus'}проигрыватели{else}players{/if}</a>
	<a {$mode[3]} href="{$sel_link}?md=3">{if $language eq 'rus'}утилиты{else}utilities{/if}</a>
	<a {$mode[0]} href="{$sel_link}?md=0">{if $language eq 'rus'}всё{else}all{/if}</a>
    </div>
	</h3>
	</td>
	<td align=right>
	
	
	
<table border=0 align=right><tr><td style='padding: 6px; border: 1px solid #eeebe8;'>

<table width=100% border=0 cellpadding=0 cellspacing=0 valign=bottom><tr><td>
<span class="dd">
{if $language eq 'rus'}просмотров{else}views{/if}</span></td><td style='padding-left: 4px;'>
 {$sf.views}
 </td></tr>
 
<tr><td>
<div nowrap><span class="dd">
{if $language eq 'rus'}обновление{else}last update{/if}</span></td><td style='padding-left: 4px;'>
 {$sf.update_}</div>
 </td></tr></table>

</td></tr></table>
	
	
	</td>
	</tr></table>
	

	
<table border=0 cellspacing='1' cellpadding='2'><tr><td valign=top><div style='float: left;'><table><tr><td>

{$soft_images}

</td><td> </td></tr></table></div>

{if !$soft_article} <div style='float: right;'> {/if}

<h3 class="roundedbox">{$sf.title} 
{if $sf.version} <div style="COLOR: #373737; DISPLAY: inline;"> version {$sf.version}</div> {/if} 
</h3>

<div class="soft_copyright">Copyright © {$sf.year} <b>{$sf.author}</b></div><br>

{if $sz[0].id_file}

{section name=n loop=$sz}
{cycle values=""}
<table cellpadding=0 cellspacing=0 border=0><tr><td>
<img src='css/dsk.png'></td><td style='padding-left: 8px;'><div class="soft_copyright"><a style='COLOR: #0063b0;' href='downloads.php?id={$sz[n].id_file}&md=software'><b>{$sf.title}{if $sf.version} {$sf.version}{/if}.zip</b></a> <span style="FONT-SIZE: 0.9em;">{$sz[n].feature} ({$sz[n].system} / {$sz[n].size}Kb)</span></div></td></tr>

<tr><td></td><td valign=top style='padding-top: 2px;'><span valign=top class="dd" style='padding-left: 8px;'>
{if $language eq 'rus'}скачиваний{else}downloads{/if}</span> {$sz[n].downloads}
</td></tr></table>
{/section}

{/if}














<br><br><div align='justify' style="FONT-SIZE: 1.1em;">{$soft_article}</div>
{if !$soft_article} </div> {/if}

</td></tr></table>
	
	  
	  
	  
	  
      	  
{include file="right_strip.tpl"}


{include file="footer.tpl"}