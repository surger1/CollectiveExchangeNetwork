<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"createOffer" => [FL_DEFAULT|FL_AUTH, "CreateOffer"],
	"createRequest" => [FL_DEFAULT|FL_AUTH, "CreateRequest"],
	"acceptExchange" => [FL_DEFAULT|FL_AUTH, "AcceptExchange"],
	"disputeExchange" => [FL_DEFAULT|FL_AUTH, "DisputeExchange"],
	"cancelExchange" => [FL_DEFAULT|FL_AUTH, "CancelExchange"],
]);