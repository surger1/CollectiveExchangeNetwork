<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createOrganization" => [FL_DEFAULT|FL_AUTH, "CreateOrganization"],
	"editOrganization" => [FL_DEFAULT|FL_AUTH, "EditOrganization"],
	"deleteOrganization" => [FL_DEFAULT|FL_AUTH, "DeleteOrganization"],
	"addRole" => [FL_DEFAULT|FL_AUTH, "AddRole"],
	"removeRole" => [FL_DEFAULT|FL_AUTH, "RemoveRole"],
	"addRule" => [FL_DEFAULT|FL_AUTH, "AddRule"],
	"removeRule" => [FL_DEFAULT|FL_AUTH, "RemoveRule"],
	"addComment" => [FL_DEFAULT|FL_AUTH, "AddComment"],
	"addTag" => [FL_DEFAULT|FL_AUTH, "AddTag"],
	"addRating" => [FL_DEFAULT|FL_AUTH, "AddRating"],
	"addMember" => [FL_DEFAULT|FL_AUTH, "AddMember"],
	"editMember" => [FL_DEFAULT|FL_AUTH, "EditMember"],
]);