<?php

define('SRC_ZIP', 0);
define('SRC_DIR', 1);

define('AY_MAX_STR', 4096);
define('CP_BUF_SIZE', 4096);

define('NO_ERROR', 0);
define('UNKNOWN_EXT', -1);
define('READ_ERROR' , -2);
       
function cleanText($text)
{
	$text = trim($text, "\x00..\x20");
	for ($i = strlen($text); $i--;)
		if ($text[$i] < ' ' || $text[$i] > chr(127))
			return '';
	return $text;
}

function asciiz($buf, $ofs)
{
	$r = '';
	for ($i = $ofs; $i < strlen($buf) && $buf[$i] != chr(0); $i++)
		$r .= $buf[$i];
	return $r;
}

function word($buf, $ofs)
{
	return ord($buf[$ofs]) << 8 | ord($buf[$ofs + 1]);
}

function dword($buf, $ofs)
{
	return word($buf, $ofs) << 16 | word($buf, $ofs + 2);
}

class Source {
	var $type;
	var $handle;
	
	var $entryName;
	var $entry;

	var $dirPath;
	var $dirStack;

	function open($name)
	{
		$this->x = 'test';
		if (substr($name, -3) == 'zip')
		{
			$this->type = SRC_ZIP;
			$this->handle = zip_open($name)
				or die("Unable to open file '$name'");
		}
		else
		{
			$this->type = SRC_DIR;
			$this->dirPath = $name;
			$h = opendir($name)
				or die("Unable to open directory '$name'");
			$this->dirStack[] = array('handle' => $h, 'pos' => 0);
		}
	}

	function close()
	{
		if ($this->type == SRC_ZIP)
			zip_close($this->handle);
		else
			while ($ent = array_pop($this->dirStack))
				closedir($ent['handle']);
	}

	function readName()
	{
		if ($this->type == SRC_ZIP)
		{
			do {
				if (!($this->entry = zip_read($this->handle)))
					return false;
				if (!($this->entryName = zip_entry_name($this->entry)))
					return false;
			} while ($this->entryName[strlen($this->entryName) - 1] == '/');
			return $this->entryName;
		}

		while ($this->dirStack)
		{
			$top = & $this->dirStack[count($this->dirStack) - 1];
			$name = readdir($top['handle']);
			if ($name === false)
			{
				closedir($top['handle']);
				$this->dirPath = substr($this->dirPath, 0, $top['pos']);
				array_pop($this->dirStack);
			}
			else if ($name != '.' && $name != '..')
			{
				$fname = "$this->dirPath/$name";
				$stat = stat($fname)
					or die("stat failed on '$fname'");

				if (($stat[2] & 040000) == 0)
					return $this->entryName = $fname;

				$h = opendir($fname)
					or die("Unable to open directory '$fname'");
				$this->dirStack[] = array(
					'handle' => $h,
					'pos' => strlen($this->dirPath)
				);
				$this->dirPath .= "/$name";
			}
		} // while ($this->dirStack)
	}

	function openEntry()
	{
		if ($this->type == SRC_ZIP)
		{
			debugMsg('inside Source->openEntry $this->entry = '.$this->entry);
			return zip_entry_open($this->handle, $this->entry);
		}
		else
			return $this->entry = fopen($this->entryName, 'r');
	}

	function closeEntry()
	{
		if ($this->type == SRC_ZIP)
			return zip_entry_close($this->entry);
		else
			return fclose($this->entry);
	}

	function readEntry($count)
	{
		if ($this->type == SRC_ZIP)
			return zip_entry_read($this->entry, $count);
		else
			return fread($this->entry, $count);
	}
}


class Module {

	var $source;

	var $author;
	var $name;
    var $ext;
	var $type;
	
	var $title;
	var $author2;

	var $lastError = NO_ERROR;

	function readTitle($ofs, $count)
	{
		return substr($this->source->readEntry($ofs + $count), $ofs);
	}

