{include file="top.tpl"}


<header class="site-header">
<div class="tpmenu">
	<div class="tpmenu__bar">
		<div class="tpmenu__logo">
			<img height="34" alt="zxtunes.com" title="zxtunes.com" src="/css/zxtunes_logo.png" width="104">
		</div>

		<nav class="tpmenu__nav" aria-label="{if $language eq 'rus'}Главное меню{else}Main menu{/if}">
			<a {$active.news} href="/news.php">{if $language eq 'rus'}новости{else}news{/if}</a>
			<a {$active.authors} href="/authors_list.php">{if $language eq 'rus'}музыканты{else}musicians{/if}</a>
			<a {$active.authors_map} href="{$authors_map_url}">{if $language eq 'rus'}карта{else}map{/if}</a>
			<a {$active.soft} href="/software_list.php">{if $language eq 'rus'}софт{else}software{/if}</a>
			<a {$active.interview} href="/interview.php">{if $language eq 'rus'}интервью{else}interviews{/if}</a>
			<a {$active.podcasts} href="/podcast_list.php">{if $language eq 'rus'}подкасты{else}podcasts{/if}</a>
			<a {$active.stats} href="/stats.php">{if $language eq 'rus'}статистика{else}stats{/if}</a>
			<a {$active.remix_mp3} href="/remix_mp3.php">{if $language eq 'rus'}ремиксы в MP3{else}MP3 remixes{/if}</a>
			<a {$active.faq} href="/faq.php">{if $language eq 'rus'}чаво{else}faq{/if}</a>
		</nav>

		<button type="button" class="tpmenu__burger" id="tpmenu-burger" aria-expanded="false" aria-controls="mobile-nav" aria-label="{if $language eq 'rus'}Открыть меню{else}Open menu{/if}" data-label-open="{if $language eq 'rus'}Открыть меню{else}Open menu{/if}" data-label-close="{if $language eq 'rus'}Закрыть меню{else}Close menu{/if}">
			<span class="tpmenu__burger-line"></span>
			<span class="tpmenu__burger-line"></span>
			<span class="tpmenu__burger-line"></span>
		</button>

		<div class="tpmenu__aside">
			<form class="site-search" method="get" action="{$search_url}">
				<input class="site-search__input" type="search" name="srtext" value="{$search_query|escape}" maxlength="31" placeholder="{if $language eq 'rus'}поиск…{else}search…{/if}" aria-label="{if $language eq 'rus'}Поиск{else}Search{/if}">
				<button class="site-search__btn" type="submit" name="submit" value="OK">OK</button>
			</form>
			<img class="tpmenu__rainbow" title="zx-spectrum" height="34" src="/css/rainbow.png" width="12" alt="">
		</div>
	</div>

	<nav class="mobile-nav" id="mobile-nav" aria-hidden="true" aria-label="{if $language eq 'rus'}Мобильное меню{else}Mobile menu{/if}">
		<div class="mobile-nav__panel">
			<a {$active.authors} href="/authors_list.php">{if $language eq 'rus'}Список музыкантов{else}Musicians list{/if}</a>
			<a {$active.soft} href="/software_list.php">{if $language eq 'rus'}Софт{else}Software{/if}</a>
			<a {$active.podcasts} href="/podcast_list.php">{if $language eq 'rus'}Подкасты{else}Podcasts{/if}</a>
			<a {$active.remix_mp3} href="/remix_mp3.php">{if $language eq 'rus'}Ремиксы в MP3{else}MP3 remixes{/if}</a>
			<a {$active.authors_map} href="{$authors_map_url}">{if $language eq 'rus'}Карта музыкантов{else}Musicians map{/if}</a>
			<a {$active.news} href="/news.php">{if $language eq 'rus'}Новости{else}News{/if}</a>
		</div>
	</nav>
</div>
<script>
{literal}
(function () {
	var burger = document.getElementById('tpmenu-burger');
	var nav = document.getElementById('mobile-nav');
	var header = document.querySelector('.site-header');
	if (!burger || !nav) {
		return;
	}
	function setOpen(open) {
		burger.setAttribute('aria-expanded', open ? 'true' : 'false');
		burger.setAttribute('aria-label', open
			? burger.getAttribute('data-label-close')
			: burger.getAttribute('data-label-open'));
		nav.setAttribute('aria-hidden', open ? 'false' : 'true');
		nav.classList.toggle('mobile-nav--open', open);
		if (header) {
			header.classList.toggle('site-header--menu-open', open);
		}
		burger.classList.toggle('tpmenu__burger--open', open);
	}
	burger.addEventListener('click', function () {
		setOpen(burger.getAttribute('aria-expanded') !== 'true');
	});
	document.addEventListener('keydown', function (e) {
		if (e.key === 'Escape') {
			setOpen(false);
		}
	});
})();
{/literal}
</script>

<div class="site-header__sub">
	<div class="site-header__tagline d">
		<img src="/css/sinclair_zx_spectrum.png" alt=""> ZX Spectrum music collection
	</div>

	<div class="site-header__meta d">
		<form class="site-search site-search--mobile" method="get" action="{$search_url}">
			<input class="site-search__input" type="search" name="srtext" value="{$search_query|escape}" maxlength="31" placeholder="{if $language eq 'rus'}поиск…{else}search…{/if}" aria-label="{if $language eq 'rus'}Поиск{else}Search{/if}">
			<button class="site-search__btn" type="submit" name="submit" value="OK">OK</button>
		</form>
		{if $language eq 'rus'}
		<span class="site-header__lang-active">rus</span> <a href="{$tkurl}ln=eng" class="site-header__lang-inactive">eng</a>
		{else}
		<a href="{$tkurl}ln=rus" class="site-header__lang-inactive">rus</a> <span class="site-header__lang-active">eng</span>{/if}
	</div>
</div>
</header>




<div class="site-layout">
<main class="site-layout__main">
