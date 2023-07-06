<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createBid" => [FL_DEFAULT|FL_AUTH, "CreateBid"],
	"revokeBid" => [FL_DEFAULT|FL_AUTH, "RevokeBid"],
	"editDescription" => [FL_DEFAULT|FL_AUTH, "EditDescription"],
	"addComment" => [FL_DEFAULT|FL_AUTH, "AddComment"],
	"addTag" => [FL_DEFAULT|FL_AUTH, "AddTag"],
	"addRating" => [FL_DEFAULT|FL_AUTH, "AddRating"],
]);