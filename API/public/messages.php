<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"sendMessage" => [FL_DEFAULT|FL_AUTH, "SendMessage"],
	"archiveMessage" => [FL_DEFAULT|FL_AUTH, "ArchiveMessage"],
]);