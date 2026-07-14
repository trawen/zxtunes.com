{include file="menu.tpl"}

<div class="page-404">
	<h1 class="page-404__title">{if $language eq 'rus'}Страница не найдена{else}Page not found{/if}</h1>
	<p class="page-404__text">
		{if $language eq 'rus'}
		Запрошенная страница не существует или была удалена.
		{else}
		The requested page does not exist or has been removed.
		{/if}
	</p>
	<p class="page-404__links">
		<a class="m" href="/authors_list.php">{if $language eq 'rus'}Список музыкантов{else}Musicians list{/if}</a>
		·
		<a class="m" href="/news.php">{if $language eq 'rus'}Новости{else}News{/if}</a>
		·
		<a class="m" href="{$search_url}">{if $language eq 'rus'}Поиск{else}Search{/if}</a>
	</p>
</div>

{include file="right_strip.tpl"}
{include file="footer.tpl"}
