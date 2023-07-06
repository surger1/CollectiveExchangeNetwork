<?php
require_once(__DIR__."/../Api.php");

ExecuteAction
([
	"registerCollaborator" => [FL_DEFAULT, "RegisterCollaborator"],
	"loginCollaborator" => [FL_DEFAULT, "LoginCollaborator"],
	"registerSkill" => [FL_DEFAULT|FL_AUTH, "RegisterSkill"],
	"searchCollaborators" => [FL_DEFAULT|FL_AUTH, "SearchCollaborators"],
	"emailConfirm" => [FL_DEFAULT, "EmailConfirm"],
	"codeConfirm" => [FL_DEFAULT, "CodeConfirm"],
	"resetPassword" => [FL_DEFAULT, "ResetPassword"],
	"editName" => [FL_DEFAULT|FL_AUTH, "EditName"],
]);

function LoginCollaborator(string $version, stdClass $request)
{
	$params = [
		"email"=>"string",
		"password"=>"string",
		"secret"=>"string",
    ];
	
    if(!CheckParams(__FILE__, __FUNCTION__, $request, $params))
    {
        return null;
    }
	
	$password = strval($request->password);
	$secret = strval($request->secret);
	$email = strval($request->email);
	$success = false;	
	
	$db = cenDb::GetDB();
	$collaboratorData = new stdClass();
	$authKey = "";
	$collaboratorId = "";
	
	
	//Check the API requester they are trying to log in from is valid
	$success = CollectiveExchangeNetwork::CheckSecret($secret);
	
	if($success)
	{
		$hashedPassword = GetPassword($password);

		$sql = "SELECT password, email, firstName, lastName
				FROM student
				WHERE id = ? AND removed = false";
		$dbRow = $db->ExecuteStoredProcedure("LoginCollaborator", [$email, $hashedPassword]);		
		if($result)
		{
			
			$authKey = GetAuthKey($studentId);
			$collaboratorData = Collaborator::GetCollaboratorData($studentId);			
				// store their auth data in memcache
			$authValue = new stdClass();
			$authValue->authToken = $authKey;
			cache::GetInstance()->Set($authKey, $authValue, AUTH_KEY_EXPIRE_TIME);
		}
	}

	$response = new stdClass();
    $response->success = $success;
	$response->collaboratorData = $collaboratorData;
	$response->authKey = $authKey;
    return $response;
}