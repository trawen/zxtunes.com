{include file="menu.tpl"}

<div class="author-photo-page">
	<p class="author-photo-page__back">
		<a class="m" href="{$author_url}">← {$author.nickname}</a>
		<span class="d">({$back_label})</span>
	</p>
	<img class="author-photo-page__img photo" src="{$photo_url|escape}" alt="{$author.nickname|escape}" width="250" height="300">
</div>

{include file="right_strip.tpl"}
{include file="footer.tpl"}
