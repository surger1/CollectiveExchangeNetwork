DELIMITER $$
DROP PROCEDURE IF EXISTS `CreatePermission` $$
CREATE PROCEDURE `CreatePermission`(IN name VARCHAR(255), IN description TEXT, IN issuer_id INT, IN issuer_type INT)
BEGIN
        -- Declare a variable to hold the ID of the newly created permission
    DECLARE permission_id INT;

    -- Check if the creator_id corresponds to an existing entity
    IF NOT CheckEntityType(issuer_id, issuer_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
    ELSE	
        INSERT INTO `permissions`(`name`, `description`)
        VALUES (name, description);
		
		SELECT LAST_INSERT_ID() INTO permission_id;		
		
		INSERT INTO `permissions_logs`(`permission_id`, `entity_id`, `entity_type`, `action`)
        VALUES (permission_id, issuer_id, issuer_type, 'created');
		
    END IF;
END$$
DELIMITER ;
