<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createLocation" => [FL_DEFAULT|FL_AUTH, "CreateLocation"],
	"editLocation" => [FL_DEFAULT|FL_AUTH, "EditLocation"],
	"deleteLocation" => [FL_DEFAULT|FL_AUTH, "DeleteLocation"],
	"addComment" => [FL_DEFAULT|FL_AUTH, "AddComment"],
	"addTag" => [FL_DEFAULT|FL_AUTH, "AddTag"],
	"addRating" => [FL_DEFAULT|FL_AUTH, "AddRating"],
]);