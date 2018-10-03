<?php

/********************************************
* PHP Newsletter 4.0.7 beta
* Copyright (c) 2006-2014 Alexander Yanitsky
* Website: http://janicky.com
* E-mail: janickiy@mail.ru
* Skype: janickiy
********************************************/

class Controller_subscribers extends Controller
{
	function __construct()
	{
		$this->model = new Model_subscribers();
		$this->view = new View();
	}
	
	public function action_index()
	{
		$this->view->generate('subscribers_view.php', $this->model);
	}
	
}

?>
