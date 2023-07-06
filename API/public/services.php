<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createService" => [FL_DEFAULT|FL_AUTH, "CreateService"],
	"editTitle" => [FL_DEFAULT|FL_AUTH, "EditTitle"],
	"editDescription" => [FL_DEFAULT|FL_AUTH, "EditDescription"],
	"removeService" => [FL_DEFAULT|FL_AUTH, "removeService"],
	"publishService"  => [FL_DEFAULT|FL_AUTH, "PublishService"],
	"addTag" => [FL_DEFAULT|FL_AUTH, "AddTag"],
	"removeTag" => [FL_DEFAULT|FL_AUTH, "RemoveTag"],
]);