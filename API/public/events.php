<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createEvent" => [FL_DEFAULT|FL_AUTH, "CreateEvent"],
	"editEvent" => [FL_DEFAULT|FL_AUTH, "EditEvent"],
	"cancelEvent" => [FL_DEFAULT|FL_AUTH, "CancelEvent"],
	"addComment" => [FL_DEFAULT|FL_AUTH, "AddComment"],
	"addTag" => [FL_DEFAULT|FL_AUTH, "AddTag"],
	"addRating" => [FL_DEFAULT|FL_AUTH, "AddRating"],
]);