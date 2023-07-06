<?php

class cenDb
{
	private static $_Db;

    public static function GetGameDB()
    {
        if(!cenDb::$_Db)
        {
            cenDb::$_Db = new cenDb(DB_HOST, DB_PORT, DB_USER, DB_PASS, DB_NAME);
        }

        return cenDb::$_Db;
    }
	
	  private $_db;
    private $_lastStatement;

    public function __construct(string $host, int $port, string $studentname, string $password, string $dbName)
    {
        $this->_db = new mysqli($host, $studentname, $password, $dbName, $port);
    }

    public function BeginTransaction()
    {
        $this->_db->begin_transaction();
    }

    public function Commit()
    {
        $this->_db->commit();
    }

    public function Rollback()
    {
        $this->_db->rollback();
    }

    public function GetInsertId()
    {
        return $this->_lastStatement->insert_id;
    }

    public function GetAffectedRows()
    {
        return $this->_lastStatement->affected_rows;
    }

    public function Escape(string $value)
    {
        return $this->_db->real_escape_string($value);
    }

    public function QuerySingleRow(string $sql, array $params = [])
    {
        $this->Query($sql, $params);

        $result = $this->_lastStatement->get_result();

        if($result->num_rows != 1)
        {
            return null;
        }

        return $result->fetch_object();
    }

    public function QueryArray(string $sql, array $params = [])
    {
        $this->Query($sql, $params);

        $result = $this->_lastStatement->get_result();

        $rows = [];
        while($row = $result->fetch_object())
        {
            $rows[] = $row;
        }

        return $rows;
    }

    public function Query(string $sql, array $params = [])
    {
        $this->CleanupLastStatement();
        $this->_lastStatement = $this->_db->prepare($sql);
        if ($this->_lastStatement === FALSE)
        {
            $this->ThrowDbException($sql, $this->_db->error, $this->_db->errno);
        }

        if (count($params) > 0)
        {
            $bindResult = call_user_func_array([$this->_lastStatement, "bind_param"], $this->ProcessParameters($params));
            if ($bindResult === FALSE)
            {
                $this->ThrowDbException($sql, $this->_lastStatement->error, $this->_lastStatement->errno);
            }
        }

        $executeResult = $this->_lastStatement->execute();
        if($executeResult === FALSE)
        {
            $this->ThrowDbException($sql, $this->_lastStatement->error, $this->_lastStatement->errno);
        }

        return $executeResult;
    }

    public function ExecuteStoredProcedure(string $procedure, array $params = [])
	{
		$this->CleanupLastStatement();

		// Prepare the call, adding placeholders for parameters
		$paramPlaceholders = implode(', ', array_fill(0, count($params), '?'));
		$sql = "CALL $procedure($paramPlaceholders);";

		$this->_lastStatement = $this->_db->prepare($sql);

		if ($this->_lastStatement === FALSE)
		{
			$this->ThrowDbException($sql, $this->_db->error, $this->_db->errno);
		}

		if (count($params) > 0)
		{
			$bindResult = call_user_func_array([$this->_lastStatement, "bind_param"], $this->ProcessParameters($params));
			if ($bindResult === FALSE)
			{
				$this->ThrowDbException($sql, $this->_lastStatement->error, $this->_lastStatement->errno);
			}
		}

		$executeResult = $this->_lastStatement->execute();
		if($executeResult === FALSE)
		{
			$this->ThrowDbException($sql, $this->_lastStatement->error, $this->_lastStatement->errno);
		}

		// Fetch the result, if any
		$result = $this->_lastStatement->get_result();

		// If there is a result set, return it. Otherwise, return true to indicate success
		return $result !== false ? $result : $executeResult;
	}


    private function ThrowDbException(string $sql, string $errorMessage, int $errorNumber)
    {
        $message = "Error running query:\n$sql\n";
        $message .= "Error Message: ".$errorMessage."\n";
        $message .= "Error Code: ".$errorNumber."\n";

        throw new Exception($message, $errorNumber);
    }

    private function ThrowStoredProcedureException(string $procedure)
    {
        $message = "Error running stored procedure:\n$procedure\n";
        $message .= "Error Message: ".$this->_db->error."\n";
        $message .= "Error Code: ".$this->_db->errno."\n";

        throw new Exception($message);
    }

    private function CleanupLastStatement()
    {
        if ($this->_lastStatement)
        {
            $this->_lastStatement->close();
            $this->_lastStatement = null;
        }
    }
	
	private function ProcessParameters(array $params)
    {
        $types = "";
        foreach ($params as $value)
        {
            if (is_int($value) || is_bool($value))
            {
                $types .= "i";
            }
            else if (is_float($value) || is_double($value))
            {
                $types .= "d";
            }
            else if (is_string($value))
            {
                $types .= "s";
            }
            //assumed string if null
            else if (is_null($value))
            {
                $types .= "s";
            }
            else
            {
                $message = "Unhandled parameter type of ".gettype($value)." for value $value, only supports bool/int, float/double, strings, nulled strings";
                throw new Exception($message);
            }
        }

        // need to convert this array of params into an array of references for the params since bind_statement requires that
        $allParams = array_merge([$types], $params);
        $refParams = [];
        foreach ($allParams as $key=>$value)
        {
            $refParams[$key] = &$allParams[$key];
        }
        return $refParams;
    }
}