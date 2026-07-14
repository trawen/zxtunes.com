<noindex>

	


<div id="boxes">
<div id="dialog">

<div align="center" style="font: bold 13px Verdana; color: white; background-color: #596680">ZXTunes Player v1.1</div>

<br>


<center>

<div class="zx-player-settings">

<div class="zx-player-settings__row">
<span class="win">Sound Chip: </span>
<select style="width: 90px; font: normal 10px Verdana; border: 1px solid #b2b9c3" id="chip">
<option value='1'>AY-3-8910</option>
<option value='0'>YM2149F</option>
</select>
</div>
 
<div class="zx-player-settings__row">
<span class="win">Channels mixer: </span>
<select style="width: 90px; font: normal 10px Verdana; border: 1px solid #b2b9c3" id="mixer">
<option value='0'>ABC</option>
<option value='1'>ACB</option>
<option value='2'>BAC</option>
</select>
</div>

<div class="zx-player-settings__row">
<span class="win">Quality sound: </span>
<select style="width: 90px; font: normal 10px Verdana;  border: 1px solid #b2b9c3" id="quality">
<option value='0'>LOW</option>
<option value='1'>HI</option>
</select>
</div>

<div class="zx-player-settings__row">
<span class="win">Stereo Enhance: </span>
<select style="width: 90px; font: normal 10px Verdana; border: 1px solid #b2b9c3" id="stereo">
<option value='0' >OFF</option>
<option value='1'>ON</option>
</select>
</div>

<div class="zx-player-settings__row">
<span class="win">Bass boost: </span>
<select style="width: 90px; font: normal 10px Verdana;  border: 1px solid #b2b9c3" id="bass">
<option value='0' >OFF</option>
<option value='1' >ON</option>
</select>
</div>

</div>
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
