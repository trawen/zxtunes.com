<?php
function trans ($char) {

$x=strlen($char)+1;
for ($i = 0; $i < $x; $i++) {

$c=substr($char, $i, 1);

if ($c=="à") {$c="a";}
elseif ($c=="á") {$c="b";}
elseif ($c=="â") {$c="v";}
elseif ($c=="ã") {$c="g";}
elseif ($c=="ä") {$c="d";}
elseif ($c=="å") {$c="e";}
elseif ($c=="¸") {$c="yo";}
elseif ($c=="æ") {$c="zh";}
elseif ($c=="ç") {$c="z";}
elseif ($c=="è") {$c="i";}
elseif ($c=="é") {$c="y";}
elseif ($c=="ê") {$c="k";}
elseif ($c=="ë") {$c="l";}
elseif ($c=="ì") {$c="m";}
elseif ($c=="í") {$c="n";}
elseif ($c=="î") {$c="o";}
elseif ($c=="ï") {$c="p";}
elseif ($c=="ð") {$c="r";}
elseif ($c=="ñ") {$c="s";}
elseif ($c=="ò") {$c="t";}
elseif ($c=="ó") {$c="u";}
elseif ($c=="ô") {$c="f";}
elseif ($c=="õ") {$c="kh";}
elseif ($c=="ö") {$c="ts";}
elseif ($c=="÷") {$c="ch";}
elseif ($c=="ø") {$c="sh";}
elseif ($c=="ù") {$c="sh";}
elseif ($c=="ú") {$c="'";}
elseif ($c=="û") {$c="y";}
elseif ($c=="ü") {$c="'";}
elseif ($c=="ý") {$c="e";}
elseif ($c=="þ") {$c="yu";}
elseif ($c=="ÿ") {$c="ya";}

ELSEIF ($c=="À") {$c="A";}
ELSEIF ($c=="Á") {$c="B";}
ELSEIF ($c=="Â") {$c="V";}
ELSEIF ($c=="Ã") {$c="G";}
ELSEIF ($c=="Ä") {$c="D";}
ELSEIF ($c=="Å") {$c="E";}
ELSEIF ($c=="¨") {$c="YO";}
ELSEIF ($c=="Æ") {$c="ZH";}
ELSEIF ($c=="Ç") {$c="Z";}
ELSEIF ($c=="È") {$c="I";}
ELSEIF ($c=="É") {$c="Y";}
ELSEIF ($c=="Ê") {$c="K";}
ELSEIF ($c=="Ë") {$c="L";}
ELSEIF ($c=="Ì") {$c="M";}
ELSEIF ($c=="Í") {$c="N";}
ELSEIF ($c=="Î") {$c="O";}
ELSEIF ($c=="Ï") {$c="P";}
ELSEIF ($c=="Ð") {$c="R";}
ELSEIF ($c=="Ñ") {$c="S";}
ELSEIF ($c=="Ò") {$c="T";}
ELSEIF ($c=="Ó") {$c="U";}
ELSEIF ($c=="Ô") {$c="F";}
ELSEIF ($c=="Õ") {$c="KH";}
ELSEIF ($c=="Ö") {$c="TS";}
ELSEIF ($c=="×") {$c="CH";}
ELSEIF ($c=="Ø") {$c="SH";}
ELSEIF ($c=="Ù") {$c="SH";}
ELSEIF ($c=="Ú") {$c="'";}
ELSEIF ($c=="Û") {$c="Y";}
ELSEIF ($c=="Ü") {$c="'";}
ELSEIF ($c=="Ý") {$c="E";}
ELSEIF ($c=="Þ") {$c="YU";}
ELSEIF ($c=="ß") {$c="YA";}

$char2.=$c;
}
    return $char2;
}
?>