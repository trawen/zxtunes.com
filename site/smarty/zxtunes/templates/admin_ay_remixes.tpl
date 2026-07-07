{include file="menu.tpl"}

<script type="text/javascript" src="css/jquery.js"></script>

{literal}

<script language="javascript">

function GetTracks(author_id) {
	
	id = $('#author_id').val();
	$.post('get_tracks.php', {id: id}, TracksInsert);

}

function TracksInsert(data) {

	$('#insert_tracks').html("<select style='width: 150px' name='blabla'>" + data + "</select>");
		
}

</script>

{/literal}




<b>Редактировать </b>

<form method='GET' action='admin_ay_remixes.php' style="display: inline">
<select name="id" onChange="javascript:this.parentNode.submit();">

<option value="0"></option>
{section name=n loop=$remixes}
<option style="color: {if $remixes[n].rfr_type eq 1}black{elseif  $remixes[n].rfr_type eq 2}blue{elseif  $remixes[n].rfr_type eq 3}red{elseif $remixes[n].rfr_type eq 4}grey{/if}" value="{$remixes[n].rfr_id}" {if $remixes[n].rfr_id eq $id}selected{/if}>
{$remixes[n].rfr_name_ru}

</span>
</otpion>
{/section}
</select>
</form>


 &nbsp; 


или <b>Создать </b>

<form method='GET' action='admin_ay_remixes.php' style="display: inline">
<select name="type" onChange="javascript:this.parentNode.submit();">
<option value="0"></option>
<option value="1">Музыкальные группы и испольнители</option>
<option value="2">Фильмы, мультфильмы и ТВ</option>
<option value="3">Игры и демосцена</option>
<option value="4">Классика</option>
</select>
<input type="hidden" name="mode" value="create">
</form>

<br><br><br><br><br>

{if $mode eq "create" and $type eq 1}

<b style="font: bold 13px Arial">Создание «Музыкальной группы или исполнителя»</b>

<br><br><br>

<table>

<tr>
<td><b>Название исполнителя</b></td><td> ru</td><td> <input style="width: 150px" type="text" name="name_ru"> </td><td>en</td><td> <input type="text" style="width: 150px" name="name_en"></td><td align=center><b>артикль</b></td><td> <input size=4 type="text" name="article"></td>
</tr>

<tr><td colspan=5><br></td></tr>

<tr><td><b>Выбрать трек</b></td></td><td>
<td>
<select id="author_id" style="width: 150px" onChange="GetTracks(1)">
<option value="0">автор</option>
{section name=n loop=$authors}
<option value="{$authors[n].id}">{$authors[n].nickname} {if $authors[n].first_name}({$authors[n].first_name} {$authors[n].last_name}){/if}</option>
{/section}
</select>
</td>

<td></td><td id="insert_tracks">
<select style="width: 150px" onChange="">
<option value="0">трек</option>
</select>
</td><td align="center">&nbsp;<a class="m" style="text-decoration: none;" href="#"><b>добавить +</b></a></td>
<tr>

<tr><td colspan=5><br></td></tr>

<tr>
<td><b>Название трека</b> </td><td>ru</td><td> <input style="width: 150px" type="text" name="title_ru"> </td><td>en</td><td> <input style="width: 150px" type="text" name="title_en">
</td><td align=center><b>год</b></td><td> <input size=4 type="text" name="article"></td>
</tr>

<tr><td colspan=5><br></td></tr>

<tr>
<td><b>Название альбома</b> </td><td>ru</td><td> <input style="width: 150px" type="text" name="album_ru"></td><td> en</td><td> <input style="width: 150px" type="text" name="album_en">
</td><td align=center><b>обложка</b></td><td> <input size=10 type="file" name="album_image"></td>
<tr>



</table>





{elseif $id}




<table>

<tr>
<td><b>Название исполнителя</b></td><td> ru</td><td> <input style="width: 150px" type="text" name="name_ru" value="{$remix.rfr_name_ru}"> </td><td>en</td><td> <input type="text" style="width: 150px" name="name_en" value="{$remix.rfr_name_en}"></td><td align=center><b>артикль</b></td><td> <input value="{$remix.rfr_article}" size=4 type="text" name="article"></td>
</tr>

<tr><td colspan=5><br></td></tr>

{section name=record loop=$contents} 
   <tr bgcolor='#B9DCFF'> 
   {section name=entry loop=$contents[record]} 
      <td align='center'>{$contents[record][entry]}</td> 
   {/section} 
   </tr> 
{/section} 



{section name=n loop=$remix_tracks}


<tr>
<td><b>Название трека</b> </td>
<td>ru</td><td> <input style="width: 150px" type="text" name="title_ru" value="{$remix_tracks[n].rti_title_ru}"></td>
<td>en</td><td> <input style="width: 150px" type="text" name="title_en" value="{$remix_tracks[n].rti_title_en}"></td>
<td align=center><b>год</b></td><td> <input size=4 type="text" name="article"></td>
</tr>

{section name=m loop=$tracks[n]}

<tr><td colspan=5>

{$tracks[n][m].filename}<br>

</td></tr>


{/section}
{/section}



</table>
<br>

{/if}


{include file="right_strip.tpl"}
{include file="footer.tpl"}