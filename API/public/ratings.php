<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createRating" => [FL_DEFAULT|FL_AUTH, "CreateRating"],
	"editRating" => [FL_DEFAULT|FL_AUTH, "EditRating"],
	"deleteRating" => [FL_DEFAULT|FL_AUTH, "DeleteRating"],
]);