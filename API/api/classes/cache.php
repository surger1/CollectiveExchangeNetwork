<?php

class cenCache 
{
    private function __construct() 
	{
        if ( !extension_loaded("apcu") ) 
		{
            error_log("APCu unavailable! Caching not available!");
        }

        else if ( !ini_get("apc.enabled") ) 
		{
            error_log("APCu disabled! Caching not available!");
        }
    }
	    
	public static function GetInstance() 
	{
        static $instance = null;
        if ( $instance === null ) 
		{
            $instance = new cenCache();
        }
        return $instance;
    }

    private function __clone() {}
    private function __sleep() {}
    private function __wakeup() {}

    private static function MakeKey( string $key ) {
        return $key.MEMCACHED_KEY_SUFFIX;
    }

    public function Get( string $key ) {
        $key = cenCache::MakeKey($key);

        $success = false;
        $value = apcu_fetch($key, $success);

        if ( !$success ) {
            return null;
        }

        return $value;
    }

    public function Set( string $key, $value, int $expiryInSeconds ) {
        $key = cenCache::MakeKey($key);

        return apcu_store($key, $value, $expiryInSeconds);
    }

    public function Delete( string $key ) {
        $key = cenCache::MakeKey($key);

        return apcu_delete($key);
    }
}
