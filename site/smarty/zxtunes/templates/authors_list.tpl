{include file="menu.tpl"}

<div class="authors-page">

<header class="authors-page__header">
	<div class="authors-page__title">
		<span class="authors-page__title-main">{$au}</span>
		<span class="authors-page__title-per">{$per}</span>
		<span class="authors-page__title-sort">{$srt}</span>
	</div>
	<div class="authors-page__alpha">{$alfavit}</div>
</header>

<div class="authors-toolbar">
	<div class="authors-toolbar__pages" id="Navigator2">
		<span class="authors-toolbar__label">{if $language eq 'rus'}Страницы:{else}Pages:{/if}</span>
		{$pages}
	</div>
	<div class="authors-toolbar__count">
		<span class="dd">{if $language eq 'rus'}музыкантов{else}musicians{/if}</span>
		{$kl2}
		<span class="dd">{if $language eq 'rus'}из{else}from{/if}</span>
		{$kl4}
	</div>
</div>

<div class="authors-grid-wrap">
<div class="authors-grid" role="table" aria-label="{if $language eq 'rus'}Список музыкантов{else}Musicians list{/if}">
	<div class="authors-grid__row authors-grid__row--head" role="row">
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--nick" role="columnheader">{$tb_title[0].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--group" role="columnheader">{$tb_title[1].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--country" role="columnheader">{$tb_title[2].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--city" role="columnheader">{$tb_title[3].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--years" role="columnheader">{$tb_title[4].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--num" role="columnheader">{$tb_title[5].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--meta" role="columnheader">{$tb_title[6].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--meta" role="columnheader">{$tb_title[7].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--meta" role="columnheader">{$tb_title[8].link}</div>
		<div class="authors-grid__cell authors-grid__cell--head authors-grid__cell--views" role="columnheader">{$tb_title[9].link}</div>
	</div>

{section name=n loop=$tbtx}
	<div class="authors-grid__row" role="row">
		<div class="authors-grid__cell authors-grid__cell--nick" role="cell">{$tbtx[n][0]}</div>
		<div class="authors-grid__cell authors-grid__cell--group" role="cell">{$tbtx[n][1]}</div>
		<div class="authors-grid__cell authors-grid__cell--country" role="cell">{$tbtx[n][2]}</div>
		<div class="authors-grid__cell authors-grid__cell--city" role="cell">{$tbtx[n][3]}</div>
		<div class="authors-grid__cell authors-grid__cell--years" role="cell">{$tbtx[n][4]}</div>
		<div class="authors-grid__cell authors-grid__cell--num" role="cell">{$tbtx[n][5]}</div>
		<div class="authors-grid__cell authors-grid__cell--meta" role="cell">{$tbtx[n][6]}</div>
		<div class="authors-grid__cell authors-grid__cell--meta" role="cell">{$tbtx[n][7]}</div>
		<div class="authors-grid__cell authors-grid__cell--meta" role="cell">{$tbtx[n][8]}</div>
		<div class="authors-grid__cell authors-grid__cell--views" role="cell">{$tbtx[n][9]}</div>
	</div>
{/section}

</div>
</div>

<div class="authors-toolbar authors-toolbar--bottom">
	<div class="authors-toolbar__pages" id="Navigator2">
		<span class="authors-toolbar__label">{if $language eq 'rus'}Страницы:{else}Pages:{/if}</span>
		{$pages}
	</div>
	<div class="authors-toolbar__count">
		<span class="dd">{if $language eq 'rus'}музыкантов{else}musicians{/if}</span>
		{$kl2}
		<span class="dd">{if $language eq 'rus'}из{else}from{/if}</span>
		{$kl4}
	</div>
</div>

</div>

{include file="right_strip.tpl"}

{include file="footer.tpl"}
