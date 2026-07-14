<!DOCTYPE html>
<HTML>
<HEAD>
{if $autoplay_title}
<TITLE>{$autoplay_title}</TITLE>
{else}
<TITLE>{$title} : {if $language eq 'rus'}Музыка для ZX Spectrum{else}ZX Spectrum music{/if} : AY, Beeper, Digital : zxtunes.com</TITLE>
{/if}

<meta name="keywords" content="ZX Spectrum, музыка, MP3, remixes, ZXTUNES, AY-3-8910, AY-3-8912, YM2149, music, modules, scene, chiptune, mod, composer, musician, {$title}"/>
<meta name="description" content="{if $author.id}{if $language eq 'rus' && $author.meta_description_ru}{$author.meta_description_ru|escape:'html'}{elseif $author.meta_description_en}{$author.meta_description_en|escape:'html'}{elseif $language eq 'rus'}ZXTUNES это крупнейшая в мире коллекция 8-битной музыки для компьютера ZX Spectrum{else}ZXTUNES it is world's biggest ZX Spectrum 8-bit music collection{/if}{elseif $language eq 'rus'}ZXTUNES это крупнейшая в мире коллекция 8-битной музыки для компьютера ZX Spectrum{else}ZXTUNES it is world's biggest ZX Spectrum 8-bit music collection{/if}"/>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>

{if $schema_jsonld}
<script type="application/ld+json">
{$schema_jsonld}
</script>
{/if}

{if $critical_css_inline}
<style id="zxtunes-critical">{$critical_css_inline}</style>
{/if}
<link rel="preload" href="/css/zxtunes.css?v={$css_v}" as="style" onload="this.onload=null;this.rel='stylesheet'">
<noscript><link rel="stylesheet" href="/css/zxtunes.css?v={$css_v}"></noscript>
{if $load_leaflet}
<link rel="preconnect" href="https://tile.openstreetmap.org" crossorigin>
<link rel="stylesheet" href="/css/leaflet/leaflet.css?v=1.9.4">
<style>
.page-authors-map .authors-map {
	width: 100%;
	height: min(70vh, 640px);
	min-height: 360px;
	border: 1px solid #dedbd8;
	border-radius: 4px;
	background: #f8f8f8;
}
@media (max-width: 768px) {
	.page-authors-map .authors-map {
		height: min(55vh, 420px);
		min-height: 280px;
	}
}
</style>
{/if}

<meta name="verify-v1" content="OlHdsBAsi/y17fbbfbH7yv5E4vWXtfwKbJOIuSaROVM=" />

</HEAD>
<BODY{if $body_class} class="{$body_class}"{/if} leftMargin="0" topMargin="8" marginheight="8" marginwidth="0">
