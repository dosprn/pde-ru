<?php

/********************************************
* PHP Newsletter 4.0.7 beta
* Copyright (c) 2006-2014 Alexander Yanitsky
* Website: http://janicky.com
* E-mail: janickiy@mail.ru
* Skype: janickiy
********************************************/

class Update {

	public function checkNewVersion($currenversion)
	{
		$str = $this->getDataNewVersion();		
		$newversion = $this->getVersion($str);
		
		preg_match("/(\d+)\.(\d+)\.(\d+)/",$currenversion,$out1);
		preg_match("/(\d+)\.(\d+)\.(\d+)/",$newversion,$out2);
		
		$v1 = ($out1[1] * 10000 + $out1[2] * 100 + $out1[3]);
		$v2 = ($out2[1] * 10000 + $out2[2] * 100 + $out2[3]);
		
		if($v2 > $v1)
			return true;
		else
			return false;
	}

	public function getDataNewVersion() 
	{ 
		$link = "http://janicky.com/scripts/index.php?s=newsletter"; 

		$fd = @fopen($link, "r"); 
		$out = ""; 

		if($fd){ 
			while (!feof ($fd)) $out .= fgets($fd, 4096); 
		} 

		@fclose ($fd);
		
		return $out; 
	}
	
	public function getVersion()
	{
		$str = $this->getDataNewVersion(); 	
		preg_match("/<version>([^<]+)<\/version>/i",$str,$out);
		
		return $out[1];
	}

	public function getDownloadLink()
	{
		$str = $this->getDataNewVersion(); 
		preg_match("/<download>([^<]+)<\/download>/i",$str,$out);
		
		return $out[1];
	}
	
	public function getCreated()
	{
		$str = $this->getDataNewVersion(); 
		preg_match("/<сreated>([^<]+)<\/сreated>/i",$str,$out);
		
		return $out[1];
	}
}

?>