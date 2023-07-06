<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createResource" => [FL_DEFAULT|FL_AUTH, "CreateResource"],
	"editResource" => [FL_DEFAULT|FL_AUTH, "EditResource"],
	"deleteResource" => [FL_DEFAULT|FL_AUTH, "DeleteResource"],
	"addComment" => [FL_DEFAULT|FL_AUTH, "AddComment"],
	"addTag" => [FL_DEFAULT|FL_AUTH, "AddTag"],
	"addRating" => [FL_DEFAULT|FL_AUTH, "AddRating"],
]);