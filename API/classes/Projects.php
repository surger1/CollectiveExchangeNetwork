<?php
require_once(__DIR__."/CollectiveExchangeNetwork.php");

class Project	
{
	function searchProjects($params) 		
	{
		$db = cenDb::GetDB();
		$sql = 'SELECT * FROM projects';
		$conditions = [];
		$values = [];

		if (isset($params['name'])) 		
		{
			$conditions[] = 'name LIKE ?';
			$values[] = '%' . $params['name'] . '%';
		}
		
		if (isset($params['organization_id'])) 		
		{
			$conditions[] = 'organization_id = ?';
			$values[] = $params['organization_id'];
		}
		
		if (isset($params['start_date'])) 		
		{
			$conditions[] = 'start_date >= ?';
			$values[] = $params['start_date'];
		}
		
		if (isset($params['end_date'])) 		
		{
			$conditions[] = 'end_date <= ?';
			$values[] = $params['end_date'];
		}

		if ($conditions) 		
		{
			$sql .= ' WHERE ' . implode(' AND ', $conditions);
		}
		
		$stmt = $db->prepare($sql);
		$stmt->execute($values);
		return $stmt->fetchAll(PDO::FETCH_ASSOC);
		

	}
	
	function blah()
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
			$studentsRow = $gameDb->QueryArray($sql, [$college]);	
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

}