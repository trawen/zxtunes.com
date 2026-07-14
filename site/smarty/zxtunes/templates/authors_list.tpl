{include file="menu.tpl"}

<div class="authors-page">

<header class="authors-page__header">
	<div class="authors-page__title-row">
		<h1 class="authors-page__title">{if $language eq 'rus'}Список музыкантов на ZX Spectrum{else}ZX Spectrum musicians list{/if}</h1>
		<span class="authors-page__count">{$kl2} / {$kl4}</span>
	</div>
	<div class="authors-page__alpha">{$alfavit}</div>
</header>

<div class="authors-toolbar">
	<div class="authors-toolbar__pages" id="Navigator2">
		<span class="authors-toolbar__label">{if $language eq 'rus'}Страницы:{else}Pages:{/if}</span>
		<span class="authors-toolbar__pages-nav authors-toolbar__pages-nav--desktop">{$pages}</span>
		<span class="authors-toolbar__pages-nav authors-toolbar__pages-nav--mobile">{$pages_mobile}</span>
	</div>
</div>

<div class="authors-grid-wrap">
<div class="authors-grid" aria-label="{if $language eq 'rus'}Список музыкантов{else}Musicians list{/if}">
	<div class="authors-grid__row authors-grid__row--head">
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--nick">{$tb_title[0].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--group">{$tb_title[1].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--country">{$tb_title[2].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--city">{$tb_title[3].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--years">{$tb_title[4].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--num">{$tb_title[5].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--meta">{$tb_title[6].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--meta">{$tb_title[7].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--meta">{$tb_title[8].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--views">{$tb_title[9].link}</div>
	</div>

{section name=n loop=$tbtx}
	<div class="authors-grid__row">
		<div class="authors-grid__cell authors-grid__cell--nick">{$tbtx[n][0]}</div>
		<div class="authors-grid__cell authors-grid__cell--group">{$tbtx[n][1]}</div>
		<div class="authors-grid__cell authors-grid__cell--country">{$tbtx[n][2]}</div>
		<div class="authors-grid__cell authors-grid__cell--city">{$tbtx[n][3]}</div>
		<div class="authors-grid__cell authors-grid__cell--years">{$tbtx[n][4]}</div>
		<div class="authors-grid__cell authors-grid__cell--num">{$tbtx[n][5]}</div>
		<div class="authors-grid__cell authors-grid__cell--meta">{$tbtx[n][6]}</div>
		<div class="authors-grid__cell authors-grid__cell--meta">{$tbtx[n][7]}</div>
		<div class="authors-grid__cell authors-grid__cell--meta">{$tbtx[n][8]}</div>
		<div class="authors-grid__cell authors-grid__cell--views">{$tbtx[n][9]}</div>
	</div>
{/section}

</div>
</div>

<div class="authors-toolbar authors-toolbar--bottom">
	<div class="authors-toolbar__pages" id="Navigator2">
		<span class="authors-toolbar__label">{if $language eq 'rus'}Страницы:{else}Pages:{/if}</span>
		<span class="authors-toolbar__pages-nav authors-toolbar__pages-nav--desktop">{$pages}</span>
		<span class="authors-toolbar__pages-nav authors-toolbar__pages-nav--mobile">{$pages_mobile}</span>
	</div>
</div>

</div>

{include file="right_strip.tpl"}

{include file="footer.tpl"}
