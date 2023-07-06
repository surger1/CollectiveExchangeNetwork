<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createPermission" => [FL_DEFAULT|FL_AUTH, "CreatePermission"],
	"editPermission" => [FL_DEFAULT|FL_AUTH, "EditPermission"],
	"deletePermission" => [FL_DEFAULT|FL_AUTH, "DeletePermission"],
	"addTag" => [FL_DEFAULT|FL_AUTH, "AddTag"],
]);