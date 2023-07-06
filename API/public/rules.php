<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createRule" => [FL_DEFAULT|FL_AUTH, "CreateRule"],
	"editTitle" => [FL_DEFAULT|FL_AUTH, "EditTitle"],
	"editDescription" => [FL_DEFAULT|FL_AUTH, "EditDescription"],
	"editTrigger" => [FL_DEFAULT|FL_AUTH, "EditTrigger"],
	"editCondition" => [FL_DEFAULT|FL_AUTH, "EditCondition"],
	"editAction" => [FL_DEFAULT|FL_AUTH, "EditAction"],
	"deleteRule" => [FL_DEFAULT|FL_AUTH, "DeleteRule"],
	"addTag" => [FL_DEFAULT|FL_AUTH, "AddTag"],
]);