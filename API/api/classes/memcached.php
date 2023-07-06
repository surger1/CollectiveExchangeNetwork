<?php

class cenMemcached
{
    private static $_instance;

    private $memcached;

    private function __construct(string $host, int $port)
    {
        $this->memcached = new Memcached();

        if ($this->memcached->addServer($host, $port))
        {
            $this->memcached->setOption(Memcached::OPT_SERIALIZER, Memcached::SERIALIZER_JSON);
            $this->memcached->setOption(Memcached::OPT_COMPRESSION, false);
        }
        else
        {
            error_log(__CLASS__."::".__FUNCTION__."() - error connecting to ".MEMCACHED_HOST.":".MEMCACHED_PORT);
            $this->memcached = null;
        }
    }

    public static function GetInstance()
    {
        if(!cenMemcached::$_instance)
        {
            cenMemcached::$_instance = new cenMemcached(MEMCACHED_HOST, MEMCACHED_PORT);
        }

        return cenMemcached::$_instance;
    }

    private static function ProcessKey(string $key)
    {        
        return $key.MEMCACHED_KEY_SUFFIX;
    }

    private static function GetResultCodeMessage(int $resCode)
    {
        switch ($resCode)
        {
            case Memcached::RES_SUCCESS:                          return "The operation was successful.";
            case Memcached::RES_FAILURE:                          return "The operation failed in some fashion.";
            case Memcached::RES_HOST_LOOKUP_FAILURE:              return "DNS lookup failed.";
            case Memcached::RES_UNKNOWN_READ_FAILURE:             return "Failed to read network data.";
            case Memcached::RES_PROTOCOL_ERROR:                   return "Bad command in memcached protocol.";
            case Memcached::RES_CLIENT_ERROR:                     return "Error on the client side.";
            case Memcached::RES_SERVER_ERROR:                     return "Error on the server side.";
            case Memcached::RES_WRITE_FAILURE:                    return "Failed to write network data.";
            case Memcached::RES_DATA_EXISTS:                      return "Failed to do compare-and-swap: item you are trying to store has been modified since you last fetched it.";
            case Memcached::RES_NOTSTORED:                        return "Item was not stored: but not because of an error. This normally means that either the condition for an 'add' or a 'replace' command wasn't met, or that the item is in a delete queue.";
            case Memcached::RES_NOTFOUND:                         return "Item with this key was not found (with 'get' operation or 'cas' operations).";
            case Memcached::RES_PARTIAL_READ:                     return "Partial network data read error.";
            case Memcached::RES_SOME_ERRORS:                      return "Some errors occurred during multi-get.";
            case Memcached::RES_NO_SERVERS:                       return "Server list is empty.";
            case Memcached::RES_END:                              return "End of result set.";
            case Memcached::RES_ERRNO:                            return "System error.";
            case Memcached::RES_BUFFERED:                         return "The operation was buffered.";
            case Memcached::RES_TIMEOUT:                          return "The operation timed out.";
            case Memcached::RES_BAD_KEY_PROVIDED:                 return "Bad key.";
            case Memcached::RES_CONNECTION_SOCKET_CREATE_FAILURE: return "Failed to create network socket.";
            case Memcached::RES_PAYLOAD_FAILURE:                  return "Payload failure: could not compress/decompress or serialize/unserialize the value.";
            case Memcached::RES_AUTH_PROBLEM:                     return "Auth problem.";
            case Memcached::RES_AUTH_FAILURE:                     return "Auth failure.";
            case Memcached::RES_AUTH_CONTINUE:                    return "Auth continue.";
            case Memcached::RES_E2BIG:                            return "E2Big??? No actual description for this.";
            case Memcached::RES_KEY_TOO_BIG:                      return "Key is too big.";
            case Memcached::RES_SERVER_TEMPORARILY_DISABLED:      return "Server temporarily disabled.";
            case Memcached::RES_SERVER_MEMORY_ALLOCATION_FAILURE: return "Server Memory allocation failure.";

            default:                                              return "Unknown result code '$resCode'";
        }
    }

    public function Get(string $key)
    {
        $key = cenMemcached::ProcessKey($key);

        $value = $this->memcached->get($key);

        if ($value === FALSE)
        {            
            $resCode = $this->memcached->getResultCode();
            if ($resCode != Memcached::RES_NOTFOUND && $resCode != Memcached::RES_SUCCESS)
            {
                error_log(__CLASS__."::".__FUNCTION__."() - failed to get key '$key', returned result code is $resCode = ".cenMemcached::GetResultCodeMessage($resCode)); 
                
                return null;
            }
        }
        
        return $value;
    }

    public function Set(string $key, $value, int $expiryInSeconds)
    {
        $key = cenMemcached::ProcessKey($key);

        $returnVal = $this->memcached->set($key, $value, $expiryInSeconds);

        if ($returnVal === FALSE)
        {
            $resCode = $this->memcached->getResultCode();
            if ($resCode != Memcached::RES_SUCCESS)
            {
                error_log(__CLASS__."::".__FUNCTION__."() - failed to set key '$key', returned result code is $resCode = ".cenMemcached::GetResultCodeMessage($resCode)); 
            }
        }

        return $returnVal;
    }

    public function Delete(string $key)
    {
        $key = cenMemcached::ProcessKey($key);

        $returnVal = $this->memcached->delete($key);

        if ($returnVal === FALSE)
        {
            $resCode = $this->memcached->getResultCode();
            if ($resCode != Memcached::RES_NOTFOUND)
            {
                error_log(__CLASS__."::".__FUNCTION__."() - failed to delete key '$key', returned result code is $resCode = ".cenMemcached::GetResultCodeMessage($resCode)); 
            }
        }

        return $returnVal;
    }
}
