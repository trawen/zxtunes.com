<!DOCTYPE html>
<HTML>
<HEAD>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

<LINK href="/css/zxtunes.css" type=text/css rel=stylesheet>
<LINK href="/js/tipsy.css" type=text/css rel=stylesheet>

<script type="text/javascript" src="/js/swfobject.js"></script>

<script type="text/javascript" src="/css/jquery.js"></script>
<script language="javascript">
var autoplay = "0";
var author_id = "{$author_id}";
var first_track = "{$playlist[0].id}";
</script>
<script type="text/javascript" src="/css/embed_player.js"></script> 

</HEAD>
<BODY>



	


<div class="zx-embed-list" id="tb">

{section name=n loop=$playlist}

<div class="zx-embed-row">

<div>
<div id="m{$playlist[n].id}" class="play" onclick="PlayB('{$playlist[n].id}')"></div>
<div id="n{$playlist[n].id}" style="display: none">{$playlist[n].next_id}</div>
<div id="p{$playlist[n].id}" style="display: none">{$playlist[n].prev_id}</div>
<div id="a{$playlist[n].id}" style="display: none">{$author_id}</div>
</div>

<div id="f{$playlist[n].id}" style="padding: 0; margin: 0; color: black"><a rel="nofollow" class='m' href='/downloads.php?id={$playlist[n].id}' 
title="{if $language eq 'rus'}Скачать {else}Download {/if} {$playlist[n].filename}">{$playlist[n].filename}</a>
{if $playlist[n].name} - {/if}
<span>{$playlist[n].name}</span>

</div>

<div id="t{$playlist[n].id}" style="color: #777; font: normal 10px Arial">{$playlist[n].time}</div>

<div style="display: none; padding-left: 8px; color: #777; font: normal 10px Arial; vertical-align: middle"><img style="opacity: 0.3; vertical-align: bottom" src="/css/plays.png"> <span id="dw{$playlist[n].id}">{$playlist[n].downloads}</span></div>

<div><img src="/images/type_{if $playlist[n].format eq 0}ay.png"  title="AY/YM song"{elseif $playlist[n].format eq 1}bp.png"  title="Beeper song"{elseif $playlist[n].format eq 2}ts.png" title="Turbo Sound song"{elseif $playlist[n].format eq 3}dg.png" title="Digital song"{/if}></div>

</div>

<div id="pl{$playlist[n].id}" class="zx-embed-line"></div>
{/section}

</div>
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
</body>
</html>
