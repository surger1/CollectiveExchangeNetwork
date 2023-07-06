<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createMembership" => [FL_DEFAULT|FL_AUTH, "CreateMembership"],
	"editMembership" => [FL_DEFAULT|FL_AUTH, "EditMembership"],
	"cancelMembership" => [FL_DEFAULT|FL_AUTH, "CancelMembership"],
]);