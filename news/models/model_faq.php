<?php

/********************************************
* PHP Newsletter 4.0.7 beta
* Copyright (c) 2006-2014 Alexander Yanitsky
* Website: http://janicky.com
* E-mail: janickiy@mail.ru
* Skype: janickiy
********************************************/

class Model_faq extends Model
{
	private $data;

	public function __construct() {
		$this->get_data();
	}

	public function get_data()
	{
		global $PNSL;
		$this->data = new DBParser($PNSL);
		return $this->data;
	}
	
	public function getSetting(){
		$query = "SELECT * FROM ".$this->data->getTableName('settings')."";
		$result = $this->data->querySQL($query);
		
		return $this->data->getRow($result);	
	}
	
	public function get_faq()
	{
		global $PNSL;
	
		$settings = $this->getSetting();
		
		$filename = $PNSL["system"]["dir_root"].$PNSL["system"]["dir_config"]."language/faq_".$settings["language"];
		if($handle = fopen($filename, "r")){
			$contents = fread($handle, filesize($filename));
			fclose($handle);
		}
		
		return $contents;
	}
}

?>