<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"editComment" => [FL_DEFAULT|FL_AUTH, "EditComment"],
	"removeComment" => [FL_DEFAULT|FL_AUTH, "RemoveComment"],
]);