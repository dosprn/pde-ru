<?php

/********************************************
* PHP Newsletter 4.0.7 beta
* Copyright (c) 2006-2014 Alexander Yanitsky
* Website: http://janicky.com
* E-mail: janickiy@mail.ru
* Skype: janickiy
********************************************/

class Model_xmllogonline extends Model
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
	
	public function getCurrentUserLog($limit)
	{
		if(!$limit) $limit = 10;
		
		$query =  "SELECT * FROM ".$this->data->getTableName('ready_send')." a LEFT JOIN ".$this->data->getTableName('users')." b ON b.id_user=a.id_user ORDER by id_ready_send DESC LIMIT ".$limit;
		$result = $this->data->querySQL($query);
		
		return $this->data->getColumnArray($result);
	}
}

?>