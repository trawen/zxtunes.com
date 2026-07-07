<noindex>

	


<div id="boxes">
<div id="dialog">

<div align="center" style="font: bold 13px Verdana; color: white; background-color: #596680">ZXTunes Player v1.1</div>

<br>


<center>

<table cellpadding="3px" >

<tr>
<td class="win">Sound Chip: </td>
<td> &nbsp; 
<select style="width: 90px; font: normal 10px Verdana; border: 1px solid #b2b9c3" id="chip">
<option value='1'>AY-3-8910</option>
<option value='0'>YM2149F</option>
</select>
</td>
</tr>
 
<tr>
<td class="win">
Channels mixer: </td>
<td> &nbsp; 
<select style="width: 90px; font: normal 10px Verdana; border: 1px solid #b2b9c3" id="mixer">
<option value='0'>ABC</option>
<option value='1'>ACB</option>
<option value='2'>BAC</option>
</select>
</td>
</tr>

<tr>
<td class="win">Quality sound: </td>
<td> &nbsp; 
<select style="width: 90px; font: normal 10px Verdana;  border: 1px solid #b2b9c3" id="quality">
<option value='0'>LOW</option>
<option value='1'>HI</option>
</select><br>
</td>
</tr>

<tr>
<td class="win">Stereo Enhance: </td>
<td> &nbsp; 
<select style="width: 90px; font: normal 10px Verdana; border: 1px solid #b2b9c3" id="stereo">
<option value='0' >OFF</option>
<option value='1'>ON</option>
</select>
</td>
</tr>

<tr>
<td class="win">Bass boost: </td>
<td> &nbsp; 
<select style="width: 90px; font: normal 10px Verdana;  border: 1px solid #b2b9c3" id="bass">
<option value='0' >OFF</option>
<option value='1' >ON</option>
</select>
</td>
</tr>

</table>
<br>
<input style="border: 1px solid #FC9E0C; width: 210px; height: 18px; font: normal 10px Arial" id="autoplay" type="text" value="" onclick="selectText();"><br>
<div style="color: white">
{if $language eq 'rus'}^ ссылка на автопроигрывание трека{else}^ play link{/if}
</div>
<br>

<input type="button" value="OK" class="close" style="width: 64px;" onclick="close_window();">






</center>
</div>
</div>

<div id="thanks1">
<div id="thanks2">
Thank you!
</div>
</div>
</noindex>