<?php

/********************************************
* PHP Newsletter 4.0.7 beta
* Copyright (c) 2006-2014 Alexander Yanitsky
* Website: http://janicky.com
* E-mail: janickiy@mail.ru
* Skype: janickiy
********************************************/

class Model_alert_update extends Model
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
}

?>