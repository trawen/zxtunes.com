{include file="menu.tpl"}
 

	<div class="zx-soft-page__head">
	<h3 class="zx-toolbar__title">
	{if $language eq 'rus'}Софт {else}Software {/if}&#160

	<div class="selector" style="DISPLAY: inline; FONT-SIZE: 0.9em;">
	<a {$mode[1]} href="{$sel_link}?md=1">{if $language eq 'rus'}редакторы{else}editors {/if}</a>
	<a {$mode[2]} href="{$sel_link}?md=2">{if $language eq 'rus'}проигрыватели{else}players{/if}</a>
	<a {$mode[3]} href="{$sel_link}?md=3">{if $language eq 'rus'}утилиты{else}utilities{/if}</a>
	<a {$mode[0]} href="{$sel_link}?md=0">{if $language eq 'rus'}всё{else}all{/if}</a>
    </div>
	</h3>

	<div class="zx-meta-box">

	<div class="zx-meta-box__row">
<span class="dd">
{if $language eq 'rus'}просмотров{else}views{/if}</span>
 {$sf.views}
 </div>

	<div class="zx-meta-box__row">
<span class="dd">
{if $language eq 'rus'}обновление{else}last update{/if}</span>
 {$sf.update_}
 </div>

	</div>
	</div>


	
<div class="zx-soft-page__body">
<div class="zx-soft-page__media">

{$soft_images}

</div>

<div class="zx-soft-page__main">

<h3 class="roundedbox">{$sf.title} 
{if $sf.version} <div style="COLOR: #373737; DISPLAY: inline;"> version {$sf.version}</div> {/if} 
</h3>

<div class="soft_copyright">Copyright © {$sf.year} <b>{$sf.author}</b></div><br>

{if $sz[0].id_file}

{section name=n loop=$sz}
{cycle values=""}
<div class="zx-soft-dl">
<img src='css/dsk.png'>
<div class="soft_copyright"><a style='COLOR: #0063b0;' href='downloads.php?id={$sz[n].id_file}&md=software'><b>{$sf.title}{if $sf.version} {$sf.version}{/if}.zip</b></a> <span style="FONT-SIZE: 0.9em;">{$sz[n].feature} ({$sz[n].system} / {$sz[n].size}Kb)</span></div>
<div class="zx-soft-dl__meta"><span class="dd">
{if $language eq 'rus'}скачиваний{else}downloads{/if}</span> {$sz[n].downloads}
</div>
</div>
{/section}

{/if}








<br><br><div align='justify' style="FONT-SIZE: 1.1em;">{$soft_article}</div>

</div>
</div>
	
	  
	  
	  
	  
      	  
{include file="right_strip.tpl"}


{include file="footer.tpl"}
