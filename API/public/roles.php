<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createRole" => [FL_DEFAULT|FL_AUTH, "CreateRole"],
	"editRole" => [FL_DEFAULT|FL_AUTH, "EditRole"],
	"deleteRole" => [FL_DEFAULT|FL_AUTH, "DeleteRole"],
]);