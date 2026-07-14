{include file="menu.tpl"}



	<div class="zx-toolbar">
	<h3 class="zx-toolbar__title">
	{if $language eq 'rus'}Софт {else}Software {/if}&#160

	<div class="selector" style="DISPLAY: inline; FONT-SIZE: 0.9em;">
	<a {$mode[1]} href="{$sel_link}&md=1">{if $language eq 'rus'}редакторы{else}editors {/if}</a>
	<a {$mode[2]} href="{$sel_link}&md=2">{if $language eq 'rus'}проигрыватели{else}players{/if}</a>
	<a {$mode[3]} href="{$sel_link}&md=3">{if $language eq 'rus'}утилиты{else}utilities{/if}</a>
	<a {$mode[0]} href="{$sel_link}&md=0">{if $language eq 'rus'}всё{else}all{/if}</a>
    </div>
	</h3>
	</div>



	
<div class="zx-pager-bar">
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div>
<div class="zx-pager-bar__count" style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}программы {else}software {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div>
</div><br>

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
	
<div class="zx-data-grid zx-data-grid--software">
<div class="zx-data-grid__row zx-data-grid__row--head">
<div class="zx-data-grid__cell">№</div>
<div class="zx-data-grid__cell">{$tb_title[1].link}</div>
<div class="zx-data-grid__cell">{$tb_title[2].link}</div>
<div class="zx-data-grid__cell">{$tb_title[3].link}</div>
<div class="zx-data-grid__cell">{$tb_title[4].link}</div>
<div class="zx-data-grid__cell">{$tb_title[5].link}</div>
<div class="zx-data-grid__cell">{$tb_title[6].link}</div>
</div>

{section name=n loop=$tbtx}
{cycle values=""}
<div class="zx-data-grid__row">
<div class="zx-data-grid__cell"><div style="COLOR: #909090;">{$tbtx[n][0]}&#160</div></div>
<div class="zx-data-grid__cell">{$tbtx[n][1]}</div>
<div class="zx-data-grid__cell">{$tbtx[n][2]}</div>
<div class="zx-data-grid__cell">{$tbtx[n][3]}</div>
<div class="zx-data-grid__cell">{$tbtx[n][4]}</div>
<div class="zx-data-grid__cell">{$tbtx[n][5]}</div>
<div class="zx-data-grid__cell">{$tbtx[n][6]}</div>
</div>
{/section}

</div>

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

<div class="zx-pager-bar">
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div>
<div class="zx-pager-bar__count" style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}программы {else}software {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div>
</div><br>
	  
	  

     	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}
