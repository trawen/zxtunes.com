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

<LINK href="/css/zxtunes.css?v={$css_v}" type=text/css rel=stylesheet>


<meta name="verify-v1" content="OlHdsBAsi/y17fbbfbH7yv5E4vWXtfwKbJOIuSaROVM=" />
<script type="text/javascript" src="/js/blocker.js"></script>
<script type="text/javascript" src="/js/swfobject.js"></script>	
<SCRIPT type="text/javascript" src="/js/jquery-1.6.4.min.js"></SCRIPT>

</HEAD>
<BODY{if $body_class} class="{$body_class}"{/if} leftMargin="0" topMargin="8" marginheight="8" marginwidth="0">