	function parse(&$source)
	{
		global $syn;

		$ok = true;

		$this->source = &$source;

		$a = explode('/', $this->source->entryName);
		$i = count($a);
		
		$s = & $a[--$i];
		$j = strlen($s);
		do { $j--; } while ($j >= 0 && $s[$j] != '.');		
		$this->ext = strtolower(substr($s, $j + 1));
		$this->name = substr($s, 0, $j);

		$t = intval($a[--$i]);
		if ($t < 1900 || $t > 3000)
			$this->year = 0;
		else
		{
			$this->year = $t;
			$i--;
		}
		
		$this->author = $a[$i--];
		if (isset($syn[$this->author]))
			$this->author = $syn[$this->author];

        $this->author2 = '';
        $this->title = '';

		$this->source->openEntry()
			or die("Unable to access '$source->entryName'");
		switch ($this->ext)
		{
			case 'stp':
				$this->title = $this->readTitle(0x26, 25);
				break;
			case 'ftc':
				$this->title = $this->readTitle(8, 42);
				break;
			case 'psc':
				$this->title = $this->readTitle(25, 20);
				$this->author2 = $this->readTitle(1, 23);
				break;
			case 'gtr':
				$this->title = $this->readTitle(7, 32);
				break;
			case 'pt1':
				$this->title = $this->readTitle(69, 30);
				break;
			case 'pt2':
				$this->title = $this->readTitle(101, 30);
				break;
			case 'pt3':
				$this->title = $this->readTitle(30, 32);
				$this->author2 = $this->readTitle(1, 36);
				break;
			case 'asc':
				$t = $this->source->readEntry(9);
				$numOrd = ord($t[8]);
				$t = $this->source->readEntry($numOrd + 63);
				$this->title = substr($t, $numOrd + 19, 21);
				$this->author2 = substr($t, $numOrd + 40);
				break;
			case 'ay':
				$this->source->readEntry(12);
				$t = $this->source->readEntry(8);
				$authOfs = word($t, 0) - 8;
				$miscOfs = word($t, 2) + 2 - 8;
				$numSongs = ord($t[4]) + 1;

				$songOfs = word($t, 6) + 6 - 8;

				$t = $this->source->readEntry(max(
					$authOfs + AY_MAX_STR, 
					$miscOfs + AY_MAX_STR, 
					$songOfs + $numSongs * 4
				));

				$this->author2 = asciiz($t, $authOfs);

				$maxOfs = 0;
				for ($i = 0; $i < $numSongs; $i++)
				{
					$ofs = $songOfs + $i * 4;
					$titleOfs[$i] = word($t,$ofs) + $ofs;
					if ($titleOfs[$i] > $maxOfs) $maxOfs = $titleOfs[$i];
				}
				$maxOfs += AY_MAX_STR - strlen($t);
				if ($maxOfs > 0)
					$t .= $this->source->readEntry($maxOfs);

				if ($numSongs == 1)
					$this->title = asciiz($t, $titleOfs[0]);
				else
				{
					$this->title = "$numSongs songs: ";
					for ($i = 0; $i < $numSongs; $i++)
						$this->title .= ($i ? ', ' : '') . asciiz($t, $titleOfs[$i]);
				}
				
				break;
/*
			case 'ym':
				$ok = (bool)($t = $source->readEntry(34));
				if ($ok)
				{
					$i = word($t, 20);
					while ($ok && $i--)
					{
						$t = $source->readEntry(4);
						$ok = $t && $source->readEntry(dword($t, 0));
					}
					$ok = (bool)($t = $source->readEntry(AY_MAX_STR));
					if ($ok)
					{
						$this->title = asciiz($t, 0);
						$this->author2 = asciiz($t, strlen($this->title) + 1);
					}
					
				}
				if (!$ok)
					errorMsg("$source->entryName: read error");					
				break;
*/
			case 'sqt':
			case 'stc':
			case 'sna':
			case 'ym':
			case 'fxm':
			case 'vtx':
			case 'bin':
			case 'psm':
			case 'trd':
			case 'zxs':
			case 'fls':
				break;				
			default:
//				$this->title = '';
				$ok = false;
				$this->lastError = UNKNOWN_EXT;
		}
		$this->source->closeEntry();

		if ($ok)
		{
			$this->title = cleanText($this->title);
			if ($this->title == '')
				$this->title = $this->name;
			$this->author2 = cleanText($this->author2);
			if ($this->author2 == '')
				$this->author2 = $this->author;
		}

		return $ok;
	}	

	function copyTo($fileName)
	{
		if (!$this->source->openEntry()) return false;
		$f = fopen($fileName, 'w');
		if (!$f)
			$done = false;
		else		
		{
			$done = true;
			do {
				$buf = $this->source->readEntry(CP_BUF_SIZE);
				fwrite($f, $buf) or $done = false;
			} while ($done && strlen($buf) == CP_BUF_SIZE);
			fclose($f);
		}
		$this->source->closeEntry();
		return $done;
	}
}

?>