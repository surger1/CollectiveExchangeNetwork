<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createTag" => [FL_DEFAULT|FL_AUTH, "CreateTag"],
	"editTag" => [FL_DEFAULT|FL_AUTH, "EditTag"],
	"deleteTag" => [FL_DEFAULT|FL_AUTH, "DeleteTag"],
]);