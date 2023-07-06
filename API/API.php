<?php
require_once(__DIR__."/../environment.php");
require_once(__DIR__."/Environment.php");
require_once(__DIR__."/api/classes/database.php");
require_once(__DIR__."/api/classes/cache.php");
require_once(__DIR__."/api/api.php");
require_once(__DIR__."/classes/Collaborator.php");

const AUTH_KEY_EXPIRE_TIME = 4800;

function GetAuthKeyForCollaborator(int $collaboratorId)
{
    return "authKey_".$collaboratorId;
}

function GetActionName(stdClass $request) : string
{
    $action = "";

    if (property_exists($request, "function"))
    {
        $action = trim($request->function);
    }
    else if (property_exists($request, "action"))
    {
        $action = trim($request->action);
    }
    else if (array_key_exists("action", $_GET))
    {
        $action = trim($_GET["action"]);
    }
    else if (array_key_exists("REQUEST_URI", $_SERVER))
    {
        $path = explode('?', $_SERVER["REQUEST_URI"])[0];
        $parts = explode('/', $path);

        if (count($parts) > 5)
        {
            $action = trim($parts[5]);
        }
    }

    return ctype_alnum(str_replace(['_', '-'], '', $action)) ? $action : "";
}

function ErrorResponse(string $file, string $function, int $lineNumber, string $errorMessage)
{
    $message = "$file::$function ($lineNumber) - $errorMessage";
    error_log($message);

    $errorData = new stdClass();
    $errorData->error = true;
    if (DEVELOPMENT_VERSION)
    {
        $errorData->message = $message;
    }
    else
    {
        $errorData->message = "err";
    }

    return $errorData;
}

function guidv4()
{
    $data = random_bytes(16);
    $data[6] = chr(ord($data[6]) & 0x0f | 0x40 ); // set version to 0100
    $data[8] = chr(ord($data[8]) & 0x3f | 0x80 ); // set bits 6-7 to 10

    return vsprintf("%s%s-%s-%s-%s-%s%s%s", str_split( bin2hex( $data ), 4 ));
}

function IsValidGuid(string $guid) 
{
    $UUIDv4 = "/^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i";
    $result = preg_match($UUIDv4, $guid);
	
    return ($result === 1);
}

function GetAuthKeyForAdmin(int $adminId)
{
    return "authAdminKey_".$adminId;
}

function GetAuthenticatedCollaboratorId(string $version, stdClass $request, string &$outNewAuthToken)
{
    $authenticatedCollaboratorId = 0;
    $jsonString = json_encode($request);
    $newAuthToken = "";
    if (property_exists($request, "collaboratorId"))
    {
        $collaboratorId = intval($request->collaboratorId);
        $token = (property_exists($request, "authToken") && $request->authToken) ? $request->authToken : "";
        if (!$token)
        {
            error_log("Auth token not found in request for collaboratorId $collaboratorId, request string: '$jsonString'");
            ExitWithInvalidSession();
        }        

        $authKey = GetAuthKeyForStudent($collaboratorId);
        $memcacheAuthValue = odeaCache::GetInstance()->Get($authKey);

        $gameDb = odeaDb::GetGameDB();

        if ( !$memcacheAuthValue || ($token != $memcacheAuthValue->authToken) )
        {

            $sql = "SELECT authToken
                    FROM student
                    WHERE id = ?;";
		    
            $studentRow = $gameDb->QuerySingleRow($sql, [$collaboratorId]);

            if ($token != $studentRow->authToken) {
                error_log("AuthToken doesnt match for student $collaboratorId, DB:'".$studentRow->authToken."', request: '$token', request string: ".$jsonString);
                ExitWithInvalidSession();
            }

            // everything checks out, generate a new one
            $newAuthToken = GetAuthKey($collaboratorId);

            $sql = "UPDATE student
                    SET authToken = ?
                    WHERE id = ? AND authToken = ?";
            $gameDb->Query($sql, [$newAuthToken, $collaboratorId, $token]);
            if ($gameDb->GetAffectedRows() != 1)
            {
                error_log("Error updating authToken from DB for student $collaboratorId, request string: '$jsonString', sql $sql");
                ExitWithInvalidSession();
            }

            $memcacheAuthValue = new stdClass();
            $memcacheAuthValue->authToken = $newAuthToken;

            $token = $newAuthToken;
            $outNewAuthToken = $newAuthToken;
        }
        else if ($token != $memcacheAuthValue->authToken)
        {
            error_log("Session key doesnt match for $collaboratorId, client value '$token', memcache value '$memcacheAuthValue->authToken', request string '$jsonString'");
            ExitWithInvalidSession();
        }

        //TODO track sessions maybe?

        $authKey = GetAuthKeyForStudent($collaboratorId);
        odeaCache::GetInstance()->Set($authKey, $memcacheAuthValue, AUTH_KEY_EXPIRE_TIME);

        $authenticatedStudentId = $collaboratorId;
    }

    return $authenticatedStudentId;
}