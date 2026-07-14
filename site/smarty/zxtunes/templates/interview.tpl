{include file="menu.tpl"}
 
 
<div class="playlist_box">
<div class="zx-toolbar">

{if $language eq "rus"}

<div class="zx-toolbar__title">
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
</div>
<div>интервью <b>{$num_interviews}</b></div>



{else}


<div class="zx-toolbar__title">
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
</div>

<div>interviews <b>{$num_interviews}</b></div>

{/if}

</div>
</div>



<br>















	
	
<div class="zx-interview-list">


{section name=n loop=$interview}

<div class="zx-interview-item">
<div class="zx-interview-item__photo">
<div class="photo_box">
{if $interview[n].photo}<img width=26 height=32 src="photo/60/{$interview[n].int_author_id}.jpg">{else}<img  width=26 height=32 src="css/wanted_60.png">{/if}
</div>
</div>



<div style="line-height: 1.8">&nbsp; <a class=m href="{$interview[n].int_author_id|aurl}?md=3&interview={$interview[n].int_id}">{$interview[n].nickname}</a> ({if $interview[n].fist_name or $interview[n].last_name}{$interview[n].first_name} {$interview[n].last_name}{/if})<br> &nbsp; © {$interview[n].int_year} {$interview[n].int_author} ®


</div>
<div>
{if $language eq 'rus'}
{if $interview[n].language}русский{else}английский{/if}
{else}
{if $interview[n].language}russian{else}english{/if}
{/if}
</div>
<div style="color: #888"><img src="css/views.png"> {$interview[n].int_views}</div>
</div>

{/section}

</div>
	  
	  
  

     	  
{include file="right_strip.tpl"}
{include file="footer.tpl"}
