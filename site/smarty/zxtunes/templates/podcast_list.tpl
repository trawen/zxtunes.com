{include file="menu.tpl"}
 
 

<H3>{if $language eq 'rus'}Подкасты о спектрумовской музыке{else}ZX Spectrum music podcasts{/if}</h3>
		

	
	
	
<div class="zx-data-grid zx-data-grid--podcast">
<div class="zx-data-grid__row zx-data-grid__row--head">
{if $language eq 'rus'}
<div class="zx-data-grid__cell"><b>Название</b></div>
<div class="zx-data-grid__cell"><b>Синопсис</b></div>
<div class="zx-data-grid__cell"><b>Дата</b></div>
<div class="zx-data-grid__cell"><b>Прочитано</b></div>
{else}
<div class="zx-data-grid__cell"><b>Title</b></div>
<div class="zx-data-grid__cell"><b>Synopsis</b></div>
<div class="zx-data-grid__cell"><b>Date</b></div>
<div class="zx-data-grid__cell"><b>Reads</b></div>
{/if}
</div>


{section name=n loop=$tbtx}

<div class="zx-data-grid__row">
<div class="zx-data-grid__cell">{$tbtx[n][1]}</div>

<div class="zx-data-grid__cell" style="text-align: justify;">
{if $language eq 'rus'}{$tbtx[n].sample_rus}{else}{$tbtx[n].sample_eng}{/if} &nbsp;
<a class=d style="color: red;" href="/podcast.php?id={$tbtx[n].id}">
{if $language eq 'rus'}читать {else}read {/if}</a>→<br><br>
</div>

<div class="zx-data-grid__cell">&nbsp;{$tbtx[n][3]}&nbsp;</div>
<div class="zx-data-grid__cell">{$tbtx[n][4]}</div>
</div>
{/section}

</div>
	  
	  

  

     	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}
