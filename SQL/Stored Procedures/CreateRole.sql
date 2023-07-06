DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateRole` $$
CREATE PROCEDURE `CreateRole`(IN name VARCHAR(255), IN description TEXT, IN issuer_id INT, IN issuer_type INT)
BEGIN
        -- Declare a variable to hold the ID of the newly created role
    DECLARE role_id INT;

    -- Check if the creator_id corresponds to an existing entity
    IF NOT CheckEntityType(issuer_id, issuer_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
    ELSE	
        INSERT INTO `roles`(`name`, `description`)
        VALUES (name, description);
		
		SELECT LAST_INSERT_ID() INTO role_id;		
		
		INSERT INTO `roles_logs`(`role_id`, `entity_id`, `entity_type`, `action`)
        VALUES (role_id, issuer_id, issuer_type, 'created');
		
    END IF;
END$$
DELIMITER ;
