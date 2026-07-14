{include file="menu.tpl"}



	<div class="zx-toolbar">
	<h3 class="zx-toolbar__title">
	{if $language eq 'rus'}Ремиксы в MP3 {else}MP3 Remixes{/if}&#160

	<div class="selector" style="DISPLAY: inline; FONT-SIZE: 0.9em;">
	<a {$mode[1]} href="{$sel_link}&md=1">{if $language eq 'rus'}игры{else}games{/if}</a>
	<a {$mode[2]} href="{$sel_link}&md=2">{if $language eq 'rus'}демо{else}demo{/if}</a>
	<a {$mode[3]} href="{$sel_link}&md=3">{if $language eq 'rus'}разное{else}others{/if}</a>
	<a {$mode[0]} href="{$sel_link}&md=0">{if $language eq 'rus'}все{else}all{/if}</a>
    </div>
	</h3>
	</div>



	
<div class="zx-pager-bar">
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div>
<div class="zx-pager-bar__count" style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}треки {else}tunes {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div>
</div><br>

	

	
	
<div class="zx-data-grid zx-data-grid--remix">
<div class="zx-data-grid__row zx-data-grid__row--head">

{if $language eq 'rus'}
<div class="zx-data-grid__cell"><b>Название</b></div>
<div class="zx-data-grid__cell"><b>Автор ремейка</b></div>
<div class="zx-data-grid__cell"><b>Композитор</b></div>
<div class="zx-data-grid__cell"><b>Год</b></div>
<div class="zx-data-grid__cell"><b>Комментарии</b></div>
<!--<div class="zx-data-grid__cell"><b>Добавлен</b></div>-->
<div class="zx-data-grid__cell"><b>Скачивания</b></div>
{else}
<div class="zx-data-grid__cell"><b>Title</b></div>
<div class="zx-data-grid__cell"><b>Remix author</b></div>
<div class="zx-data-grid__cell"><b>Composer</b></div>
<div class="zx-data-grid__cell"><b>Year</b></div>
<div class="zx-data-grid__cell"><b>Comment</b></div>
<div class="zx-data-grid__cell"><b>Dwns</b></div>
{/if}
</div>





{section name=n loop=$remixes}
<div class="zx-data-grid__row">
<div class="zx-data-grid__cell">
<strong>

{if $remixes[n].original_id}

{$remixes[n].title} <a class='m' href='/downloads.php?id={$remixes[n].id}&md=remix_mp3'>MP3</a> &nbsp; <a class='m' href='/downloads.php?id={$remixes[n].original_id}'>AY</a>

{else}

{$remixes[n].title} <a class='m' href='/downloads.php?id={$remixes[n].id}&md=remix_mp3'>MP3</a>

{/if}

</strong></div>
<div class="zx-data-grid__cell">{$remixes[n].author}</div>
<div class="zx-data-grid__cell">

{if $remixes[n].composer_name and $remixes[n].composer_id}

	<a class='m' href='{$remixes[n].composer_id|aurl}'>{$remixes[n].composer_name}</a>
	
{elseif $remixes[n].composer_name}

	{$remixes[n].composer_name}

{else}

		—

{/if}

</div>
<div class="zx-data-grid__cell">

{if $remixes[n].year} {$remixes[n].year} {else} — {/if}

</div>
<div class="zx-data-grid__cell">

{if $remixes[n].comment} {$remixes[n].comment} {else} — {/if}

</div>
<!--<div class="zx-data-grid__cell">{$tbtx[n][6]}</div>-->
<div class="zx-data-grid__cell">{$remixes[n].downloads}</div>
</div>
{/section}

</div>

  

<div class="zx-pager-bar">
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 1.2em;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> {$pages}</div>
<div class="zx-pager-bar__count" style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}треки {else}tunes {/if}</span> {$kl2} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$kl4}</div>
</div><br>
	  
	  
	  
	  
	  
     	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}
