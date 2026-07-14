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



	


<table id="tb" style="padding: 4px;" border=0 cellpadding=0 cellspacing=0 width=600>

{section name=n loop=$playlist}

<tr>


<td width="26" align="center">
<div id="m{$playlist[n].id}" class="play" onclick="PlayB('{$playlist[n].id}')"></div>
<div id="n{$playlist[n].id}" style="display: none">{$playlist[n].next_id}</div>
<div id="p{$playlist[n].id}" style="display: none">{$playlist[n].prev_id}</div>
<div id="a{$playlist[n].id}" style="display: none">{$author_id}</div>
</td>

<td id="f{$playlist[n].id}" style="padding: 0; margin: 0; color: black"><a rel="nofollow" class='m' href='/downloads.php?id={$playlist[n].id}' 
title="{if $language eq 'rus'}Скачать {else}Download {/if} {$playlist[n].filename}">{$playlist[n].filename}</a>
{if $playlist[n].name} - {/if}
<span>{$playlist[n].name}</span>

</td>





<td id="t{$playlist[n].id}" style="color: #777; font: normal 10px Arial; width: 32px">{$playlist[n].time}</td>


<td style="display: none; padding-left: 8px; color: #777; width: 50px; font: normal 10px Arial; vertical-align:  middle"><img style="opacity: 0.3; vertical-align: bottom" src="/css/plays.png"> <span id="dw{$playlist[n].id}">{$playlist[n].downloads}</span></td>

<td style="width: 16px; padding-left: 4px"><img src="/images/type_{if $playlist[n].format eq 0}ay.png"  title="AY/YM song"{elseif $playlist[n].format eq 1}bp.png"  title="Beeper song"{elseif $playlist[n].format eq 2}ts.png" title="Turbo Sound song"{elseif $playlist[n].format eq 3}dg.png" title="Digital song"{/if}></td>

</tr>




<tr>
<td></td>
<td colspan=3 id="pl{$playlist[n].id}" style="margin-left: 32px; height: 17px; background-image: url(/line.png);  background-repeat: repeat-x"></td>

</tr>
{/section}

</table>
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
</body>
</html>