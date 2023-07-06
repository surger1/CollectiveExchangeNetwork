<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([	
	"editTitle" => [FL_DEFAULT|FL_AUTH, "EditTitle"],
	"editDescription" => [FL_DEFAULT|FL_AUTH, "EditDescription"],
	"editPriority" => [FL_DEFAULT|FL_AUTH, "EditPriority"],
	"addComment" => [FL_DEFAULT|FL_AUTH, "AddComment"],
	"addTag" => [FL_DEFAULT|FL_AUTH, "AddTag"],
	"addRating" => [FL_DEFAULT|FL_AUTH, "AddRating"],
]);