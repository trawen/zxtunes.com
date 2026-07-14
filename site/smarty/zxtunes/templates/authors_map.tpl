{include file="menu.tpl"}

<header class="authors-map__header">
	<h1 class="authors-map__title">{if $language eq 'rus'}Карта музыкантов{else}Musicians map{/if}</h1>
	<p class="authors-map__summary">
		{if $language eq 'rus'}
		<b>{$map_musicians}</b> музыкантов в <b>{$map_cities}</b> городах на карте. Размер и насыщенность кружка — число музыкантов в городе.
		{else}
		<b>{$map_musicians}</b> musicians in <b>{$map_cities}</b> cities on the map. Circle size and color intensity reflect the number of musicians in each city.
		{/if}
	</p>
</header>

<div id="authors-map" class="authors-map" role="img" aria-label="{if $language eq 'rus'}Карта городов с музыкантами{else}Map of cities with musicians{/if}"></div>

<section class="authors-map-top">
	<h2 class="authors-map-top__title">{if $language eq 'rus'}TOP 50 городов{else}TOP 50 cities{/if}</h2>
	<div class="authors-map-top__list">
		{foreach from=$top_cities item=city name=top}
		<div class="authors-map-top__row">
			<div class="authors-map-top__city">
				<span class="authors-map-top__rank">{$smarty.foreach.top.iteration}.</span>{if $city.flag_url}<img class="flag authors-map-top__flag" src="{$city.flag_url|escape}" width="16" height="10" alt="">{/if}<span class="authors-map-top__city-text"><a class="mm" href="/authors_list.php?letter=ALL&amp;order=city&amp;up=ASC&amp;sr={if $language eq 'rus'}{$city.city_ru|escape:'url'}{else}{$city.city_en|escape:'url'}{/if}">{if $language eq 'rus'}{$city.city_ru|escape}{else}{$city.city_en|escape}{/if}</a>{if ($language eq 'rus' && $city.country_ru) || ($language neq 'rus' && $city.country_en)}<span class="authors-map-top__country">, {if $language eq 'rus'}{$city.country_ru|escape}{else}{$city.country_en|escape}{/if}</span>{/if}<span class="authors-map-top__count"> — {$city.count} {$city.count_label}</span></span>
			</div>
			<div class="authors-map-top__musicians">
				{foreach from=$city.authors item=author name=auth}
				<a class="mm authors-map-top__musician" style="font-size: {$author.font_size}px" href="{$author.id|aurl}">{$author.nickname|escape}</a>{if !$smarty.foreach.auth.last}<span class="authors-map-top__sep">, </span>{/if}
				{/foreach}
			</div>
		</div>
		{/foreach}
	</div>
</section>

<script type="application/json" id="authors-map-data">{$map_points_json}</script>
<script defer src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
<script defer type="text/javascript">
{literal}
(function () {
	var dataEl = document.getElementById('authors-map-data');
	var points = [];
	if (dataEl) {
		try {
			points = JSON.parse(dataEl.textContent);
		} catch (e) {
			points = [];
		}
	}
	var lang = '{/literal}{if $language eq 'rus'}rus{else}eng{/if}{literal}';
	var mapEl = document.getElementById('authors-map');
	if (!mapEl || !window.L || !points.length) {
		return;
	}

	var map = L.map('authors-map', {
		worldCopyJump: true,
		scrollWheelZoom: true
	});

	L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
		maxZoom: 18,
		attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
	}).addTo(map);

	var maxCount = 1;
	for (var i = 0; i < points.length; i++) {
		if (points[i].count > maxCount) {
			maxCount = points[i].count;
		}
	}

	function radiusForCount(count) {
		var radius = 4 + Math.sqrt(count / maxCount) * 22;
		if (count === 1) {
			radius *= 0.5;
		}
		return radius;
	}

	function intensityForCount(count) {
		if (count === 1) {
			return 0;
		}
		return Math.sqrt(count / maxCount);
	}

	function hexToRgb(hex) {
		var n = parseInt(hex.slice(1), 16);
		return [n >> 16, (n >> 8) & 255, n & 255];
	}

	function rgbToHex(r, g, b) {
		return '#' + [r, g, b].map(function (channel) {
			var hex = Math.round(channel).toString(16);
			return hex.length === 1 ? '0' + hex : hex;
		}).join('');
	}

	function mixColor(from, to, t) {
		var a = hexToRgb(from);
		var b = hexToRgb(to);
		return rgbToHex(
			a[0] + (b[0] - a[0]) * t,
			a[1] + (b[1] - a[1]) * t,
			a[2] + (b[2] - a[2]) * t
		);
	}

	function colorForCount(count) {
		return mixColor('#6d8299', '#2f3d52', intensityForCount(count));
	}

	function strokeForCount(count) {
		return mixColor('#556a82', '#1f2835', intensityForCount(count));
	}

	function fillOpacityForCount(count) {
		return 0.72 + intensityForCount(count) * 0.23;
	}

	function cityLabel(p) {
		if (lang === 'rus') {
			return p.city_ru || p.city_en;
		}
		return p.city_en || p.city_ru;
	}

	function countryLabel(p) {
		if (lang === 'rus') {
			return p.country_ru || p.country_en;
		}
		return p.country_en || p.country_ru;
	}

	function musiciansWord(n) {
		if (lang !== 'rus') {
			return n === 1 ? 'musician' : 'musicians';
		}
		var mod10 = n % 10;
		var mod100 = n % 100;
		if (mod10 === 1 && mod100 !== 11) {
			return 'музыкант';
		}
		if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
			return 'музыканта';
		}
		return 'музыкантов';
	}

	var bounds = [];

	for (var j = 0; j < points.length; j++) {
		var point = points[j];
		var latLng = [point.lat, point.lng];
		bounds.push(latLng);

		var city = cityLabel(point);
		var country = countryLabel(point);
		var listCity = lang === 'rus' ? (point.city_ru || point.city_en) : (point.city_en || point.city_ru);
		var href = '/authors_list.php?letter=ALL&order=city&up=ASC&sr=' + encodeURIComponent(listCity);

		var popup = '<div class="authors-map-popup">'
			+ '<strong>' + city + '</strong>'
			+ (country ? '<br><span class="authors-map-popup__country">' + country + '</span>' : '')
			+ '<br>' + point.count + ' ' + musiciansWord(point.count)
			+ '<br><a href="' + href + '">' + (lang === 'rus' ? 'Список музыкантов' : 'Musicians list') + '</a>'
			+ '</div>';

		L.circleMarker(latLng, {
			radius: radiusForCount(point.count),
			fillColor: colorForCount(point.count),
			color: strokeForCount(point.count),
			weight: 1.2,
			opacity: 0.95,
			fillOpacity: fillOpacityForCount(point.count)
		}).bindPopup(popup).addTo(map);
	}

	function setMapView() {
		if (bounds.length) {
			map.setView(L.latLngBounds(bounds).getCenter(), 4.5);
		} else {
			map.setView([30, 20], 1);
		}
	}

	setMapView();

	window.addEventListener('resize', function () {
		map.invalidateSize();
	});
	setTimeout(function () {
		map.invalidateSize();
		setMapView();
	}, 150);
})();
{/literal}
</script>

{include file="right_strip.tpl"}
{include file="footer.tpl"}
