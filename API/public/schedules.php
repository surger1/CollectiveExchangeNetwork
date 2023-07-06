<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"addEntry" => [FL_DEFAULT|FL_AUTH, "AddEntry"],
	"editEntry" => [FL_DEFAULT|FL_AUTH, "EditEntry"],
	"removeEntry" => [FL_DEFAULT|FL_AUTH, "RemoveEntry"],
]);