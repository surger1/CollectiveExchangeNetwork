<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createProject" => [FL_DEFAULT|FL_AUTH, "CreateProject"],
	"editProject" => [FL_DEFAULT|FL_AUTH, "EditProject"],
	"deleteProject" => [FL_DEFAULT|FL_AUTH, "DeleteProject"],
	"addTask" => [FL_DEFAULT|FL_AUTH, "AddTask"],
	"removeTask" => [FL_DEFAULT|FL_AUTH, "RemoveTask"],
	"addBid" => [FL_DEFAULT|FL_AUTH, "AddBid"],
	"addComment" => [FL_DEFAULT|FL_AUTH, "AddComment"],
	"addTag" => [FL_DEFAULT|FL_AUTH, "AddTag"],
	"addRating" => [FL_DEFAULT|FL_AUTH, "AddRating"],
]);