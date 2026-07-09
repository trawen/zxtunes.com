{include file="menu.tpl"}
 
 
<div class="playlist_box">
<table width=100%><tr><td>

{if $language eq "rus"}

<strong style="font: bold 10pt Arial">ИНТЕРВЬЮ</strong> &nbsp; &nbsp; сортировать по &nbsp; 
<b>

{if $sort eq "playing"}

<a class="m" href="{$author.id|aurl}?sort=year">году</a> &nbsp;&nbsp; <a class="m" href="{$author.id|aurl}?sort=rating">языку</a>
 &nbsp;&nbsp; просмотрам

{elseif $sort eq "rating"}

 <a class="m" href="{$author.id|aurl}?sort=year">году</a> &nbsp;&nbsp; языку
 &nbsp;&nbsp; <a class="m" href="{$author.id|aurl}?sort=playing">просмотрам</a>

{else}

году &nbsp;&nbsp; <a class="m" href="{$author.id|aurl}?sort=rating">языку</a>
 &nbsp;&nbsp; <a class="m" href="{$author.id|aurl}?sort=playing">просмотрам</a>

{/if}
</b>

</td>
<td align="right">интервью <b>{$num_interviews}</b></td>



{else}


<strong style="font: bold 10pt Arial">INTERVIEWS</strong> &nbsp; &nbsp; sort by &nbsp; 
<b>

{if $sort eq "playing"}

<a class="m" href="{$author.id|aurl}?sort=year">year</a> &nbsp;&nbsp; <a class="m" href="{$author.id|aurl}?sort=rating">language</a>
 &nbsp;&nbsp; views

{elseif $sort eq "rating"}

 <a class="m" href="{$author.id|aurl}?sort=year">year</a> &nbsp;&nbsp; language
 &nbsp;&nbsp; <a class="m" href="{$author.id|aurl}?sort=playing">views</a>

{else}

year &nbsp;&nbsp; language
 &nbsp;&nbsp; <a class="m" href="{$author.id|aurl}?sort=playing">views</a>

{/if}
</b>



</td>
<td align="right">interviews <b>{$num_interviews}</b></td>

{/if}

</tr>
</table>
</div>



<br>















	
	
<table border=0 bgcolor=#ffffff cellpadding=2 cellspacing=0 width='100%'>


{section name=n loop=$interview}

<tr>
<td align="center" width=32>
<div class="photo_box">
{if $interview[n].photo}<img width=26 height=32 src="photo/60/{$interview[n].int_author_id}.jpg">{else}<img  width=26 height=32 src="css/wanted_60.png">{/if}
</div>
</td>



<td valign=middle nowrap style="line-height: 1.8">&nbsp; <a class=m href="{$interview[n].int_author_id|aurl}?md=3&interview={$interview[n].int_id}">{$interview[n].nickname}</a> ({if $interview[n].fist_name or $interview[n].last_name}{$interview[n].first_name} {$interview[n].last_name}{/if})<br> &nbsp; © {$interview[n].int_year} {$interview[n].int_author} ®


</td>
<td valign=middle nowrap>&#160;</td>
<td valign=middle nowrap>
{if $language eq 'rus'}
{if $interview[n].language}русский{else}английский{/if}
{else}
{if $interview[n].language}russian{else}english{/if}
{/if}
</td>
<td valign=middle align=left style="color: #888"><img src="css/views.png"> {$interview[n].int_views}</td>
</tr>

<tr><td></td><td colspan=4 style='padding: 2px;'><div style='border-bottom: 1px solid #F4F2F4;'></div></td></tr>

{/section}

</table>
	  
	  
  

     	  
{include file="right_strip.tpl"}
{include file="footer.tpl"}